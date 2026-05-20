from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import Intake, CustomRecipeData, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import custom_recipe_collection


router = APIRouter()


@router.post("/custom_recipe/add_recipe")
async def add_custom_recipe(
    recipe: Intake,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    # give timestamp to each intakes in meal
    custom_recipe_data = CustomRecipeData(
        user_id = current_user.id,
        timestamp = datetime.now(),
        intake_details = recipe
    )
    
    
    try:
        # try to store in mongo
        await custom_recipe_collection.insert_one(
            custom_recipe_data.model_dump()
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"Database error: {e}"
        )
    

    return {"message": "Custom recipe successfully inserted in db"}

        



