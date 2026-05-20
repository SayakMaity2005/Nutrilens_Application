import os
import certifi
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

# Load .env file
load_dotenv()

# Get URI from env
MONGO_URI = os.getenv("MONGO_URI")

client = AsyncIOMotorClient(
    MONGO_URI,
    tls=True,
    tlsCAFile=certifi.where()
)

db = client["nutrilens_db"]

# collections
users_collection = db["users"]
users_daily_data_collection = db["users_daily_data"]

# default intakes collection
default_intakes_collection = db["default_intakes"]

# custo recipe
custom_recipe_collection = db["custom_recipe"]

# dietician collections
dietician_profiles_collection = db["dietician_profiles"]
meetings_collection = db["meetings"]
nudges_collection = db["nudges"]
