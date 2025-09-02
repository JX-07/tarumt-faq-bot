# Use slim Python 3.10 image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip wheel setuptools && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Train the RASA model
RUN rasa train --fixed-model-name tarumt-bot

# Expose the port Railway provides
EXPOSE $PORT

# Start Rasa server directly (no start.sh script needed)
CMD rasa run --enable-api --port $PORT --model models/tarumt-bot.tar.gz --cors "*"
