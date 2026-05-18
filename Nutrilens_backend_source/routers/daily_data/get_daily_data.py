from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from Nutrilens_backend_source.schemas import UserInDB, DailyDataUser
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_daily_data_collection


router = APIRouter()

@router.get("/daily_data/get_daily_data")
async def get_daily_data(
    date: str,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    try:
        selected_date: datetime = datetime.strptime(
            date,
            "%Y-%m-%d"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Error: date should be in 'YYYY-MM-DD' format only"
        )
    
    try:
        daily_data_dict: dict = await users_daily_data_collection.find_one(
            {"user_id": current_user.id, "date": selected_date}
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail="Daily data fetch error"
        )
    
    if daily_data_dict is not None: 
        daily_data_dict["_id"] = str(daily_data_dict["_id"])
    
    return {"messge": "Daily data fetched successfully", "data": daily_data_dict}

    
