import torch
from ultralytics import YOLO
import sys
import os

def verify(image_path, model_path="backend/weights/best_indian_food.pt", conf=0.25):
    if not os.path.exists(image_path):
        print(f"Error: Image not found at {image_path}")
        return
    
    print(f"Loading model: {model_path}")
    model = YOLO(model_path)
    
    print(f"Predicting on: {image_path} (threshold={conf})")
    results = model.predict(source=image_path, conf=conf)
    
    print("\n--- Detection Results ---")
    for result in results:
        for box in result.boxes:
            cls_id = int(box.cls[0])
            label = model.names[cls_id]
            conf = float(box.conf[0])
            print(f"Detected: {label} ({conf:.2f})")
    
    print("\nVerification Complete!")

if __name__ == "__main__":
    # You can change the image path here or pass it as an argument!
    if len(sys.argv) > 1:
        img = sys.argv[1]
    else:
        # Default test image
        img = r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\ai_model\dataset\valid\images\0baf1193-760f-4634-935d-6c98d683bfb1_JPG.rf.eb3ec0d861e3878fc4d7d0f6a5d1dbcd.jpg"
    
    verify(img)
