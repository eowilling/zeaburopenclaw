# 使用 Zeabur 模板同版本的 OpenClaw 映像，僅覆蓋設定檔
FROM ghcr.io/openclaw/openclaw:2026.3.2

# 將 repo 裡的 openclaw.json 複製到容器內（推送 GitHub 後每次部署都會用這份）
COPY --chown=1000:1000 openclaw.json /home/node/.openclaw/openclaw.json
