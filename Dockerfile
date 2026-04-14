# --- Stage 1: Build dependencies ---
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# --- Stage 2: Lean runtime image ---
FROM python:3.12-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy app source
COPY . .

# Non-root user for security
RUN useradd -m appuser
USER appuser

EXPOSE 8000

CMD ["python", "app.py"]