from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from bson import ObjectId
from Nutrilens_backend_source.schemas import Intake, CustomRecipeData, UserInDB
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import custom_recipe_collection


router = APIRouter()


@router.delete("/custom_recipe/delete_recipe")
async def delete_custom_recipe(
    recipe_id: str,
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    
    try:
        # try to store in mongo
        await custom_recipe_collection.delete_one(
            {"user_id": current_user.id, "_id": ObjectId(recipe_id)}
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail=f"Database error: {e}"
        )
    

    return {"message": "Custom recipe successfully deleted from db"}

        



