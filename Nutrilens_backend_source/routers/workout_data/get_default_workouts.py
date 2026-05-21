from fastapi import APIRouter, HTTPException, status
from Nutrilens_backend_source.schemas import Workout
from Nutrilens_backend_source.database.db import default_workouts_collection


router = APIRouter()


@router.get("/default_workouts")
async def get_default_workouts():
    default_workout_list = None
    try:
        default_workout_list: list[Workout] = await default_workouts_collection.find().to_list(length=50)

        # Convert ObjectId → str
        for intake in default_workout_list:

            intake["_id"] = str(
                intake["_id"]
            )
    except Exception as e:
        HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail="Default workout fetch error"
        )

    return {"message": "Default workout data successfully fetched", "data": default_workout_list}
