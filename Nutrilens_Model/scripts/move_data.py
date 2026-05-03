import os
import shutil

src = 'd:/Projects/Nutrilens_front/Nutrilens_Application/Nutrilens_Model/ai_model/dataset/unlabeled_images'
labels_dir = 'd:/Projects/Nutrilens_front/Nutrilens_Application/Nutrilens_Model/ai_model/dataset/train/labels'
images_dir = 'd:/Projects/Nutrilens_front/Nutrilens_Application/Nutrilens_Model/ai_model/dataset/train/images'

os.makedirs(labels_dir, exist_ok=True)
os.makedirs(images_dir, exist_ok=True)

for root, dirs, files in os.walk(src):
    for file in files:
        if file.endswith('.txt'):
            shutil.move(os.path.join(root, file), os.path.join(labels_dir, file))
        elif file.endswith(('.jpg', '.jpeg', '.png', '.webp', '.avif')):
            shutil.move(os.path.join(root, file), os.path.join(images_dir, file))
print("Moved all files successfully!")
