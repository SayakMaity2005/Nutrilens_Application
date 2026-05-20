from datetime import timedelta
from fastapi import APIRouter, HTTPException, status
from Nutrilens_backend_source.security import Hash
from Nutrilens_backend_source.schemas import (
    RegisterDieticianForm, UserModelDB, DieticianProfile, Token, Profile, DailyTarget, UserRole
)
from Nutrilens_backend_source.auth import authenticate_user, create_access_token
from Nutrilens_backend_source.database.db import users_collection, dietician_profiles_collection

router = APIRouter(prefix="/dietician", tags=["Dietician"])

ACCESS_TOKEN_EXPIRE_WEEKS = 1
VALIDATION_TIME = timedelta(weeks=ACCESS_TOKEN_EXPIRE_WEEKS)


@router.post("/register")
async def register_dietician(form_data: RegisterDieticianForm) -> Token:
    """Register a new dietician account with optional credential documents stored in MongoDB."""

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
    hashed_password = Hash.get_password_hash(form_data.password)

    # Create user with dietician role
    new_user = UserModelDB(
        username=form_data.username,
        email=form_data.email,
        full_name=form_data.full_name,
        hashed_password=hashed_password,
        role=UserRole.dietician,
        profile=Profile(daily_target=DailyTarget()),
        disabled=False
    )

    # Store user in MongoDB
    result = await users_collection.insert_one(new_user.model_dump())
    user_id = str(result.inserted_id)

    # Create dietician profile document
    dietician_profile = DieticianProfile(
        user_id=user_id,
        specialization=form_data.specialization,
        qualification=form_data.qualification,
        experience_years=form_data.experience_years,
        document_data=form_data.document_data,
        document_filename=form_data.document_filename,
        verification_status="pending",
        client_ids=[]
    )

    await dietician_profiles_collection.insert_one(dietician_profile.model_dump())

    # Auto-login: generate token
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
