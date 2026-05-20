"""
AI Service Configuration
"""

from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    """Application settings."""
    
    # General
    DEBUG: bool = False
    APP_NAME: str = "AWAS-AI Diagnostics Service"
    VERSION: str = "1.0.0"
    
    # Server
    HOST: str = "0.0.0.0"
    PORT: int = 5000
    
    # CORS
    ALLOWED_ORIGINS: List[str] = ["*"]
    
    # ML Models
    MODEL_PATH: str = "./models"
    YOLO_MODEL: str = "yolov8n.pt"
    EMBEDDING_MODEL: str = "sentence-transformers/all-MiniLM-L6-v2"
    
    # Vector Store
    VECTOR_DB_PATH: str = "./vector_db"
    
    # Redis
    REDIS_HOST: str = "redis"
    REDIS_PORT: int = 6379
    
    # API Gateway
    API_GATEWAY_URL: str = "http://api-gateway:3000"
    
    # Storage
    S3_BUCKET: str = "awas-ai-diagnostics"
    MAX_UPLOAD_SIZE: int = 10 * 1024 * 1024  # 10MB
    
    class Config:
        env_file = ".env"


settings = Settings()