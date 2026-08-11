"""
Vinyl Groove API - 통합 서버 (단일 서버 버전)
모든 기능이 하나의 서버에 통합되어 있습니다.
"""
import sys

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")

import os
from fastapi import FastAPI, HTTPException, Request, status, Depends, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
from pydantic import BaseModel
import bcrypt
from typing import Optional
from config import settings
from database import get_db, create_tables, User as UserModel, Product as ProductModel, Notification as NotificationModel
from schemas import BaseResponse, ErrorDetail
from auth import create_access_token, get_current_user
from utils import (
    validate_email, validate_password_login, validate_password_signup,
    validate_name, validate_phone, validate_barcode,
    GENRE_CODES, CONDITION_CODES, TRADE_METHOD_CODES, CONDITION_DESCRIPTIONS
)

# FastAPI 앱
app = FastAPI(title=settings.app_name, version=settings.app_version)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# FastAPI는 raise HTTPException(detail={...}) 을 기본적으로 {"detail": {...}} 로 한 번 더 감싸서 응답한다.
# API 스펙은 success/message/errors가 최상위에 오는 형태이므로, 감싸지 않고 그대로 내려준다.
@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    if isinstance(exc.detail, dict):
        return JSONResponse(status_code=exc.status_code, content=exc.detail)
    return JSONResponse(status_code=exc.status_code, content={"success": False, "message": str(exc.detail), "errors": None})

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors = [
        {"code": "INVALID_FORMAT", "field": ".".join(str(p) for p in e["loc"] if p != "body"), "message": e["msg"]}
        for e in exc.errors()
    ]
    return JSONResponse(status_code=status.HTTP_400_BAD_REQUEST, content={"success": False, "message": "유효성 검사 실패", "errors": errors})

# 업로드된 이미지 저장 및 정적 파일 서빙
UPLOAD_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "static", "images")
os.makedirs(os.path.join(UPLOAD_DIR, "album"), exist_ok=True)
os.makedirs(os.path.join(UPLOAD_DIR, "profile"), exist_ok=True)
app.mount("/images", StaticFiles(directory=UPLOAD_DIR), name="images")

# DB에는 "/images/album/xxx.jpg" 같은 상대 경로만 저장하고, 응답을 내려줄 때마다
# 지금 이 요청이 실제로 사용한 호스트:포트를 기준으로 절대 URL을 만든다.
# 이렇게 하면 서버 포트를 바꿔도(예: 8000 -> 8001) 이미 저장된 데이터의 이미지가 깨지지 않는다.
def resolve_image_url(request: Request, path: Optional[str]) -> Optional[str]:
    if not path:
        return path
    if path.startswith("http://") or path.startswith("https://"):
        return path
    return f"{str(request.base_url).rstrip('/')}/{path.lstrip('/')}"

# 비밀번호 해싱 (bcrypt는 72바이트까지만 지원하므로 초과분은 잘라서 사용)
def hash_password(password: str) -> str:
    password_bytes = password.encode("utf-8")[:72]
    return bcrypt.hashpw(password_bytes, bcrypt.gensalt()).decode("utf-8")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    password_bytes = plain_password.encode("utf-8")[:72]
    return bcrypt.checkpw(password_bytes, hashed_password.encode("utf-8"))

# ==================== 스키마 ====================

class LoginRequest(BaseModel):
    email: str
    password: str

class SignupRequest(BaseModel):
    email: str
    password: str
    name: str
    phone: str

class ProductCreateRequest(BaseModel):
    albumName: str
    artist: str
    genre: str
    condition: str
    price: int
    tradeMethod: str
    barcode: Optional[str] = None
    description: Optional[str] = None
    albumImage: str

class ImageUploadRequest(BaseModel):
    image: str
    type: Optional[str] = "ALBUM"

# ==================== 라이프사이클 ====================

def simulate_price_changes():
    """주기적으로 상품 가격 변동 시뮬레이션 및 알림 생성"""
    import random
    import threading
    import time
    from database import SessionLocal

    def price_change_worker():
        while True:
            try:
                time.sleep(30)  # 30초마다 실행
                db = SessionLocal()

                # 랜덤하게 상품 선택
                products = db.query(ProductModel).all()
                if not products:
                    db.close()
                    continue

                product = random.choice(products)

                # 30% 확률로 가격 변동
                if random.random() < 0.3:
                    old_price = product.price
                    change_percent = random.randint(5, 15)

                    # 50% 확률로 인상, 50% 확률로 인하
                    if random.random() < 0.5:
                        new_price = int(old_price * (1 + change_percent / 100))
                        notification_type = "PRICE_UP"
                    else:
                        new_price = int(old_price * (1 - change_percent / 100))
                        notification_type = "PRICE_DOWN"

                    product.price = new_price
                    db.commit()

                    # 모든 사용자에게 알림 생성 (테스트용)
                    users = db.query(UserModel).all()
                    for user in users:
                        notification = NotificationModel(
                            userId=user.id,
                            type=notification_type,
                            productId=product.id,
                            previousPrice=old_price,
                            currentPrice=new_price,
                            isRead=False
                        )
                        db.add(notification)

                    db.commit()
                    print(f"💰 알림 생성: {product.albumName} ({old_price} → {new_price})")

                db.close()
            except Exception as e:
                print(f"알림 생성 오류: {e}")

    # 백그라운드 스레드에서 실행
    thread = threading.Thread(target=price_change_worker, daemon=True)
    thread.start()

def init_default_data():
    """기본 샘플 데이터 초기화"""
    from database import SessionLocal
    db = SessionLocal()

    try:
        # 기존 데이터가 있으면 스킵
        existing_user = db.query(UserModel).first()
        if existing_user:
            return

        # 테스트 사용자 생성
        test_users = [
            UserModel(
                email="seller@example.com",
                password=hash_password("Seller1234!@"),
                name="레코드 판매자",
                phone="010-1111-2222",
                profileImage="/images/profile/seller.jpg"
            ),
            UserModel(
                email="buyer@example.com",
                password=hash_password("Buyer1234!@"),
                name="구매자",
                phone="010-3333-4444",
                profileImage="/images/profile/buyer.jpg"
            )
        ]
        db.add_all(test_users)
        db.commit()

        # 테스트 상품 생성
        sample_products = [
            ProductModel(
                albumName="Rumours",
                artist="Fleetwood Mac",
                genre="ROCK",
                condition="NM",
                price=85000,
                tradeMethod="BOTH",
                barcode="0075992605138",
                description="Fleetwood Mac의 명작 앨범. 거의 새것 같은 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=45
            ),
            ProductModel(
                albumName="Kind of Blue",
                artist="Miles Davis",
                genre="JAZZ",
                condition="VG+",
                price=72000,
                tradeMethod="DELIVERY",
                barcode="0016861829425",
                description="재즈의 명반. 약간의 사용감이 있지만 재생에는 문제없습니다.",
                albumImage="",
                sellerId=1,
                likeCount=32
            ),
            ProductModel(
                albumName="Thriller",
                artist="Michael Jackson",
                genre="POP",
                condition="M",
                price=95000,
                tradeMethod="BOTH",
                barcode="0082408029621",
                description="전설적인 팝앨범. 개봉했지만 완벽한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=78
            ),
            ProductModel(
                albumName="Purple Rain",
                artist="Prince",
                genre="ROCK",
                condition="VG",
                price=68000,
                tradeMethod="DIRECT",
                barcode="0077923614627",
                description="Prince의 걸작. 약간의 스크래치가 있습니다.",
                albumImage="",
                sellerId=1,
                likeCount=56
            ),
            ProductModel(
                albumName="Abbey Road",
                artist="The Beatles",
                genre="ROCK",
                condition="EX",
                price=120000,
                tradeMethod="BOTH",
                barcode="0077776184025",
                description="비틀즈의 마지막 앨범. 매우 좋은 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=102
            ),
            ProductModel(
                albumName="Dark Side of the Moon",
                artist="Pink Floyd",
                genre="ROCK",
                condition="NM",
                price=110000,
                tradeMethod="BOTH",
                barcode="0054429161320",
                description="프로그레시브 록의 명작. 거의 새것입니다.",
                albumImage="",
                sellerId=1,
                likeCount=88
            ),
            ProductModel(
                albumName="Born to Run",
                artist="Bruce Springsteen",
                genre="ROCK",
                condition="VG+",
                price=75000,
                tradeMethod="DELIVERY",
                barcode="0075992631125",
                description="스프링스틴의 대표작. 양호한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=41
            ),
            ProductModel(
                albumName="Clair de Lune",
                artist="Claude Debussy",
                genre="CLASSICAL",
                condition="M",
                price=65000,
                tradeMethod="BOTH",
                barcode="0075992841421",
                description="클래식 음악의 보석. 완벽한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=34
            ),
            ProductModel(
                albumName="Illmatic",
                artist="Nas",
                genre="HIPHOP",
                condition="VG",
                price=58000,
                tradeMethod="DIRECT",
                barcode="0075992234521",
                description="90년대 힙합의 명작. 약간의 사용감이 있습니다.",
                albumImage="",
                sellerId=1,
                likeCount=29
            ),
            ProductModel(
                albumName="Discovery",
                artist="Daft Punk",
                genre="ELECTRONIC",
                condition="NM",
                price=82000,
                tradeMethod="BOTH",
                barcode="0075992145621",
                description="일렉트로닉 뮤직의 걸작. 거의 새것 같습니다.",
                albumImage="",
                sellerId=1,
                likeCount=67
            ),
            ProductModel(
                albumName="Houses of the Holy",
                artist="Led Zeppelin",
                genre="ROCK",
                condition="VG+",
                price=98000,
                tradeMethod="BOTH",
                barcode="0075992341425",
                description="LED ZEPPELIN의 명곡 모음. 양호한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=51
            ),
            ProductModel(
                albumName="A Love Supreme",
                artist="John Coltrane",
                genre="JAZZ",
                condition="NM",
                price=88000,
                tradeMethod="DELIVERY",
                barcode="0075992451425",
                description="존 콜트레인의 걸작. 거의 새것 같습니다.",
                albumImage="",
                sellerId=1,
                likeCount=43
            ),
            ProductModel(
                albumName="Nevermind",
                artist="Nirvana",
                genre="ROCK",
                condition="VG",
                price=75000,
                tradeMethod="BOTH",
                barcode="0075992551425",
                description="Nirvana의 1집. 약간의 사용감이 있습니다.",
                albumImage="",
                sellerId=1,
                likeCount=89
            ),
            ProductModel(
                albumName="The Wall",
                artist="Pink Floyd",
                genre="ROCK",
                condition="M",
                price=105000,
                tradeMethod="DELIVERY",
                barcode="0075992651425",
                description="Pink Floyd의 더블 앨범. 완벽한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=76
            ),
            ProductModel(
                albumName="Thriller",
                artist="Michael Jackson",
                genre="POP",
                condition="VG+",
                price=92000,
                tradeMethod="BOTH",
                barcode="0075992751425",
                description="팝의 왕 마이클 잭슨의 대표작 재출시. 양호 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=65
            ),
            ProductModel(
                albumName="Taste of Honey",
                artist="A Taste of Honey",
                genre="JAZZ",
                condition="EX",
                price=45000,
                tradeMethod="DIRECT",
                barcode="0075992851425",
                description="부드러운 재즈 음악. 약간의 사용감이 있으나 재생 양호합니다.",
                albumImage="",
                sellerId=1,
                likeCount=27
            ),
            ProductModel(
                albumName="Sketches of Spain",
                artist="Miles Davis",
                genre="JAZZ",
                condition="NM",
                price=85000,
                tradeMethod="BOTH",
                barcode="0075992951425",
                description="Miles Davis의 스페인 풍 재즈. 완벽한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=38
            ),
            ProductModel(
                albumName="Moanin'",
                artist="Art Blakey",
                genre="JAZZ",
                condition="VG+",
                price=68000,
                tradeMethod="DELIVERY",
                barcode="0075993051425",
                description="Art Blakey의 재즈 명곡. 양호한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=31
            ),
            ProductModel(
                albumName="Blue Train",
                artist="John Coltrane",
                genre="JAZZ",
                condition="VG+",
                price=75000,
                tradeMethod="BOTH",
                barcode="0075993151425",
                description="콜트레인의 블루 트레인. 양호한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=44
            ),
            ProductModel(
                albumName="Midnight Special",
                artist="Bill Evans",
                genre="JAZZ",
                condition="NM",
                price=80000,
                tradeMethod="DELIVERY",
                barcode="0075993251425",
                description="Bill Evans의 미드나이트. 거의 새것 같습니다.",
                albumImage="",
                sellerId=1,
                likeCount=35
            ),
            ProductModel(
                albumName="My Funny Valentine",
                artist="Chet Baker",
                genre="JAZZ",
                condition="VG+",
                price=72000,
                tradeMethod="DIRECT",
                barcode="0075993351425",
                description="Chet Baker의 낭만적인 재즈. 양호한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=29
            ),
            ProductModel(
                albumName="Thelonious Monk Quartet",
                artist="Thelonious Monk",
                genre="JAZZ",
                condition="NM",
                price=90000,
                tradeMethod="BOTH",
                barcode="0075993451425",
                description="Thelonious Monk의 4중주 앨범. 완벽한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=41
            ),
            ProductModel(
                albumName="Giant Steps",
                artist="John Coltrane",
                genre="JAZZ",
                condition="EX",
                price=78000,
                tradeMethod="BOTH",
                barcode="0075993551425",
                description="콜트레인의 거대한 발걸음. 좋은 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=52
            ),
            ProductModel(
                albumName="Ballads",
                artist="Bill Evans",
                genre="JAZZ",
                condition="VG",
                price=65000,
                tradeMethod="DELIVERY",
                barcode="0075993651425",
                description="Bill Evans의 발라드 모음. 약간의 사용감이 있습니다.",
                albumImage="",
                sellerId=1,
                likeCount=26
            ),
            ProductModel(
                albumName="Someday My Prince Will Come",
                artist="Bill Evans",
                genre="JAZZ",
                condition="NM",
                price=82000,
                tradeMethod="BOTH",
                barcode="0075993751425",
                description="Bill Evans의 낭만적 재즈. 거의 새것 같습니다.",
                albumImage="",
                sellerId=1,
                likeCount=37
            ),
            ProductModel(
                albumName="Stardust",
                artist="Chet Baker",
                genre="JAZZ",
                condition="VG+",
                price=70000,
                tradeMethod="DELIVERY",
                barcode="0075993851425",
                description="Chet Baker의 스타더스트. 양호한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=30
            ),
            ProductModel(
                albumName="Plays Cole Porter",
                artist="John Coltrane",
                genre="JAZZ",
                condition="NM",
                price=86000,
                tradeMethod="BOTH",
                barcode="0075993951425",
                description="콜트레인이 연주한 콜 포터 명곡. 완벽한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=39
            ),
            ProductModel(
                albumName="Impressions",
                artist="John Coltrane",
                genre="JAZZ",
                condition="VG+",
                price=76000,
                tradeMethod="DELIVERY",
                barcode="0075994051425",
                description="콜트레인의 인상곡 모음. 양호한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=42
            ),
            ProductModel(
                albumName="Naima",
                artist="John Coltrane",
                genre="JAZZ",
                condition="NM",
                price=84000,
                tradeMethod="BOTH",
                barcode="0075994151425",
                description="콜트레인의 나이마. 거의 새것 같습니다.",
                albumImage="",
                sellerId=1,
                likeCount=40
            ),
            ProductModel(
                albumName="In a Sentimental Mood",
                artist="Duke Ellington",
                genre="JAZZ",
                condition="VG+",
                price=73000,
                tradeMethod="DELIVERY",
                barcode="0075994251425",
                description="Duke Ellington의 감상적 기분. 양호한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=33
            ),
            ProductModel(
                albumName="Autumn Leaves",
                artist="Bill Evans",
                genre="JAZZ",
                condition="NM",
                price=81000,
                tradeMethod="BOTH",
                barcode="0075994351425",
                description="Bill Evans의 가을 낙엽. 완벽한 상태입니다.",
                albumImage="",
                sellerId=1,
                likeCount=36
            )
        ]
        db.add_all(sample_products)
        db.commit()

        # 테스트 알림 생성
        sample_notifications = [
            NotificationModel(
                userId=2,
                type="PRICE_DOWN",
                productId=1,
                previousPrice=95000,
                currentPrice=85000,
                isRead=False
            ),
            NotificationModel(
                userId=2,
                type="PRICE_DOWN",
                productId=3,
                previousPrice=100000,
                currentPrice=95000,
                isRead=False
            )
        ]
        db.add_all(sample_notifications)
        db.commit()

        print("✅ 샘플 데이터 생성 완료 (33개 앨범 - JAZZ 17개 포함)")
    finally:
        db.close()

@app.on_event("startup")
async def startup():
    print("=" * 60)
    print(f"🎵 {settings.app_name} v{settings.app_version} 시작됨")
    print("=" * 60)
    create_tables()
    print("✅ 데이터베이스 준비 완료")
    init_default_data()
    simulate_price_changes()
    print("📊 알림 시뮬레이션 시작 (30초 주기)")

@app.on_event("shutdown")
async def shutdown():
    print("\n" + "=" * 60)
    print(f"👋 {settings.app_name} 종료됨")
    print("=" * 60)

# ==================== 헬스체크 ====================

@app.get("/", tags=["health"])
async def root():
    return {"message": f"🎵 {settings.app_name} v{settings.app_version}", "status": "running"}

@app.get("/health", tags=["health"])
async def health():
    return {"status": "healthy"}

# ==================== 인증 API ====================

@app.post("/auth/login", response_model=BaseResponse, tags=["auth"])
async def login(request: LoginRequest, db: Session = Depends(get_db)):
    """로그인"""
    errors = []

    if not request.email:
        errors.append(ErrorDetail(code="REQUIRED", field="email", message="이메일을 입력해주세요."))
    elif not validate_email(request.email):
        errors.append(ErrorDetail(code="INVALID_FORMAT", field="email", message="올바른 이메일 형식을 입력해주세요."))

    if not request.password:
        errors.append(ErrorDetail(code="REQUIRED", field="password", message="비밀번호를 입력해주세요."))
    else:
        is_valid, error_msg = validate_password_login(request.password)
        if not is_valid:
            if len(request.password) < 6:
                errors.append(ErrorDetail(code="INVALID_LENGTH", field="password", message="비밀번호는 6자 이상이어야 합니다."))
            else:
                errors.append(ErrorDetail(code="INVALID_FORMAT", field="password", message="비밀번호는 대문자와 소문자를 각 1자 이상 포함해야 합니다."))

    if errors:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "success": False,
                "message": "유효성 검사 실패",
                "data": None,
                "errors": [e.dict() for e in errors],
                "pagination": None
            }
        )

    user = db.query(UserModel).filter(UserModel.email == request.email).first()
    if not user or not verify_password(request.password, user.password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail={"success": False, "message": "로그인 실패", "errors": [{"code": "INVALID_CREDENTIALS", "message": "이메일 또는 비밀번호가 올바르지 않습니다."}]})

    token = create_access_token(data={"sub": str(user.id), "email": user.email})

    return BaseResponse(success=True, message="로그인 성공", data={"token": token, "user": {"id": user.id, "email": user.email, "name": user.name, "phone": user.phone}})

@app.post("/auth/login/v2", response_model=BaseResponse, tags=["auth"])
async def login_v2(request: LoginRequest, db: Session = Depends(get_db)):
    """로그인 v2"""
    errors = []

    if not request.email:
        errors.append(ErrorDetail(code="REQUIRED", field="email", message="이메일을 입력해주세요."))
    elif not validate_email(request.email):
        errors.append(ErrorDetail(code="INVALID_FORMAT", field="email", message="올바른 이메일 형식을 입력해주세요."))

    if not request.password:
        errors.append(ErrorDetail(code="REQUIRED", field="password", message="비밀번호를 입력해주세요."))
    else:
        is_valid, error_msg = validate_password_login(request.password)
        if not is_valid:
            if len(request.password) < 6:
                errors.append(ErrorDetail(code="INVALID_LENGTH", field="password", message="비밀번호는 6자 이상이어야 합니다."))
            else:
                errors.append(ErrorDetail(code="INVALID_FORMAT", field="password", message="비밀번호는 대문자와 소문자를 각 1자 이상 포함해야 합니다."))

    if errors:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "success": False,
                "message": "유효성 검사 실패",
                "data": None,
                "errors": [e.dict() for e in errors],
                "pagination": None
            }
        )

    user = db.query(UserModel).filter(UserModel.email == request.email).first()
    if not user or not verify_password(request.password, user.password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail={"success": False, "message": "로그인 실패", "errors": [{"code": "INVALID_CREDENTIALS", "message": "이메일 또는 비밀번호가 올바르지 않습니다."}]})

    token = create_access_token(data={"sub": str(user.id), "email": user.email})

    return BaseResponse(success=True, message="로그인 성공", data={"token": token, "user": {"id": user.id, "email": user.email, "name": user.name}})

@app.post("/auth/signup", response_model=BaseResponse, tags=["auth"])
async def signup(request: SignupRequest, db: Session = Depends(get_db)):
    """회원가입"""
    errors = []

    if not request.email:
        errors.append(ErrorDetail(code="REQUIRED", field="email", message="이메일을 입력해주세요."))
    elif not validate_email(request.email):
        errors.append(ErrorDetail(code="INVALID_FORMAT", field="email", message="올바른 이메일 형식을 입력해주세요."))

    if not request.password:
        errors.append(ErrorDetail(code="REQUIRED", field="password", message="비밀번호를 입력해주세요."))
    else:
        is_valid, error_msg = validate_password_signup(request.password)
        if not is_valid:
            errors.append(ErrorDetail(code="INVALID_PASSWORD", field="password", message=error_msg))

    if not request.name:
        errors.append(ErrorDetail(code="REQUIRED", field="name", message="이름을 입력해주세요."))
    elif not validate_name(request.name):
        errors.append(ErrorDetail(code="INVALID_FORMAT", field="name", message="이름은 한글 또는 영문만 입력 가능합니다."))

    if not request.phone:
        errors.append(ErrorDetail(code="REQUIRED", field="phone", message="휴대폰 번호를 입력해주세요."))
    elif not validate_phone(request.phone):
        errors.append(ErrorDetail(code="INVALID_FORMAT", field="phone", message="휴대폰 번호는 010-XXXX-XXXX 형식으로 입력해주세요."))

    if errors:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail={"success": False, "message": "유효성 검사 실패", "errors": [e.dict() for e in errors]})

    existing_user = db.query(UserModel).filter(UserModel.email == request.email).first()
    if existing_user:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail={"success": False, "message": "회원가입 실패", "errors": [{"code": "EMAIL_ALREADY_EXISTS", "message": "이미 가입된 이메일입니다."}]})

    new_user = UserModel(email=request.email, password=hash_password(request.password), name=request.name, phone=request.phone)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return BaseResponse(success=True, message="회원가입이 완료되었습니다.", data={"id": new_user.id, "email": new_user.email, "name": new_user.name, "phone": new_user.phone, "createdAt": new_user.createdAt.isoformat() + "Z"})

# ==================== 상품 조회 API ====================

@app.get("/products", response_model=BaseResponse, tags=["products"])
async def list_products(
    http_request: Request,
    sort: str = Query("recent"),
    limit: Optional[int] = Query(None, ge=1),
    keyword: Optional[str] = Query(None),
    genres: Optional[str] = Query(None),
    conditions: Optional[str] = Query(None),
    minPrice: Optional[int] = Query(None),
    maxPrice: Optional[int] = Query(None),
    tradeMethod: Optional[str] = Query(None),
    barcode: Optional[str] = Query(None),
    page: int = Query(1, ge=1),
    size: int = Query(12, ge=1),
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """상품 목록 조회"""
    query = db.query(ProductModel)

    if keyword:
        query = query.filter((ProductModel.albumName.ilike(f"%{keyword}%")) | (ProductModel.artist.ilike(f"%{keyword}%")))
    if barcode:
        query = query.filter(ProductModel.barcode == barcode)
    if genres:
        genre_list = [g.strip() for g in genres.split(",")]
        query = query.filter(ProductModel.genre.in_(genre_list))
    if conditions:
        condition_list = [c.strip() for c in conditions.split(",")]
        query = query.filter(ProductModel.condition.in_(condition_list))
    if minPrice is not None:
        query = query.filter(ProductModel.price >= minPrice)
    if maxPrice is not None:
        query = query.filter(ProductModel.price <= maxPrice)
    if tradeMethod:
        query = query.filter(ProductModel.tradeMethod.in_([tradeMethod, "BOTH"]))

    if sort == "popular":
        query = query.order_by(ProductModel.likeCount.desc())
    elif sort == "price_asc":
        query = query.order_by(ProductModel.price.asc())
    else:
        query = query.order_by(ProductModel.createdAt.desc())

    total_count = query.count()

    # limit 파라미터 사용, 또는 바코드 검색 시: 페이지네이션 없이 {success, data, totalCount} 형태로 반환
    # (스펙: "limit 사용 (페이지네이션 없음)", 바코드 검색 200 OK 응답 모두 pagination 없음)
    if limit is not None or barcode:
        products = query.limit(limit).all() if limit is not None else query.all()
        return BaseResponse(success=True, data=[{"id": p.id, "albumName": p.albumName, "artist": p.artist, "genre": p.genre, "condition": p.condition, "price": p.price, "tradeMethod": p.tradeMethod, "albumImage": resolve_image_url(http_request, p.albumImage), "likeCount": p.likeCount, "createdAt": p.createdAt.isoformat() + "Z"} for p in products], totalCount=total_count)

    offset = (page - 1) * size
    products = query.offset(offset).limit(size).all()

    from schemas import PaginationInfo
    pagination = PaginationInfo(page=page, size=size, totalCount=total_count, totalPages=(total_count + size - 1) // size, hasNext=page < (total_count + size - 1) // size)

    return BaseResponse(success=True, data=[{"id": p.id, "albumName": p.albumName, "artist": p.artist, "genre": p.genre, "condition": p.condition, "price": p.price, "tradeMethod": p.tradeMethod, "albumImage": resolve_image_url(http_request, p.albumImage), "likeCount": p.likeCount, "createdAt": p.createdAt.isoformat() + "Z"} for p in products], pagination=pagination)

@app.get("/products/me", response_model=BaseResponse, tags=["products"])
async def get_my_products(
    http_request: Request,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """내 상품 조회"""
    user_id = current_user["user_id"]
    products = db.query(ProductModel).filter(ProductModel.sellerId == user_id).all()
    return BaseResponse(success=True, data=[{"id": p.id, "albumName": p.albumName, "artist": p.artist, "genre": p.genre, "condition": p.condition, "price": p.price, "tradeMethod": p.tradeMethod, "albumImage": resolve_image_url(http_request, p.albumImage), "createdAt": p.createdAt.isoformat() + "Z"} for p in products])

@app.get("/products/{product_id}", response_model=BaseResponse, tags=["products"])
async def get_product(
    product_id: int,
    http_request: Request,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """상품 상세 조회"""
    product = db.query(ProductModel).filter(ProductModel.id == product_id).first()

    if not product:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail={"success": False, "message": "상품을 찾을 수 없습니다.", "errors": [{"code": "PRODUCT_NOT_FOUND", "message": "존재하지 않는 상품입니다."}]})

    seller = None
    if product.sellerId:
        seller_user = db.query(UserModel).filter(UserModel.id == product.sellerId).first()
        if seller_user:
            seller = {"id": seller_user.id, "name": seller_user.name, "email": seller_user.email, "profileImage": resolve_image_url(http_request, seller_user.profileImage)}

    return BaseResponse(success=True, data={"id": product.id, "albumName": product.albumName, "artist": product.artist, "genre": product.genre, "condition": product.condition, "conditionDescription": CONDITION_DESCRIPTIONS.get(product.condition, ""), "price": product.price, "tradeMethod": product.tradeMethod, "barcode": product.barcode, "description": product.description, "albumImage": resolve_image_url(http_request, product.albumImage), "seller": seller, "likeCount": product.likeCount, "createdAt": product.createdAt.isoformat() + "Z"})

# ==================== 상품 관리 API ====================

@app.post("/products", response_model=BaseResponse, status_code=status.HTTP_201_CREATED, tags=["products"])
async def create_product(
    request: ProductCreateRequest,
    http_request: Request,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """상품 등록"""
    user_id = current_user["user_id"]
    errors = []
    if not request.albumName:
        errors.append(ErrorDetail(code="REQUIRED", field="albumName", message="앨범명을 입력해주세요."))
    if not request.artist:
        errors.append(ErrorDetail(code="REQUIRED", field="artist", message="아티스트를 입력해주세요."))
    if not request.genre or request.genre not in GENRE_CODES:
        errors.append(ErrorDetail(code="REQUIRED", field="genre", message="장르를 선택해주세요."))
    if not request.condition or request.condition not in CONDITION_CODES:
        errors.append(ErrorDetail(code="REQUIRED", field="condition", message="음반 상태를 선택해주세요."))
    if request.price is None or request.price < 1000:
        errors.append(ErrorDetail(code="INVALID_RANGE", field="price", message="가격은 1,000원 이상 입력해주세요."))
    if not request.tradeMethod or request.tradeMethod not in TRADE_METHOD_CODES:
        errors.append(ErrorDetail(code="REQUIRED", field="tradeMethod", message="거래 방식을 선택해주세요."))
    if not request.albumImage:
        errors.append(ErrorDetail(code="REQUIRED", field="albumImage", message="상품 이미지를 등록해주세요."))

    if errors:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "success": False,
                "message": "유효성 검사 실패",
                "data": None,
                "errors": [e.dict() for e in errors],
                "pagination": None
            }
        )

    new_product = ProductModel(albumName=request.albumName, artist=request.artist, genre=request.genre, condition=request.condition, price=request.price, tradeMethod=request.tradeMethod, barcode=request.barcode, description=request.description, albumImage=request.albumImage, sellerId=user_id)
    db.add(new_product)
    db.commit()
    db.refresh(new_product)

    return BaseResponse(success=True, message="상품이 등록되었습니다.", data={"id": new_product.id, "albumName": new_product.albumName, "artist": new_product.artist, "genre": new_product.genre, "condition": new_product.condition, "price": new_product.price, "tradeMethod": new_product.tradeMethod, "barcode": new_product.barcode, "description": new_product.description, "albumImage": resolve_image_url(http_request, new_product.albumImage), "createdAt": new_product.createdAt.isoformat() + "Z"})

@app.delete("/products/{product_id}", response_model=BaseResponse, tags=["products"])
async def delete_product(
    product_id: int,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """상품 삭제"""
    user_id = current_user["user_id"]
    product = db.query(ProductModel).filter(ProductModel.id == product_id).first()
    if not product:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail={"success": False, "message": "상품을 찾을 수 없습니다.", "errors": [{"code": "PRODUCT_NOT_FOUND", "message": "존재하지 않는 상품입니다."}]})
    if product.sellerId != user_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail={"success": False, "message": "삭제 권한이 없습니다.", "errors": [{"code": "FORBIDDEN", "message": "본인이 등록한 상품만 삭제할 수 있습니다."}]})

    db.delete(product)
    db.commit()
    return BaseResponse(success=True, message="상품이 삭제되었습니다.", data={"id": product_id})

# ==================== 이미지 업로드 API ====================

@app.post("/upload/image", response_model=BaseResponse, status_code=status.HTTP_201_CREATED, tags=["upload"])
async def upload_image(
    request: ImageUploadRequest,
    http_request: Request,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """이미지 업로드"""
    import base64
    import random
    import re
    import string
    from datetime import datetime

    match = re.match(r"^data:image/(?P<ext>[a-zA-Z0-9.+-]+);base64,(?P<data>.+)$", request.image, re.DOTALL)
    if not match:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail={"success": False, "message": "유효성 검사 실패", "errors": [{"code": "INVALID_FORMAT", "message": "올바른 이미지 형식이 아닙니다."}]})

    ext = match.group("ext").lower()
    ext = "jpg" if ext in ("jpeg", "jpg") else ext
    if ext not in ("jpg", "png", "gif", "webp"):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail={"success": False, "message": "유효성 검사 실패", "errors": [{"code": "INVALID_FORMAT", "message": "올바른 이미지 형식이 아닙니다."}]})

    try:
        image_bytes = base64.b64decode(match.group("data"), validate=True)
    except Exception:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail={"success": False, "message": "유효성 검사 실패", "errors": [{"code": "INVALID_FORMAT", "message": "올바른 이미지 형식이 아닙니다."}]})

    max_bytes = settings.max_image_size_mb * 1024 * 1024
    if len(image_bytes) > max_bytes:
        raise HTTPException(status_code=status.HTTP_413_CONTENT_TOO_LARGE, detail={"success": False, "message": "이미지 업로드 실패", "errors": [{"code": "FILE_TOO_LARGE", "message": f"이미지 크기는 {settings.max_image_size_mb}MB 이하여야 합니다."}]})

    timestamp = datetime.utcnow().strftime("%Y%m%d")
    random_str = ''.join(random.choices(string.ascii_lowercase + string.digits, k=6))
    image_type = "album" if request.type == "ALBUM" else "profile"
    filename = f"uploaded_{timestamp}_{random_str}.{ext}"

    with open(os.path.join(UPLOAD_DIR, image_type, filename), "wb") as f:
        f.write(image_bytes)

    image_url = f"{str(http_request.base_url).rstrip('/')}/images/{image_type}/{filename}"

    return BaseResponse(success=True, message="이미지가 업로드되었습니다.", data={"imageUrl": image_url, "type": request.type, "size": len(image_bytes), "uploadedAt": datetime.utcnow().isoformat() + "Z"})

# ==================== 알림 API ====================

@app.get("/notifications", response_model=BaseResponse, tags=["notifications"])
async def get_notifications(
    http_request: Request,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """알림 조회"""
    user_id = current_user["user_id"]

    notifications = db.query(NotificationModel).filter(NotificationModel.userId == user_id).order_by(NotificationModel.createdAt.desc()).all()
    unread_count = db.query(NotificationModel).filter(NotificationModel.userId == user_id, NotificationModel.isRead == False).count()

    notification_list = []
    for notif in notifications:
        product = db.query(ProductModel).filter(ProductModel.id == notif.productId).first()
        if product:
            notification_list.append({"id": notif.id, "type": notif.type, "title": "가격 인하" if notif.type == "PRICE_DOWN" else "가격 인상", "productId": notif.productId, "albumName": product.albumName, "artist": product.artist, "albumImage": resolve_image_url(http_request, product.albumImage), "previousPrice": notif.previousPrice, "currentPrice": notif.currentPrice, "isRead": notif.isRead, "createdAt": notif.createdAt.isoformat() + "Z"})

    return BaseResponse(success=True, data={"unreadCount": unread_count, "notifications": notification_list})

@app.put("/notifications/read", response_model=BaseResponse, tags=["notifications"])
async def mark_notification_read(
    id: Optional[int] = Query(None),
    all: Optional[bool] = Query(None),
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """알림 읽음 처리"""
    user_id = current_user["user_id"]
    if id is None and all is None:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail={"success": False, "message": "유효성 검사 실패", "errors": [{"code": "INVALID_PARAMS", "message": "id 또는 all 파라미터가 필요합니다."}]})

    if all:
        updated = db.query(NotificationModel).filter(NotificationModel.userId == user_id, NotificationModel.isRead == False).update({"isRead": True})
        db.commit()
        return BaseResponse(success=True, data={"updatedCount": updated}, message="모든 알림이 읽음 처리되었습니다.")
    elif id is not None:
        notification = db.query(NotificationModel).filter(NotificationModel.id == id, NotificationModel.userId == user_id).first()
        if notification:
            notification.isRead = True
            db.commit()
            return BaseResponse(success=True, data={"id": notification.id, "isRead": True, "updatedCount": 1}, message="알림이 읽음 처리되었습니다.")
        return BaseResponse(success=True, data={"id": id, "isRead": False, "updatedCount": 0}, message="알림이 읽음 처리되었습니다.")

@app.delete("/notifications", response_model=BaseResponse, tags=["notifications"])
async def delete_notifications(
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """알림 전체 삭제"""
    user_id = current_user["user_id"]
    deleted = db.query(NotificationModel).filter(NotificationModel.userId == user_id).delete()
    db.commit()
    return BaseResponse(success=True, data={"deletedCount": deleted}, message="모든 알림이 삭제되었습니다.")

# ==================== 테스트 데이터 초기화 ====================

@app.post("/init-sample-data", response_model=BaseResponse, tags=["admin"])
async def init_sample_data(db: Session = Depends(get_db)):
    """테스트용 샘플 데이터 초기화"""
    # 기존 데이터 삭제
    db.query(NotificationModel).delete()
    db.query(ProductModel).delete()
    db.query(UserModel).delete()
    db.commit()

    # 테스트 사용자 생성
    test_users = [
        UserModel(
            email="seller@example.com",
            password=hash_password("Seller1234!@"),
            name="레코드 판매자",
            phone="010-1111-2222",
            profileImage="/images/profile/seller.jpg"
        ),
        UserModel(
            email="buyer@example.com",
            password=hash_password("Buyer1234!@"),
            name="구매자",
            phone="010-3333-4444",
            profileImage="/images/profile/buyer.jpg"
        )
    ]
    db.add_all(test_users)
    db.commit()

    # 테스트 상품 생성
    sample_products = [
        ProductModel(
            albumName="Rumours",
            artist="Fleetwood Mac",
            genre="ROCK",
            condition="NM",
            price=85000,
            tradeMethod="BOTH",
            barcode="0075992605138",
            description="Fleetwood Mac의 명작 앨범. 거의 새것 같은 상태입니다.",
            albumImage="/images/album/rumours.jpg",
            sellerId=1,
            likeCount=45
        ),
        ProductModel(
            albumName="Kind of Blue",
            artist="Miles Davis",
            genre="JAZZ",
            condition="VG+",
            price=72000,
            tradeMethod="DELIVERY",
            barcode="0016861829425",
            description="재즈의 명반. 약간의 사용감이 있지만 재생에는 문제없습니다.",
            albumImage="/images/album/kind_of_blue.jpg",
            sellerId=1,
            likeCount=32
        ),
        ProductModel(
            albumName="Thriller",
            artist="Michael Jackson",
            genre="POP",
            condition="M",
            price=95000,
            tradeMethod="BOTH",
            barcode="0082408029621",
            description="전설적인 팝앨범. 개봉했지만 완벽한 상태입니다.",
            albumImage="/images/album/thriller.jpg",
            sellerId=1,
            likeCount=78
        ),
        ProductModel(
            albumName="Purple Rain",
            artist="Prince",
            genre="ROCK",
            condition="VG",
            price=68000,
            tradeMethod="DIRECT",
            barcode="0077923614627",
            description="Prince의 걸작. 약간의 스크래치가 있습니다.",
            albumImage="/images/album/purple_rain.jpg",
            sellerId=1,
            likeCount=56
        ),
        ProductModel(
            albumName="Abbey Road",
            artist="The Beatles",
            genre="ROCK",
            condition="EX",
            price=120000,
            tradeMethod="BOTH",
            barcode="0077776184025",
            description="비틀즈의 마지막 앨범. 매우 좋은 상태입니다.",
            albumImage="/images/album/abbey_road.jpg",
            sellerId=1,
            likeCount=102
        ),
        ProductModel(
            albumName="Dark Side of the Moon",
            artist="Pink Floyd",
            genre="ROCK",
            condition="NM",
            price=110000,
            tradeMethod="BOTH",
            barcode="0054429161320",
            description="프로그레시브 록의 명작. 거의 새것입니다.",
            albumImage="/images/album/rumours.jpg",
            sellerId=1,
            likeCount=88
        ),
        ProductModel(
            albumName="Born to Run",
            artist="Bruce Springsteen",
            genre="ROCK",
            condition="VG+",
            price=75000,
            tradeMethod="DELIVERY",
            barcode="0075992631125",
            description="스프링스틴의 대표작. 양호한 상태입니다.",
            albumImage="/images/album/born_to_run.jpg",
            sellerId=1,
            likeCount=41
        ),
        ProductModel(
            albumName="Clair de Lune",
            artist="Claude Debussy",
            genre="CLASSICAL",
            condition="M",
            price=65000,
            tradeMethod="BOTH",
            barcode="0075992841421",
            description="클래식 음악의 보석. 완벽한 상태입니다.",
            albumImage="/images/album/purple_rain.jpg",
            sellerId=1,
            likeCount=34
        ),
        ProductModel(
            albumName="Illmatic",
            artist="Nas",
            genre="HIPHOP",
            condition="VG",
            price=58000,
            tradeMethod="DIRECT",
            barcode="0075992234521",
            description="90년대 힙합의 명작. 약간의 사용감이 있습니다.",
            albumImage="/images/album/born_to_run.jpg",
            sellerId=1,
            likeCount=29
        ),
        ProductModel(
            albumName="Discovery",
            artist="Daft Punk",
            genre="ELECTRONIC",
            condition="NM",
            price=82000,
            tradeMethod="BOTH",
            barcode="0075992145621",
            description="일렉트로닉 뮤직의 걸작. 거의 새것 같습니다.",
            albumImage="/images/album/discovery.jpg",
            sellerId=1,
            likeCount=67
        )
    ]
    db.add_all(sample_products)
    db.commit()

    # 테스트 알림 생성
    sample_notifications = [
        NotificationModel(
            userId=2,
            type="PRICE_DOWN",
            productId=1,
            previousPrice=95000,
            currentPrice=85000,
            isRead=False
        ),
        NotificationModel(
            userId=2,
            type="PRICE_DOWN",
            productId=3,
            previousPrice=100000,
            currentPrice=95000,
            isRead=False
        )
    ]
    db.add_all(sample_notifications)
    db.commit()

    return BaseResponse(
        success=True,
        message="샘플 데이터 초기화 완료",
        data={
            "users": 2,
            "products": 10,
            "notifications": 2,
            "testAccounts": [
                {"email": "seller@example.com", "password": "Seller1234!@", "role": "판매자"},
                {"email": "buyer@example.com", "password": "Buyer1234!@", "role": "구매자"}
            ]
        }
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, reload=settings.debug)
