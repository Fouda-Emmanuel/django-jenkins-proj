#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

echo "🚀 Starting Flower for Celery monitoring..."
exec celery -A talent_base flower --port=5555
