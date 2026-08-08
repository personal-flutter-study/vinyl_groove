FROM python:3.11-slim

WORKDIR /app

# 시스템 패키지 설치
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Python 패키지 설치
COPY docker/requirements-simple.txt .
RUN pip install --no-cache-dir -r requirements-simple.txt

# 애플리케이션 코드 복사
COPY . .

# 포트 공개
EXPOSE 8000

# 서버 실행
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
