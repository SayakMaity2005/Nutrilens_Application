# Project Context: YOLO Model Integration for Mobile App

## 1. Project Overview
This project involves setting up a YOLO (You Only Look Once) object detection model and integrating it into a mobile application. The AI assistant's goal is to write robust, modular code that handles model inference, exposes it via a fast API, and provides a clear integration path for the mobile frontend.

## 2. Architecture Strategy
To ensure optimal mobile performance, we will adopt a **Cloud-First API Architecture** with a fallback plan for **On-Device Inference**.

* **Primary Path (API Inference):** A Python backend (using FastAPI) that receives image frames from the mobile app, runs YOLO inference, and returns bounding box coordinates and labels in lightweight JSON format.
* **Secondary Path (On-Device):** Scripts to export the trained YOLO model to mobile-friendly formats (TFLite for Android, CoreML for iOS) if offline capabilities are required later.

## 3. Technology Stack
* **Computer Vision:** `ultralytics` (YOLOv8 / YOLO11)
* **Backend Framework:** `FastAPI` (for high-performance, async API endpoints), `uvicorn`
* **Image Processing:** `OpenCV` (`cv2`), `Pillow`, `numpy`
* **Mobile Frontend (Target):** React Native or Flutter (The AI must format API responses to be easily parsable by these frameworks).

## 4. Target Directory Structure
The AI should enforce and build within the following directory structure:

```text
project_root/
├── ai_model/                  # Model training and export scripts
│   ├── weights/               # .pt, .tflite, .mlmodel files
│   ├── train.py               # Script to fine-tune YOLO (if custom data)
│   └── export.py              # Script to convert YOLO to TFLite/CoreML
├── backend/                   # FastAPI Server
│   ├── main.py                # FastAPI app initialization
│   ├── api/
│   │   └── routes.py          # /predict endpoints
│   ├── core/
│   │   └── config.py          # Environment variables and model paths
│   ├── services/
│   │   └── yolo_service.py    # YOLO loading and inference logic
│   └── requirements.txt       # Python dependencies
└── mobile_app/                # Mobile frontend (React Native/Flutter)
    └── (Mobile specific folders will reside here)
```

## 5. Implementation Phases & AI Tasks

### Phase 1: Model Setup & Service Layer (`backend/services/yolo_service.py`)
**AI Task:** 1. Create a singleton class or service module to load the YOLO model (`ultralytics.YOLO`) into memory only once when the server starts.
2. Write a prediction function that accepts an image (bytes or base64), runs model inference (`model.predict()`), and formats the output.
3. **Data Constraint:** The output MUST be a clean JSON array of objects containing: `{"class": string, "confidence": float, "bbox": {"x_min": float, "y_min": float, "x_max": float, "y_max": float}}`.

### Phase 2: High-Performance API (`backend/main.py` & `backend/api/routes.py`)
**AI Task:**
1. Setup a FastAPI application with CORS enabled (crucial for mobile testing).
2. Create a `POST /predict` endpoint.
3. Ensure the endpoint accepts `multipart/form-data` (UploadFile) for standard image uploads, and optionally a JSON payload with a Base64 encoded image string to accommodate different mobile camera libraries.

### Phase 3: Mobile Export Utilities (`ai_model/export.py`)
**AI Task:**
1. Write a Python script utilizing the `ultralytics` export module to convert the base `.pt` model into `.tflite` (with INT8 quantization if possible for smaller size) and `.mlmodel` (CoreML). 
2. Add comments explaining the input tensor shapes required for the mobile developer.

## 6. Coding Standards & Guidelines for AI
* **Asynchronous Code:** Use `async def` for FastAPI routes to handle concurrent mobile requests efficiently.
* **Error Handling:** Implement `HTTPException` for bad image data or model failures. Never return a 500 error without logging the specific OpenCV/YOLO exception.
* **Typing:** Use Python type hints (`pydantic` models) for all function parameters and API responses to generate accurate OpenAPI (Swagger) documentation.
* **Statelessness:** The API must remain stateless. Do not save incoming images to the disk; process them in memory using `io.BytesIO` or `cv2.imdecode` to maximize speed.
