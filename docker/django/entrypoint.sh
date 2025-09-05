#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

echo "⏳ Waiting for Database to be available..."

python << END
import sys, time, psycopg2
suggest_unrecoverable_after = 30
start = time.time()
while True:
    try:
        psycopg2.connect(
            dbname="${POSTGRES_DB}",
            user="${POSTGRES_USER}",
            password="${POSTGRES_PASSWORD}",
            host="${POSTGRES_HOST}",
            port="${POSTGRES_PORT}",
        )
        break
    except psycopg2.OperationalError as error:
        sys.stderr.write("Waiting for PostgreSQL to become available...\n")
        if time.time() - start > suggest_unrecoverable_after:
            sys.stderr.write(f"This is taking longer than expected: {error}\n")
        time.sleep(3)
END

echo "✅ Database is available"

echo "🚀 Running migrations..."
python manage.py migrate --noinput
echo "✅ Migrations completed"

echo "📦 Collecting static files..."
python manage.py collectstatic --noinput
echo "✅ Static files collected"

# Execute whatever command is passed to the container
exec "$@"
