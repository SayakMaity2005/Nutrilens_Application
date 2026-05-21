from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import IntakeInMeal, MealType, Meal, Meals, DailyDataUser, User, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_collection, users_daily_data_collection


router = APIRouter()


@router.post("/daily_data/add_water")
async def add_water_in_daily_data(
    water_quantity: float,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)],
    date: str | None = None
):
    
    # Removed water target checks that were causing 400 Bad Request

    # pymongo does not support date so I had to make the date (of daily_data) as datetime type with min time
    # this make date with min time 00.00.00 like 2026-05-16 00:00:00
    if date:
        try:
            today: datetime = datetime.combine(datetime.strptime(date, "%Y-%m-%d").date(), datetime.min.time())
        except Exception:
            today: datetime = datetime.combine(datetime.now().date(), datetime.min.time())
    else:
        today: datetime = datetime.combine(datetime.now().date(), datetime.min.time())

    
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
    

    if users_daily_data_dict is None:

        # create new meals to add in new daily data
        new_meals: Meals = Meals()

        # new daily data to stored in db
        new_users_daily_data = DailyDataUser(
            user_id = current_user.id,                        # set the cuurent_user's id
            date = today,                                     # set date to today date
            daily_target = current_user.profile.daily_target, # daily_target is current_user's  current daily_target
            meals = new_meals,                                # attach the new_meals (created above) in teh meals fileld
            water = water_quantity
        )

        try:
            await users_daily_data_collection.insert_one(
                new_users_daily_data.model_dump() # model_dump() converts pydantic model (UserModelDB) to python dict
            )
        except Exception as e:
            raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"database error: {e}"
        )
    
    else:
        water_drunk: float = users_daily_data_dict["water"]
    
        try:
            await users_daily_data_collection.update_one(
                {"_id": users_daily_data_dict["_id"], "user_id": current_user.id, "date": today},
                {"$set": {"water": water_drunk + water_quantity}}
            )
        except Exception as e:
            raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"Database error: {e}"
        )

    return {"message": "Water successfully added in daily data"}

        



