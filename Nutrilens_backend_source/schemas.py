from pydantic import BaseModel, EmailStr, Field
from datetime import datetime
from enum import Enum


#  Enum for Gender
class Gender(str, Enum):
    male = "male"
    female = "female"
    other = "other"

# Enum for User Role
class UserRole(str, Enum):
    user = "user"
    dietician = "dietician"


# User structure with profile
# Targets of the user with default values
class DailyTarget(BaseModel):
    energy: float = 2000 # in kcal
    carbs: float = 250   # in gram
    protein: float = 150 # in gram
    fat: float = 44      # in gram
    water: float = 2250  # in ml

# Profile details of the user
class Profile(BaseModel):
    height: float | None = None # in cm
    weight: float | None = None # in kg
    age: int | None = None      # in years
    gender: Gender | None = None
    daily_target: DailyTarget   # defined above with default values

# This version of user data can be given to user
class User(BaseModel):
    username: str
    email: EmailStr | None = None
    full_name: str | None = None
    disabled: bool = False
    role: UserRole = UserRole.user  # "user" or "dietician"
    profile: Profile



# Authentication Schemas

class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    user_id: str | None = None


# Actual User structure stored in db
# This will not be given to user
class UserInDB(User):
    # id: str = Field(alias="_id") means
    # "When data contains '_id', store it inside field named 'id'"
    id: str = Field(alias="_id")
    hashed_password: str

# For sending to database 
# This time id is unknown, it will be given by Mogo
class UserModelDB(User):
    hashed_password: str

# This template is expected from user during registration
class RegisterUserForm(User):
    password: str = Field(min_length=8)

# This template is expected from user during login / signup
class LoginForm(BaseModel):
    username: str
    password: str

# Not used yet (optional)
class VerifiedUser(BaseModel):
    name: str
    username: str
    role: str




# Update User

# Update profile
class UpdateProfile(BaseModel):
    height: float | None = None              # in cm
    weight: float | None = None              # in kg
    age: int | None = None                   # in years
    gender: Gender | None = None
    # daily_target: DailyTarget | None = None  # defined above with default values

# Update User details (full_name & email)
class UpdateUserDetails(BaseModel):
    email: EmailStr | None = None
    full_name: str | None = None

# Update daily target of user (energy, carbs, ...)
# DailyTarget class can be used for that purpose, so no need to create another one for update
# class UpdateUserDailyTarget(BaseModel):





# User data Schemas

# Meal type Enum
class MealType(str, Enum):
    breakfast = "breakfast"
    lunch = "lunch"
    dinner = "dinner"
    snacks = "snacks"


# Intake structure (Actual Intake stored in db)
class Intake(BaseModel):
    # id: str = Field(alias="_id")
    meal_type: MealType

    # basic details
    name: str | None = None
    type: str | None = None

    # nutrients details
    energy_per_unit: float | None = None  # in kcal
    quantity: float | None = None           # in gram
    carbs_per_unit: float | None = None   # in gram
    protein_per_unit: float | None = None # in gram
    fat_per_unit: float | None = None     # in gram

    # physical details
    ingredients: list[str] = []
    recipe: str = ""

# Intake Tracking structure used in Meal for Daily Data
# For space saving, ingredients and recipe are excluded
class IntakeInMeal(BaseModel):
    intake_id: str | None = None
    timestamp: datetime | None = None
    # basic details
    name: str | None = None
    type: str | None = None

    # nutrients details
    energy_per_unit: float | None = None  # in kcal
    quantity: float | None = None           # in gram
    carbs_per_unit: float | None = None   # in gram
    protein_per_unit: float | None = None # in gram
    fat_per_unit: float | None = None     # in gram



# Meal structure
class Meal(BaseModel):
    meal_type: MealType
    consumed_intakes: list[IntakeInMeal] = []

# Meals collection
class Meals(BaseModel):
    breakfast: Meal = Meal(meal_type=MealType.breakfast)
    lunch: Meal = Meal(meal_type=MealType.lunch)
    dinner: Meal = Meal(meal_type=MealType.dinner)
    snacks: Meal = Meal(meal_type=MealType.snacks)


# # Daily target reached
# class DailyReach(BaseModel):
#     meals: list[Meal] = [] # list of 4 types of meal
#     water: float = 0       # in ml


# Daily  User data
class DailyDataUser(BaseModel):
    # id: str = Field(alias="_id")
    user_id: str
    date: datetime
    # daily target reached
    # daily_reach: DailyReach
    # daily target (in history the target may be different)
    # so the target should also be there
    daily_target: DailyTarget
    meals: Meals # 4 types of meal
    water: float = 0       # in ml
    weight: float | None = None # in kg



# Workout data
# Workout template
class Workout(BaseModel):
    name: str
    duration: float | None = None
    timestamp: datetime | None = None
    count: int | None = None
    energy: float

# User Daily workout data
# Daily  User data
class DailyWorkoutDataUser(BaseModel):
    # id: str = Field(alias="_id")
    user_id: str
    date: datetime
    energy_burned: float = 0.0
    workouts: list[Workout]


# =============================================
# Dietician-specific Schemas
# =============================================

# Dietician profile stored in dietician_profiles collection
class DieticianProfile(BaseModel):
    user_id: str                                # links to users_collection _id
    specialization: str | None = None           # e.g. "Clinical Nutrition"
    qualification: str | None = None            # e.g. "M.Sc Dietetics"
    experience_years: int | None = None
    verification_status: str = "pending"        # "pending" | "verified" | "rejected"
    document_data: str | None = None            # base64 encoded credential document
    document_filename: str | None = None        # original filename of the uploaded doc
    client_ids: list[str] = []                  # list of user ObjectId strings

# Registration form for dietician (expected from frontend)
class RegisterDieticianForm(BaseModel):
    username: str
    email: EmailStr | None = None
    full_name: str | None = None
    password: str = Field(min_length=8)
    specialization: str | None = None
    qualification: str | None = None
    experience_years: int | None = None
    document_data: str | None = None            # base64 encoded credential doc
    document_filename: str | None = None


# =============================================
# Meeting / Appointment Schemas
# =============================================

class MeetingStatus(str, Enum):
    scheduled = "scheduled"
    completed = "completed"
    cancelled = "cancelled"

class Meeting(BaseModel):
    dietician_id: str
    user_id: str
    user_name: str | None = None
    dietician_name: str | None = None
    scheduled_at: datetime
    notes: str | None = None
    status: MeetingStatus = MeetingStatus.scheduled

class BookMeetingForm(BaseModel):
    dietician_id: str
    scheduled_at: datetime
    notes: str | None = None




# Custom recipe data
class CustomRecipeData(BaseModel):
    user_id: str
    timestamp: datetime
    intake_details: Intake
