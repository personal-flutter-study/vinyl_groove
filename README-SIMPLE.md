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
python -m uvicorn app:app --reload
```

**다른 포트로 실행**
```bash
python -m uvicorn app:app --port 8001 --reload
```

**모든 IP에서 접근 가능하게 (0.0.0.0:8000)**
```bash
python -m uvicorn app:app --host 0.0.0.0 --port 8000 --reload
```

**포트와 호스트 커스터마이징 (예: 0.0.0.0:3000)**
```bash
python -m uvicorn app:app --host 0.0.0.0 --port 3000 --reload
```

> **Windows 참고:** `uvicorn app:app ...` 처럼 `uvicorn`을 바로 실행하면 `'uvicorn' 용어가 인식되지 않습니다` 오류가 날 수 있습니다. pip이 설치한 `uvicorn.exe`가 있는 `Scripts` 폴더가 PATH에 없기 때문입니다. 위처럼 `python -m uvicorn ...` 형태로 실행하면 PATH와 무관하게 항상 동작합니다.

서버가 시작되면 `http://localhost:8000/docs` 에서 Swagger UI를 볼 수 있습니다. (포트 변경 시 해당 포트 번호로 접속)

서버를 처음 시작하면 44개의 샘플 앨범과 아래 테스트 계정이 자동으로 생성됩니다. (DB에 이미 사용자가 있으면 스킵되므로, 다시 생성하려면 `vinyl_groove.db`를 지우고 재시작)

바코드 스캔 테스트용 앨범 2개(`0011105016919`, `5099990656019`)는 위 초기 생성 여부와 무관하게, 서버가 시작될 때마다 없으면 자동으로 채워 넣어집니다.

## 🔑 테스트 계정

| 이메일 | 비밀번호 | 역할 |
|---|---|---|
| `seller@example.com` | `Seller1234!@` | 판매자 (레코드 판매자) |
| `buyer@example.com` | `Buyer1234!@` | 구매자 |

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
- `POST /notifications/trigger` - 알림 생성 (테스트용, 가격 변동 알림을 즉시 발생시킴)
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

### 알림 생성 (테스트용)
특정 상품/방향을 지정하지 않으면 무작위 상품의 가격을 무작위로 인상/인하시키고, 전체 유저에게 알림을 생성합니다.
```bash
curl -X POST http://localhost:8000/notifications/trigger \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "productId": 1,
    "direction": "down",
    "count": 5
  }'
```
`productId`, `direction`, `count` 모두 생략 가능합니다 (`{}`만 보내도 동작, `count` 기본값 1, 최대 50).
`count`를 지정하면 한 번의 호출로 여러 건을 연속 생성합니다. `productId`를 같이 지정하면 그 상품 가격이 매번 누적으로 변동되고, 생략하면 매번 무작위 상품이 선택됩니다.

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
- [x] 알림 생성 (테스트용)
- [x] 알림 읽음 처리
- [x] 알림 삭제
- [x] 바코드 검색

## 🐛 문제 해결

### 포트 8000 이미 사용 중
```bash
# 다른 포트로 실행
python -m uvicorn app:app --port 8001
```

### 'uvicorn' 용어가 인식되지 않습니다 (Windows)
`pip install`은 성공했는데 `uvicorn` 명령을 바로 실행하면 인식이 안 되는 경우, `uvicorn.exe`가 설치된 `Scripts` 폴더가 PATH에 없는 것입니다. 아래처럼 모듈로 실행하세요.
```bash
python -m uvicorn app:app --port 8001 --reload
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

### Swagger UI
- URL: `http://localhost:8000/docs`
- Try it out 버튼으로 직접 실행 가능

### Docker 실행
Docker를 사용하려면 [DOCKER.md](docker/DOCKER.md) 참고

---

간단하고 깔끔한 단일 서버 버전입니다! 🎵
