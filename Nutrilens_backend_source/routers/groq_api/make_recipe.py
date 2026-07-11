from dotenv import load_dotenv
import os
import json

from groq import Groq

from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status
)

from typing import Annotated

from Nutrilens_backend_source.schemas import User

from Nutrilens_backend_source.auth import (
    get_current_active_user
)


load_dotenv()


GROQ_API_KEY = os.getenv(
    "GROQ_API_KEY"
)


client = Groq(
    api_key=GROQ_API_KEY
)


router = APIRouter()



@router.post("/make_recipe")
async def make_custom_recipe(
    user_prompt: str,
    current_user: Annotated[User, Depends(get_current_active_user)],
):

    prompt = f"""
        Generate a healthy recipe using the following ingredients as the primary base:
        {user_prompt}

        You may assume that basic pantry staples (like salt, pepper, oil, water, garlic, common spices) are available and can be used.

        CRITICAL RULES FOR INGREDIENTS:
        - If the user provides ingredients that are completely incompatible or unappetizing together (e.g., banana and mutton), use your culinary expertise to select only the ingredients that work well together and ignore the rest.
        - If the input contains non-food items, ignore them completely.
        - If no sensible recipe can be made from the input, set "success" to false and provide a polite explanation in "error_message" stating why.

        Return ONLY raw valid JSON.

        Do NOT use markdown.
        Do NOT use ```json.

        JSON format:

        {{
            "success": bool,           # true if a valid recipe could be made, false if ingredients are entirely unusable
            "error_message": "str",    # If success is false, explain why. If true, leave as empty string.
            "name": "str",
            "type": "str",

            "quantity": float,         # total weight of the recipe in grams
            "energy_per_unit": float,  # calories per gram
            "carbs_per_unit": float,   # carbs per gram
            "protein_per_unit": float, # protein per gram
            "fat_per_unit": float,     # fat per gram
            "ingredients": ["str"],
            "recipe": "str"            # highly detailed, numbered step-by-step instructions
        }}
    """


    try:

        response = (
            client.chat.completions.create(

                model=
                    "llama-3.3-70b-versatile",

                response_format={"type": "json_object"},

                messages=[

                    {
                        "role": "system",

                        "content":
                            "You are a nutrition and culinary expert."
                    },

                    {
                        "role": "user",

                        "content": prompt
                    }
                ]
            )
        )


        result = (
            response
            .choices[0]
            .message
            .content
        )


        recipe = json.loads(result)

        if not recipe.get("success", True):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=recipe.get("error_message", "Could not generate a sensible recipe from those ingredients.")
            )

        return {
            "message":
                "Recipe generated successfully",

            "data":
                recipe
        }


    except Exception as e:

        print(e)

        raise HTTPException(
            status_code=
                status.HTTP_500_INTERNAL_SERVER_ERROR,

            detail=
                "Recipe generation failed"
        )





# prompt = f"""
# You are a fitness nutrition expert.

# Generate a healthy recipe using ONLY these ingredients:
# {ingredients}

# Goal: {goal}
# Meal type: {meal_type}
# Target calories: around {target_calories}

# Return ONLY valid JSON.

# Format:
# {{
#     "recipe_name": "",
#     "description": "",
#     "ingredients_used": [],
#     "steps": [],
#     "estimated_calories": 0,
#     "protein": 0,
#     "carbs": 0,
#     "fat": 0
# }}
# """


# load_dotenv()

# router = APIRouter()

# client = Groq(
#     api_key=os.getenv("GROQ_API_KEY")
# )

# class RecipeRequest(BaseModel):
#     ingredients: list[str]
#     goal: str

# @router.post("/make_recipe")
# async def make_custom_recipe(
#     user_prompt: str,
#     current_user: Annotated[User, Depends(get_current_active_user)],
# ):
#     prompt = f"""
# Generate a healthy recipe using ONLY:
# {data.ingredients}

# Goal:
# {data.goal}

# Return ONLY valid JSON:
# {{
#     "recipe_name": "",
#     "ingredients_used": [],
#     "steps": []
# }}
# """

#     response = client.chat.completions.create(
#         model="llama-3.3-70b-versatile",
#         messages=[
#             {
#                 "role": "system",
#                 "content": "You are a nutrition expert."
#             },
#             {
#                 "role": "user",
#                 "content": prompt
#             }
#         ]
#     )

#     result = response.choices[0].message.content

#     recipe = json.loads(result)

#     return recipe