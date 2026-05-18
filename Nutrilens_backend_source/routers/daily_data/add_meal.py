from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import IntakeInMeal, MealType, Meal, Meals, DailyDataUser, User, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_collection, users_daily_data_collection


router = APIRouter()


@router.post("/daily_data/add_meal")
async def add_meal_in_daily_data(
    meal: Meal,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    # give timestamp to each intakes in meal
    for intake in meal.consumed_intakes:
        intake.timestamp = datetime.now()

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
    

    if users_daily_data_dict is None:

        # create new meals to add in new daily data
        new_meals: Meals = Meals()

        # add the consumed+intakes to corresponding Intake round (provided by user, breakfast or lunch or ...)
        if meal.meal_type == MealType.breakfast:
            new_meals.breakfast.consumed_intakes = meal.consumed_intakes
        elif meal.meal_type == MealType.lunch:
            new_meals.lunch.consumed_intakes = meal.consumed_intakes
        elif meal.meal_type == MealType.dinner:
            new_meals.dinner.consumed_intakes = meal.consumed_intakes
        elif meal.meal_type == MealType.snacks:
            new_meals.snacks.consumed_intakes = meal.consumed_intakes
        else: raise HTTPException(
            status_code = status.HTTP_400_BAD_REQUEST,
            detail = "Invalid meal_type"
        )

        # new daily data to stored in db
        new_users_daily_data = DailyDataUser(
            user_id = current_user.id,                        # set the cuurent_user's id
            date = today,                                     # set date to today date
            daily_target = current_user.profile.daily_target, # daily_target is current_user's  current daily_target
            meals = new_meals                                 # attach the new_meals (created above) in teh meals fileld
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
        # list[IntakeInMeal] is list of pydantic object so 1st it should be converted to list of python dict
        consumed_intakes: list[dict] = [intake.model_dump() for intake in meal.consumed_intakes]

        try:
            await users_daily_data_collection.update_one(
                {"_id": users_daily_data_dict["_id"], "user_id": current_user.id, "date": today},
                # to add anything in list in db, this is the process
                {"$push": {f"meals.{meal.meal_type.value}.consumed_intakes": {"$each": consumed_intakes}}}
            )
        except Exception as e:
            raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"Database error: {e}"
        )

    return {"message": "Intakes successfully inserted in daily data"}

        



