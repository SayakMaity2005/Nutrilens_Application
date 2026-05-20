from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from Nutrilens_backend_source.schemas import UserInDB, DailyDataUser
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_daily_data_collection


router = APIRouter()

@router.get("/daily_data/get_daily_data_list")
async def get_daily_data_list(
    start_date: str,
    end_date: str,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    try:
        selected_start_date: datetime = datetime.strptime(
            start_date,
            "%Y-%m-%d"
        )
        selected_end_date: datetime = datetime.strptime(
            end_date,
            "%Y-%m-%d"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error: date should be in 'YYYY-MM-DD' format only"
        )
    
    try:
        # daily_data_dict: dict = await users_daily_data_collection.find_one(
        #     {"user_id": current_user.id, "date": selected_date}
        # )
        daily_data_list = await (
            users_daily_data_collection.find(
                {
                    "user_id": current_user.id,

                    "date": {
                        "$gte": start_date,
                        "$lte": end_date
                    }
                }
            ).to_list(length=36)
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail="Daily data fetch error"
        )
    
    print(len(daily_data_list))
    
    if daily_data_list is not None:
        for daily_data in daily_data_list:
            if daily_data is not None:
                daily_data["_id"] = str(daily_data["_id"])
    
    return {"messge": "Daily data list fetched successfully", "data": daily_data_list}

    
