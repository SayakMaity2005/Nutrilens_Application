import asyncio
from Nutrilens_backend_source.database.db import default_workouts_collection


default_workouts = [
    # --- Time-Based Cardio & Conditioning (Hours) ---
    {
        "name": "Running (Moderate Pace, 6 mph)",
        "duration": 1.0,
        "count": None,
        "energy": 700.0
    },
    {
        "name": "Cycling (Leisurely Pace)",
        "duration": 0.75,
        "count": None,
        "energy": 300.0
    },
    {
        "name": "Vinyasa Yoga Flow",
        "duration": 1.0,
        "count": None,
        "energy": 280.0
    },
    {
        "name": "High-Intensity Interval Training (HIIT)",
        "duration": 0.5,
        "count": None,
        "energy": 400.0
    },
    {
        "name": "Lap Swimming (Freestyle, Moderate)",
        "duration": 0.75,
        "count": None,
        "energy": 450.0
    },
    {
        "name": "Brisk Walking (3.5 mph)",
        "duration": 1.5,
        "count": None,
        "energy": 350.0
    },
    {
        "name": "Jump Rope (Fast Pace)",
        "duration": 0.25,
        "count": None,
        "energy": 250.0
    },
    {
        "name": "Rowing Machine (Moderate Effort)",
        "duration": 0.5,
        "count": None,
        "energy": 310.0
    },
    {
        "name": "Elliptical Trainer",
        "duration": 0.75,
        "count": None,
        "energy": 420.0
    },
    {
        "name": "Stair Climber Machine",
        "duration": 0.5,
        "count": None,
        "energy": 360.0
    },
    {
        "name": "Trail Hiking (Moderate Incline)",
        "duration": 2.0,
        "count": None,
        "energy": 900.0
    },
    {
        "name": "Kickboxing Class",
        "duration": 1.0,
        "count": None,
        "energy": 600.0
    },

    # --- Repetition & Count-Based Exercises ---
    {
        "name": "Bodyweight Squats",
        "duration": None,
        "count": 100,
        "energy": 50.0
    },
    {
        "name": "Standard Push-Ups",
        "duration": None,
        "count": 50,
        "energy": 35.0
    },
    {
        "name": "Barbell Deadlifts (Heavy)",
        "duration": None,
        "count": 25,
        "energy": 60.0
    },
    {
        "name": "Kettlebell Swings",
        "duration": None,
        "count": 75,
        "energy": 80.0
    },
    {
        "name": "Pull-Ups",
        "duration": None,
        "count": 30,
        "energy": 25.0
    },
    {
        "name": "Walking Lunges",
        "duration": None,
        "count": 60,
        "energy": 40.0
    },
    {
        "name": "Burpees",
        "duration": None,
        "count": 40,
        "energy": 55.0
    },
    {
        "name": "Abdominal Crunches",
        "duration": None,
        "count": 120,
        "energy": 30.0
    },
    {
        "name": "Dumbbell Bicep Curls",
        "duration": None,
        "count": 45,
        "energy": 20.0
    },
    {
        "name": "Barbell Bench Press",
        "duration": None,
        "count": 40,
        "energy": 45.0
    },
    {
        "name": "Thrusters (Squat to Overhead Press)",
        "duration": None,
        "count": 30,
        "energy": 50.0
    },
    {
        "name": "Box Jumps",
        "duration": None,
        "count": 50,
        "energy": 65.0
    }
]


async def seed():

    try:
        await default_workouts_collection.insert_many(
            default_workouts
        )
    except Exception as e:
        print(f"Error: {e}")

    print("Inserted")


asyncio.run(seed())