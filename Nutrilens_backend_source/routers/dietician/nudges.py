from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from pydantic import BaseModel
from Nutrilens_backend_source.schemas import UserInDB, UserRole
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import (
    dietician_profiles_collection, nudges_collection
)

router = APIRouter(prefix="/dietician", tags=["Dietician"])

class NudgeRequest(BaseModel):
    message: str

@router.post("/clients/{client_id}/nudge")
async def send_nudge(
    client_id: str,
    nudge_data: NudgeRequest,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    if current_user.role != UserRole.dietician:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only dieticians can send nudges"
        )

    # Verify dietician has access to this client
    profile = await dietician_profiles_collection.find_one({"user_id": current_user.id})
    if not profile or client_id not in profile.get("client_ids", []):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not authorized to send nudges to this client"
        )

    nudge_doc = {
        "dietician_id": current_user.id,
        "user_id": client_id,
        "message": nudge_data.message,
        "timestamp": datetime.utcnow(),
        "read": False
    }
    
    try:
        await nudges_collection.insert_one(nudge_doc)
        return {"status_ok": True, "message": "Nudge sent successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to save nudge: {str(e)}"
        )
