#!/usr/bin/env bash
set -euo pipefail
cd /home/ubuntu/canvas-lms
docker compose stop web jobs webpack postgres redis
docker compose ps -a
