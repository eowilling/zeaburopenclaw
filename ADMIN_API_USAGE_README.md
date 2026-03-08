# Admin 紀錄各組 Gemini API 使用量

## 為什麼沒辦法「自動」紀錄每組 Key 的用量？

- **OpenClaw** 只會在你設定的多個 key 之間做**輪替**（遇到 429 換下一個），不會對外回報「這次請求用的是第幾號 key、用了多少 token」。
- 所以**無法**單靠 OpenClaw 的 API 或 hook 做出「每組 key 各自用量」的自動統計。

## 可行做法

### 做法一：用本專案附的 admin 頁（推薦）

1. 開啟 **`admin-api-usage.html`**（雙擊用瀏覽器開，或放到你任何靜態網站）。
2. 在表格裡填寫「每個環境變數對應哪個 Google 帳號」（例如 `GEMINI_API_KEY_1` = `main@gmail.com`）。
3. 點「儲存到本機」會存進瀏覽器 localStorage，下次開啟可點「載入本機紀錄」。
4. 要查用量時：用**該列的 Google 帳號**登入，點該列的「Google AI Studio → API Key / 用量」連結，在 AI Studio 裡看該帳號的用量與限額。

這樣你就有一份自己的「Key ↔ 帳號」對照表，並能依帳號去查官方用量。

### 做法二：直接到 Google 各帳號查

- 每個 **GEMINI_API_KEY_1 ~ 5** 對應一個**不同的 Google 帳號**。
- 用該帳號登入 [Google AI Studio](https://aistudio.google.com/)（或 Cloud Console），在用量/計費頁面即可看到該 key 的用量。
- 不需要額外程式，只是要記得「哪個 key 是哪個帳號」。

### 做法三：看「整體」用量（不區分哪一組 key）

- 在聊天裡用 **`/usage full`**：每次回覆後會顯示該次請求的 token / 預估成本（不區分 key）。
- CLI：`openclaw status --usage` 可看目前 provider 的用量概況（仍是整體，不是 per-key）。
- 若啟用 **diagnostics-otel** 並把資料送到 Grafana/Prometheus，可以做「總 token / 總成本」的儀表板，但依然**無法**拆成「Key 1～5 各自多少」。

## 總結

| 需求 | 做法 |
|------|------|
| 紀錄「Key 1～5 各對應哪個帳號」 | 用 `admin-api-usage.html` 填表並存本機 |
| 看「某一組 key」的用量 | 用該 key 對應的 Google 帳號登入 AI Studio 查看 |
| 看「整體」Gemini 用量 | `/usage full`、`openclaw status --usage` 或 OTLP 匯出 |

目前**沒有**「OpenClaw 自動回報每組 API key 使用量」的內建方式，admin 頁主要是幫你對照 key 與帳號、並快速連到官方用量頁。
