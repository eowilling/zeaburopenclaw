# Zeabur 環境變數：五組 Gemini API Key 輪替

在 Zeabur 專案 → 你的 OpenClaw 服務 → **Variables** 裡新增以下 5 個變數：

| 變數名稱 | 說明 |
|----------|------|
| `GEMINI_API_KEY_1` | 第 1 個 Google 帳號的 API Key |
| `GEMINI_API_KEY_2` | 第 2 個 Google 帳號的 API Key |
| `GEMINI_API_KEY_3` | 第 3 個 Google 帳號的 API Key |
| `GEMINI_API_KEY_4` | 第 4 個 Google 帳號的 API Key |
| `GEMINI_API_KEY_5` | 第 5 個 Google 帳號的 API Key |

- 名稱必須**全大寫**、底線，與上表一致。
- 每個值到 [Google AI Studio](https://aistudio.google.com/apikey) 用不同 Google 帳號申請 API Key 後貼上。
- 設定完後重新部署，OpenClaw 會自動在遇到限流（429）時輪替使用這 5 組 key。

**openclaw.json 不需修改**，多 key 輪替由環境變數驅動。

**注意：** 已移除 Zeabur AI Hub，**不需要**再設定 `ZEABUR_AI_HUB_API_KEY`。只要設定上述 5 組 Gemini key 即可啟動。
