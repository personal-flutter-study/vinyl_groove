"""
Pydantic 스키마 정의
"""
from pydantic import BaseModel
from typing import List, Optional, Any
from datetime import datetime

class ErrorDetail(BaseModel):
    code: str
    field: Optional[str] = None
    message: str

class PaginationInfo(BaseModel):
    page: int
    size: int
    totalCount: int
    totalPages: int
    hasNext: bool

class BaseResponse(BaseModel):
    success: bool
    message: Optional[str] = None
    data: Optional[Any] = None
    errors: Optional[List[ErrorDetail]] = None
    pagination: Optional[PaginationInfo] = None

class User(BaseModel):
    id: int
    email: str
    name: str
    phone: Optional[str] = None
    profileImage: Optional[str] = None

    class Config:
        from_attributes = True
