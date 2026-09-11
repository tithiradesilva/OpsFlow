#!/bin/bash

echo "Showing recent OpsFlow application logs..."

docker compose logs --tail=50 app
