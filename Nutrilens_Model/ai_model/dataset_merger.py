import os
import shutil
import yaml
from pathlib import Path

def merge_yolo_datasets(target_yaml_path, new_dataset_dir, class_mapping):
    """
    Merges a new YOLO dataset into our primary Nutrilens dataset.
    
    Args:
        target_yaml_path: Path to our dataset_final.yaml
        new_dataset_dir: Path to the new dataset we want to import
        class_mapping: Dictionary mapping the NEW dataset's class IDs to OUR class IDs.
                       e.g., { 0: 4 } (Maps their class 0 to our class 4 'snack_item')
    """
    print(f"Starting Dataset Merge Operation...")
    print(f"Target Config: {target_yaml_path}")
    print(f"Source Data: {new_dataset_dir}")
    
    # 1. Load our config
    with open(target_yaml_path, 'r') as f:
        target_config = yaml.safe_load(f)
        
    target_base = Path(target_yaml_path).parent
    new_base = Path(new_dataset_dir)
    
    if not new_base.exists():
        print(f"[ERROR] Source directory {new_dataset_dir} does not exist.")
        return

    splits = ['train', 'valid']
    images_copied = 0
    
    for split in splits:
        src_img_dir = new_base / split / 'images'
        src_lbl_dir = new_base / split / 'labels'
        
        dst_img_dir = target_base / split / 'images'
        dst_lbl_dir = target_base / split / 'labels'
        
        # Create destination dirs if they don't exist
        dst_img_dir.mkdir(parents=True, exist_ok=True)
        dst_lbl_dir.mkdir(parents=True, exist_ok=True)
        
        if not src_img_dir.exists() or not src_lbl_dir.exists():
            print(f"Skipping {split} split as source directories are missing.")
            continue
            
        print(f"\nProcessing {split} split...")
        images = list(src_img_dir.glob("*.jpg")) + list(src_img_dir.glob("*.png"))
        
        for img_path in images:
            lbl_path = src_lbl_dir / f"{img_path.stem}.txt"
            
            # Skip if label doesn't exist
            if not lbl_path.exists():
                continue
                
            # Read label and remap classes
            with open(lbl_path, 'r') as f:
                lines = f.readlines()
                
            new_lines = []
            valid_labels = False
            for line in lines:
                parts = line.strip().split()
                if len(parts) >= 5:
                    old_class_id = int(parts[0])
                    
                    # Check if this class should be mapped
                    if old_class_id in class_mapping:
                        new_class_id = class_mapping[old_class_id]
                        new_line = f"{new_class_id} " + " ".join(parts[1:]) + "\n"
                        new_lines.append(new_line)
                        valid_labels = True
                        
            # If the image has at least one valid mapped label, copy it!
            if valid_labels:
                # 1. Copy image
                new_img_name = f"imported_{img_path.name}"
                shutil.copy2(str(img_path), str(dst_img_dir / new_img_name))
                
                # 2. Write new label
                new_lbl_name = f"imported_{img_path.stem}.txt"
                with open(dst_lbl_dir / new_lbl_name, 'w') as f:
                    f.writelines(new_lines)
                    
                images_copied += 1
                
    print(f"\n✅ Merge Complete! Successfully imported and remapped {images_copied} new images.")

if __name__ == "__main__":
    print("Welcome to the Nutrilens Dataset Merger.")
    print("Please download a YOLO dataset from Kaggle, extract it, and provide the path.")
    
    # --- Example Configuration ---
    # target_yaml = r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\ai_model\dataset\dataset_final.yaml"
    # new_data_dir = r"C:\Downloads\archive\Kaggle_Indian_Food"
    
    # Example Mapping: Suppose the Kaggle dataset has "Samosa" as class 2.
    # In Nutrilens, "snack_item" is class 4.
    # We map { 2: 4 }
    # mapping = {
    #     2: 4, 
    #     5: 1,  # Kaggle 'Chicken Curry' (5) -> Nutrilens 'curry_dish' (1)
    # }
    
    # merge_yolo_datasets(target_yaml, new_data_dir, mapping)
    print("\nEdit this file with your downloaded dataset path and run it to expand your model!")
