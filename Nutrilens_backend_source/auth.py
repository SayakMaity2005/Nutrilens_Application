from datetime import datetime, timedelta, timezone
from typing import Annotated

import jwt
from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jwt.exceptions import InvalidTokenError
from motor.motor_asyncio import AsyncIOMotorCollection
from pwdlib import PasswordHash
from pydantic import BaseModel

from bson import ObjectId

from Nutrilens_backend_source.security import Hash
from Nutrilens_backend_source.schemas import TokenData, User, UserInDB
from Nutrilens_backend_source.database.db import users_collection

import os

from dotenv import load_dotenv
load_dotenv(os.path.join(os.path.dirname(__file__), ".env"))


SECRET_KEY = os.getenv("JWT_SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# def get_user(db, username: str):
#     if username in db:
#         user_dict = db[username]
#         return UserInDB(**user_dict)

async def get_user_from_db_by_id(users_collection: AsyncIOMotorCollection, user_id: str) -> UserInDB:

    user_dict = await users_collection.find_one(
        {"_id": ObjectId(user_id)}
    )

    if user_dict:
        # # MongoDB ObjectId remove
        # user_dict.pop("_id", None)
        user_dict["_id"] = str(user_dict["_id"])
        return UserInDB(**user_dict)
        # return User(**user_dict) # not returning the hashed_password

    return None

async def get_user_from_db(users_collection: AsyncIOMotorCollection, username: str) -> UserInDB:

    user_dict = await users_collection.find_one(
        {"username": username}
    )

    if user_dict:
        # # MongoDB ObjectId remove
        # user_dict.pop("_id", None)
        user_dict["_id"] = str(user_dict["_id"])
        return UserInDB(**user_dict) # **user_dict is converting user_dict from python dict to pydantic model
        # return User(**user_dict) # not returning the hashed_password

    return None

async def authenticate_user(username: str, password: str) -> UserInDB:
    user = await get_user_from_db(users_collection=users_collection, username=username)
    if not user:
        # verify_password(password, DUMMY_HASH)
        return False
    if not Hash.verify_password(password, user.hashed_password):
        return False
    return user


def create_access_token(user_id: str, expires_delta: timedelta | None = None):
    to_encode = {"sub": user_id}
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]) -> UserInDB:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("sub")
        if user_id is None:
            raise credentials_exception
        token_data = TokenData(user_id=user_id)
    except InvalidTokenError:
        raise credentials_exception
    user = await get_user_from_db_by_id(users_collection=users_collection, user_id=token_data.user_id)
    if user is None:
        raise credentials_exception
    return user


async def get_current_active_user(
    current_user: Annotated[UserInDB, Depends(get_current_user)],
) -> UserInDB:
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user