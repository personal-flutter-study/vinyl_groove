"""
데이터베이스 ORM 모델
"""
from sqlalchemy import create_engine, Column, Integer, String, DateTime, Float, Text, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime
from config import settings

engine = create_engine(settings.database_url, connect_args={"check_same_thread": False} if "sqlite" in settings.database_url else {})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    password = Column(String)
    name = Column(String)
    phone = Column(String, nullable=True)
    profileImage = Column(String, nullable=True)
    createdAt = Column(DateTime, default=datetime.utcnow)
    updatedAt = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Product(Base):
    __tablename__ = "products"
    id = Column(Integer, primary_key=True, index=True)
    albumName = Column(String)
    artist = Column(String)
    genre = Column(String)
    condition = Column(String)
    price = Column(Integer)
    tradeMethod = Column(String)
    barcode = Column(String, nullable=True, index=True)
    description = Column(Text, nullable=True)
    albumImage = Column(String)
    sellerId = Column(Integer, index=True)
    likeCount = Column(Integer, default=0)
    createdAt = Column(DateTime, default=datetime.utcnow, index=True)
    updatedAt = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Like(Base):
    __tablename__ = "likes"
    id = Column(Integer, primary_key=True, index=True)
    userId = Column(Integer, index=True)
    productId = Column(Integer, index=True)
    createdAt = Column(DateTime, default=datetime.utcnow)

class Notification(Base):
    __tablename__ = "notifications"
    id = Column(Integer, primary_key=True, index=True)
    userId = Column(Integer, index=True)
    type = Column(String)
    productId = Column(Integer, index=True)
    previousPrice = Column(Integer, nullable=True)
    currentPrice = Column(Integer, nullable=True)
    isRead = Column(Boolean, default=False)
    createdAt = Column(DateTime, default=datetime.utcnow, index=True)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def create_tables():
    Base.metadata.create_all(bind=engine)

if __name__ == "__main__":
    create_tables()
    print("데이터베이스 테이블 생성 완료")
