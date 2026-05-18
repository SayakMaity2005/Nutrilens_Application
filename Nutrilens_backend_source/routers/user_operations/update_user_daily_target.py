from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import DailyTarget, User, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_collection, users_daily_data_collection


router = APIRouter()

@router.patch("/users/update/daily_target")
async def update_user_daily_target(
    daily_target: DailyTarget,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):

    # model_dump(exclude_unset=True) converts pydantic Obj to python dict excluding the None / null fields
    # .items() is a method over dict in python to convet dict to list of (key, value) pair
    update_daily_target = {
        f"profile.daily_target.{key}": value for key, value in daily_target.model_dump(exclude_unset=True, exclude_none=True).items()
    }

    # for example I sent in profile_data
    # {
    #     "energy": 2200,
    #     "water":  2500
    # }
    # update_profile_data = {
    #     "profile.daily_target.energy": 2200,
    #     "profile.daily_target.water": 2500
    # }

    # Update in MongoDB
    try:
        await users_collection.update_one(
            {"_id": ObjectId(current_user.id), "username": current_user.username},
            {"$set": update_daily_target}
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail="Update request to db failed"
        )
    

    # Also need to update in current or today daily data
    # pymongo does not support date so I had to make the date (of daily_data) as datetime type with min time
    # this make date with min time 00.00.00 like 2026-05-16 00:00:00
    today: datetime = datetime.combine(
        datetime.now().date(),
        datetime.min.time()
    )
    try:
        # try to fetch daily data from mongo db
        users_daily_data_dict = await users_daily_data_collection.find_one(
            {"user_id": current_user.id, "date": today}
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"Database error: {e}"
        )
    
    if users_daily_data_dict is not None:
        update_daily_target_in_daily_data: dict = {
            f"daily_target.{key}": value for key, value in daily_target.model_dump(exclude_unset=True, exclude_none=True).items()
        }
        
        try:
            await users_daily_data_collection.update_one(
                {"_id": users_daily_data_dict["_id"], "user_id": current_user.id, "date": today},
                {"$set": update_daily_target_in_daily_data}
            )
        except Exception as e:
            raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail="Update request in daily data failed"
        )

    
    # current_user is of type UserInDB so it contains password and id
    # which should never be sent to api user
    # model_validate() is a method of pydantic to convert Greater extent pydantic data to its smaller extent pydantic form
    # updated_user = User.model_validate(current_user)
    
    return {"message": "Daily target updated successfully"}




