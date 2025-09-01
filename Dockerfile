# Use slim Python 3.10 image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies and Git LFS
RUN apt-get update && \
    apt-get install -y git-lfs git curl && \
    git lfs install && \
    apt-get clean

# Copy project files
COPY . .

# Upgrade pip and install dependencies
RUN python -m pip install --upgrade pip wheel setuptools
RUN pip install --no-cache-dir -r requirements.txt

# Expose Rasa port (Render sets $PORT automatically)
EXPOSE 5005

# Start Rasa server
CMD rasa run --enable-api --port ${PORT:-5005} --model models
