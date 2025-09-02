# Use slim Python 3.10 image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install only essential dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies with specific versions to reduce memory
RUN pip install --no-cache-dir --upgrade pip wheel setuptools && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Train with minimal settings to reduce model size
RUN rasa train --fixed-model-name tarumt-bot --data data --config config.yml --domain domain.yml

# Expose the port Railway provides
EXPOSE $PORT

# Start with minimal memory footprint
CMD rasa run --enable-api --port $PORT --model models/tarumt-bot.tar.gz --cors "*" --num-threads 1
