from fastapi import APIRouter, HTTPException, status
from Nutrilens_backend_source.schemas import MealType, Intake
from Nutrilens_backend_source.database.db import default_intakes_collection


router = APIRouter()


@router.get("/default_intakes")
async def get_default_intakes(meal_type: MealType):
    default_intake_list = None
    try:
        default_intake_list: list[Intake] = await default_intakes_collection.find({"meal_type": meal_type.value}).to_list(length=100)

        # Convert ObjectId → str
        for intake in default_intake_list:

            intake["_id"] = str(
                intake["_id"]
            )
    except Exception as e:
        HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail="Default intake fetch error"
        )

    return {"message": "Default intakes successfully fetched", "data": default_intake_list}
