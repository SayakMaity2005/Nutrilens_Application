from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from typing import Annotated
import os
import base64
from dotenv import load_dotenv
import httpx
import json
from io import BytesIO
from PIL import Image
from Nutrilens_backend_source.schemas import IntakeInMeal, MealType
from Nutrilens_backend_source.auth import get_current_active_user

router = APIRouter()

# Load environment variables from .env file
load_dotenv(os.path.join(os.path.dirname(__file__), "../../../Nutrilens_Model/.env"), override=True)
load_dotenv(override=True) # also load from current dir just in case

# We use the REST endpoint for Gemini. 
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

@router.post("/daily_data/analyze_food", response_model=IntakeInMeal)
async def analyze_food(
    file: UploadFile = File(...),
    meal_type: MealType = Form(MealType.lunch),
    quantity: float = Form(...)
):
    """
    Analyzes an uploaded food image using Gemini Vision to identify the food
    and calculate nutritional content simultaneously.
    """
    
    gemini_keys = [
        key for key in [os.environ.get("GEMINI_KEY"), os.environ.get("GEMINI_KEY_2")]
        if key and key != "your_second_api_key_here"
    ]

    if not gemini_keys:
        # Fallback gracefully if no keys are configured
        return IntakeInMeal(
            name="Unidentified Food (No AI Key)",
            meal_type=meal_type.value,
            amount=quantity,
            energy_per_unit=0,
            carbs_per_unit=0,
            protein_per_unit=0,
            fat_per_unit=0
        )

    try:
        # Read the uploaded image
        file_content = await file.read()
        
        # --- Image Compression Logic ---
        try:
            image = Image.open(BytesIO(file_content))
            # Convert to RGB if it has an alpha channel (e.g. PNG)
            if image.mode in ("RGBA", "P"):
                image = image.convert("RGB")
            
            # Resize if the image is too large (max dimension 1024)
            max_size = (1024, 1024)
            image.thumbnail(max_size, Image.Resampling.LANCZOS)
            
            # Save compressed image to bytes
            compressed_io = BytesIO()
            image.save(compressed_io, format="JPEG", quality=85)
            file_content = compressed_io.getvalue()
            mime_type = "image/jpeg"
        except Exception as compression_error:
            print(f"Image compression skipped due to error: {compression_error}")
            # Fallback to original content if PIL fails or is not installed
            mime_type = file.content_type
            if not mime_type or not mime_type.startswith("image/"):
                mime_type = "image/jpeg"
        # -------------------------------
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to read uploaded image: {e}"
        )

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
    
    reply_content = None
    success = False

    async with httpx.AsyncClient() as client:
        for api_key in gemini_keys:
            try:
                gemini_response = await client.post(
                    GEMINI_API_URL,
                    headers={
                        "Content-Type": "application/json",
                        "x-goog-api-key": api_key
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
                
                if gemini_response.status_code == 200:
                    gemini_data = gemini_response.json()
                    reply_content = gemini_data['candidates'][0]['content']['parts'][0]['text'].strip()
                    success = True
                    break
                else:
                    print(f"Gemini API Error with key {api_key[:5]}...: {gemini_response.status_code} - {gemini_response.text}")
                    # Attempt next key on failure
                    continue
                    
            except Exception as e:
                print(f"Exception during Gemini API call with key {api_key[:5]}...: {e}")
                continue

    if not success:
        print("All Gemini API keys failed or exhausted. Returning graceful degradation fallback.")
        return IntakeInMeal(
            name="Unidentified Food (AI Offline)",
            meal_type=meal_type.value,
            amount=quantity,
            energy_per_unit=0,
            carbs_per_unit=0,
            protein_per_unit=0,
            fat_per_unit=0
        )

    try:
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
        print(f"Failed to parse Gemini output as JSON: {reply_content}")
        return IntakeInMeal(
            name="Unidentified Food (Format Error)",
            meal_type=meal_type.value,
            amount=quantity,
            energy_per_unit=0,
            carbs_per_unit=0,
            protein_per_unit=0,
            fat_per_unit=0
        )
