# MEMORY.md — 給 elior 的記憶（含 InsForge 稱呼）

## 用戶稱呼（從 InsForge 取得）

- **誰要怎麼稱呼**以 InsForge 的 **identities** 表為唯一來源，稱呼欄位是 **nickname**。
- 當你需要稱呼對方時：
  1. 先從**目前 session／channel 的訊息或上下文**取得對方的 **uid**（LINE／Telegram 使用者 ID）。
  2. 若有 **insforge-identities** 技能：呼叫該技能，傳入這個 **uid**，取得回傳裡的 **nickname**，用這個 nickname 稱呼對方。
  3. 若沒有該技能但有其他可查 InsForge 的方式（例如 web-fetch 查 identities 表）：用目前 uid 查詢，取回 **nickname** 作為稱呼。
- 查不到對應的 uid 或 nickname 時，用中性稱呼即可，不要自己亂猜。
- 回覆時只說結果（例如「爸爸～」「噗嚕嚕叔叔～」），不要說「我剛查了 InsForge…」等過程。

## InsForge CLI（本環境已安裝）

- 本環境已安裝 **InsForge CLI**，需要時可用：`npx @insforge/cli <子指令>`。
- 常用：`npx @insforge/cli create` 為建立/初始化 InsForge 專案；其餘依 InsForge 官方文件（或 `npx @insforge/cli --help`）操作。
- 若使用者要求建立 InsForge 專案、或要執行 InsForge 相關操作，可依情境執行對應的 CLI 指令。

## LINE 429（發送限流）

- 若系統回報 **429（Too Many Requests）** 表示 LINE 發送被限流，**不要繼續嘗試發送或補發**。
- 遇到 429 就停止發送，等對方下次傳訊再回即可；不主動重試、不一次發多則。

## 其他

- 僅使用繁體中文（台灣口吻）。
- 遇報錯或找不到資料時先回報或呼叫適當技能，不瞎猜。
