from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status
from bson import ObjectId
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.schemas import (
    UserInDB, BookMeetingForm, Meeting, MeetingStatus
)
from Nutrilens_backend_source.database.db import (
    users_collection, dietician_profiles_collection, meetings_collection
)

router = APIRouter(prefix="/meetings", tags=["Meetings"])


@router.post("/book")
async def book_meeting(
    form_data: BookMeetingForm,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    """Book a meeting with a dietician. Called by a normal user."""

    # Verify the dietician exists and is verified
    dietician_profile = await dietician_profiles_collection.find_one(
        {"user_id": form_data.dietician_id}
    )

    if not dietician_profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Dietician not found"
        )

    if dietician_profile.get("verification_status") != "verified":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="This dietician is not yet verified"
        )

    # Get dietician's display name
    dietician_user = await users_collection.find_one(
        {"_id": ObjectId(form_data.dietician_id)}
    )
    dietician_name = dietician_user.get("full_name", dietician_user.get("username")) if dietician_user else None

    # Create meeting
    meeting = Meeting(
        dietician_id=form_data.dietician_id,
        user_id=current_user.id,
        user_name=current_user.full_name or current_user.username,
        dietician_name=dietician_name,
        scheduled_at=form_data.scheduled_at,
        notes=form_data.notes,
        status=MeetingStatus.scheduled
    )

    await meetings_collection.insert_one(meeting.model_dump())

    # Auto-add user to dietician's client_ids if not already there
    if current_user.id not in dietician_profile.get("client_ids", []):
        await dietician_profiles_collection.update_one(
            {"user_id": form_data.dietician_id},
            {"$addToSet": {"client_ids": current_user.id}}
        )

    return {"message": "Meeting booked successfully", "status": "ok"}


@router.get("/my")
async def get_my_meetings(
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    """Get all meetings for the current user (works for both users and dieticians)."""

    # Query based on role
    if current_user.role == "dietician":
        query = {"dietician_id": current_user.id}
    else:
        query = {"user_id": current_user.id}

    cursor = meetings_collection.find(query).sort("scheduled_at", 1)
    meetings = []

    async for m in cursor:
        m["_id"] = str(m["_id"])
        meetings.append(m)

    return {"meetings": meetings}


@router.patch("/{meeting_id}/cancel")
async def cancel_meeting(
    meeting_id: str,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    """Cancel a scheduled meeting."""

    meeting = await meetings_collection.find_one({"_id": ObjectId(meeting_id)})

    if not meeting:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meeting not found"
        )

    # Only the user or dietician involved can cancel
    if meeting["user_id"] != current_user.id and meeting["dietician_id"] != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not authorized to cancel this meeting"
        )

    await meetings_collection.update_one(
        {"_id": ObjectId(meeting_id)},
        {"$set": {"status": "cancelled"}}
    )

    return {"message": "Meeting cancelled successfully"}
