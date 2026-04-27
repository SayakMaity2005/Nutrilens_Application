from datetime import timedelta
from fastapi import APIRouter, Depends, Response, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from auth import get_user, create_access_token
from database import get_db
from security import Hash
from schemas import LoginForm, VerifiedUser

router = APIRouter()

ACCESS_TOKEN_EXPIRE_MINUTES = 2
VALIDATION_TIME = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

ACCESS_TOKEN_EXPIRE_WEEKS = 1
VALIDATION_TIME = timedelta(weeks=ACCESS_TOKEN_EXPIRE_WEEKS)

@router.post("/login/")
async def login(response: Response, request: LoginForm, db: Session = Depends(get_db)):
    user = get_user(request.username, db)
    if not user or not Hash.verify_password(request.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Incorrect username or password"
        )
    
    access_token_expires = VALIDATION_TIME
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    
    verifiedUser = VerifiedUser(
        name=user.name,
        username=user.username,
        role=user.role
    )
    return {"status":"ok","message": "Login successful!", "user": verifiedUser}