from datetime import timedelta
from fastapi import APIRouter, HTTPException, status
from Nutrilens_backend_source.security import Hash
from Nutrilens_backend_source.schemas import RegisterUserForm, UserModelDB, Token
from Nutrilens_backend_source.auth import authenticate_user, create_access_token
from Nutrilens_backend_source.database.db import users_collection

router = APIRouter()

ACCESS_TOKEN_EXPIRE_MINUTES = 5
VALIDATION_TIME = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

ACCESS_TOKEN_EXPIRE_WEEKS = 1
VALIDATION_TIME = timedelta(weeks=ACCESS_TOKEN_EXPIRE_WEEKS)


@router.post("/register")
async def register(form_data: RegisterUserForm) -> Token:

    # Check existing username
    existing_user = await users_collection.find_one(
        {"username": form_data.username}
    )

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="Username already exists"
        )

    # Hash password
    hashed_password = Hash.get_password_hash(
        form_data.password
    )

    # Create new user
    new_user = UserModelDB(
        username=form_data.username,
        email=form_data.email,
        full_name=form_data.full_name,
        hashed_password=hashed_password,
        profile=form_data.profile,
        disabled=False
    )
 
    # Store in MongoDB
    await users_collection.insert_one(
        new_user.model_dump() # model_dump() converts pydantic model (UserModelDB) to python dict
    )

    # Auto-login token
    user_db = await authenticate_user(form_data.username, form_data.password)
    if not user_db:
        raise HTTPException(
            status_code=status.HTTP_424_FAILED_DEPENDENCY,
            detail="Registration failed",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token = create_access_token(
        user_id=user_db.id, expires_delta=VALIDATION_TIME
    )

    return Token(access_token=access_token, token_type="bearer")
