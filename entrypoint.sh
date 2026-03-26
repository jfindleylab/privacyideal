#!/bin/sh
set -eu

echo "Checking privacyIDEA core database..."
if ! pi-manage db check >/dev/null 2>&1; then
    echo "Database/tables not found. Creating..."
    pi-manage createdb
else
    echo "Database already initialized. Skipping creation."
fi

# Initialize encryption key if it doesn't exist
if [ ! -f /etc/privacyidea/enckey ]; then
    echo "Encryption key not found. Creating enckey..."
    pi-manage create_enckey
else
    echo "Encryption key already exists. Skipping create_enckey."
fi

# Check if user exists
USER_EXISTS=$(pi-manage admin list | grep -w "$ADMIN_USERNAME" || true)
if [ -z "$USER_EXISTS" ]; then
    echo "Creating admin user..."
    pi-manage admin add $ADMIN_USERNAME --password "$ADMIN_PASSWORD" --email "$ADMIN_EMAIL"
else
    echo "Admin user already exists. Skipping adduser."
fi

# For now we just start the gunicorn process
# TODO: make number of processes and port configurable
exec python3 -m gunicorn --worker-tmp-dir /dev/shm --bind 0.0.0.0:8080 'privacyidea.app:create_docker_app()'