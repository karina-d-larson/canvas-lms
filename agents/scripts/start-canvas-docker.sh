#!/usr/bin/env bash
# Start Canvas LMS via Docker Compose on EC2.
# Run as ubuntu from anywhere; uses /home/ubuntu/canvas-lms.
set -euo pipefail

cd /home/ubuntu/canvas-lms
export CANVAS_SKIP_DOCKER_USERMOD=1

if ! groups | grep -q '\bdocker\b'; then
  echo "Add user to docker group: sudo usermod -aG docker \$USER && newgrp docker"
  exit 1
fi

grep -q canvas.docker /etc/hosts 2>/dev/null || echo '127.0.0.1 canvas.docker' | sudo tee -a /etc/hosts

echo "Starting postgres and redis..."
docker compose up -d postgres redis
sleep 3

echo "Starting webpack (JS watch)..."
docker compose up -d webpack
sleep 20

echo "Starting web and jobs..."
docker compose up -d web jobs

echo "Waiting for Canvas web (first boot may take 1-2 minutes)..."
for i in $(seq 1 20); do
  code=$(curl -s -o /dev/null -w '%{http_code}' -m 10 http://127.0.0.1/ 2>/dev/null || echo "000")
  if [[ "$code" == "200" || "$code" == "302" || "$code" == "301" ]]; then
    echo "Canvas is up (HTTP $code)"
    docker compose ps
    echo ""
    echo "Open: http://127.0.0.1/ or http://canvas.docker/"
    echo "From your laptop: http://<EC2_PUBLIC_IP>/ (security group must allow TCP 80)"
    exit 0
  fi
  sleep 15
done

echo "Canvas did not respond in time. Check: docker compose logs web --tail 50"
exit 1
