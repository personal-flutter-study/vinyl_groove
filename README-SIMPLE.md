# 🎵 Vinyl Groove API - 단일 서버 버전

레코드판 거래 플랫폼 API입니다. 모든 기능이 **하나의 서버**에 통합되어 있어서 간단합니다.

## 📁 파일 구조

```
vinyl-groove-api/
├── app.py              ⭐ 메인 애플리케이션 (모든 API)
├── config.py           설정
├── schemas.py          응답 스키마
├── database.py         ORM 모델
├── auth.py             JWT 인증
├── utils.py            유틸리티
├── requirements-simple.txt  의존성
├── .env-simple         환경 변수 (복사해서 .env로 사용)
└── README-SIMPLE.md    이 파일
```

## 🚀 시작하기

### 1단계: 의존성 설치

```bash
pip install -r requirements-simple.txt
```

### 2단계: 환경 설정

```bash
# .env 파일 생성
cp .env-simple .env
```

### 3단계: 서버 실행

**기본 실행 (localhost:8000)**
```bash
python app.py
```

**Uvicorn으로 실행 (hot reload 활성화)**
```bash
uvicorn app:app --reload
```

**다른 포트로 실행**
```bash
uvicorn app:app --port 8001 --reload
```

**모든 IP에서 접근 가능하게 (0.0.0.0:8000)**
```bash
uvicorn app:app --host 0.0.0.0 --port 8000 --reload
```

**포트와 호스트 커스터마이징 (예: 0.0.0.0:3000)**
```bash
uvicorn app:app --host 0.0.0.0 --port 3000 --reload
```

서버가 시작되면 `http://localhost:8000/docs` 에서 Swagger UI를 볼 수 있습니다. (포트 변경 시 해당 포트 번호로 접속)

**참고:** 서버 시작 시 자동으로 10개의 샘플 앨범과 테스트 사용자가 생성됩니다.
- 테스트 이메일: `seller@example.com` / `buyer@example.com`
- 테스트 비밀번호: `Seller1234!@` / `Buyer1234!@`

## 📚 API 엔드포인트

### 인증 (auth)
- `POST /auth/login` - 로그인
- `POST /auth/signup` - 회원가입

### 상품 조회 (products)
- `GET /products` - 상품 목록 (검색, 필터, 정렬, 페이지)
- `GET /products/{id}` - 상품 상세

### 상품 관리 (products)
- `POST /products` - 상품 등록
- `GET /products/me` - 내 상품
- `DELETE /products/{id}` - 상품 삭제

### 이미지 업로드 (upload)
- `POST /upload/image` - 이미지 업로드 (Base64)

### 알림 (notifications)
- `GET /notifications` - 알림 조회
- `PUT /notifications/read` - 알림 읽음 처리
- `DELETE /notifications` - 알림 삭제

## 🔐 인증

### Bearer Token 사용
```
Authorization: Bearer {token}
```

### Query Parameter 사용
```
?userId=1
```

## 💾 데이터베이스

SQLite 자동 생성 (`vinyl_groove.db`)

## 📝 예제

### 회원가입
```bash
curl -X POST http://localhost:8000/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test1234!@",
    "name": "테스트",
    "phone": "010-1234-5678"
  }'
```

### 로그인
```bash
curl -X POST http://localhost:8000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test1234!@"
  }'
```

### 상품 목록 조회
```bash
curl -X GET "http://localhost:8000/products?page=1&size=10&userId=1" \
  -H "Authorization: Bearer {token}"
```

### 상품 등록
```bash
curl -X POST http://localhost:8000/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "albumName": "Album Name",
    "artist": "Artist Name",
    "genre": "ROCK",
    "condition": "NM",
    "price": 50000,
    "tradeMethod": "BOTH",
    "albumImage": "https://example.com/image.jpg"
  }' \
  -G -d "userId=1"
```

## 🎯 사용 가능한 값

### 장르 (genre)
`ROCK`, `JAZZ`, `POP`, `HIPHOP`, `ELECTRONIC`, `CLASSICAL`, `RNB_SOUL`, `ETC`

### 음반 상태 (condition)
- `SS`: 미개봉
- `M`: Mint (완벽한 상태)
- `NM`: Near Mint (거의 새것)
- `EX`: Excellent (약간의 사용감)
- `VG+`: Very Good Plus (양호)
- `VG`: Very Good (사용감 있음)
- `G`: Good (많은 사용감)

### 거래 방식 (tradeMethod)
`DIRECT` (직거래), `DELIVERY` (택배), `BOTH` (둘 다)

## ✅ 기능 확인 목록

- [x] 회원가입 & 로그인
- [x] 상품 목록 조회 (검색, 필터, 정렬)
- [x] 상품 상세 조회
- [x] 상품 등록
- [x] 내 상품 조회
- [x] 상품 삭제
- [x] 이미지 업로드
- [x] 알림 조회
- [x] 알림 읽음 처리
- [x] 알림 삭제
- [x] 바코드 검색

## 🐛 문제 해결

### 포트 8000 이미 사용 중
```bash
# 다른 포트로 실행
uvicorn app:app --port 8001
```

### 모듈을 찾을 수 없음
```bash
# Python 경로 확인
pwd
# 현재 디렉토리에서 실행
python app.py
```

### 데이터베이스 초기화
```bash
# vinyl_groove.db 파일 삭제
rm vinyl_groove.db
# 재실행하면 자동 생성됨
```

## 📖 더 알아보기

Swagger UI에서 모든 API를 테스트할 수 있습니다:
- URL: `http://localhost:8000/docs`
- Try it out 버튼으로 직접 실행 가능

---

간단하고 깔끔한 단일 서버 버전입니다! 🎵
