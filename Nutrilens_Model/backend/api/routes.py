from fastapi import APIRouter, File, UploadFile, HTTPException, Request
from pydantic import BaseModel
from typing import Optional
import base64
import io
from PIL import Image
from backend.services.yolo_service import yolo_service
from backend.services.nutrition_service import nutrition_service
from backend.services.grok_service import grok_service

router = APIRouter()

@router.post("/predict")
async def predict_food(request: Request, file: Optional[UploadFile] = File(None)):
    """
    Predicts food from either a multipart file or a JSON payload with a base64 string.
    """
    image_bytes = None

    # 1. Try to get image from multipart file upload
    if file:
        image_bytes = await file.read()
    
    # 2. If no file, try to parse JSON for a base64 string
    else:
        try:
            # Check if it's a JSON request
            content_type = request.headers.get("content-type", "")
            if "application/json" in content_type:
                data = await request.json()
                image_str = data.get("image")
                if image_str:
                    # Handle data:image/jpeg;base64,... prefix
                    if "," in image_str:
                        image_str = image_str.split(",")[1]
                    image_bytes = base64.b64decode(image_str)
        except Exception as e:
            # We don't raise here yet in case there's another way to get data later
            pass

    if not image_bytes:
        raise HTTPException(
            status_code=400, 
            detail="No image provided. Either upload a 'file' using multipart/form-data or send a JSON with an 'image' field."
        )

    # Run Detection and Nutrition Logic
    try:
        detections = yolo_service.predict(image_bytes)
        
        # 3. Enrich with nutrition info and Grok refinement
        enriched_results = []
        pil_image = Image.open(io.BytesIO(image_bytes))
        
        for det in detections:
            # Crop image for Grok (cast to int for safety)
            bbox = det["bbox"]
            x1, y1, x2, y2 = int(bbox["x_min"]), int(bbox["y_min"]), int(bbox["x_max"]), int(bbox["y_max"])
            crop = pil_image.crop((x1, y1, x2, y2))
            
            # Convert crop to bytes
            crop_buffer = io.BytesIO()
            crop.save(crop_buffer, format="JPEG")
            crop_bytes = crop_buffer.getvalue()
            
            # Use Grok to refine the dish name
            refined = await grok_service.refine_dish(crop_bytes, det["class"])
            refined_name = refined.get("name", det["class"])
            dish_description = refined.get("description", "")
            
            # Get nutrition for the REFINED name (or category fallback)
            nutrition_info = nutrition_service.get_nutrition_info(refined_name)
            
            enriched_results.append({
                **det,
                "refined_name": refined_name,
                "description": dish_description,
                "nutrition_info": nutrition_info
            })
        
        # Aggregate all nutrition and get advice
        all_nutrients = [e["nutrition_info"] for e in enriched_results if not e["nutrition_info"].get("unknown")]
        diet_advice = nutrition_service.get_diet_advice(all_nutrients)
        
        return {
            "status": "success",
            "results": enriched_results,
            "diet_summary": diet_advice
        }
    except Exception as e:
        import traceback
        error_msg = traceback.format_exc()
        raise HTTPException(status_code=500, detail=f"Inference error: {error_msg}")
