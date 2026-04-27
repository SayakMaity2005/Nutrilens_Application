import cv2
import torch
import numpy as np
import os
import json
from pathlib import Path
from ultralytics import YOLO
import torchvision.transforms as transforms
import torchvision.models as models

class NutrilensAdvancedPipeline:
    """
    Two-Stage Architecture for Nutrilens:
    Stage 1: YOLOv11 for Object Detection (Bounding Boxes)
    Stage 2: Secondary CNN / Regression Model for fine-grained Calorie/Volume Estimation
    """
    def __init__(self, yolo_weights_path="yolo11m.pt", cnn_weights_path=None):
        print("[INFO] Loading Stage 1: YOLOv11 Detector...")
        self.detector = YOLO(yolo_weights_path)
        
        print("[INFO] Loading Stage 2: Secondary CNN Classifier/Regressor...")
        
        # Load classes dynamically from the JSON created during training
        json_path = Path(r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\cnn_class_names.json")
        if json_path.exists():
            with open(json_path, 'r') as f:
                self.cnn_class_names = json.load(f)
            self.num_classes = len(self.cnn_class_names)
            print(f"[INFO] Loaded {self.num_classes} dynamic classes from cnn_class_names.json")
        else:
            print("[WARNING] cnn_class_names.json not found, falling back to default 12 classes")
            self.num_classes = 12
            self.cnn_class_names = [
                'bread_or_Roti_naan', 'curry_dish', 'drink', 'dry_vegetable', 'fish_dish', 'fruits',
                'pasta', 'rice_dish', 'snack_item', 'soup', 'south_indian_breakfast', 'sweet_item'
            ]
        
        self.secondary_model = models.resnet18(weights=models.ResNet18_Weights.DEFAULT)
        # Modify the final layer to match the 12 classes we trained on
        self.secondary_model.fc = torch.nn.Linear(self.secondary_model.fc.in_features, self.num_classes)
        
        if cnn_weights_path and os.path.exists(cnn_weights_path):
            print(f"[INFO] Loading fine-tuned CNN weights from {cnn_weights_path}")
            # Load weights, handling potential mismatch if not strict or mapped
            self.secondary_model.load_state_dict(torch.load(cnn_weights_path, map_location='cpu'))
        else:
            print("[WARNING] No CNN weights provided or found. Using untrained ResNet18 output layer.")
            
        self.secondary_model.eval()
        
        # Image transforms for the secondary CNN
        self.transform = transforms.Compose([
            transforms.ToPILImage(),
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
        ])
        
        # Base calorie dictionary (per 100 sq pixels approximation)
        # This will be replaced by a true regression model once calorie data is available.
        self.calorie_base = {
            0: 2.5,  # bread_or_Roti_naan
            1: 3.0,  # curry_dish
            2: 2.0,  # rice_dish
            3: 1.5,  # dry_vegetable
            4: 4.0,  # snack_item
            5: 4.5,  # sweet_item
            6: 1.0,  # accompaniment
            7: 1.8,  # Dal_or_sambar
            8: 1.2,  # drink
            9: 2.2,  # eggs
            10: 2.8, # fish_dish
            11: 0.8, # fruits
            12: 2.5, # pasta
            13: 0.5, # salad
            14: 0.9, # soup
            15: 2.0  # south_indian_breakfast
        }

    def estimate_calories_regression(self, class_id, bbox_width, bbox_height, img_width, img_height):
        """
        Pseudo-Regression Model:
        Estimates calories based on the relative area of the bounding box compared to the whole image.
        """
        area = bbox_width * bbox_height
        img_area = img_width * img_height
        
        # Normalize relative to the actual image size (0.0 to 1.0)
        # Prevents a 4K photo of an apple from returning 10,000 calories!
        normalized_area = area / img_area
        
        base_factor = self.calorie_base.get(int(class_id), 2.0)
        
        # Simple polynomial regression curve representation: c = factor * (area^1.2) * multiplier
        # Max realistic calories for a full screen plate of food is ~800, not 5000
        estimated_calories = base_factor * (normalized_area ** 1.2) * 800 
        return max(10, round(estimated_calories)) # Minimum 10 calories

    def process_image(self, image_input):
        """
        Runs the full two-stage pipeline on an image.
        """
        if isinstance(image_input, str) or isinstance(image_input, Path):
            img = cv2.imread(str(image_input))
            if img is None:
                print(f"[ERROR] Could not load image: {image_input}")
                return None
        elif isinstance(image_input, np.ndarray):
            img = image_input
        else:
            print(f"[ERROR] Unsupported image type: {type(image_input)}")
            return None
            
        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # --- STAGE 1: YOLO Detection ---
        # Set a lower confidence threshold to catch more potential food items
        results = self.detector(img_rgb, conf=0.15)[0]
        
        detections = []
        
        for box in results.boxes:
            x1, y1, x2, y2 = map(int, box.xyxy[0])
            conf = float(box.conf[0])
            cls_id = int(box.cls[0])
            cls_name = results.names[cls_id]
            
            # --- STAGE 2: Crop & Secondary Analysis ---
            # Crop the bounding box for the secondary model
            crop = img_rgb[y1:y2, x1:x2]
            
            if crop.shape[0] > 0 and crop.shape[1] > 0:
                input_tensor = self.transform(crop).unsqueeze(0)
                
                # Pass through secondary CNN
                with torch.no_grad():
                    cnn_output = self.secondary_model(input_tensor)
                    cnn_class_idx = torch.argmax(cnn_output, dim=1).item()
                    # Override YOLO's generic class with the specific CNN class
                    fine_grained_cls_name = self.cnn_class_names[cnn_class_idx]
                    
                    # Calculate dynamic calories based on relative size
                    img_h, img_w = img.shape[:2]
                    box_w = x2 - x1
                    box_h = y2 - y1
                    estimated_calories = self.estimate_calories_regression(cls_id, box_w, box_h, img_w, img_h)
                    
                    detections.append({
                        "yolo_class": cls_name,
                        "fine_grained_class": fine_grained_cls_name,
                        "confidence": conf,
                        "bbox": [x1, y1, x2, y2],
                        "estimated_calories": estimated_calories
                    })
                
                # Draw on image
                cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)
                label = f"{fine_grained_cls_name}: {estimated_calories} kcal"
                cv2.putText(img, label, (x1, max(y1-10, 0)), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

        return img, detections

if __name__ == "__main__":
    print("Nutrilens Advanced Two-Stage Pipeline Initialized.")
    # Example usage (uncomment to test):
    # pipeline = NutrilensAdvancedPipeline()
    # out_img, results = pipeline.process_image("sample_food.jpg")
    # cv2.imwrite("output.jpg", out_img)
