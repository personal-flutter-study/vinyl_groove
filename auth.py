"""
JWT 인증
"""
from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from fastapi import HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthenticationCredentials
from config import settings

security = HTTPBearer()

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.access_token_expire_minutes)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.secret_key, algorithm=settings.algorithm)
    return encoded_jwt

def verify_token(token: str) -> dict:
    try:
        payload = jwt.decode(token, settings.secret_key, algorithms=[settings.algorithm])
        return payload
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"success": False, "message": "인증 실패", "errors": [{"code": "INVALID_TOKEN", "message": "유효하지 않은 토큰입니다."}]}
        )

async def get_current_user(credentials: HTTPAuthenticationCredentials = Depends(security)) -> dict:
    """현재 사용자 정보 추출 (토큰 검증)"""
    token = credentials.credentials
    payload = verify_token(token)
    user_id = payload.get("sub")
    email = payload.get("email")

    if user_id is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={"success": False, "message": "인증 실패", "errors": [{"code": "INVALID_TOKEN", "message": "유효하지 않은 토큰입니다."}]}
        )

    return {"user_id": int(user_id), "email": email}
