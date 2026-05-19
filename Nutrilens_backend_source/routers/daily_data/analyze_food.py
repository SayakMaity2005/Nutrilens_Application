from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from typing import Annotated
import os
import io
from dotenv import load_dotenv
import httpx
import json
import random
from PIL import Image
from Nutrilens_backend_source.schemas import IntakeInMeal, MealType
from Nutrilens_backend_source.auth import get_current_active_user

router = APIRouter()

# Load environment variables from .env file
load_dotenv(os.path.join(os.path.dirname(__file__), "../../../Nutrilens_Model/.env"), override=True)
load_dotenv(override=True) # also load from current dir just in case

HF_API_URL = "https://rohit2k24-nutrilens-ai.hf.space/api/v1/predict"
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

@router.post("/daily_data/analyze_food", response_model=IntakeInMeal)
async def analyze_food(
    file: UploadFile = File(...),
    quantity: float = Form(...)
):
    """
    Analyzes the uploaded food image using the deployed Hugging Face model,
    then calculates nutritional info via Grok based on the quantity (grams).
    """
    
    # Step 1: Call Hugging Face API to identify the food
    try:
        # Read file contents
        file_content = await file.read()
        
        # Convert image to RGB using Pillow to prevent RGBA errors on Hugging Face
        image = Image.open(io.BytesIO(file_content))
        if image.mode in ("RGBA", "P"):
            image = image.convert("RGB")
            
        img_byte_arr = io.BytesIO()
        image.save(img_byte_arr, format='JPEG')
        img_byte_arr.seek(0)
        
        async with httpx.AsyncClient() as client:
            files = {'file': (file.filename or 'image.jpg', img_byte_arr, 'image/jpeg')}
            hf_response = await client.post(HF_API_URL, files=files, timeout=30.0)
            
        if hf_response.status_code != 200:
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail=f"Error from AI Model: {hf_response.text}"
            )
            
        hf_data = hf_response.json()
        
        # The Hugging Face model might return different JSON structures.
        # Commonly {"label": "pizza"} or similar depending on the exact deployment.
        # From test_api.py, we expect it to return JSON. Let's extract the prediction.
        # Assuming typical HF return: [{"label": "Samosa", "score": 0.95}] or {"prediction": "Samosa"}
        # Adjusting to a robust check:
        food_name = "Unknown Food"
        
        # Format 1: {'status': 'success', 'results': [{'class': 'cham_cham', ...}]}
        # Also handles uppercase keys: {'Status': 'Success', 'Results': []}
        results_list = hf_data.get('results') or hf_data.get('Results')
        
        if isinstance(hf_data, dict) and isinstance(results_list, list):
            if len(results_list) > 0:
                result_item = results_list[0]
                if 'class' in result_item:
                    food_name = result_item['class']
                elif 'label' in result_item:
                    food_name = result_item['label']
            else:
                # Empty results list means nothing was detected
                food_name = "Unknown Food"
        # Format 2: [{"label": "Samosa", "score": 0.95}]
        elif isinstance(hf_data, list) and len(hf_data) > 0 and 'label' in hf_data[0]:
            food_name = hf_data[0]['label']
        # Format 3: {"prediction": "Samosa"}
        elif isinstance(hf_data, dict) and 'prediction' in hf_data:
            food_name = hf_data['prediction']
        elif isinstance(hf_data, dict) and 'label' in hf_data:
            food_name = hf_data['label']
        elif isinstance(hf_data, dict) and 'class' in hf_data:
            food_name = hf_data['class']
        else:
            # Fallback instead of raw string
            food_name = "Unknown Food"
            
        # Clean up the food name if it has underscores (e.g., 'cham_cham' -> 'Cham Cham')
        if food_name != "Unknown Food" and isinstance(food_name, str):
            food_name = food_name.replace("_", " ").title()
            
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to communicate with Hugging Face Model: {str(e)}"
        )
        
    # Step 2: Call Gemini API to get nutritional facts OR generate dummy data
    if food_name == "Unknown Food":
        # Generate dummy data within a reasonable range for 100g base if AI couldn't detect the food
        base_energy = random.randint(150, 350)
        base_carbs = random.randint(10, 40)
        base_protein = random.randint(5, 20)
        base_fat = random.randint(5, 15)
        
        # Scale by quantity
        multiplier = quantity / 100.0 if quantity > 0 else 1.0
        
        nutrition_info = {
            "energy_per_unit": round(base_energy * multiplier, 1),
            "carbs_per_unit": round(base_carbs * multiplier, 1),
            "protein_per_unit": round(base_protein * multiplier, 1),
            "fat_per_unit": round(base_fat * multiplier, 1)
        }
    else:
        gemini_api_key = os.environ.get("GEMINI_KEY")
        if not gemini_api_key:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="GEMINI_KEY is not set in the environment variables."
            )
            
        system_prompt = (
            "You are an expert nutritionist AI. Return ONLY a valid JSON object representing the nutritional "
            "content of the given food and amount. Do NOT include markdown code blocks (```json) or any other text. "
            "The JSON MUST have EXACTLY these numeric keys: "
            "'energy_per_unit' (kcal), 'carbs_per_unit' (grams), 'protein_per_unit' (grams), 'fat_per_unit' (grams)."
        )
        
        user_prompt = f"The food identified is: {food_name}. The user consumed {quantity} grams of it. Calculate the total nutritional values for this amount."
        
        try:
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
                                "parts": [{"text": user_prompt}]
                            }
                        ],
                        "generationConfig": {
                            "temperature": 0.1
                        }
                    },
                    timeout=20.0
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
        
    # Step 3: Format the output as IntakeInMeal
    intake = IntakeInMeal(
        name=food_name,
        type="Solid", # Default
        quantity=quantity,
        energy_per_unit=nutrition_info.get("energy_per_unit", 0),
        carbs_per_unit=nutrition_info.get("carbs_per_unit", 0),
        protein_per_unit=nutrition_info.get("protein_per_unit", 0),
        fat_per_unit=nutrition_info.get("fat_per_unit", 0)
    )
    
    return intake
