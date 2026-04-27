import os
from huggingface_hub import snapshot_download
import shutil

# Configuration
REPO_ID = "SohlHealth/sohl-multidish-yolo-dataset"
LOCAL_DIR = "d:/Projects/Nutrilens/ai_model/dataset"

def download_and_organize():
    print(f"Starting download of Indian Food Dataset from {REPO_ID}...")
    print("This may take a few minutes. Please wait...")
    
    # Download the entire repository with a much higher timeout
    try:
        download_path = snapshot_download(
            repo_id=REPO_ID,
            repo_type="dataset",
            local_dir=LOCAL_DIR,
            local_dir_use_symlinks=False,
            max_workers=4,
            resume_download=True  # Allows resuming if it times out again
        )
        print(f"Download complete! Dataset located at: {download_path}")
    except Exception as e:
        print(f"Download error: {e}")
        print("Retrying might help if it was a timeout.")
        return
    
    # The dataset uses 'dataset.yaml' instead of 'data.yaml'
    yaml_path = os.path.join(LOCAL_DIR, "dataset.yaml")
    if os.path.exists(yaml_path):
        print(f"Verified dataset configuration: {yaml_path}")
    else:
        # Search for any yaml file if dataset.yaml is missing
        yaml_files = [f for f in os.listdir(LOCAL_DIR) if f.endswith(".yaml")]
        if yaml_files:
            print(f"Found alternative configuration: {yaml_files[0]}")
        else:
            print("Warning: No .yaml configuration file found in the dataset root.")

if __name__ == "__main__":
    download_and_organize()
