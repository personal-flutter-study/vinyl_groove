"""
설정 파일
"""
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "Vinyl Groove API"
    app_version: str = "1.0.0"
    debug: bool = True
    secret_key: str = "your-secret-key-change-this-in-production"
    algorithm: str = "HS256"
    database_url: str = "sqlite:///./vinyl_groove.db"
    max_image_size_mb: int = 10
    cors_origins: list = ["*"]

    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()
