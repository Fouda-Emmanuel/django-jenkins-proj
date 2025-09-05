#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

echo "🚀 Starting Gunicorn..."
exec gunicorn talent_base.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level info
