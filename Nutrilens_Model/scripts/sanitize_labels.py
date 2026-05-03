import os

def sanitize_labels(labels_dir, max_class_id=24):
    print(f"Sanitizing labels in {labels_dir}...")
    cleaned_count = 0
    for root, dirs, files in os.walk(labels_dir):
        for file in files:
            if not file.endswith('.txt'): continue
            
            filepath = os.path.join(root, file)
            with open(filepath, 'r') as f:
                lines = f.readlines()
                
            valid_lines = []
            modified = false
            for line in lines:
                parts = line.strip().split()
                if not parts: continue
                
                class_id = int(parts[0])
                if class_id <= max_class_id:
                    valid_lines.append(line)
                else:
                    modified = True
                    
            if modified:
                with open(filepath, 'w') as f:
                    f.writelines(valid_lines)
                cleaned_count += 1
                
    print(f"Sanitized {cleaned_count} files in {labels_dir}")

base_dir = r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\ai_model\dataset"
sanitize_labels(os.path.join(base_dir, "train", "labels"))
sanitize_labels(os.path.join(base_dir, "valid", "labels"))
print("Done!")
