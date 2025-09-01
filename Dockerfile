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

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Train the model (if not already trained)
RUN rasa train --fixed-model-name tarumt-bot

# Expose port
EXPOSE $PORT

# Start Rasa with explicit port binding
CMD rasa run --enable-api --port $PORT --model models/tarumt-bot.tar.gz --cors "*"
