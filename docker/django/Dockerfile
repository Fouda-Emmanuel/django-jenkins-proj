# -------------------
# Stage 1: Builder
# -------------------
FROM python:3.12.2-slim-bookworm AS builder

# Install system dependencies for building packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and build wheels
COPY requirements.txt .
RUN pip wheel --wheel-dir /wheels -r requirements.txt

# -------------------
# Stage 2: Runtime
# -------------------
FROM python:3.12.2-slim-bookworm AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    libpq-dev gettext \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group
RUN groupadd -r django && useradd -r -g django django

# Create static/media folders and assign ownership to django
RUN mkdir -p /vol/web/static /vol/web/media \
    && chown -R django:django /vol/web \
    && chmod -R 775 /vol/web

# Copy built wheels and install
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/* \
    && rm -rf /wheels

# Copy app code and scripts as django user
COPY --chown=django:django . /app
COPY --chown=django:django ./docker/django/entrypoint.sh /entrypoint.sh
COPY --chown=django:django ./docker/django/start.sh /start.sh
COPY --chown=django:django ./docker/django/celery/worker/start.sh /start-celeryworker.sh
COPY --chown=django:django ./docker/django/celery/flower/start.sh /start-flower.sh

# Fix line endings and make executable
RUN sed -i 's/\r$//g' /entrypoint.sh /start.sh /start-celeryworker.sh /start-flower.sh \
    && chmod +x /entrypoint.sh /start.sh /start-celeryworker.sh /start-flower.sh

# Switch to non-root user
USER django

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
