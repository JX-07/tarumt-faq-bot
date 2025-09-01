FROM python:3.10-slim

# Install system deps
RUN apt-get update && apt-get install -y git-lfs

# Enable git-lfs (important for your large Rasa models)
RUN git lfs install

# Set work directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose Rasa port
EXPOSE 5005

# Run Rasa server
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--port", "5005", "--model", "models"]
