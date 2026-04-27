import argparse
from ultralytics import YOLO
import os
import torch
import psutil

def get_hardware_stats():
    """Prints basic hardware status before training."""
    cpu_usage = psutil.cpu_percent()
    ram = psutil.virtual_memory()
    stats = f"CPU: {cpu_usage}% | RAM: {ram.percent}% ({ram.available / 1024 / 1024 / 1024:.1f}GB free)"
    
    if torch.cuda.is_available():
        gpu_name = torch.cuda.get_device_name(0)
        vram_total = torch.cuda.get_device_properties(0).total_memory / 1024**3
        vram_reserved = torch.cuda.memory_reserved(0) / 1024**3
        stats += f" | GPU: {gpu_name} ({vram_total:.1f}GB VRAM, {vram_reserved:.1f}GB reserved)"
    
    return stats

def train_v11_model(trial=False):
    """
    Trains (fine-tunes) the YOLOv11 model for Indian Food Detection.
    Includes hardware-optimized configurations and safety guards.
    """
    print("="*50)
    print("Nutrilens Model Optimizer - YOLOv11")
    print(get_hardware_stats())
    print("="*50)

    # 1. Load the pre-trained YOLO11 Medium model
    model_path = "yolo11m.pt"
    print(f"Loading base model: {model_path}...")
    model = YOLO(model_path)

    # 2. Path to our Indian Food dataset configuration
    DATASET_CONFIG = "d:/Projects/Nutrilens_front/Nutrilens_Application/Nutrilens_Model/ai_model/dataset/dataset_final.yaml"
    
    if not os.path.exists(DATASET_CONFIG):
        # Fallback to a relative path if absolute fails
        DATASET_CONFIG = os.path.join(os.path.dirname(__file__), "dataset", "dataset_final.yaml")
        if not os.path.exists(DATASET_CONFIG):
            print(f"Error: Dataset configuration not found!")
            return

    # 3. Hardware Optimization
    device = "0" if torch.cuda.is_available() else "cpu"
    
    # 4. Trial Settings vs Production Settings
    if trial:
        print(">>> RUNNING SAFE TRIAL RUN (2 Epochs, Low Resolution) <<<")
        epochs = 2
        imgsz = 320
        batch = 8
        name = "TrialRun"
    else:
        print(">>> STARTING FULL OPTIMIZED TRAINING <<<")
        epochs = 100
        imgsz = 800  # Optimized for RTX 4050 (6GB VRAM)
        batch = 8    # Reduced batch size for 800px stability
        name = "IndianFoodV2_Optimized"

    # 5. Start Training
    results = model.train(
        data=DATASET_CONFIG,
        epochs=epochs,
        imgsz=imgsz,
        batch=batch,
        device=device,
        patience=30,
        save=True,
        project="Nutrilens",
        name=name,
        
        # --- Augmentation Strategy ---
        hsv_h=0.015,
        hsv_s=0.7,
        hsv_v=0.4,
        degrees=10.0,
        translate=0.1,
        scale=0.5,
        fliplr=0.5,
        mosaic=1.0,
        mixup=0.1,
        
        # --- Stability ---
        amp=True,
        workers=4,
        exist_ok=True,
        verbose=True
    )

    print("\n" + "="*50)
    if trial:
        print("Trial successful! System handled the load perfectly.")
    else:
        print("Training Complete!")
        print(f"Model saved in: runs/Nutrilens/{name}/weights/best.pt")
    print("="*50)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--trial", action="store_true", help="Run a quick 2-epoch trial to check system stability")
    args = parser.parse_args()

    try:
        train_v11_model(trial=args.trial)
    except Exception as e:
        print(f"\n[!] Training interrupted or failed: {e}")
        if "out of memory" in str(e).lower():
            print("Action required: Decrease batch size or resolution.")

