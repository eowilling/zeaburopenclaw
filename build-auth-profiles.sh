#!/bin/sh
# 在 Zeabur Command 執行：從環境變數 GEMINI_API_KEY_1~5 建置 /home/node/.openclaw/auth-profiles.json
# 用法：sh /opt/openclaw-seed/build-auth-profiles.sh

set -e
CONFIG_DIR="${HOME}/.openclaw"
OUT_FILE="${CONFIG_DIR}/auth-profiles.json"

if [ -z "$GEMINI_API_KEY_1" ] || [ -z "$GEMINI_API_KEY_2" ] || [ -z "$GEMINI_API_KEY_3" ] || [ -z "$GEMINI_API_KEY_4" ] || [ -z "$GEMINI_API_KEY_5" ]; then
  echo "錯誤：請在 Zeabur Variables 設定 GEMINI_API_KEY_1 ~ GEMINI_API_KEY_5"
  exit 1
fi

mkdir -p "$CONFIG_DIR"

# 將 key 內含的 " 換成 \"，避免破壞 JSON
escape() { echo "$1" | sed 's/"/\\"/g'; }
K1=$(escape "$GEMINI_API_KEY_1")
K2=$(escape "$GEMINI_API_KEY_2")
K3=$(escape "$GEMINI_API_KEY_3")
K4=$(escape "$GEMINI_API_KEY_4")
K5=$(escape "$GEMINI_API_KEY_5")

cat << EOF > "$OUT_FILE"
{
  "profiles": {
    "google:key1": {
      "type": "api_key",
      "provider": "google",
      "key": "$K1"
    },
    "google:key2": {
      "type": "api_key",
      "provider": "google",
      "key": "$K2"
    },
    "google:key3": {
      "type": "api_key",
      "provider": "google",
      "key": "$K3"
    },
    "google:key4": {
      "type": "api_key",
      "provider": "google",
      "key": "$K4"
    },
    "google:key5": {
      "type": "api_key",
      "provider": "google",
      "key": "$K5"
    }
  }
}
EOF

echo "已寫入: $OUT_FILE"
echo "請在 Zeabur 重啟 OpenClaw 服務使設定生效。"
