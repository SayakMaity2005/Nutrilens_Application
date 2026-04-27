import os
import cv2
import yaml
from pathlib import Path
from tqdm import tqdm

def crop_yolo_to_cnn_dataset(yolo_yaml_path, output_dir):
    """
    Reads a YOLO dataset and crops bounding boxes to create a PyTorch ImageFolder dataset.
    """
    print(f"Loading YOLO config: {yolo_yaml_path}")
    with open(yolo_yaml_path, 'r') as f:
        data_config = yaml.safe_load(f)
        
    class_names = data_config.get('names', {})
    base_path = Path(yolo_yaml_path).parent
    
    out_dir = Path(output_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    
    splits = ['train', 'valid']
    
    total_crops = 0
    
    for split in splits:
        split_img_dir = base_path / split / 'images'
        split_lbl_dir = base_path / split / 'labels'
        
        if not split_img_dir.exists():
            continue
            
        print(f"Processing {split} split...")
        images = list(split_img_dir.glob("*.jpg")) + list(split_img_dir.glob("*.png"))
        
        for img_path in tqdm(images):
            lbl_path = split_lbl_dir / f"{img_path.stem}.txt"
            
            if not lbl_path.exists() or lbl_path.stat().st_size == 0:
                continue
                
            img = cv2.imread(str(img_path))
            if img is None:
                continue
                
            h, w, _ = img.shape
            
            with open(lbl_path, 'r') as f:
                lines = f.readlines()
                
            for idx, line in enumerate(lines):
                parts = line.strip().split()
                if len(parts) < 5:
                    continue
                    
                class_id = int(parts[0])
                x_center, y_center, bbox_w, bbox_h = map(float, parts[1:5])
                
                # Denormalize
                x1 = int((x_center - bbox_w / 2) * w)
                y1 = int((y_center - bbox_h / 2) * h)
                x2 = int((x_center + bbox_w / 2) * w)
                y2 = int((y_center + bbox_h / 2) * h)
                
                # Constrain to image boundaries
                x1, y1 = max(0, x1), max(0, y1)
                x2, y2 = min(w, x2), min(h, y2)
                
                crop = img[y1:y2, x1:x2]
                if crop.shape[0] < 10 or crop.shape[1] < 10:
                    continue # Skip tiny crops
                    
                class_name = class_names.get(class_id, f"class_{class_id}")
                # Clean class name for directory
                safe_class_name = class_name.replace(' ', '_').replace('/', '_').replace('(', '').replace(')', '')
                
                save_dir = out_dir / split / safe_class_name
                save_dir.mkdir(parents=True, exist_ok=True)
                
                save_path = save_dir / f"{img_path.stem}_crop_{idx}.jpg"
                cv2.imwrite(str(save_path), crop)
                total_crops += 1

    print(f"\nDataset generation complete! Created {total_crops} cropped images at: {output_dir}")

if __name__ == "__main__":
    yolo_yaml = r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\ai_model\dataset\dataset_final.yaml"
    out_dir = r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\ai_model\dataset_cnn_cropped"
    crop_yolo_to_cnn_dataset(yolo_yaml, out_dir)
