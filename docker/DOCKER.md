# 🐳 Docker 실행 가이드

Vinyl Groove API를 Docker로 실행하는 방법입니다.

## 사전 요구사항

- Docker Desktop 설치 ([다운로드](https://www.docker.com/products/docker-desktop))
- Docker Desktop 실행 중

## 🚀 빠른 시작

### 방법 1: Docker Compose (권장)

```bash
cd docker
docker-compose up
```

브라우저에서 `http://localhost:8000/docs` 접속

### 방법 2: Docker 직접 빌드

```bash
cd docker
docker build -t vinyl-groove-api .
docker run -p 8000:8000 vinyl-groove-api
```

## 📋 명령어 모음

### Docker Compose 명령어

```bash
cd docker

# 실행
docker-compose up

# 백그라운드 실행
docker-compose up -d

# 중지
docker-compose down

# 로그 확인
docker-compose logs -f
```

### Docker 직접 빌드 명령어

```bash
cd docker

# 이미지 빌드
docker build -t vinyl-groove-api .

# 컨테이너 실행 (기본)
docker run -p 8000:8000 vinyl-groove-api

# 컨테이너 실행 (백그라운드)
docker run -d -p 8000:8000 --name vinyl-groove vinyl-groove-api

# 컨테이너 중지
docker stop vinyl-groove

# 컨테이너 삭제
docker rm vinyl-groove

# 로그 확인
docker logs vinyl-groove
```

## 🔧 포트 변경

기본 포트 8000 대신 다른 포트 사용:

```bash
cd docker
docker run -p 3000:8000 vinyl-groove-api
# http://localhost:3000/docs 접속
```

## 💾 데이터 유지

SQLite 데이터베이스를 호스트에 저장:

```bash
docker run -p 8000:8000 -v $(pwd):/app vinyl-groove-api
```

## 🐛 문제 해결

### Docker Desktop이 실행되지 않음
- Windows 시작 메뉴에서 "Docker Desktop" 검색 후 실행
- 완전히 시작될 때까지 1-2분 대기

### 포트 8000이 이미 사용 중
```bash
docker run -p 8001:8000 vinyl-groove-api
# http://localhost:8001/docs 접속
```

### 이미지 다시 빌드
```bash
docker build --no-cache -t vinyl-groove-api .
```

## 📊 Docker Compose 환경 변수

`docker-compose.yml` 파일에서 환경 변수 수정 가능:

```yaml
environment:
  - DEBUG=True
  - SECRET_KEY=your-secret-key
  - DATABASE_URL=sqlite:///./vinyl_groove.db
```

---

Docker 없이 실행하려면 [README-SIMPLE.md](../README-SIMPLE.md)를 참고하세요.
