from datetime import datetime, timedelta, timezone
from fastapi import APIRouter, Depends, HTTPException, status, Response
from auth import create_access_token
from schemas import RegisterForm
from database import get_db
from security import Hash
import models
from dotenv import load_dotenv
import os

load_dotenv()


router = APIRouter()

ACCESS_TOKEN_EXPIRE_MINUTES = 5
VALIDATION_TIME = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

ACCESS_TOKEN_EXPIRE_WEEKS = 1
VALIDATION_TIME = timedelta(weeks=ACCESS_TOKEN_EXPIRE_WEEKS)

@router.post("/register/")
async def register(response: Response, request: RegisterForm, db: Session = Depends(get_db)):
    admin = db.query(models.Admin).filter(models.Admin.username == request.username).first()
    user = db.query(models.User).filter(models.User.username == request.username).first()
    if admin:
        raise HTTPException(
            status_code=status.HTTP_406_NOT_ACCEPTABLE,
            detail=f"Admin with username {admin.username} already registered"
        )
    if user:
        raise HTTPException(
            status_code=status.HTTP_406_NOT_ACCEPTABLE,
            detail=f"User with username {user.username} already registered"
        )
    if request.password != request.confirmPassword:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Password mismatch"
        )
    new_user = models.User(
        name=request.name,
        username=request.username,
        password=Hash.hash_password(request.password),
        role=request.role,
        contact = request.contact
    )
    # db.add(new_user)
    # db.commit()
    # db.refresh(new_user)

    access_token_expires = VALIDATION_TIME
    access_token = create_access_token(
        data={"sub": request.username}, expires_delta=access_token_expires
    )
    # 
    return {"status":"ok","message": "Registration successful!"}
    # return Token(access_token=access_token, token_type="bearer")
    