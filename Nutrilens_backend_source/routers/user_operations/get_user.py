from fastapi import APIRouter, Depends
from typing import Annotated
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.schemas import User

router = APIRouter()

@router.get("/users/me/")
async def read_users_me(
    current_user: Annotated[User, Depends(get_current_active_user)],
):
    # which will be sent as response, need to remove username and hashed_password
    current_user_data: User = User(
    **current_user.model_dump(
        exclude={
            "hashed_password"
        }
    )
)
    return {"message": "User data fetched successfully", "user": current_user_data}