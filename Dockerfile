# Use Python 3.10 base
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy files
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip wheel
RUN pip install -r requirements.txt

# Expose port
EXPOSE 5005

# Run Rasa
CMD ["rasa", "run", "--enable-api", "--port", "8080", "--host", "0.0.0.0"]
