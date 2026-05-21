from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from Nutrilens_backend_source.routers.authentication import register, login
from Nutrilens_backend_source.routers.user_operations import get_user, update_profile, update_user_deatails, update_user_daily_target
from Nutrilens_backend_source.routers.daily_data import add_meal, add_water, get_daily_data, get_default_intakes, get_daily_data_list
from Nutrilens_backend_source.routers.groq_api import make_recipe
from Nutrilens_backend_source.routers.custom_recipe import add_custom_recipe, get_all_custom_recipe, delete_custom_recipe
from Nutrilens_backend_source.routers.user_operations import get_user, update_profile, update_user_deatails, update_user_daily_target, get_nudges
from Nutrilens_backend_source.routers.daily_data import add_meal, add_water, get_daily_data, get_default_intakes, analyze_food
from Nutrilens_backend_source.routers.dietician import register_dietician, get_clients, get_client_progress, meetings, list_dieticians, update_client_targets, nudges
from Nutrilens_backend_source.routers.workout_data import add_workout


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins (good for local testing with Flutter Web)
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Authentication routers
app.include_router(register.router)
app.include_router(login.router)

# user operation routers
app.include_router(get_user.router)
app.include_router(update_profile.router)
app.include_router(update_user_deatails.router)
app.include_router(update_user_daily_target.router)
app.include_router(get_nudges.router)
app.include_router(add_meal.router)
app.include_router(add_water.router)
app.include_router(get_daily_data.router)
app.include_router(get_daily_data_list.router)
app.include_router(get_default_intakes.router)

#groq prompt
app.include_router(make_recipe.router)

# custom recipe
app.include_router(add_custom_recipe.router)
app.include_router(get_all_custom_recipe.router)
app.include_router(delete_custom_recipe.router)
app.include_router(analyze_food.router)

# workout data
app.include_router(add_workout.router)

# Dietician routers
app.include_router(register_dietician.router)
app.include_router(get_clients.router)
app.include_router(get_client_progress.router)
app.include_router(meetings.router)
app.include_router(list_dieticians.router)
app.include_router(update_client_targets.router)
app.include_router(nudges.router)
