from ultralytics import YOLO

if __name__ == '__main__':
    # Initialize the base YOLOv11 model
    model = YOLO("yolo11m.pt")
    
    # Train the model on the 92-class dataset!
    results = model.train(
        data=r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\ai_model\dataset\dataset_92.yaml",
        epochs=50,
        imgsz=640,
        batch=8,
        device=0, # Use GPU
        name="IndianFood_92Class",
        workers=4,
        patience=10
    )
    print("✅ YOLO 92-Class Training Complete!")
