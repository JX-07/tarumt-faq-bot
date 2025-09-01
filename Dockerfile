# Use slim Python 3.10 image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies and Git LFS
RUN apt-get update && \
    apt-get install -y git-lfs git curl && \
    git lfs install && \
    apt-get clean

# Copy all project files into container
COPY . .

# Install Rasa and Rasa SDK
RUN pip install --no-cache-dir rasa==3.6.21 rasa-sdk==3.6.1

# Expose Rasa port (Render will set PORT env variable)
EXPOSE 5005

# Start Rasa server, use $PORT if set by Render
CMD ["sh", "-c", "rasa run --enable-api --cors '*' --port ${PORT:-5005} --model models"]
