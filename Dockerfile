# Stage 1: Build Stage - Install Dependencies
FROM python:3.9 AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Test Stage (Run Tests Inside Docker)
FROM builder AS tester
WORKDIR /app

# Copy all files from root (including app/, tests/, run.py, etc.)
COPY . .

# Run tests
CMD ["python", "-m", "unittest", "discover", "-s", "tests"]

# Stage 3: Production Stage (Slim Final App)
FROM python:3.9-slim AS production
WORKDIR /app

# Copy pre-installed dependencies from builder
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy all application files (including run.py, app/, etc.)
COPY . .

# Expose Flask port
EXPOSE 5000

# Start Flask app
CMD ["python", "run.py"]


