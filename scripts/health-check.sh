#!/bin/bash

URL="http://localhost:8083/actuator/health"

echo "Checking OpsFlow health..."

if curl -fsS "$URL" > /dev/null; then
    echo "OpsFlow is healthy."
    exit 0
else
    echo "OpsFlow is DOWN."
    exit 1
fi
