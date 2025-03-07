# Stage 1: Install Dependencies
FROM python:3.9 AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Test Stage (Runs Tests Inside Docker)
FROM builder AS tester
WORKDIR /app

COPY . .

# Set Python Path so /app is root and "tests" is importable
ENV PYTHONPATH=/app

# Run specific test files (not using "discover")
CMD ["python", "-m", "unittest", "tests.test_routes", "tests.test_healthcheck"]

# Stage 3: Production Stage
FROM python:3.9-slim AS production
WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY . .

EXPOSE 5000

CMD ["python", "run.py"]

