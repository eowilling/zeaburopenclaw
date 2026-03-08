#!/bin/sh
# 若 Volume 掛在 /home/node 且初次為空，把 repo 的 openclaw.json 種到磁碟上，之後 UI 改寫會持久化
CONFIG_DIR="/home/node/.openclaw"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"
SEED_FILE="/opt/openclaw-seed/openclaw.json"

# 每次部署啟動時清除未送出的 delivery 佇列（OpenClaw 實際路徑為 delivery-queue）
DELIVERY_QUEUE="$CONFIG_DIR/delivery-queue"
if [ -d "$DELIVERY_QUEUE" ]; then
  rm -rf "$DELIVERY_QUEUE"/*
  echo "[entrypoint] Cleared pending deliveries: $DELIVERY_QUEUE"
fi

if [ ! -f "$CONFIG_FILE" ] && [ -f "$SEED_FILE" ]; then
  mkdir -p "$CONFIG_DIR"
  cp "$SEED_FILE" "$CONFIG_FILE"
  chown 1000:1000 "$CONFIG_FILE" 2>/dev/null || true
fi
# 若 workspace 尚未有 MEMORY，從種子複製（含 InsForge 稱呼與 CLI 說明）
WORKSPACE_SEED="/opt/openclaw-seed/workspace-seed"
WORKSPACE_DIR="$CONFIG_DIR/workspace"
if [ -d "$WORKSPACE_SEED" ] && [ ! -f "$WORKSPACE_DIR/MEMORY.md" ]; then
  mkdir -p "$WORKSPACE_DIR"
  cp -r "$WORKSPACE_SEED"/* "$WORKSPACE_DIR/"
  chown -R 1000:1000 "$WORKSPACE_DIR" 2>/dev/null || true
fi

if [ $# -eq 0 ]; then
  exec openclaw gateway run
fi
exec "$@"
