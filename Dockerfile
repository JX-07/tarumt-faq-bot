# Use slim Python 3.10 image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install only essential system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Upgrade pip and install dependencies
RUN pip install --no-cache-dir --upgrade pip wheel setuptools && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Train the RASA model with optimized settings
RUN rasa train --fixed-model-name tarumt-bot --data data --config config.yml --domain domain.yml

# Create a start script to handle memory better
RUN echo '#!/bin/bash\n\
# Set Python memory management options\nexport PYTHONUNBUFFERED=1\nexport PYTHONDONTWRITEBYTECODE=1\n\
# Start Rasa with optimized settings\nrasa run --enable-api --port ${PORT:-5005} --model models/tarumt-bot.tar.gz --response-timeout 60\n\
' > /app/start.sh && chmod +x /app/start.sh

# Expose Rasa port
EXPOSE $PORT

# Use the start script
CMD ["/app/start.sh"]
