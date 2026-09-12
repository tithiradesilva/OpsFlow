#!/bin/bash

BACKUP_DIR="$HOME/OpsFlow/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/opsflow_$TIMESTAMP.sql"

mkdir -p "$BACKUP_DIR"

echo "Creating OpsFlow database backup..."

docker exec opsflow-db pg_dump \
  -U opsflow \
  -d opsflow \
  > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup created successfully:"
    echo "$BACKUP_FILE"
else
    echo "Database backup failed."
    exit 1
fi
