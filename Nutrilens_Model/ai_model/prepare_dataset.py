import os
import shutil
import random
from collections import Counter

# Configuration
DATASET_ROOT = "d:/Projects/Nutrilens/ai_model/dataset"
IMAGES_DIR = os.path.join(DATASET_ROOT, "images")
LABELS_DIR = os.path.join(DATASET_ROOT, "labels")

def get_class_distribution(label_list):
    """Counts classes across all label files."""
    counts = Counter()
    for label_name in label_list:
        label_path = os.path.join(LABELS_DIR, label_name)
        if os.path.exists(label_path):
            try:
                with open(label_path, 'r') as f:
                    for line in f:
                        cls = line.split()[0]
                        counts[cls] += 1
            except Exception:
                pass
    return counts

def prepare():
    print("Reorganizing dataset into YOLOv8/v11 format...")
    
    if not os.path.exists(IMAGES_DIR):
        print(f"Error: Images directory not found at {IMAGES_DIR}")
        return

    # 1. Create target directories
    for split in ["train", "valid"]:
        for subdir in ["images", "labels"]:
            os.makedirs(os.path.join(DATASET_ROOT, split, subdir), exist_ok=True)

    # 2. Get all images and validate labels
    all_images = [f for f in os.listdir(IMAGES_DIR) if f.lower().endswith(('.jpg', '.jpeg', '.png'))]
    valid_pairs = []
    
    print(f"Checking {len(all_images)} images for corresponding labels...")
    for img_name in all_images:
        label_name = os.path.splitext(img_name)[0] + ".txt"
        if os.path.exists(os.path.join(LABELS_DIR, label_name)):
            valid_pairs.append((img_name, label_name))
        else:
            print(f"Warning: Missing label for {img_name}. Skipping.")

    random.shuffle(valid_pairs)

    # 3. Split 80/20
    split_idx = int(len(valid_pairs) * 0.8)
    train_pairs = valid_pairs[:split_idx]
    val_pairs = valid_pairs[split_idx:]

    # Distribution analysis
    print("\nClass Distribution (Total):")
    all_labels = [p[1] for p in valid_pairs]
    dist = get_class_distribution(all_labels)
    for cls, count in sorted(dist.items()):
        print(f"  Class {cls}: {count} samples")

    def move_files(pairs, split_name):
        print(f"\nMoving {len(pairs)} files to {split_name}...")
        for img_name, label_name in pairs:
            # Move image
            img_src = os.path.join(IMAGES_DIR, img_name)
            img_dst = os.path.join(DATASET_ROOT, split_name, "images", img_name)
            shutil.copy2(img_src, img_dst) # Use copy2 to preserve metadata

            # Move label
            label_src = os.path.join(LABELS_DIR, label_name)
            label_dst = os.path.join(DATASET_ROOT, split_name, "labels", label_name)
            shutil.copy2(label_src, label_dst)

    # 4. Perform move (using copy instead of move for safety)
    move_files(train_pairs, "train")
    move_files(val_pairs, "valid")

    print("\nSuccess! Dataset reorganized.")
    print(f"Train: {len(train_pairs)} images")
    print(f"Valid: {len(val_pairs)} images")

if __name__ == "__main__":
    prepare()
