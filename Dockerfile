# Stage 1: Build Stage - Install Dependencies
FROM python:3.9 AS builder
WORKDIR /app

# Install dependencies in a temporary layer
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Test Stage (Optional Test Runner Stage)
FROM builder AS tester
WORKDIR /app

# Copy the full app including test files
COPY . /app

# Run tests (this is where your test command goes)
CMD ["python", "-m", "unittest", "discover", "-s", "tests"]

# Stage 3: Final Production Stage - Slim Image for Running the App
FROM python:3.9-slim AS production
WORKDIR /app

# Copy pre-installed packages from builder
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
# Copy app files
COPY . /app

# Expose Flask Port
EXPOSE 5000

# Default start command for production
CMD ["python", "run.py"]

