import os
from ultralytics import YOLOWorld

# The mapping of folder names to their new YOLO class index in dataset_expanded.yaml
# We also provide a "prompt" which is the text YOLO-World will search for.
CLASS_MAPPING = {
    "momos_or_dumplings": {"id": 16, "prompt": "momos dumplings"},
    "noodles_or_chowmein": {"id": 17, "prompt": "noodles chowmein"},
    "grilled_or_tandoori_meat": {"id": 18, "prompt": "tandoori chicken kebab"},
    "pizza": {"id": 19, "prompt": "pizza"},
    "burger_or_sandwich": {"id": 20, "prompt": "burger sandwich"},
    "french_fries": {"id": 21, "prompt": "french fries"},
    "chaat_items": {"id": 22, "prompt": "pani puri chaat"},
    "poha_or_chivda": {"id": 23, "prompt": "poha"},
    "shawarma_or_wrap": {"id": 24, "prompt": "shawarma wrap roll"}
}

DATASET_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "ai_model", "dataset", "unlabeled_images"))

def auto_annotate():
    print("Loading YOLO-World model (this may take a minute to download the first time)...")
    # yolov8s-world.pt is the small, fast zero-shot model
    model = YOLOWorld('yolov8s-world.pt')
    
    for folder_name, info in CLASS_MAPPING.items():
        folder_path = os.path.join(DATASET_DIR, folder_name)
        if not os.path.exists(folder_path):
            print(f"Skipping {folder_name}, folder not found.")
            continue
            
        class_id = info["id"]
        prompt = info["prompt"]
        
        print(f"\n--- Auto-annotating {folder_name} (Class ID: {class_id}) ---")
        
        # Set the model to only look for our specific prompt
        model.set_classes([prompt])
        
        images = [f for f in os.listdir(folder_path) if f.lower().endswith(('.png', '.jpg', '.jpeg', '.webp'))]
        for img_name in images:
            img_path = os.path.join(folder_path, img_name)
            txt_path = os.path.join(folder_path, os.path.splitext(img_name)[0] + ".txt")
            
            # Skip if already annotated
            if os.path.exists(txt_path):
                continue
                
            # Run inference
            results = model.predict(img_path, conf=0.1, verbose=False) # Low confidence to catch everything
            
            # Write to txt in YOLO format: class_id x_center y_center width height
            with open(txt_path, 'w') as f:
                for result in results:
                    boxes = result.boxes
                    for box in boxes:
                        # Convert to normalized xywh
                        b = box.xywhn[0].tolist() 
                        f.write(f"{class_id} {b[0]:.6f} {b[1]:.6f} {b[2]:.6f} {b[3]:.6f}\n")
                        
            print(f"Annotated: {img_name}")
            
    print("\n✅ Auto-Annotation Complete!")
    print("All .txt files have been generated next to their images.")
    print("You can now move the images and .txt files into your train/images and train/labels folders!")

if __name__ == "__main__":
    auto_annotate()
