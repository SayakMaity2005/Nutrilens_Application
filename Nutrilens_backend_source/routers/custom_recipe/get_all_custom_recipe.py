from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import Annotated
from Nutrilens_backend_source.schemas import UserInDB, DailyDataUser
from Nutrilens_backend_source.auth import get_current_active_user
from Nutrilens_backend_source.database.db import custom_recipe_collection


router = APIRouter()

@router.get("/custom_recipe/get_all")
async def get_all_custom_recipe(
    current_user: Annotated[UserInDB, Depends(get_current_active_user)]
):
    
    try:
        custom_recipe_list: list[dict] = await custom_recipe_collection.find(
            {"user_id": current_user.id}
        ).to_list(length=3200)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_417_EXPECTATION_FAILED,
            detail="Custom recipe collection fetch error"
        )
    
    if custom_recipe_list is not None:
        for custom_recipe in custom_recipe_list:
            if custom_recipe is not None:
                custom_recipe["_id"] = str(custom_recipe["_id"])
    
    return {"messge": "Custom recipe collection fetched successfully", "data": custom_recipe_list}

    
