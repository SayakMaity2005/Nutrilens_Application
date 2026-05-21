from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import Workout, DailyWorkoutDataUser, User, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_daily_workout_collection


router = APIRouter()


@router.post("/daily_data/add_workout")
async def add_workout_in_daily_data(
    workout: Workout,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)],
):
    # give timestamp to workout data
    workout.timestamp = datetime.now()

    # pymongo does not support date so I had to make the date (of daily_data) as datetime type with min time
    # this make date with min time 00.00.00 like 2026-05-16 00:00:00

    today: datetime = datetime.combine(datetime.now().date(), datetime.min.time())
    
    try:
        # try to fetch daily data from mongo db
        users_daily_workout_dict = await users_daily_workout_collection.find_one(
            {"user_id": current_user.id, "date": today}
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"Database error: {e}"
        )
    

    if users_daily_workout_dict is None:

        # new daily data to stored in db
        new_users_daily_workout = DailyWorkoutDataUser(
            user_id = current_user.id, # set the cuurent_user's id
            date = today,              # set date to today date
            workouts = [workout]       # attach the workout
        )

        try:
            await users_daily_workout_collection.insert_one(
                new_users_daily_workout.model_dump() # model_dump() converts pydantic model (UserModelDB) to python dict
            )
        except Exception as e:
            raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"database error: {e}"
        )
    
    else:

        try:
            await users_daily_workout_collection.update_one(
                {"_id": users_daily_workout_dict["_id"], "user_id": current_user.id, "date": today},
                # to add anything in list in db, this is the process
                {"$push": {"workouts": workout.model_dump()}}
            )
        except Exception as e:
            raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"Database error: {e}"
        )

    return {"message": "Workout successfully added in daily workout data"}

        



