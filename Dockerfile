# 使用 Zeabur 模板同版本的 OpenClaw 映像，僅覆蓋設定檔
FROM ghcr.io/openclaw/openclaw:2026.3.2

# 種子設定放在 /opt，避免被掛在 /home/node 的 Volume 蓋掉；entrypoint 只在磁碟尚無設定時複製過去
RUN mkdir -p /opt/openclaw-seed
COPY --chown=1000:1000 openclaw.json /opt/openclaw-seed/openclaw.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
# 保留 base 映像的 CMD（例如 openclaw gateway run），由 entrypoint 傳下去
CMD ["openclaw", "gateway", "run"]
