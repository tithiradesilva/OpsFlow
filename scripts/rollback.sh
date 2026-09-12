#!/bin/bash

set -e

COMMIT="$1"

if [ -z "$COMMIT" ]; then
    echo "Usage: $0 <commit-sha>"
    exit 1
fi

echo "Preparing rollback to commit: $COMMIT"

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "ERROR: Working tree has uncommitted changes."
    echo "Commit or remove them before rollback."
    exit 1
fi

git fetch origin

if ! git cat-file -e "$COMMIT^{commit}" 2>/dev/null; then
    echo "ERROR: Commit not found: $COMMIT"
    exit 1
fi

echo "Switching to rollback version..."
git checkout --detach "$COMMIT"

echo "Building application..."
mvn clean package -DskipTests

echo "Deploying rollback version..."
docker compose up -d --build

echo "Waiting for application health..."

HEALTHY=false

for i in $(seq 1 30); do
    if curl -fsS http://localhost/actuator/health > /dev/null; then
        HEALTHY=true
        break
    fi

    echo "Waiting... ($i/30)"
    sleep 2
done

if [ "$HEALTHY" = true ]; then
    echo "Rollback successful."
    echo "Running commit: $(git rev-parse --short HEAD)"
else
    echo "ERROR: Rollback health check failed."
    exit 1
fi