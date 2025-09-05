#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

echo "🚀 Starting Celery worker..."
exec celery -A talent_base worker --loglevel=info
