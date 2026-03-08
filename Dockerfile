# 使用 Zeabur 模板同版本的 OpenClaw 映像，僅覆蓋設定檔
FROM ghcr.io/openclaw/openclaw:2026.3.2

# base 映像可能以 non-root 執行，先用 root 建立目錄並設權限
USER root
RUN mkdir -p /opt/openclaw-seed && chown -R 1000:1000 /opt/openclaw-seed
COPY --chown=1000:1000 openclaw.json /opt/openclaw-seed/openclaw.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER 1000

ENTRYPOINT ["/entrypoint.sh"]
# 保留 base 映像的 CMD（例如 openclaw gateway run），由 entrypoint 傳下去
CMD ["openclaw", "gateway", "run"]
