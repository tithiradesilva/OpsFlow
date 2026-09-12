#!/bin/bash

BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup-file.sql>"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Restoring OpsFlow database..."
echo "Backup: $BACKUP_FILE"

docker exec -i opsflow-db psql \
  -U opsflow \
  -d opsflow \
  < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Database restore completed successfully."
else
    echo "Database restore failed."
    exit 1
fi
