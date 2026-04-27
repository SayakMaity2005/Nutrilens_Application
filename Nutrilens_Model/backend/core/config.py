import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Nutrilens API"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"
    
    # YOLO Model Configuration
    MODEL_PATH: str = "backend/weights/best_indian_food.pt"
    CONFIDENCE_THRESHOLD: float = 0.25
    
    # Grok/Groq API Configuration
    XAI_API_KEY: str = ""
    
    # CORS Configuration
    CORS_ORIGINS: list = ["*"]
    
    class Config:
        case_sensitive = True
        env_file = ".env"
        extra = "ignore"

settings = Settings()
