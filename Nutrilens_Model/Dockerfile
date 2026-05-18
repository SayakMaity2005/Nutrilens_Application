# Use a lightweight Python image
FROM python:3.10-slim

# Install system dependencies for OpenCV and other libraries
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set up a new user to avoid running as root (Required for HF Spaces)
RUN useradd -m -u 1000 user
USER user
ENV PATH="/home/user/.local/bin:${PATH}"

WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY --chown=user:user backend/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
# We copy everything in Nutrilens_Model into /app
COPY --chown=user:user . .

# Expose the default Hugging Face port
EXPOSE 7860

# Run the application
# Note: We use -m to run the backend.main module correctly
CMD ["python", "-m", "backend.main"]
