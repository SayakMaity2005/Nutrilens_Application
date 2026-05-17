# Nutrilens Full-Stack Roadmap

This document outlines the architecture, current state, and the remaining tasks required to bring the Nutrilens application to a production-ready state across all domains: AI Backend, User/Auth Backend, and Flutter Frontend.

---

## 1. AI Microservice (`Nutrilens_Model/backend`)
*A FastAPI application that handles image uploads, runs the two-stage YOLO + CNN pipeline, hits the Grok API for dish refinement, and returns nutrition info.*

- [ ] **Update YOLO Weights Path:** In `yolo_service.py`, update `yolo_weights` to point to the newly trained 25-class model (`IndianFoodV2_Optimized/weights/best.pt`) once training finishes.
- [ ] **Fix Hardcoded Paths:** Change the absolute path for `cnn_class_names.json` in `advanced_pipeline.py` to a relative path using `Path(__file__).parent` to ensure safe deployment.
- [ ] **Implement Grok API Caching:** In `api/routes.py`, add a caching layer (in-memory or Redis) for `grok_service.refine_dish` to prevent redundant LLM queries for commonly detected foods.
- [ ] **JWT Middleware:** Update the `/predict` route to accept and validate the user's JWT Token in the Authorization header to secure the endpoint.

---

## 2. User & Authentication Service (`Nutrilens_backend_source`)
*A FastAPI application backed by MongoDB that handles user registration, login, and session verification.*

- [ ] **Implement Meal Logging Endpoint:** Create `POST /log-meal` to accept AI service output (calories, protein, dish name) and save it to a `food_history` collection tagged with the User's ID.
- [ ] **Create User Dashboard Endpoints:** Add `GET /dashboard-stats` to fetch a user's daily and weekly aggregated data (e.g., total calories consumed today vs budget).
- [ ] **Dietary Profile Integration:** Expand the User schema to include dietary restrictions (e.g., vegan, peanut allergy). Use this profile to warn users if a detected food violates their restrictions.

---

## 3. Flutter Frontend (`lib/`)
*The cross-platform mobile app featuring macro tracking, a calorie budget, and specific meal intake rounds.*

- [ ] **API Integration (Replacing Hardcoded Data):** Replace the mock data in `dashboard.dart` (`_requiredIntake`, `_consumedIntake`) with asynchronous API calls to the User Backend to fetch real historical data on `initState()`.
- [ ] **Camera / Image Upload Flow:** Build the UI allowing users to snap a photo of their meal, and implement a `dio` or `http` multipart request to send this image to the AI Backend's `/predict` endpoint.
- [ ] **Handling AI Responses:** Parse the AI response on the frontend and update the dashboard macros (`_consumedIntake`) and UI rings dynamically.
- [ ] **User Auth Flow:** Complete the Login/Register UI, connecting to the Auth backend, and securely storing the JWT token in `flutter_secure_storage`.
- [ ] **AI Custom Recipe Feature:** Connect the `AiCustomRecipe` widget to a backend Grok endpoint to generate and render custom markdown recipes based on user ingredients.

---

## 4. Deployment & DevOps
- [ ] **Dockerization:** Create separate `Dockerfile`s for the lightweight Auth service and the heavier AI service (which requires PyTorch, OpenCV, and Ultralytics).
- [ ] **CORS Configuration:** Update `CORS_ORIGINS` in both FastAPI backend `main.py` files to accept requests from your production frontend domains or mobile app origins.
- [ ] **Environment Variables:** Migrate all hardcoded API keys (Grok, Nutrition APIs) and MongoDB URIs into a `.env` configuration.
