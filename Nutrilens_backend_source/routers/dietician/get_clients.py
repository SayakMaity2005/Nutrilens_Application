from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status
from bson import ObjectId
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.schemas import UserInDB, UserRole
from Nutrilens_backend_source.database.db import (
    users_collection, dietician_profiles_collection, users_daily_data_collection
)
from datetime import datetime, timedelta

router = APIRouter(prefix="/dietician", tags=["Dietician"])


@router.get("/clients")
async def get_clients(
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    """Get list of all clients assigned to the current dietician."""

    # Must be a dietician
    if current_user.role != UserRole.dietician:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only dieticians can access client list"
        )

    # Get dietician profile
    profile = await dietician_profiles_collection.find_one(
        {"user_id": current_user.id}
    )

    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Dietician profile not found"
        )

    # Check verification status
    if profile.get("verification_status") != "verified":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Your account is pending verification"
        )

    client_ids = profile.get("client_ids", [])

    if not client_ids:
        return {"clients": []}

    # Fetch client details
    clients = []
    for cid in client_ids:
        try:
            user = await users_collection.find_one({"_id": ObjectId(cid)})
            if user:
                client_data = {
                    "id": str(user["_id"]),
                    "username": user.get("username"),
                    "full_name": user.get("full_name"),
                    "email": user.get("email"),
                    "profile": {
                        "age": user.get("profile", {}).get("age"),
                        "gender": user.get("profile", {}).get("gender"),
                        "height": user.get("profile", {}).get("height"),
                        "weight": user.get("profile", {}).get("weight"),
                        "daily_target": user.get("profile", {}).get("daily_target"),
                    },
                    "risk_level": "low",
                    "risk_reason": "On track"
                }

                # Evaluate risk based on last 3 days
                today = datetime.combine(datetime.now().date(), datetime.min.time())
                three_days_ago = today - timedelta(days=3)

                recent_data = await users_daily_data_collection.find(
                    {"user_id": cid, "date": {"$gte": three_days_ago, "$lte": today}}
                ).to_list(length=4)

                if not recent_data:
                    client_data["risk_level"] = "high"
                    client_data["risk_reason"] = "No logs in last 3 days"
                else:
                    exceeded_count = 0
                    for day_data in recent_data:
                        target = day_data.get("daily_target", {})
                        target_energy = target.get("energy", 2000)
                        
                        total_energy = 0
                        meals = day_data.get("meals", {})
                        for meal_type in ["breakfast", "lunch", "dinner", "snacks"]:
                            meal = meals.get(meal_type, {})
                            for intake in meal.get("consumed_intakes", []):
                                total_energy += intake.get("energy_per_unit", 0) * intake.get("quantity", 0)
                        
                        if total_energy > target_energy * 1.15: # Exceeded by 15%
                            exceeded_count += 1
                    
                    if exceeded_count >= 2:
                        client_data["risk_level"] = "high"
                        client_data["risk_reason"] = "Exceeded targets frequently"
                    elif exceeded_count == 1:
                        client_data["risk_level"] = "medium"
                        client_data["risk_reason"] = "Minor target breach"
                
                clients.append(client_data)
        except Exception as e:
            continue

    return {"clients": clients}
