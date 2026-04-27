import requests
import base64
import os

# Configuration
API_URL = "http://localhost:8000/api/v1/predict"
# Use the test image created earlier or provide a path to an image
IMAGE_PATH = r"C:\Users\ROHIT\.gemini\antigravity\brain\af78742d-9c7d-4b7d-8542-79da5067f61e\test_apple_jpg_1774880373177.png"

def test_multipart_upload():
    print("--- Testing Multipart File Upload ---")
    if not os.path.exists(IMAGE_PATH):
        print(f"Error: Image not found at {IMAGE_PATH}")
        return

    with open(IMAGE_PATH, "rb") as f:
        files = {"file": f}
        response = requests.post(API_URL, files=files)
    
    if response.status_code == 200:
        print("Success!")
        print(response.json())
    else:
        print(f"Failed with status {response.status_code}")
        print(response.text)

def test_base64_upload():
    print("\n--- Testing Base64 JSON Upload ---")
    if not os.path.exists(IMAGE_PATH):
        print(f"Error: Image not found at {IMAGE_PATH}")
        return

    with open(IMAGE_PATH, "rb") as f:
        img_base64 = base64.b64encode(f.read()).decode("utf-8")
    
    payload = {"image": img_base64}
    response = requests.post(API_URL, json=payload)
    
    if response.status_code == 200:
        print("Success!")
        print(response.json())
    else:
        print(f"Failed with status {response.status_code}")
        print(response.text)

if __name__ == "__main__":
    try:
        test_multipart_upload()
        test_base64_upload()
    except Exception as e:
        print(f"Connection error: {e}. Make sure the server is running on http://localhost:8000")
