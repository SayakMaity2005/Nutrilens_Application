class NutritionService:
    # Local mapping for common food items (Calories per 100g/unit, Macros in grams)
    # This acts as a mock database
    FOOD_DATABASE = {
        # --- Specialized Indian Food Dataset Classes ---
        "bread_or_roti_naan": {"calories": 120, "carbs": 24, "protein": 3.5, "fat": 0.5, "unit": "1 piece"},
        "curry_dish": {"calories": 180, "carbs": 10, "protein": 8, "fat": 12, "unit": "100g"},
        "rice_dish": {"calories": 130, "carbs": 28, "protein": 2.7, "fat": 0.3, "unit": "100g"},
        "dry_vegetable": {"calories": 90, "carbs": 12, "protein": 3, "fat": 4, "unit": "100g"},
        "snack_item": {"calories": 250, "carbs": 30, "protein": 5, "fat": 12, "unit": "100g"},
        "sweet_item": {"calories": 150, "carbs": 30, "protein": 2, "fat": 7, "unit": "1 piece"},
        "dal_or_sambar": {"calories": 120, "carbs": 15, "protein": 7, "fat": 4, "unit": "100g"},
        "accompaniment": {"calories": 50, "carbs": 5, "protein": 1, "fat": 3, "unit": "1 serving (pickle/chutney)"},
        "drink": {"calories": 45, "carbs": 10, "protein": 0.5, "fat": 0.1, "unit": "100ml"},
        "eggs": {"calories": 155, "carbs": 1.1, "protein": 13, "fat": 11, "unit": "100g"},
        "fish_dish": {"calories": 200, "carbs": 0, "protein": 22, "fat": 12, "unit": "100g"},
        "fruits": {"calories": 60, "carbs": 15, "protein": 1, "fat": 0.3, "unit": "100g"},
        "pasta": {"calories": 131, "carbs": 25, "protein": 5, "fat": 1.1, "unit": "100g"},
        "salad": {"calories": 40, "carbs": 8, "protein": 1.5, "fat": 0.5, "unit": "100g"},
        "soup": {"calories": 60, "carbs": 10, "protein": 2, "fat": 2, "unit": "100ml"},
        "south_indian_breakfast": {"calories": 170, "carbs": 30, "protein": 4, "fat": 4, "unit": "1 serving (Dosa/Idli)"},

        # --- Specific Indian Food Favorites ---
        "paneer roll": {"calories": 320, "carbs": 35, "protein": 12, "fat": 15, "unit": "1 unit"},
        "dosa": {"calories": 168, "carbs": 29, "protein": 3.9, "fat": 3.7, "unit": "1 unit (standard)"},
        "idli": {"calories": 58, "carbs": 12, "protein": 1.6, "fat": 0.1, "unit": "1 piece"},
        "samosa": {"calories": 262, "carbs": 24, "protein": 3.5, "fat": 17, "unit": "1 piece"},
        "biryani": {"calories": 190, "carbs": 25, "protein": 8, "fat": 7, "unit": "100g"},
        "dal makhani": {"calories": 150, "carbs": 15, "protein": 5, "fat": 8, "unit": "100g"},
        "chole bhature": {"calories": 427, "carbs": 55, "protein": 9, "fat": 19, "unit": "1 plate"},
        "palak paneer": {"calories": 180, "carbs": 8, "protein": 10, "fat": 13, "unit": "100g"},
        "butter chicken": {"calories": 250, "carbs": 10, "protein": 18, "fat": 16, "unit": "100g"},
        "roti": {"calories": 120, "carbs": 24, "protein": 3.5, "fat": 0.5, "unit": "1 piece"},
        "naan": {"calories": 260, "carbs": 45, "protein": 8, "fat": 5, "unit": "1 piece"},
        "gulab jamun": {"calories": 150, "carbs": 25, "protein": 2, "fat": 7, "unit": "1 piece"},
        "jalebi": {"calories": 150, "carbs": 30, "protein": 0.5, "fat": 4, "unit": "1 piece"},
        "poha": {"calories": 180, "carbs": 32, "protein": 3.5, "fat": 4, "unit": "100g"},
        "vada pav": {"calories": 290, "carbs": 40, "protein": 6, "fat": 12, "unit": "1 unit"},

        # --- International Favorites ---
        "apple": {"calories": 52, "carbs": 14, "protein": 0.3, "fat": 0.2, "unit": "100g"},
        "orange": {"calories": 47, "carbs": 12, "protein": 0.9, "fat": 0.1, "unit": "100g"},
        "broccoli": {"calories": 34, "carbs": 7, "protein": 2.8, "fat": 0.4, "unit": "100g"},
        "carrot": {"calories": 41, "carbs": 10, "protein": 0.9, "fat": 0.2, "unit": "100g"},
        "hot dog": {"calories": 290, "carbs": 18, "protein": 10, "fat": 20, "unit": "1 unit"},
        "pizza": {"calories": 266, "carbs": 33, "protein": 11, "fat": 10, "unit": "100g"},
        "donut": {"calories": 452, "carbs": 51, "protein": 4.9, "fat": 25, "unit": "1 unit"},
        "cake": {"calories": 257, "carbs": 35, "protein": 3.1, "fat": 12, "unit": "100g"},
        "sandwich": {"calories": 250, "carbs": 25, "protein": 15, "fat": 10, "unit": "1 unit"},
        "banana": {"calories": 89, "carbs": 23, "protein": 1.1, "fat": 0.3, "unit": "100g"},
        "hamburger": {"calories": 250, "carbs": 30, "protein": 15, "fat": 10, "unit": "1 unit"},
        "sushi": {"calories": 40, "carbs": 8, "protein": 2, "fat": 0.2, "unit": "1 piece"},
        "taco": {"calories": 226, "carbs": 20, "protein": 12, "fat": 11, "unit": "1 unit"},
        "pasta": {"calories": 131, "carbs": 25, "protein": 5, "fat": 1.1, "unit": "100g"},
        "chicken breast": {"calories": 165, "carbs": 0, "protein": 31, "fat": 3.6, "unit": "100g"},
        "egg": {"calories": 78, "carbs": 0.6, "protein": 6.3, "fat": 5.3, "unit": "1 large"},
        "rice": {"calories": 130, "carbs": 28, "protein": 2.7, "fat": 0.3, "unit": "100g"},
        "avocado": {"calories": 160, "carbs": 8.5, "protein": 2, "fat": 14.7, "unit": "100g"},
        "almonds": {"calories": 579, "carbs": 21, "protein": 21, "fat": 49, "unit": "100g"},
        "salmon": {"calories": 208, "carbs": 0, "protein": 20, "fat": 13, "unit": "100g"},
    }

    # Alias system to help map general detections to specialized items
    # (e.g., if YOLO says 'sandwich', it might be a 'paneer roll' in this project)
    ALIASES = {
        "sandwich": ["paneer roll", "vada pav", "sandwich", "burger"],
        "hot dog": ["paneer roll", "sausage roll"],
        "cake": ["gulab jamun", "jalebi", "cake"],
    }

    def get_nutrition_info(self, label: str):
        """
        Fetches nutrition info for a specific label.
        Handles descriptive labels by matching the primary category.
        """
        label = label.lower()
        
        # Extract primary category Name (everything before the first space or paren)
        # e.g., 'rice_dish (Biryani...)' -> 'rice_dish'
        primary_key = label.split(' ')[0].strip()

        # 1. Direct match check (descriptive or primary)
        if label in self.FOOD_DATABASE:
            return self.FOOD_DATABASE[label]
        if primary_key in self.FOOD_DATABASE:
            return self.FOOD_DATABASE[primary_key]
        
        # 2. Alias check
        if primary_key in self.ALIASES:
            possible_items = self.ALIASES[primary_key]
            specific_label = possible_items[0]
            if specific_label in self.FOOD_DATABASE:
                return {**self.FOOD_DATABASE[specific_label], "inferred_from": label}

        return {
            "calories": 0, "carbs": 0, "protein": 0, "fat": 0, "unit": "N/A", "unknown": True
        }

    def get_diet_advice(self, nutrition_data: list):
        """
        Analyzes a list of nutrition info objects and provides dietary advice.
        """
        total_calories = sum(item.get("calories", 0) for item in nutrition_data)
        total_carbs = sum(item.get("carbs", 0) for item in nutrition_data)
        total_protein = sum(item.get("protein", 0) for item in nutrition_data)
        
        advice = []
        health_score = 100

        # Basic analysis logic
        if total_calories > 800:
            advice.append("Total calories are a bit high for a single meal.")
            health_score -= 20
        
        if total_carbs > 60:
            advice.append("Consider reducing your carbohydrate intake.")
            health_score -= 15
        
        if total_protein < 10 and total_calories > 300:
            advice.append("Try to add more protein to your meal for better balance.")
            health_score -= 10
        
        # General feedback
        if health_score >= 80:
            overall_status = "Excellent"
            recommendation = "Great choice! Keep it up for a healthy lifestyle."
        elif health_score >= 50:
            overall_status = "Good, with room for improvement"
            recommendation = "This is a decent meal, but balance the macros better next time."
        else:
            overall_status = "Needs adjustment"
            recommendation = "You might want to rethink this meal choice to reach your fitness goals."

        return {
            "total": {
                "calories": round(total_calories, 2),
                "carbohydrates": round(total_carbs, 2),
                "protein": round(total_protein, 2)
            },
            "advice": advice,
            "overall_status": overall_status,
            "recommendation": recommendation,
            "health_score": max(health_score, 0)
        }

nutrition_service = NutritionService()
