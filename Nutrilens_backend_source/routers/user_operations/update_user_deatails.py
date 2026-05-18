from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import UpdateUserDetails, User, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_collection


router = APIRouter()

@router.patch("/users/update/details")
async def update_user_details(
    user_details: UpdateUserDetails,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):

    # model_dump(exclude_unset=True) converts pydantic Obj to python dict excluding the None / null fields
    # Update in MongoDB
    try:
        await users_collection.update_one(
            {"_id": ObjectId(current_user.id), "username": current_user.username},
            {"$set": user_details.model_dump(exclude_unset=True)}
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
    
    return {"message": "User details updated successfully"}




