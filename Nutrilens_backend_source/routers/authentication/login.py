from datetime import timedelta
from fastapi import APIRouter, Depends, Response, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from Nutrilens_backend_source.auth import authenticate_user, create_access_token
from Nutrilens_backend_source.security import Hash
from Nutrilens_backend_source.schemas import Token


from datetime import datetime, timedelta, timezone
from typing import Annotated



# from pydantic import BaseModel

router = APIRouter()

ACCESS_TOKEN_EXPIRE_MINUTES = 2
VALIDATION_TIME = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

ACCESS_TOKEN_EXPIRE_WEEKS = 1
VALIDATION_TIME = timedelta(weeks=ACCESS_TOKEN_EXPIRE_WEEKS)


@router.post("/token")
async def login_for_access_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
) -> Token:
    user = await authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        user_id=user.id, expires_delta=VALIDATION_TIME
    )
    return Token(access_token=access_token, token_type="bearer")


