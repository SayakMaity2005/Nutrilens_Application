from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import UpdateProfile, User, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_collection


router = APIRouter()

@router.patch("/users/update/profile")
async def update_user_profile(
    profile_data: UpdateProfile,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):

    # model_dump(exclude_unset=True) converts pydantic Obj to python dict excluding the None / null fields
    # .items() is a method over dict in python to convet dict to list of (key, value) pair
    update_profile_data = {
        f"profile.{key}": value for key, value in profile_data.model_dump(exclude_unset=True).items()
    }

    # for example I sent in profile_data
    # {
    #     "height": 20,
    #     "weight": 57
    # }
    # update_profile_data = {
    #     "profile.height": 20,
    #     "profile.weight": 57
    # }

    # Update in MongoDB
    try:
        await users_collection.update_one(
            {"_id": ObjectId(current_user.id), "username": current_user.username},
            {"$set": update_profile_data}
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail="Update request to db failed"
        )
    
    # current_user is of type UserInDB so it contains password and id
    # which should never be sent to api user
    # model_validate() is a method of pydantic to convert Greater extent pydantic data to its smaller extent pydantic form
    # updated_user = User.model_validate(current_user)
    
    return {"message": "profile updated successfully"}




