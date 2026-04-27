import requests
import sys
import os
import json

def test_image(image_path, api_url="http://localhost:8000/api/v1/predict"):
    if not os.path.exists(image_path):
        print(f"Error: File {image_path} not found.")
        return

    print(f"Sending {image_path} to {api_url}...")
    
    with open(image_path, "rb") as f:
        files = {"file": (os.path.basename(image_path), f, "image/jpeg")}
        try:
            response = requests.post(api_url, files=files)
            response.raise_for_status()
            
            result = response.json()
            print("\n=== Prediction Results ===")
            print(json.dumps(result, indent=2))
            
            if result.get("status") == "success":
                summary = result.get("diet_summary", {})
                print("\n--- Summary ---")
                print(f"Health Score: {summary.get('health_score')}/100")
                print(f"Recommendation: {summary.get('recommendation')}")
                
        except requests.exceptions.RequestException as e:
            print(f"Error connecting to API: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python scripts/test_image.py <path_to_image> [api_url]")
        sys.exit(1)
    
    image_path = sys.argv[1]
    api_url = sys.argv[2] if len(sys.argv) > 2 else "http://localhost:8000/api/v1/predict"
    
    test_image(image_path, api_url)
