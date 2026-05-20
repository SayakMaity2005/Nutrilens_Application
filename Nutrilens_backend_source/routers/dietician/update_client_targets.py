from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import DailyTarget, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import users_collection, users_daily_data_collection, dietician_profiles_collection

router = APIRouter()

@router.put("/dietician/clients/{client_id}/targets")
async def update_client_targets(
    client_id: str,
    daily_target: DailyTarget,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    # Ensure current user is a dietician
    if current_user.role != "dietician":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only dieticians can set client targets"
        )

    # Verify dietician profile and authorization for this client
    dietician_profile = await dietician_profiles_collection.find_one({"user_id": current_user.id})
    if not dietician_profile or dietician_profile.get("verification_status") != "verified":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Dietician profile is not verified"
        )
        
    if client_id not in dietician_profile.get("client_ids", []):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not authorized to update this client's targets"
        )

    # Convert DailyTarget to dictionary without unsets
    update_daily_target = {
        f"profile.daily_target.{key}": value for key, value in daily_target.model_dump(exclude_unset=True, exclude_none=True).items()
    }

    # Update User Profile in MongoDB
    try:
        result = await users_collection.update_one(
            {"_id": ObjectId(client_id)},
            {"$set": update_daily_target}
        )
        if result.matched_count == 0:
            raise HTTPException(status_code=404, detail="Client not found")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Update request to db failed: {str(e)}"
        )
    
    # Update Today's Daily Data in MongoDB
    today = datetime.combine(datetime.now().date(), datetime.min.time())
    try:
        users_daily_data_dict = await users_daily_data_collection.find_one(
            {"user_id": client_id, "date": today}
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Database error while fetching daily data: {str(e)}"
        )
    
    if users_daily_data_dict is not None:
        update_daily_target_in_daily_data = {
            f"daily_target.{key}": value for key, value in daily_target.model_dump(exclude_unset=True, exclude_none=True).items()
        }
        try:
            await users_daily_data_collection.update_one(
                {"_id": users_daily_data_dict["_id"], "user_id": client_id, "date": today},
                {"$set": update_daily_target_in_daily_data}
            )
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Update request in daily data failed: {str(e)}"
            )

    return {"status_ok": True, "message": "Client targets updated successfully"}
