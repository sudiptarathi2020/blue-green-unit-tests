# Stage 1: Build Stage (Install Dependencies)
FROM python:3.9 AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Test Stage (optional)
FROM builder AS tester
WORKDIR /app

# Copy all app files (including tests directory)
COPY . .

# Run tests
CMD ["python", "-m", "unittest", "discover", "-s", "tests"]
# ^ This will now correctly find /app/tests inside the container

# Stage 3: Production Stage
FROM python:3.9-slim AS production
WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY . .

EXPOSE 5000
CMD ["python", "run.py"]

