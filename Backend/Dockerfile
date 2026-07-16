# ─── Stage 1: Builder ────────────────────────────────────────────────────────
FROM python:3.11-slim AS builder

# System deps needed to compile some wheels (e.g. grpcio used by firebase-admin)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Copy and install Python dependencies into an isolated directory
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt


# ─── Stage 2: Runtime ────────────────────────────────────────────────────────
FROM python:3.11-slim AS runtime

# Create a non-root user for security
RUN groupadd --gid 1001 appgroup \
    && useradd --uid 1001 --gid appgroup --shell /bin/bash --create-home appuser

WORKDIR /app

# Copy installed packages from the builder stage
COPY --from=builder /install /usr/local

# Copy the application source
COPY firebase_config.py .
COPY api/ ./api/

# Copy the Firebase service-account key.
# IMPORTANT: For production, prefer mounting this as a secret instead of baking
# it into the image (e.g. Docker secret, Kubernetes secret, or env var path).
COPY serviceAccountKey.json .

# Switch to the non-root user
USER appuser

# Expose the port uvicorn will listen on
EXPOSE 8000

# Health-check so orchestrators know when the app is ready
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/docs')" || exit 1

# Run the app with uvicorn
# --workers 1 is safe as a starting point; tune for your deployment target
CMD ["uvicorn", "api.main:app", \
     "--host", "0.0.0.0", \
     "--port", "8000", \
     "--workers", "1", \
     "--log-level", "info"]
