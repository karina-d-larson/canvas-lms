#!/usr/bin/env bash
# Install systemd unit so Canvas Docker stack starts on EC2 boot.
set -euo pipefail

SERVICE_NAME=canvas-docker.service
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
UNIT_SRC="$REPO_ROOT/agents/scripts/canvas-docker.service"
UNIT_DEST="/etc/systemd/system/$SERVICE_NAME"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run with sudo: sudo $0"
  exit 1
fi

grep -q canvas.docker /etc/hosts || echo '127.0.0.1 canvas.docker' >> /etc/hosts
cp "$UNIT_SRC" "$UNIT_DEST"
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

echo "Installed and enabled $SERVICE_NAME"
systemctl status "$SERVICE_NAME" --no-pager || true
echo ""
echo "After reboot: systemctl status canvas-docker"
echo "Logs: journalctl -u canvas-docker -f"
