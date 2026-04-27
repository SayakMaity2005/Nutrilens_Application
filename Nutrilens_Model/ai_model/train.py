from ultralytics import YOLO
import os

def train_specialized_model():
    """
    Trains (fine-tunes) the YOLOv8 model for Indian Food Detection.
    Includes "GPU Safe" configurations to prevent overheating or OOM errors.
    """
    # 1. Load the pre-trained 'small' model (better accuracy than 'nano' for food details)
    # Using 'yolov8s.pt' for better balance
    print("Loading base model: yolov8s.pt...")
    model = YOLO("yolov8s.pt")

    # 2. Path to our Indian Food dataset configuration
    # Note: download_dataset.py should be run first to populate this folder
    DATASET_CONFIG = "d:/Projects/Nutrilens/ai_model/dataset/dataset.yaml"
    
    if not os.path.exists(DATASET_CONFIG):
        print(f"Error: Dataset configuration not found at {DATASET_CONFIG}")
        print("Please run download_dataset.py first.")
        return

    # 3. Start Safe Training
    # Batch size 16 is small enough for most GPUs to handle without overheating
    # 'amp=True' ensures better efficiency and lower memory usage
    # 'patience=10' will stop if the model isn't improving (saves power)
    print("Starting Training with GPU-safe configuration...")
    
    results = model.train(
        data=DATASET_CONFIG,
        epochs=100,             # Full training run
        imgsz=640,              # Standard YOLO resolution
        batch=16,               # Safe batch size for GPU
        device=0,               # Use NVIDIA GPU
        patience=20,            # Early stopping to save energy
        save=True,              # Save weights/best.pt
        cache=True,             # Speeds up training if RAM permits
        workers=4,              # Reduce CPU overhead
        amp=True,               # Automatic Mixed Precision (Very safe for modern GPUs)
        project="Nutrilens",    # Output project name
        name="IndianFoodV1"     # Output run name
    )

    print("Training Complete! The 'best.pt' model is now ready in the runs/Nutrilens/IndianFoodV1/weights folder.")

if __name__ == "__main__":
    try:
        train_specialized_model()
    except Exception as e:
        print(f"Training failed: {e}")
        if "CUDA" in str(e):
            print("Note: If CUDA failed, ensure your NVIDIA drivers and PyTorch-CUDA version are correctly installed.")
