from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from typing import Annotated
import os
import base64
from dotenv import load_dotenv
import httpx
import json
from Nutrilens_backend_source.schemas import IntakeInMeal, MealType
from Nutrilens_backend_source.auth import get_current_active_user

router = APIRouter()

# Load environment variables from .env file
load_dotenv(os.path.join(os.path.dirname(__file__), "../../../Nutrilens_Model/.env"), override=True)
load_dotenv(override=True) # also load from current dir just in case

# We use the REST endpoint for Gemini. 
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

@router.post("/analyze_food", response_model=IntakeInMeal)
async def analyze_food(
    file: UploadFile = File(...),
    meal_type: MealType = Form(MealType.lunch),
    quantity: float = Form(...)
):
    """
    Analyzes an uploaded food image using Gemini Vision to identify the food
    and calculate nutritional content simultaneously.
    """
    
    gemini_api_key = os.environ.get("GEMINI_KEY")
    if not gemini_api_key:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="GEMINI_KEY is not set in the environment variables."
        )

    try:
        # Read and encode the uploaded image
        file_content = await file.read()
        mime_type = file.content_type or "image/jpeg"
        base64_image = base64.b64encode(file_content).decode("utf-8")
        
        system_prompt = (
            "You are an expert nutritionist AI. The user has provided an image of food and specified the quantity consumed. "
            "Your task is to visually identify the food and calculate its nutritional content for the specified amount. "
            "Return ONLY a valid JSON object. Do NOT include markdown code blocks (```json) or any other text. "
            "The JSON MUST have EXACTLY these keys: "
            "'food_name' (string - clean and capitalized), 'energy_per_unit' (numeric kcal), 'carbs_per_unit' (numeric grams), "
            "'protein_per_unit' (numeric grams), 'fat_per_unit' (numeric grams)."
        )
        
        user_prompt = f"Identify the food in this image. The user consumed {quantity} grams of it. Calculate the total nutritional values for {quantity} grams."
        
        async with httpx.AsyncClient() as client:
            gemini_response = await client.post(
                GEMINI_API_URL,
                headers={
                    "Content-Type": "application/json",
                    "x-goog-api-key": gemini_api_key
                },
                json={
                    "systemInstruction": {
                        "parts": [{"text": system_prompt}]
                    },
                    "contents": [
                        {
                            "parts": [
                                {"text": user_prompt},
                                {
                                    "inlineData": {
                                        "mimeType": mime_type,
                                        "data": base64_image
                                    }
                                }
                            ]
                        }
                    ],
                    "generationConfig": {
                        "temperature": 0.1
                    }
                },
                timeout=30.0
            )
            
        if gemini_response.status_code != 200:
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail=f"Error from Gemini API: {gemini_response.text}"
            )
            
        gemini_data = gemini_response.json()
        reply_content = gemini_data['candidates'][0]['content']['parts'][0]['text'].strip()
        
        # Strip potential markdown formatting if LLM ignores instructions
        if reply_content.startswith("```json"):
            reply_content = reply_content.replace("```json", "", 1)
        if reply_content.endswith("```"):
            reply_content = reply_content.rsplit("```", 1)[0]
            
        nutrition_info = json.loads(reply_content)
        
        # Format the output as IntakeInMeal
        intake = IntakeInMeal(
            name=nutrition_info.get("food_name", "Unknown Food"),
            meal_type=meal_type.value,
            amount=quantity,
            energy_per_unit=nutrition_info.get("energy_per_unit", 0),
            carbs_per_unit=nutrition_info.get("carbs_per_unit", 0),
            protein_per_unit=nutrition_info.get("protein_per_unit", 0),
            fat_per_unit=nutrition_info.get("fat_per_unit", 0)
        )
        return intake
        
    except json.JSONDecodeError:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to parse Gemini output as JSON: {reply_content}"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to communicate with Gemini API: {str(e)}"
        )
