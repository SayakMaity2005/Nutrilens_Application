from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from Nutrilens_backend_source.schemas import UserInDB, UserRole
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import nudges_collection

router = APIRouter(prefix="/user", tags=["User Operations"])

@router.get("/nudges")
async def get_user_nudges(
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    if current_user.role != UserRole.user:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only users can fetch nudges"
        )
        
    try:
        # Fetch unread nudges sorted by newest first
        cursor = nudges_collection.find(
            {"user_id": current_user.id, "read": False}
        ).sort("timestamp", -1)
        
        nudges = []
        async for document in cursor:
            nudges.append({
                "id": str(document["_id"]),
                "message": document["message"],
                "timestamp": document["timestamp"],
                "dietician_id": document["dietician_id"]
            })
            
        # Mark as read
        if nudges:
            nudge_ids = [n["id"] for n in nudges]
            from bson import ObjectId
            await nudges_collection.update_many(
                {"_id": {"$in": [ObjectId(nid) for nid in nudge_ids]}},
                {"$set": {"read": True}}
            )
            
        return {"nudges": nudges}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch nudges: {str(e)}"
        )
