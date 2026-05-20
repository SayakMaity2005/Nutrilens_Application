from fastapi import APIRouter
from Nutrilens_backend_source.database.db import (
    users_collection, dietician_profiles_collection
)
from bson import ObjectId

router = APIRouter(tags=["Dietician"])


@router.get("/dieticians/available")
async def list_available_dieticians():
    """Get list of all verified dieticians. Available to any authenticated user."""

    # Find all verified dietician profiles
    cursor = dietician_profiles_collection.find(
        {"verification_status": "verified"}
    )

    dieticians = []
    async for profile in cursor:
        # Get the user details for this dietician
        try:
            user = await users_collection.find_one(
                {"_id": ObjectId(profile["user_id"])}
            )
            if user:
                dieticians.append({
                    "id": str(user["_id"]),
                    "username": user.get("username"),
                    "full_name": user.get("full_name"),
                    "email": user.get("email"),
                    "specialization": profile.get("specialization"),
                    "qualification": profile.get("qualification"),
                    "experience_years": profile.get("experience_years"),
                    "client_count": len(profile.get("client_ids", [])),
                })
        except Exception:
            continue

    return {"dieticians": dieticians}
