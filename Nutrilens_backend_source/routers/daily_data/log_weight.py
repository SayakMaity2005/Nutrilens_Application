from typing import Annotated
from datetime import datetime
from bson import ObjectId
from pydantic import BaseModel
from fastapi import APIRouter, Depends, HTTPException, status
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.schemas import UserInDB
from Nutrilens_backend_source.database.db import users_daily_data_collection, users_collection

router = APIRouter()

class LogWeightRequest(BaseModel):
    weight: float
    date: str

@router.post("/daily_data/log_weight")
async def log_weight(
    request: LogWeightRequest,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    try:
        target_date = datetime.strptime(request.date, "%Y-%m-%d")
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid date format. Use YYYY-MM-DD"
        )

    # Update profile weight globally
    try:
        await users_collection.update_one(
            {"_id": ObjectId(current_user.id)},
            {"$set": {"profile.weight": request.weight}}
        )
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update global profile weight"
        )

    # Update weight for specific date in daily data collection
    try:
        await users_daily_data_collection.update_one(
            {"user_id": current_user.id, "date": target_date},
            {"$set": {"weight": request.weight}},
            upsert=True
        )
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to log daily weight"
        )

    return {"message": "Weight logged successfully"}
