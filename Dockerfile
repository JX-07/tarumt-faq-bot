FROM python:3.10-slim

# Install system deps
RUN apt-get update && apt-get install -y git-lfs && rm -rf /var/lib/apt/lists/*

# Enable git-lfs (important for large models)
RUN git lfs install

# Set work directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Render will set the PORT env variable
ENV PORT=5005

# Expose the port (whatever Render gives)
EXPOSE ${PORT}

# Run Rasa using PORT env variable
CMD ["sh", "-c", "rasa run --enable-api --cors '*' --port $PORT --host 0.0.0.0 --model models"]
