# Use Python 3.10 base
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy files
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip wheel
RUN pip install -r requirements.txt

# Train model (if you want pre-trained, remove this and upload your models/)
RUN rasa train

# Expose port
EXPOSE 5005

# Run Rasa
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--debug"]
