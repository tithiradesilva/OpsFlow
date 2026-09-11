#!/bin/bash

URL="http://localhost:8083/actuator/health"
MAX_ATTEMPTS=12
ATTEMPT=1

echo "Restarting OpsFlow application..."

docker compose restart app

echo "Waiting for application to become healthy..."

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    if curl -fsS "$URL" > /dev/null; then
        echo "OpsFlow restarted successfully."
        exit 0
    fi

    echo "Waiting... ($ATTEMPT/$MAX_ATTEMPTS)"
    sleep 2
    ATTEMPT=$((ATTEMPT + 1))
done

echo "OpsFlow failed to become healthy."
exit 1
