# Stage 1: Install Dependencies
FROM python:3.9 AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Test Stage (Runs Tests Inside Docker)
FROM builder AS tester
WORKDIR /app

COPY . .

# Ensure Python sees /app as the project root
ENV PYTHONPATH=/app

# Run individual test modules explicitly (avoid "discover")
CMD ["python", "-m", "unittest", "tests.test_routes", "tests.test_healthcheck"]
# Alternatively: you can add all test files here

# Stage 3: Production Stage (Final App Image)
FROM python:3.9-slim AS production
WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY . .

EXPOSE 5000

CMD ["python", "run.py"]
