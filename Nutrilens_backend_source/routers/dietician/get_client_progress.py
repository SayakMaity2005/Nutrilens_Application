from typing import Annotated
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status, Query
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.schemas import UserInDB, UserRole
from Nutrilens_backend_source.database.db import (
    users_daily_data_collection, dietician_profiles_collection
)

router = APIRouter(prefix="/dietician", tags=["Dietician"])


@router.get("/clients/{client_id}/progress")
async def get_client_progress(
    client_id: str,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)],
    date: str = Query(None, description="Date in YYYY-MM-DD format")
):
    """Get a specific client's daily progress data. Only accessible by their assigned dietician."""

    # Must be a dietician
    if current_user.role != UserRole.dietician:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only dieticians can access client progress"
        )

    # Verify this client belongs to the dietician
    profile = await dietician_profiles_collection.find_one(
        {"user_id": current_user.id}
    )

    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Dietician profile not found"
        )

    if profile.get("verification_status") != "verified":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Your account is pending verification"
        )

    if client_id not in profile.get("client_ids", []):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This client is not assigned to you"
        )

    # Determine date
    if date:
        try:
            target_date = datetime.strptime(date, "%Y-%m-%d")
        except ValueError:
            raise HTTPException(
                status_code=400,
                detail="Invalid date format. Use YYYY-MM-DD"
            )
    else:
        target_date = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)

    # Fetch daily data (same logic as get_daily_data)
    daily_data = await users_daily_data_collection.find_one({
        "user_id": client_id,
        "date": target_date
    })

    if not daily_data:
        return {
            "date": target_date.strftime("%Y-%m-%d"),
            "meals": {
                "breakfast": {"meal_type": "breakfast", "consumed_intakes": []},
                "lunch": {"meal_type": "lunch", "consumed_intakes": []},
                "dinner": {"meal_type": "dinner", "consumed_intakes": []},
                "snacks": {"meal_type": "snacks", "consumed_intakes": []}
            },
            "water": 0,
            "daily_target": {
                "energy": 2000, "carbs": 250, "protein": 150, "fat": 44, "water": 2250
            }
        }

    # Clean up MongoDB _id for JSON serialization
    daily_data["_id"] = str(daily_data["_id"])

    return daily_data
