import cv2
import numpy as np
from ultralytics import YOLO
from PIL import Image
import io
from backend.core.config import settings
import sys
from pathlib import Path

# Add ai_model path to sys path to import advanced pipeline
ai_model_path = str(Path(__file__).resolve().parent.parent.parent / 'ai_model')
if ai_model_path not in sys.path:
    sys.path.append(ai_model_path)

from advanced_pipeline import NutrilensAdvancedPipeline

class YOLOService:
    _instance = None
    _model = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(YOLOService, cls).__new__(cls)
            # Initialize the advanced pipeline model only once
            try:
                # Use fine-tuned yolo weights and cnn weights
                yolo_weights = r"d:\Projects\Nutrilens_front\runs\detect\IndianFood_92Class\weights\best.pt"
                cnn_weights = r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\best_cnn_stage2.pth"
                cls._model = NutrilensAdvancedPipeline(yolo_weights_path=yolo_weights, cnn_weights_path=cnn_weights)
                print(f"Nutrilens Advanced Pipeline loaded successfully")
            except Exception as e:
                print(f"FAILED to load advanced pipeline: {e}")
                # Fallback
                cls._model = NutrilensAdvancedPipeline(yolo_weights_path="yolo11m.pt") 
        return cls._instance

    @property
    def model(self):
        return self._model

    def predict(self, image_input):
        """
        Runs Nutrilens Advanced Pipeline inference on the input image.
        image_input: bytes or PIL.Image.Image or numpy array
        """
        # Convert bytes to cv2 numpy array
        if isinstance(image_input, bytes):
            image_input = Image.open(io.BytesIO(image_input))
            
        if isinstance(image_input, Image.Image):
            # Convert PIL Image to BGR numpy array for OpenCV
            image_input = cv2.cvtColor(np.array(image_input), cv2.COLOR_RGB2BGR)
        
        # Run advanced inference
        result = self.model.process_image(image_input)
        
        if result is None:
            return []
            
        out_img, pipeline_detections = result
        
        formatted_detections = []
        for det in pipeline_detections:
            formatted_detections.append({
                "class": det["fine_grained_class"], # Expose the 92-class CNN prediction!
                "yolo_base_class": det["yolo_class"],
                "confidence": round(det["confidence"], 3),
                "calories": det["estimated_calories"], # Expose the dynamic calories!
                "bbox": {
                    "x_min": det["bbox"][0],
                    "y_min": det["bbox"][1],
                    "x_max": det["bbox"][2],
                    "y_max": det["bbox"][3]
                }
            })
        
        return formatted_detections

yolo_service = YOLOService()
