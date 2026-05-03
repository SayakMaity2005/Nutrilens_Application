import os
import sys
import shutil
import random
import types

# MOCK `imghdr` for Python 3.13 compatibility because bing-image-downloader requires it.
if 'imghdr' not in sys.modules:
    mock_imghdr = types.ModuleType('imghdr')
    mock_imghdr.what = lambda *args, **kwargs: 'jpeg'
    sys.modules['imghdr'] = mock_imghdr

try:
    from bing_image_downloader import downloader
except ImportError:
    import subprocess
    print("bing-image-downloader is missing. Installing it automatically...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "bing-image-downloader"])
    from bing_image_downloader import downloader

BACKGROUND_QUERIES = [
    "empty dining table",
    "clean kitchen counter",
    "empty white plate",
    "person using cellphone at table"
]

LIMIT_PER_QUERY = 50

# Target Directories
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "ai_model", "dataset"))
TEMP_DIR = os.path.join(BASE_DIR, "unlabeled_images", "background_temp")

TRAIN_IMG_DIR = os.path.join(BASE_DIR, "train", "images")
TRAIN_LBL_DIR = os.path.join(BASE_DIR, "train", "labels")
VALID_IMG_DIR = os.path.join(BASE_DIR, "valid", "images")
VALID_LBL_DIR = os.path.join(BASE_DIR, "valid", "labels")

def scrape_backgrounds():
    if not os.path.exists(TEMP_DIR):
        os.makedirs(TEMP_DIR)
        
    print("--- Downloading Background (Negative) Images ---")
    for query in BACKGROUND_QUERIES:
        query_folder = os.path.join(TEMP_DIR, query)
        if os.path.exists(query_folder) and len(os.listdir(query_folder)) > 10:
            print(f"Skipping '{query}', already downloaded.")
            continue
            
        downloader.download(
            query,
            limit=LIMIT_PER_QUERY,
            output_dir=TEMP_DIR,
            adult_filter_off=False,
            force_replace=False,
            timeout=60,
            verbose=False
        )

def distribute_and_create_labels():
    print("\n--- Distributing Images and Creating Empty Labels ---")
    # Ensure target directories exist
    for d in [TRAIN_IMG_DIR, TRAIN_LBL_DIR, VALID_IMG_DIR, VALID_LBL_DIR]:
        os.makedirs(d, exist_ok=True)
        
    all_images = []
    for query in BACKGROUND_QUERIES:
        query_folder = os.path.join(TEMP_DIR, query)
        if not os.path.exists(query_folder): continue
        
        for file in os.listdir(query_folder):
            if file.lower().endswith(('.png', '.jpg', '.jpeg', '.webp', '.avif')):
                all_images.append(os.path.join(query_folder, file))
                
    if not all_images:
        print("No new background images found to distribute.")
        return
        
    # Shuffle for random train/valid split
    random.shuffle(all_images)
    
    # 80% train, 20% valid
    split_idx = int(len(all_images) * 0.8)
    train_images = all_images[:split_idx]
    valid_images = all_images[split_idx:]
    
    def process_split(img_list, target_img_dir, target_lbl_dir):
        count = 0
        for src_path in img_list:
            filename = os.path.basename(src_path)
            # Prefix filename to avoid collision
            new_filename = f"bg_negative_{filename}"
            dst_img_path = os.path.join(target_img_dir, new_filename)
            
            # Label file is the same name but .txt
            lbl_filename = os.path.splitext(new_filename)[0] + ".txt"
            dst_lbl_path = os.path.join(target_lbl_dir, lbl_filename)
            
            # Move image
            shutil.move(src_path, dst_img_path)
            
            # Create empty txt file for YOLO
            open(dst_lbl_path, 'w').close()
            count += 1
        return count
        
    train_count = process_split(train_images, TRAIN_IMG_DIR, TRAIN_LBL_DIR)
    valid_count = process_split(valid_images, VALID_IMG_DIR, VALID_LBL_DIR)
    
    print(f"Successfully added {train_count} background images to training set.")
    print(f"Successfully added {valid_count} background images to validation set.")
    
    # Clean up temp directory
    try:
        shutil.rmtree(TEMP_DIR)
    except:
        pass

if __name__ == "__main__":
    scrape_backgrounds()
    distribute_and_create_labels()
    print("\n✅ Background images have been fully integrated into your YOLO dataset!")
    print("These empty labels will teach YOLO not to hallucinate food on empty tables/plates.")
