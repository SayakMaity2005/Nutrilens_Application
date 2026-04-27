import base64
from openai import OpenAI
from backend.core.config import settings

class GrokService:
    def __init__(self):
        # Auto-detect provider based on key prefix
        api_key = settings.XAI_API_KEY or ""
        self.is_groq = api_key.startswith("gsk_")
        
        base_url = "https://api.groq.com/openai/v1" if self.is_groq else "https://api.x.ai/v1"
        self.model = "llama-3.2-11b-vision-preview" if self.is_groq else "grok-vision-beta"
        
        self.client = OpenAI(
            api_key=api_key,
            base_url=base_url,
        )

    async def refine_dish(self, image_bytes: bytes, yolo_category: str) -> dict:
        """
        Uses Grok Vision to identify the specific Indian dish from a cropped image.
        """
        if not settings.XAI_API_KEY:
            return {"name": yolo_category, "description": "Grok API key not configured."}

        base64_image = base64.b64encode(image_bytes).decode('utf-8')

        try:
            response = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "text",
                                "text": f"This image is a crop of a food item categorized as '{yolo_category}'. "
                                        f"Please identify the EXACT Indian dish name (e.g., 'Paneer Butter Masala', 'Chicken Biryani'). "
                                        f"Return a JSON object with 'name' and 'description' (1 sentence). "
                                        f"Return ONLY the raw JSON, no markdown code blocks."
                            },
                            {
                                "type": "image_url",
                                "image_url": {
                                    "url": f"data:image/jpeg;base64,{base64_image}",
                                },
                            },
                        ],
                    }
                ]
            )

            content = response.choices[0].message.content
            # Clean content if Grok used code blocks anyway
            if content.startswith("```"):
                content = content.replace("```json", "").replace("```", "").strip()
            
            import json
            result = json.loads(content)
            return result
        except Exception as e:
            import traceback
            print(f"Grok Error detailed: {traceback.format_exc()}")
            return {"name": yolo_category, "description": "Failed to refine dish name."}

grok_service = GrokService()
