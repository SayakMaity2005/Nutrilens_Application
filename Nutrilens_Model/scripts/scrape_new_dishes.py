import os
import time
import subprocess
import sys
import types

# MOCK `imghdr` for Python 3.13 compatibility because bing-image-downloader requires it.
if 'imghdr' not in sys.modules:
    mock_imghdr = types.ModuleType('imghdr')
    mock_imghdr.what = lambda *args, **kwargs: 'jpeg'
    sys.modules['imghdr'] = mock_imghdr

try:
    from bing_image_downloader import downloader
except ImportError:
    print("bing-image-downloader is missing. Installing it automatically...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "bing-image-downloader"])
    from bing_image_downloader import downloader

# Define the output directory
OUTPUT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "ai_model", "dataset", "unlabeled_images"))

# The new classes we want to download images for
NEW_CLASSES = {
    "momos_or_dumplings": "steamed momos street food",
    "noodles_or_chowmein": "hakka noodles chowmein plate",
    "grilled_or_tandoori_meat": "tandoori chicken tikka kebab",
    "pizza": "pizza slice top view",
    "burger_or_sandwich": "hamburger sandwich plate",
    "french_fries": "french fries plate",
    "chaat_items": "pani puri bhel puri chaat",
    "poha_or_chivda": "poha breakfast plate",
    "shawarma_or_wrap": "shawarma chicken wrap roll"
}

LIMIT_PER_CLASS = 150

def scrape_images():
    print(f"Downloading images to: {OUTPUT_DIR}")
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    for class_name, search_query in NEW_CLASSES.items():
        target_folder = os.path.join(OUTPUT_DIR, class_name)
        
        # Skip if we already downloaded enough images (to resume after crashes)
        if os.path.exists(target_folder) and len(os.listdir(target_folder)) > 50:
            print(f"\n--- Skipping {class_name} (Already downloaded {len(os.listdir(target_folder))} images) ---")
            continue

        print(f"\n--- Downloading images for: {class_name} ---")
        
        # Download images
        downloader.download(
            search_query, 
            limit=LIMIT_PER_CLASS,  
            output_dir=OUTPUT_DIR, 
            adult_filter_off=False, 
            force_replace=False, 
            timeout=60, 
            verbose=False
        )
        
        # bing-image-downloader creates a folder with the name of the search query.
        downloaded_folder = os.path.join(OUTPUT_DIR, search_query)
        
        if os.path.exists(downloaded_folder):
            if os.path.exists(target_folder):
                # If target exists but we still downloaded, merge them or replace
                pass # Already handled by force_replace=False
            else:
                os.rename(downloaded_folder, target_folder)
                print(f"Successfully downloaded and saved to folder: {class_name}")
                
        time.sleep(2) # Be polite to the server

if __name__ == "__main__":
    scrape_images()
    print("\nDownload complete! Images are located in ai_model/dataset/unlabeled_images/")
    print("Next step: Run python scripts/auto_annotate.py to label them automatically!")
