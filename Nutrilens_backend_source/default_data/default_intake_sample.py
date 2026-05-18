import asyncio
from Nutrilens_backend_source.database.db import default_intakes_collection



default_intakes_breakfast = [
    {
        "meal_type": "breakfast",
        "name": "Oats Vegetable Upma",
        "type": "Veg",
        "energy_per_unit": 0.88,
        "quantity": 250.0,
        "carbs_per_unit": 0.128,
        "protein_per_unit": 0.03,
        "fat_per_unit": 0.024,
        "ingredients": ["Rolled oats", "Onion", "Carrot", "Green peas", "Mustard seeds", "Curry leaves", "Green chilies", "Oil"],
        "recipe": "Dry roast the oats for 3-4 minutes and set aside. Heat oil in a pan, add mustard seeds, curry leaves, and green chilies. Sauté chopped onions, carrots, and peas until tender. Add water (1.5 cups for 1 cup of oats) and salt, bring to a boil. Stir in the roasted oats, cover, and cook on low heat for 4-5 minutes until the water is absorbed."
    },
    {
        "meal_type": "breakfast",
        "name": "Moong Dal Chilla",
        "type": "Veg",
        "energy_per_unit": 1.2,
        "quantity": 150.0,
        "carbs_per_unit": 0.16,
        "protein_per_unit": 0.073,
        "fat_per_unit": 0.03,
        "ingredients": ["Split yellow moong dal", "Ginger", "Green chili", "Hing (Asafoetida)", "Coriander leaves", "Salt", "Oil"],
        "recipe": "Soak moong dal for 3-4 hours, then blend it into a smooth batter with ginger and green chili. Stir in hing, salt, and finely chopped coriander. Heat a non-stick tawa, pour a ladle of batter, and spread it into a thin circle. Drizzle a few drops of oil and cook both sides until golden brown."
    },
    {
        "meal_type": "breakfast",
        "name": "Paneer Bhurji with Whole Wheat Toast",
        "type": "Veg",
        "energy_per_unit": 1.7,
        "quantity": 200.0,
        "carbs_per_unit": 0.14,
        "protein_per_unit": 0.09,
        "fat_per_unit": 0.08,
        "ingredients": ["Low-fat paneer", "Whole wheat bread", "Onion", "Tomato", "Green chili", "Turmeric powder", "Coriander leaves", "Butter/Oil"],
        "recipe": "Heat a teaspoon of oil in a pan, sauté chopped onions and green chilies until translucent. Add tomatoes, turmeric, and salt, cooking until soft. Crumb the paneer and stir it into the mixture for 2-3 minutes. Garnish with coriander leaves and serve alongside toasted whole wheat bread."
    },
    {
        "meal_type": "breakfast",
        "name": "Vegetable Poha",
        "type": "Veg",
        "energy_per_unit": 1.25,
        "quantity": 200.0,
        "carbs_per_unit": 0.21,
        "protein_per_unit": 0.025,
        "fat_per_unit": 0.0325,
        "ingredients": ["Flattened rice (Poha)", "Onion", "Potato", "Roasted peanuts", "Turmeric powder", "Mustard seeds", "Lemon juice", "Oil"],
        "recipe": "Rinse poha under running water and drain completely. Heat oil, splutter mustard seeds, and sauté onions, diced potatoes, and peanuts until cooked. Add turmeric powder and salt. Toss in the soaked poha gently, mix well, cover, and steam on low heat for 2 minutes. Finish with a squeeze of fresh lemon juice."
    },
    {
        "meal_type": "breakfast",
        "name": "Ragi Idli",
        "type": "Veg",
        "energy_per_unit": 1.5,
        "quantity": 100.0,
        "carbs_per_unit": 0.29,
        "protein_per_unit": 0.04,
        "fat_per_unit": 0.015,
        "ingredients": ["Finger millet flour (Ragi)", "Idli batter (Rice & Urad dal)", "Salt"],
        "recipe": "Mix ragi flour thoroughly into standard fermented idli batter, adding a splash of water if it becomes too thick. Grease idli molds, pour the batter into the slots, and steam in an idli cooker for 10-12 minutes until a toothpick inserted comes out clean."
    },
    {
        "meal_type": "breakfast",
        "name": "Sprouted Chana Salad",
        "type": "Veg",
        "energy_per_unit": 1.4,
        "quantity": 150.0,
        "carbs_per_unit": 0.2,
        "protein_per_unit": 0.07,
        "fat_per_unit": 0.016,
        "ingredients": ["Sprouted black chana", "Cucumber", "Tomato", "Onion", "Chaat masala", "Lemon juice", "Coriander leaves"],
        "recipe": "Boil or steam the sprouted black chana for 5 minutes (optional, or use raw). In a bowl, combine the sprouts with finely chopped cucumber, tomato, and onion. Toss well with chaat masala, salt, fresh coriander, and lemon juice for a refreshing, oil-free start."
    },
    {
        "meal_type": "breakfast",
        "name": "Egg Bhurji with Multi-grain Roti",
        "type": "Non-Veg",
        "energy_per_unit": 1.55,
        "quantity": 200.0,
        "carbs_per_unit": 0.13,
        "protein_per_unit": 0.08,
        "fat_per_unit": 0.06,
        "ingredients": ["Eggs", "Multi-grain flour", "Onion", "Tomato", "Green chili", "Red chili powder", "Oil"],
        "recipe": "Prepare a soft dough with multi-grain flour and roll out a thin roti on a hot tawa. For the bhurji, heat oil in a pan, sauté onions, green chilies, and tomatoes. Whisk the eggs with salt and red chili powder, pour into the pan, and scramble until fully cooked. Serve together."
    },
    {
        "meal_type": "breakfast",
        "name": "Mixed Vegetable Dalia",
        "type": "Veg",
        "energy_per_unit": 0.76,
        "quantity": 300.0,
        "carbs_per_unit": 0.126,
        "protein_per_unit": 0.023,
        "fat_per_unit": 0.013,
        "ingredients": ["Broken wheat (Dalia)", "Moong dal", "Carrot", "Green beans", "Cumin seeds", "Asafoetida", "Ghee"],
        "recipe": "Heat ghee in a pressure cooker, add cumin seeds and a pinch of hing. Add broken wheat and moong dal, roasting for 2 minutes until fragrant. Throw in chopped carrots and beans. Add 3 cups of water, season with salt, and pressure cook for 3-4 whistles until mushy and soft."
    },
    {
        "meal_type": "breakfast",
        "name": "Sattu Drink (Namkeen)",
        "type": "Veg",
        "energy_per_unit": 0.53,
        "quantity": 300.0,
        "carbs_per_unit": 0.083,
        "protein_per_unit": 0.03,
        "fat_per_unit": 0.006,
        "ingredients": ["Roasted chana flour (Sattu)", "Water", "Roasted cumin powder", "Black salt", "Lemon juice", "Mint leaves"],
        "recipe": "Add 3-4 tablespoons of sattu flour to a tall glass of chilled water. Whisk or stir vigorously to eliminate any lumps. Mix in black salt, roasted cumin powder, and fresh lemon juice. Garnish with crushed mint leaves and serve as a quick, protein-rich liquid breakfast."
    },
    {
        "meal_type": "breakfast",
        "name": "Masala Oats Omelette",
        "type": "Non-Veg",
        "energy_per_unit": 1.8,
        "quantity": 150.0,
        "carbs_per_unit": 0.093,
        "protein_per_unit": 0.103,
        "fat_per_unit": 0.086,
        "ingredients": ["Eggs", "Oats powder", "Milk", "Onion", "Capsicum", "Black pepper", "Oil"],
        "recipe": "Whisk two eggs with 2 tablespoons of powdered oats and a splash of milk. Stir in finely chopped onions, capsicum, salt, and black pepper. Heat oil in a pan, pour the egg-oats mixture, and cook on medium flame. Flip carefully when the base sets, and cook until both sides are fluffy and cooked through."
    },
    {
        "meal_type": "breakfast",
        "name": "Besan Chilla",
        "type": "Veg",
        "energy_per_unit": 1.26,
        "quantity": 150.0,
        "carbs_per_unit": 0.146,
        "protein_per_unit": 0.063,
        "fat_per_unit": 0.033,
        "ingredients": ["Gram flour (Besan)", "Ajwain (Carom seeds)", "Onion", "Tomato", "Green chilies", "Turmeric powder", "Oil"],
        "recipe": "Mix besan with water to form a smooth, pourable batter. Stir in ajwain, turmeric, chopped onions, tomatoes, green chilies, and salt. Heat a seasoned tawa, spread a ladle of batter thinly, drizzle minimal oil on the edges, and flip to cook evenly until golden on both sides."
    },
    {
        "meal_type": "breakfast",
        "name": "Boiled Egg and Sprouts Chaat",
        "type": "Non-Veg",
        "energy_per_unit": 1.2,
        "quantity": 200.0,
        "carbs_per_unit": 0.08,
        "protein_per_unit": 0.09,
        "fat_per_unit": 0.05,
        "ingredients": ["Hard-boiled eggs", "Mixed sprouts (Moong & Kala Chana)", "Onion", "Tomato", "Chaat masala", "Lemon juice"],
        "recipe": "Steam the mixed sprouts for 5 minutes. Chop the hard-boiled eggs into quarters. In a bowl, toss the sprouts and egg pieces together with finely chopped onions, tomatoes, salt, a generous dash of chaat masala, and a squeeze of fresh lemon juice."
    },
    {
        "meal_type": "breakfast",
        "name": "Methi Thepla with Low-Fat Curd",
        "type": "Veg",
        "energy_per_unit": 1.48,
        "quantity": 175.0,
        "carbs_per_unit": 0.205,
        "protein_per_unit": 0.045,
        "fat_per_unit": 0.04,
        "ingredients": ["Whole wheat flour", "Fresh methi (Fenugreek) leaves", "Yogurt", "Turmeric", "Red chili powder", "Oil"],
        "recipe": "Knead whole wheat flour, finely chopped methi leaves, turmeric, chili powder, salt, and a tablespoon of yogurt into a soft dough. Roll into thin flatbreads and cook on a hot tawa, pressing gently with a clean cloth and brushing with minimal oil. Serve with a bowl of fresh curd."
    },
    {
        "meal_type": "breakfast",
        "name": "Quinoa Vegetable Poha",
        "type": "Veg",
        "energy_per_unit": 1.07,
        "quantity": 200.0,
        "carbs_per_unit": 0.145,
        "protein_per_unit": 0.04,
        "fat_per_unit": 0.0275,
        "ingredients": ["Quinoa", "Mustard seeds", "Curry leaves", "Onion", "Carrot", "Green peas", "Turmeric powder", "Lemon juice"],
        "recipe": "Rinse and boil quinoa until fluffy, then drain well. Heat oil in a pan, splutter mustard seeds and curry leaves, and sauté chopped onions, carrots, and peas until soft. Stir in turmeric and salt, then toss the cooked quinoa into the pan. Cover and let steam for 2 minutes before finishing with lemon juice."
    },
    {
        "meal_type": "breakfast",
        "name": "Soy Stir-Fry with Whole Wheat Toast",
        "type": "Veg",
        "energy_per_unit": 1.45,
        "quantity": 200.0,
        "carbs_per_unit": 0.125,
        "protein_per_unit": 0.105,
        "fat_per_unit": 0.045,
        "ingredients": ["Soya chunks", "Capsicum", "Onion", "Garlic", "Soy sauce", "Green chili paste", "Whole wheat bread", "Oil"],
        "recipe": "Boil soya chunks until soft, squeeze out the water thoroughly, and mince or chop them finely. Heat oil, sauté minced garlic, sliced onions, and capsicum. Add the soya chunks, a splash of soy sauce, chili paste, and salt. Stir-fry on high heat for 3-4 minutes and serve hot with toasted whole wheat bread."
    }
]

default_intakes_lunch = [
    {
        "meal_type": "lunch",
        "name": "Dal Chawal with Bhindi Masala",
        "type": "Veg",
        "energy_per_unit": 1.15,
        "quantity": 350.0,
        "carbs_per_unit": 0.197,
        "protein_per_unit": 0.034,
        "fat_per_unit": 0.023,
        "ingredients": ["Pigeon peas (Arhar dal)", "Basmati rice", "Okra (Bhindi)", "Onion", "Tomato", "Mustard oil", "Spices"],
        "recipe": "Cook rinsed rice and boil dal with turmeric and salt. For dal tadka, heat oil, add cumin, garlic, onions, and tomatoes, then pour over the cooked dal. For bhindi, sauté sliced okra with onions, turmeric, coriander powder, and amchur until crisp and cooked through."
    },
    {
        "meal_type": "lunch",
        "name": "Palak Paneer with Missi Roti",
        "type": "Veg",
        "energy_per_unit": 1.42,
        "quantity": 250.0,
        "carbs_per_unit": 0.136,
        "protein_per_unit": 0.068,
        "fat_per_unit": 0.064,
        "ingredients": ["Spinach (Palak)", "Low-fat paneer", "Gram flour (Besan)", "Whole wheat flour", "Ginger-garlic paste", "Oil"],
        "recipe": "Blanch spinach and blend into a smooth puree. Sauté onions, ginger, garlic, and tomatoes in a pan, add spices, then mix in the spinach puree and low-fat paneer cubes; simmer for 5 minutes. Prepare dough by mixing equal parts wheat flour and besan with ajwain, roll out, and cook on a tawa to make missi roti."
    },
    {
        "meal_type": "lunch",
        "name": "Chicken Curry with Brown Rice",
        "type": "Non-Veg",
        "energy_per_unit": 1.28,
        "quantity": 350.0,
        "carbs_per_unit": 0.148,
        "protein_per_unit": 0.082,
        "fat_per_unit": 0.037,
        "ingredients": ["Skinless chicken breast", "Brown rice", "Onion", "Tomato puree", "Ginger-garlic paste", "Garam masala", "Oil"],
        "recipe": "Boil brown rice until cooked. For the curry, heat oil in a pan, sauté onions, ginger, and garlic until golden brown. Add tomato puree and spices, then add chicken pieces. Sear the chicken, add a splash of water, cover, and simmer on low heat until the chicken is tender."
    },
    {
        "meal_type": "lunch",
        "name": "Rajma Chawal with Cucumber Raita",
        "type": "Veg",
        "energy_per_unit": 1.12,
        "quantity": 400.0,
        "carbs_per_unit": 0.185,
        "protein_per_unit": 0.038,
        "fat_per_unit": 0.021,
        "ingredients": ["Kidney beans (Rajma)", "Basmati rice", "Onion-tomato paste", "Curd (Low-fat)", "Cucumber", "Jeera powder", "Oil"],
        "recipe": "Soak rajma overnight and pressure cook until soft. Prepare a gravy by sautéing onion-tomato paste, ginger, garlic, and rajma masala. Stir in the cooked beans with their water and simmer until thick. Serve with boiled rice and a side of curd mixed with grated cucumber and roasted cumin."
    },
    {
        "meal_type": "lunch",
        "name": "Fish Curry with Red Rice",
        "type": "Non-Veg",
        "energy_per_unit": 1.22,
        "quantity": 300.0,
        "carbs_per_unit": 0.143,
        "protein_per_unit": 0.08,
        "fat_per_unit": 0.033,
        "ingredients": ["Rohu or King fish", "Matta/Red rice", "Coconut milk (Light)", "Tamarind paste", "Mustard seeds", "Curry leaves", "Oil"],
        "recipe": "Cook the red rice thoroughly. For the curry, heat oil and temper with mustard seeds and curry leaves. Sauté onions, garlic, and green chilies. Pour in light coconut milk, tamarind paste, turmeric, and chili powder. Bring to a gentle simmer, add fish steaks, and cook for 7-8 minutes until flaky."
    },
    {
        "meal_type": "lunch",
        "name": "Soya Chunk Matar Ki Sabzi with Roti",
        "type": "Veg",
        "energy_per_unit": 1.35,
        "quantity": 250.0,
        "carbs_per_unit": 0.176,
        "protein_per_unit": 0.084,
        "fat_per_unit": 0.031,
        "ingredients": ["Soya chunks", "Green peas", "Whole wheat flour", "Onion", "Tomato", "Garlic", "Kashmiri chili powder", "Oil"],
        "recipe": "Boil and squeeze soya chunks. Make a standard onion-tomato gravy with ginger, garlic, and basic spices. Add the green peas and soya chunks, add half a cup of water, and cook covered for 10 minutes. Serve hot alongside freshly rolled and puffed whole wheat rotis."
    },
    {
        "meal_type": "lunch",
        "name": "Egg Curry with Millet Roti",
        "type": "Non-Veg",
        "energy_per_unit": 1.46,
        "quantity": 250.0,
        "carbs_per_unit": 0.132,
        "protein_per_unit": 0.076,
        "fat_per_unit": 0.068,
        "ingredients": ["Boiled eggs", "Jowar (Sorghum) flour", "Onion", "Tomato", "Ginger-garlic paste", "Coriander powder", "Oil"],
        "recipe": "Knead jowar flour with warm water and pat or roll out into flat rotis; cook on a hot tawa. For the curry, prick boiled eggs and sear them in a pan with a pinch of turmeric. Create a rich gravy using minced onions, tomatoes, ginger, garlic, and Indian spices, then simmer the eggs in it for 5 minutes."
    },
    {
        "meal_type": "lunch",
        "name": "Baingan Bharta with Yellow Moong Dal and Roti",
        "type": "Veg",
        "energy_per_unit": 1.18,
        "quantity": 300.0,
        "carbs_per_unit": 0.166,
        "protein_per_unit": 0.046,
        "fat_per_unit": 0.03,
        "ingredients": ["Large eggplant (Baingan)", "Split yellow moong dal", "Whole wheat flour", "Garlic", "Green chilies", "Tomatoes", "Oil"],
        "recipe": "Roast the eggplant over an open flame until charred, peel the skin, and mash the pulp. Sauté minced garlic, green chilies, onions, and tomatoes in oil, then stir in the mashed eggplant and cook for 5 minutes. Serve with a bowl of boiled yellow dal and whole wheat rotis."
    },
    {
        "meal_type": "lunch",
        "name": "Chickpea (Chole) Salad Bowl with Quinoa",
        "type": "Veg",
        "energy_per_unit": 1.25,
        "quantity": 280.0,
        "carbs_per_unit": 0.182,
        "protein_per_unit": 0.054,
        "fat_per_unit": 0.029,
        "ingredients": ["Boiled chickpeas (Kabuli chana)", "Quinoa", "Bell peppers", "Cucumber", "Lemon juice", "Olive oil", "Chaat masala"],
        "recipe": "Cook quinoa as per package instructions and let it cool. In a large mixing bowl, combine the cooked quinoa, boiled chickpeas, diced bell peppers, and cucumbers. Whisk olive oil, fresh lemon juice, black salt, and chaat masala together, then drizzle over the salad and toss well."
    },
    {
        "meal_type": "lunch",
        "name": "Methi Matar Malai (Healthy Style) with Roti",
        "type": "Veg",
        "energy_per_unit": 1.38,
        "quantity": 250.0,
        "carbs_per_unit": 0.172,
        "protein_per_unit": 0.052,
        "fat_per_unit": 0.048,
        "ingredients": ["Fenugreek leaves (Methi)", "Green peas", "Low-fat curd", "Cashew paste (1 tbsp)", "Whole wheat flour", "Spices", "Oil"],
        "recipe": "Sauté chopped methi leaves to remove bitterness. Cook green peas. Blend a gravy base of onions, a few cashews, and spices. Cook this base in a pan, stir in the low-fat curd, methi, and peas. Simmer until the sauce coats the vegetables. Pair with soft whole wheat rotis."
    },
    {
        "meal_type": "lunch",
        "name": "Kadi Pakoda (Baked) with Jeera Rice",
        "type": "Veg",
        "energy_per_unit": 1.08,
        "quantity": 350.0,
        "carbs_per_unit": 0.174,
        "protein_per_unit": 0.031,
        "fat_per_unit": 0.024,
        "ingredients": ["Sour curd", "Gram flour (Besan)", "Basmati rice", "Cumin seeds", "Fenugreek seeds", "Onion", "Baking soda", "Oil"],
        "recipe": "Make a thick batter of besan, onions, salt, and a pinch of soda; drop spoonfuls onto a tray and bake at 180°C until firm. Whisk curd, besan, and water to make a thin mixture. Cook it with a tempering of cumin, fenugreek seeds, and turmeric until thickened, then add the baked pakodas. Serve over cumin-scented rice."
    },
    {
        "meal_type": "lunch",
        "name": "Stuffed Tinda (Round Gourd) with Dal Makhani (Low Fat)",
        "type": "Veg",
        "energy_per_unit": 1.24,
        "quantity": 300.0,
        "carbs_per_unit": 0.14,
        "protein_per_unit": 0.052,
        "fat_per_unit": 0.044,
        "ingredients": ["Round gourd (Tinda)", "Whole black urad dal", "Low-fat milk", "Paneer crumble", "Onion-tomato paste", "Spices", "Oil"],
        "recipe": "Hollow out the tindas and stuff them with seasoned crumbled paneer and spices; shallow fry or steam until tender. Slow cook black urad dal with ginger-garlic paste, then add a light onion-tomato tadka and a splash of low-fat milk for creaminess instead of heavy cream or butter."
    },
    {
        "meal_type": "lunch",
        "name": "Fish Tikka with Mint Chutney and Stir-Fry Veggies",
        "type": "Non-Veg",
        "energy_per_unit": 1.16,
        "quantity": 250.0,
        "carbs_per_unit": 0.052,
        "protein_per_unit": 0.136,
        "fat_per_unit": 0.04,
        "ingredients": ["Firm fish cubes (Thick fish)", "Thick yogurt", "Ginger-garlic paste", "Lemon juice", "Broccoli", "Carrot", "Mint leaves", "Oil"],
        "recipe": "Marinate fish cubes in a blend of yogurt, ginger-garlic paste, lemon juice, and tandoori masala for 1 hour. Grill or air-fry the fish until lightly charred and cooked through. Serve alongside a quick stir-fry of broccoli and carrots, with a fresh dip of blended mint, coriander, and lemon juice."
    },
    {
        "meal_type": "lunch",
        "name": "Lauki Chana Dal with Multi-grain Roti",
        "type": "Veg",
        "energy_per_unit": 1.21,
        "quantity": 280.0,
        "carbs_per_unit": 0.189,
        "protein_per_unit": 0.046,
        "fat_per_unit": 0.022,
        "ingredients": ["Bottle gourd (Lauki)", "Bengal gram (Chana dal)", "Multi-grain flour", "Mustard seeds", "Hing", "Turmeric", "Oil"],
        "recipe": "Pressure cook chopped bottle gourd and soaked chana dal with turmeric, salt, and water for 3 whistles. Heat oil in a small pan, temper with mustard seeds, hing, and green chilies, and mix it directly into the cooked dal. Serve hot alongside fresh multi-grain rotis."
    },
    {
        "meal_type": "lunch",
        "name": "Mushroom Matar Semi-Dry with Oats Roti",
        "type": "Veg",
        "energy_per_unit": 1.32,
        "quantity": 250.0,
        "carbs_per_unit": 0.176,
        "protein_per_unit": 0.06,
        "fat_per_unit": 0.036,
        "ingredients": ["Button mushrooms", "Green peas", "Oats flour", "Whole wheat flour", "Onions", "Tomatoes", "Garam masala", "Oil"],
        "recipe": "Knead equal portions of oats flour and wheat flour into a smooth dough for rotis. Sauté sliced onions and tomatoes with ginger till soft, add sliced mushrooms and green peas. Season with spices and cook on medium flame without water until the mushrooms release their moisture and turn tender."
    }
]


default_intakes_dinner = [
    {
        "meal_type": "dinner",
        "name": "Moong Dal Khichdi with Roasted Papad",
        "type": "Veg",
        "energy_per_unit": 0.95,
        "quantity": 350.0,
        "carbs_per_unit": 0.165,
        "protein_per_unit": 0.034,
        "fat_per_unit": 0.013,
        "ingredients": ["Split yellow moong dal", "Rice", "Ghee", "Cumin seeds", "Asafoetida", "Turmeric powder", "Moong dal papad"],
        "recipe": "Wash and soak rice and moong dal together for 20 minutes. Heat ghee in a pressure cooker, add cumin seeds and hing. Add the drained rice, dal, turmeric, salt, and 3.5 cups of water. Pressure cook for 3-4 whistles until completely soft and mushy. Serve hot with an oil-free open-flame roasted papad."
    },
    {
        "meal_type": "dinner",
        "name": "Tofu Stir-Fry with Broccoli and Brown Rice",
        "type": "Veg",
        "energy_per_unit": 1.12,
        "quantity": 300.0,
        "carbs_per_unit": 0.146,
        "protein_per_unit": 0.053,
        "fat_per_unit": 0.031,
        "ingredients": ["Firm tofu", "Broccoli florets", "Brown rice", "Garlic", "Soy sauce", "Sesame oil", "Green chili"],
        "recipe": "Boil brown rice and set aside. Heat sesame oil in a wok, add minced garlic and green chilies, and sauté for a minute. Toss in broccoli florets and cubed tofu, stir-frying on high heat for 4-5 minutes. Splash soy sauce and a pinch of salt, mix thoroughly, and serve warm right over the bed of brown rice."
    },
    {
        "meal_type": "dinner",
        "name": "Grilled Lemon Chicken with Stir-Fried Beans",
        "type": "Non-Veg",
        "energy_per_unit": 1.25,
        "quantity": 250.0,
        "carbs_per_unit": 0.044,
        "protein_per_unit": 0.132,
        "fat_per_unit": 0.048,
        "ingredients": ["Chicken breast cubes", "Lemon juice", "Black pepper", "French beans", "Garlic", "Olive oil"],
        "recipe": "Marinate chicken breast pieces with lemon juice, minced garlic, salt, and cracked black pepper for 30 minutes. Heat half a teaspoon of olive oil in a grill pan and cook the chicken until tender and lightly charred. In the same pan, flash-fry chopped French beans for 2-3 minutes keeping them crisp."
    },
    {
        "meal_type": "dinner",
        "name": "Grilled Paneer Tikka with Tossed Green Salad",
        "type": "Veg",
        "energy_per_unit": 1.45,
        "quantity": 220.0,
        "carbs_per_unit": 0.054,
        "protein_per_unit": 0.095,
        "fat_per_unit": 0.088,
        "ingredients": ["Low-fat paneer", "Bell peppers", "Onion cubes", "Thick yogurt", "Tandoori masala", "Lettuce", "Cucumber", "Oil"],
        "recipe": "Whisk tandoori masala into thick yogurt and coat paneer cubes, bell peppers, and onion cubes. Skewer them and grill or air-fry at 180°C until edges turn golden. Mix shredded lettuce and sliced cucumber with a squeeze of lemon and black salt, then serve immediately alongside the hot skewers."
    },
    {
        "meal_type": "dinner",
        "name": "Jeera Alloo Capsicum with Yellow Dal and Roti",
        "type": "Veg",
        "energy_per_unit": 1.22,
        "quantity": 300.0,
        "carbs_per_unit": 0.176,
        "protein_per_unit": 0.043,
        "fat_per_unit": 0.028,
        "ingredients": ["Potato cubes", "Capsicum", "Cumin seeds", "Split yellow moong dal", "Whole wheat flour", "Spices", "Oil"],
        "recipe": "Boil dal with turmeric and salt. Heat oil in a pan, splutter plenty of cumin seeds, then sauté diced potatoes and capsicum with dry spices until tender. Knead wheat flour into dough, roll out a thin flatbread, and cook on a tawa. Serve the dry vegetable with a bowl of dal and one roti."
    },
    {
        "meal_type": "dinner",
        "name": "Clear Chicken Soup with Multi-grain Bread Toast",
        "type": "Non-Veg",
        "energy_per_unit": 0.85,
        "quantity": 320.0,
        "carbs_per_unit": 0.075,
        "protein_per_unit": 0.071,
        "fat_per_unit": 0.022,
        "ingredients": ["Minced chicken", "Carrot", "Sweet corn", "Garlic", "Black pepper", "Multi-grain bread", "Butter"],
        "recipe": "Boil minced chicken in 3 cups of water with minced garlic, chopped carrots, and sweet corn. Skim any foam from the surface. Season with salt and black pepper powder, and simmer until the chicken is fully cooked. Serve steaming hot alongside a slice of crisp multi-grain toast."
    },
    {
        "meal_type": "dinner",
        "name": "Mushroom Soup with Paneer Sandwich",
        "type": "Veg",
        "energy_per_unit": 1.24,
        "quantity": 280.0,
        "carbs_per_unit": 0.125,
        "protein_per_unit": 0.064,
        "fat_per_unit": 0.046,
        "ingredients": ["Button mushrooms", "Onion", "Skimmed milk", "Whole wheat bread", "Low-fat paneer slices", "Black pepper", "Oil"],
        "recipe": "Sauté mushrooms and onions, blend with water, then simmer with a splash of skimmed milk and black pepper to make soup. Place seasoned paneer slices between two slices of whole wheat bread and toast on a dry pan until crispy. Pair together for a comforting dinner."
    },
    {
        "meal_type": "dinner",
        "name": "Egg White Omelette with Stir-Fried Veggies",
        "type": "Non-Veg",
        "energy_per_unit": 0.92,
        "quantity": 250.0,
        "carbs_per_unit": 0.048,
        "protein_per_unit": 0.076,
        "fat_per_unit": 0.038,
        "ingredients": ["Egg whites", "Onion", "Tomato", "Mushroom", "Spinach leaves", "Oregano", "Oil"],
        "recipe": "Whisk egg whites with salt and chopped onions. Pour onto a lightly greased pan to make a clean, fluffy omelette. In a separate pan, quickly sauté sliced mushrooms, tomatoes, and fresh spinach leaves with a sprinkle of oregano and black pepper for a light, high-protein meal."
    },
    {
        "meal_type": "dinner",
        "name": "Baked Fish Tikka with Mint Salad",
        "type": "Non-Veg",
        "energy_per_unit": 1.28,
        "quantity": 200.0,
        "carbs_per_unit": 0.035,
        "protein_per_unit": 0.155,
        "fat_per_unit": 0.045,
        "ingredients": ["Fish fillet cubes", "Yogurt", "Lemon juice", "Ginger-garlic paste", "Kashmiri chili powder", "Onion rings", "Mint leaves"],
        "recipe": "Marinate fish cubes in a mixture of yogurt, lemon juice, ginger-garlic paste, and chili powder for 40 minutes. Lay them on a baking sheet and bake at 200°C for 12-15 minutes. Serve garnished with raw onion rings and a handful of freshly washed mint leaves."
    },
    {
        "meal_type": "dinner",
        "name": "Lauki Kofta (Appe Pan) with Roti",
        "type": "Veg",
        "energy_per_unit": 1.18,
        "quantity": 260.0,
        "carbs_per_unit": 0.165,
        "protein_per_unit": 0.042,
        "fat_per_unit": 0.034,
        "ingredients": ["Bottle gourd (Lauki)", "Gram flour (Besan)", "Onion", "Tomato puree", "Ginger", "Whole wheat flour", "Oil"],
        "recipe": "Grate bottle gourd, squeeze excess water, mix with besan and salt, and roll into balls. Cook these balls in a greased appe (pappe) pan till brown on all sides. Make a light gravy using onion-tomato puree and spices, drop the non-fried koftas inside, and simmer. Eat with a soft wheat roti."
    },
    {
        "meal_type": "dinner",
        "name": "Stir-Fried Sprouts Khichdi",
        "type": "Veg",
        "energy_per_unit": 1.05,
        "quantity": 300.0,
        "carbs_per_unit": 0.173,
        "protein_per_unit": 0.048,
        "fat_per_unit": 0.015,
        "ingredients": ["Mixed sprouts (Moong/Chana)", "Broken wheat (Dalia)", "Green chilies", "Mustard seeds", "Curry leaves", "Oil"],
        "recipe": "Boil dalia with a pinch of salt until soft and drain excess water. Heat oil, add mustard seeds, curry leaves, and green chilies. Toss in the mixed sprouts and stir-fry for 3 minutes. Add the cooked dalia into the pan, mix gently, and steam covered on low heat for 2 minutes."
    },
    {
        "meal_type": "dinner",
        "name": "Palak Corn Sabzi with Jowar Roti",
        "type": "Veg",
        "energy_per_unit": 1.26,
        "quantity": 250.0,
        "carbs_per_unit": 0.184,
        "protein_per_unit": 0.044,
        "fat_per_unit": 0.032,
        "ingredients": ["Spinach puree", "Sweet corn kernels", "Jowar flour", "Garlic", "Onion", "Garam masala", "Oil"],
        "recipe": "Boil sweet corn kernels. Heat a little oil, sauté minced garlic and onions, then add the cooked sweet corn and fresh spinach puree. Season with salt and garam masala, cooking for 5 minutes. Prepare a jowar roti by kneading sorghum flour with hot water and baking it on a flat tawa."
    },
    {
        "meal_type": "dinner",
        "name": "Masala Oats Porridge with Boiled Egg",
        "type": "Non-Veg",
        "energy_per_unit": 1.15,
        "quantity": 240.0,
        "carbs_per_unit": 0.125,
        "protein_per_unit": 0.062,
        "fat_per_unit": 0.041,
        "ingredients": ["Rolled oats", "Hard-boiled egg", "Onion", "Tomato", "Carrot bits", "Turmeric powder", "Oil"],
        "recipe": "Sauté onions, tomatoes, and chopped carrots in a teaspoon of oil. Add oats, salt, turmeric, and 1.5 cups of water. Cook for 4-5 minutes until it forms a thick savory porridge. Slice a hard-boiled egg in half and place it right on top of the porridge before serving."
    },
    {
        "meal_type": "dinner",
        "name": "Veg Daliya Upma with Curd",
        "type": "Veg",
        "energy_per_unit": 1.02,
        "quantity": 300.0,
        "carbs_per_unit": 0.162,
        "protein_per_unit": 0.038,
        "fat_per_unit": 0.02,
        "ingredients": ["Broken wheat (Dalia)", "Green peas", "Carrot", "Mustard seeds", "Curry leaves", "Low-fat curd", "Oil"],
        "recipe": "Dry roast daliya until aromatic. Heat oil in a pan, temper with mustard seeds and curry leaves, and sauté chopped carrots and green peas. Add roasted daliya, salt, and double the volume of water. Cover and cook on low heat until grains are soft. Serve with a side of cold curd."
    },
    {
        "meal_type": "dinner",
        "name": "Soya Bhurji with Whole Wheat Roti",
        "type": "Veg",
        "energy_per_unit": 1.36,
        "quantity": 250.0,
        "carbs_per_unit": 0.164,
        "protein_per_unit": 0.088,
        "fat_per_unit": 0.036,
        "ingredients": ["Soya granules", "Onion", "Tomato", "Green capsicum", "Coriander powder", "Whole wheat flour", "Oil"],
        "recipe": "Soak soya granules in hot water for 10 minutes, then squeeze out the water. Sauté onions, tomatoes, and diced capsicum in a pan with standard spices. Add the soft soya granules, stirring constantly over medium heat for 5-6 minutes. Serve along with a freshly made hot wheat roti."
    }
]


default_intakes_snacks = [
    {
        "meal_type": "snacks",
        "name": "Roasted Makhana (Foxnuts)",
        "type": "Veg",
        "energy_per_unit": 1.48,
        "quantity": 30.0,
        "carbs_per_unit": 0.23,
        "protein_per_unit": 0.032,
        "fat_per_unit": 0.042,
        "ingredients": ["Phool makhana", "Ghee", "Turmeric powder", "Black salt", "Black pepper powder"],
        "recipe": "Heat half a teaspoon of ghee in a heavy-bottomed pan. Add the makhana and dry roast on low flame for 8-10 minutes until they become crispy and crack easily. Turn off the heat, add a pinch of turmeric, black salt, and black pepper, and toss well to coat."
    },
    {
        "meal_type": "snacks",
        "name": "Papaya with Chaat Masala",
        "type": "Veg",
        "energy_per_unit": 0.43,
        "quantity": 150.0,
        "carbs_per_unit": 0.108,
        "protein_per_unit": 0.005,
        "fat_per_unit": 0.003,
        "ingredients": ["Ripe papaya cubes", "Chaat masala", "Lemon juice"],
        "recipe": "Peel and deseed a fresh papaya, then slice it into bite-sized cubes. Arrange the cubes in a bowl, squeeze a dash of fresh lemon juice on top, and dust lightly with chaat masala before serving chilled."
    },
    {
        "meal_type": "snacks",
        "name": "Roasted Chana (Kala Chana)",
        "type": "Veg",
        "energy_per_unit": 1.64,
        "quantity": 40.0,
        "carbs_per_unit": 0.232,
        "protein_per_unit": 0.088,
        "fat_per_unit": 0.024,
        "ingredients": ["Roasted black gram (Chana without skin)"],
        "recipe": "This is a zero-prep, high-fiber traditional snacks. Measure out the dry-roasted chana and consume directly alongside water or hot green tea for a sustained release of energy."
    },
    {
        "meal_type": "snacks",
        "name": "Guava with Black Salt",
        "type": "Veg",
        "energy_per_unit": 0.68,
        "quantity": 120.0,
        "carbs_per_unit": 0.143,
        "protein_per_unit": 0.026,
        "fat_per_unit": 0.01,
        "ingredients": ["Fresh pink or white guava", "Kala namak (Black salt)", "Red chili powder"],
        "recipe": "Wash the guava thoroughly and cut it into clean wedges. Sprinkle a pinch of black salt and a tiny touch of red chili powder over the pieces to balance the natural sweetness with an authentic Indian street-side kick."
    },
    {
        "meal_type": "snacks",
        "name": "Sukha Bhel (Healthy Style)",
        "type": "Veg",
        "energy_per_unit": 1.35,
        "quantity": 60.0,
        "carbs_per_unit": 0.234,
        "protein_per_unit": 0.038,
        "fat_per_unit": 0.028,
        "ingredients": ["Puffed rice (Murmura)", "Roasted chana", "Onion", "Tomato", "Green chutney", "Lemon juice"],
        "recipe": "In a dry mixing bowl, combine puffed rice and roasted chana. Add finely chopped onions, tomatoes, and green chilies. Drizzle half a teaspoon of spicy coriander-mint green chutney and a squeeze of lemon juice. Toss rapidly and consume immediately before the puffed rice turns soggy."
    },
    {
        "meal_type": "snacks",
        "name": "Spiced Buttermilk (Chaas)",
        "type": "Veg",
        "energy_per_unit": 0.3,
        "quantity": 250.0,
        "carbs_per_unit": 0.036,
        "protein_per_unit": 0.018,
        "fat_per_unit": 0.008,
        "ingredients": ["Low-fat curd", "Water", "Roasted cumin powder", "Ginger paste", "Fresh coriander", "Salt"],
        "recipe": "Whisk low-fat curd together with cold water until thin and frothy. Stir in salt, roasted cumin powder, and a tiny dab of extracted ginger juice. Garnish with minced coriander leaves and serve as a hydrating mid-afternoon snacks."
    },
    {
        "meal_type": "snacks",
        "name": "Mixed Indian Fruit Chaat",
        "type": "Veg",
        "energy_per_unit": 0.52,
        "quantity": 180.0,
        "carbs_per_unit": 0.122,
        "protein_per_unit": 0.008,
        "fat_per_unit": 0.002,
        "ingredients": ["Apple", "Banana", "Pomegranate arils", "Orange segments", "Chaat masala", "Roasted cumin"],
        "recipe": "Chop the apple and banana into uniform pieces. Combine them in a bowl with orange segments and fresh pomegranate arils. Season lightly with chaat masala and a touch of roasted cumin powder, then toss the fruits together gently."
    },
    {
        "meal_type": "snacks",
        "name": "Boiled Peanut Salad",
        "type": "Veg",
        "energy_per_unit": 1.85,
        "quantity": 80.0,
        "carbs_per_unit": 0.112,
        "protein_per_unit": 0.096,
        "fat_per_unit": 0.118,
        "ingredients": ["Raw peanuts in shell", "Onion", "Tomato", "Green chili", "Lemon juice", "Coriander"],
        "recipe": "Pressure cook raw peanuts with salt and water for 2-3 whistles, then shell them. Toss the soft, warm peanuts with finely chopped onions, tomatoes, green chilies, coriander leaves, and a generous squeeze of fresh lemon juice."
    },
    {
        "meal_type": "snacks",
        "name": "Mango Slices (Seasonal)",
        "type": "Veg",
        "energy_per_unit": 0.6,
        "quantity": 150.0,
        "carbs_per_unit": 0.15,
        "protein_per_unit": 0.008,
        "fat_per_unit": 0.004,
        "ingredients": ["Ripe Alphonso or Langra mango"],
        "recipe": "Wash the mango thoroughly, slice off the cheeks along the pit, score the flesh into a neat grid pattern, and invert the skin to expose the juicy mango cubes. Consume immediately as a nutrient-dense summer snacks."
    },
    {
        "meal_type": "snacks",
        "name": "Baked Beetroot Chips",
        "type": "Veg",
        "energy_per_unit": 1.1,
        "quantity": 40.0,
        "carbs_per_unit": 0.22,
        "protein_per_unit": 0.038,
        "fat_per_unit": 0.012,
        "ingredients": ["Fresh beetroot", "Olive oil brush", "Amchur (Dry mango powder)", "Salt"],
        "recipe": "Slice raw beetroot into razor-thin rounds using a mandoline slicer. Pat them dry with a paper towel. Arrange the slices on a baking sheet, lightly brush with a microscopic layer of olive oil, and bake at 160°C for 15-20 minutes until crisp. Dust with amchur powder."
    },
    {
        "meal_type": "snacks",
        "name": "Pomegranate (Anar) Bowl",
        "type": "Veg",
        "energy_per_unit": 0.83,
        "quantity": 100.0,
        "carbs_per_unit": 0.187,
        "protein_per_unit": 0.017,
        "fat_per_unit": 0.012,
        "ingredients": ["Fresh pomegranate seeds"],
        "recipe": "Slice the crown off a fresh pomegranate, score the skin along its natural segments, and gently submerge or tap out the juicy red arils into a clean bowl. Enjoy raw to maximize fiber and antioxidant intake."
    },
    {
        "meal_type": "snacks",
        "name": "Paneer Cubes with Black Pepper",
        "type": "Veg",
        "energy_per_unit": 1.8,
        "quantity": 60.0,
        "carbs_per_unit": 0.024,
        "protein_per_unit": 0.114,
        "fat_per_unit": 0.138,
        "ingredients": ["Low-fat paneer", "Crushed black pepper", "Chat masala"],
        "recipe": "Cut fresh low-fat paneer into small cubes. Heat a non-stick pan and dry-sear the paneer pieces for 1 minute on each side until just warm. Remove and sprinkle instantly with crushed black pepper and a pinch of chaat masala."
    },
    {
        "meal_type": "snacks",
        "name": "Watermelon Cubes",
        "type": "Veg",
        "energy_per_unit": 0.3,
        "quantity": 200.0,
        "carbs_per_unit": 0.076,
        "protein_per_unit": 0.006,
        "fat_per_unit": 0.002,
        "ingredients": ["Fresh watermelon", "Mint leaves"],
        "recipe": "Dice cold watermelon into large squares, discarding the hard green rind. Place the cubes in a bowl, garnish with torn fresh mint leaves for enhanced coolness, and serve as an ideal hydrating afternoon snacks."
    },
    {
        "meal_type": "snacks",
        "name": "Dhokla (Steamed Besan)",
        "type": "Veg",
        "energy_per_unit": 1.6,
        "quantity": 80.0,
        "carbs_per_unit": 0.22,
        "protein_per_unit": 0.065,
        "fat_per_unit": 0.052,
        "ingredients": ["Gram flour (Besan)", "Lemon juice", "Fruit salt (Eno)", "Mustard seeds", "Green chilies", "Oil"],
        "recipe": "Make a smooth batter of besan, water, turmeric, and salt. Stir in fruit salt and instantly steam in a pan for 15 minutes. Slice into cubes and apply a light tempering of mustard seeds, curry leaves, and green chilies sizzled in a teaspoon of oil with water."
    },
    {
        "meal_type": "snacks",
        "name": "Sprouted Moong Chaat",
        "type": "Veg",
        "energy_per_unit": 1.15,
        "quantity": 100.0,
        "carbs_per_unit": 0.19,
        "protein_per_unit": 0.075,
        "fat_per_unit": 0.01,
        "ingredients": ["Green moong sprouts", "Onion", "Tomato", "Lemon juice", "Green chili", "Rock salt"],
        "recipe": "Steam green moong sprouts for 3 minutes to make them easier to digest. Toss the sprouts with finely chopped onions, juicy tomatoes, and a minced green chili. Season with a tiny pinch of rock salt and finish with fresh lemon juice."
    }
]


async def seed():

    try:
        await default_intakes_collection.insert_many(
            default_intakes_breakfast
        )
    except Exception as e:
        print(f"Error: {e}")

    try:
        await default_intakes_collection.insert_many(
            default_intakes_lunch
        )
    except Exception as e:
        print(f"Error: {e}")

    try:
        await default_intakes_collection.insert_many(
            default_intakes_dinner
        )
    except Exception as e:
        print(f"Error: {e}")

    try:
        await default_intakes_collection.insert_many(
            default_intakes_snacks
        )
    except Exception as e:
        print(f"Error: {e}")

    print("Inserted")


asyncio.run(seed())