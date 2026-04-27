import os
import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms, models
from torch.utils.data import DataLoader
import json

def train_secondary_cnn(data_dir, num_epochs=40, batch_size=32, learning_rate=0.001):
    """
    Trains a ResNet18 model on the cropped YOLO dataset for fine-grained classification.
    """
    print("Initializing CNN Stage 2 Training Pipeline...")
    
    # 1. Hardware Setup
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    print(f"Using device: {device}")

    # 2. Data Transforms (ResNet expects 224x224)
    data_transforms = {
        'train': transforms.Compose([
            transforms.RandomResizedCrop(224),
            transforms.RandomHorizontalFlip(),
            transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
        ]),
        'valid': transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
        ]),
    }

    # 3. Load Dataset
    image_datasets = {
        x: datasets.ImageFolder(os.path.join(data_dir, x), data_transforms[x])
        for x in ['train', 'valid']
    }
    
    dataloaders = {
        x: DataLoader(image_datasets[x], batch_size=batch_size, shuffle=True, num_workers=4)
        for x in ['train', 'valid']
    }
    
    dataset_sizes = {x: len(image_datasets[x]) for x in ['train', 'valid']}
    class_names = image_datasets['train'].classes
    num_classes = len(class_names)
    
    print(f"Found {num_classes} classes: {class_names}")
    print(f"Dataset sizes -> Train: {dataset_sizes['train']}, Valid: {dataset_sizes['valid']}")

    # Save classes to JSON for the pipeline
    with open('cnn_class_names.json', 'w') as f:
        json.dump(class_names, f)

    # 4. Model Setup
    model = models.resnet18(weights=models.ResNet18_Weights.DEFAULT)
    num_ftrs = model.fc.in_features
    # Replace final layer with the exact number of our classes
    model.fc = nn.Linear(num_ftrs, num_classes)
    model = model.to(device)

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)
    # Reduce LR by 50% every 10 epochs
    scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.5)

    # 5. Training Loop
    print("\nStarting Training...")
    best_acc = 0.0
    
    for epoch in range(num_epochs):
        print(f'Epoch {epoch+1}/{num_epochs}')
        print('-' * 10)

        for phase in ['train', 'valid']:
            if phase == 'train':
                model.train()
            else:
                model.eval()

            running_loss = 0.0
            running_corrects = 0

            for inputs, labels in dataloaders[phase]:
                inputs = inputs.to(device)
                labels = labels.to(device)

                optimizer.zero_grad()

                with torch.set_grad_enabled(phase == 'train'):
                    outputs = model(inputs)
                    _, preds = torch.max(outputs, 1)
                    loss = criterion(outputs, labels)

                    if phase == 'train':
                        loss.backward()
                        optimizer.step()

                running_loss += loss.item() * inputs.size(0)
                running_corrects += torch.sum(preds == labels.data)

            if phase == 'train':
                scheduler.step()

            epoch_loss = running_loss / dataset_sizes[phase]
            epoch_acc = running_corrects.double() / dataset_sizes[phase]

            print(f'{phase.capitalize()} Loss: {epoch_loss:.4f} Acc: {epoch_acc:.4f}')

            # Save best model
            if phase == 'valid' and epoch_acc > best_acc:
                best_acc = epoch_acc
                torch.save(model.state_dict(), 'best_cnn_stage2.pth')

        print()

    print(f'Training complete. Best Validation Acc: {best_acc:4f}')
    print("Saved best model weights to 'best_cnn_stage2.pth'")

if __name__ == '__main__':
    # Ensure this runs nicely on windows
    import multiprocessing
    multiprocessing.freeze_support()
    
    data_directory = r"d:\Projects\Nutrilens_front\Nutrilens_Application\Nutrilens_Model\ai_model\dataset_cnn_cropped"
    train_secondary_cnn(data_directory, num_epochs=40)
