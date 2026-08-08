"""
JWT 인증
"""
from typing import Optional
from jose import JWTError, jwt
from fastapi import HTTPException, status, Depends, Query
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from config import settings

security = HTTPBearer(auto_error=False)

def create_access_token(data: dict) -> str:
    # exp(만료시각)를 넣지 않는다: payload가 계정 정보만으로 고정되므로,
    # 같은 계정으로 로그인할 때마다 항상 동일한 토큰 문자열이 발급된다.
    encoded_jwt = jwt.encode(data, settings.secret_key, algorithm=settings.algorithm)
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

async def get_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security),
    userId: Optional[int] = Query(None)
) -> dict:
    """현재 사용자 정보 추출 (Bearer 토큰 또는 userId 쿼리로 인증)"""
    if credentials is not None:
        payload = verify_token(credentials.credentials)
        user_id = payload.get("sub")
        email = payload.get("email")

        if user_id is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail={"success": False, "message": "인증 실패", "errors": [{"code": "INVALID_TOKEN", "message": "유효하지 않은 토큰입니다."}]}
            )

        return {"user_id": int(user_id), "email": email}

    if userId is not None:
        return {"user_id": userId, "email": None}

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail={"success": False, "message": "인증 실패", "errors": [{"code": "INVALID_TOKEN", "message": "인증 정보가 필요합니다."}]}
    )
