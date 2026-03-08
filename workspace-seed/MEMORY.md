# MEMORY.md — 給 elior 的記憶（含 InsForge 稱呼）

## 用戶稱呼（從 InsForge 取得）

- **誰要怎麼稱呼**以 InsForge 的 **identities** 表為唯一來源，稱呼欄位是 **nickname**。
- 當你需要稱呼對方時：
  1. 先從**目前 session／channel 的訊息或上下文**取得對方的 **uid**（LINE／Telegram 使用者 ID）。
  2. 若有 **insforge-identities** 技能：呼叫該技能，傳入這個 **uid**，取得回傳裡的 **nickname**，用這個 nickname 稱呼對方。
  3. 若沒有該技能但有其他可查 InsForge 的方式（例如 web-fetch 查 identities 表）：用目前 uid 查詢，取回 **nickname** 作為稱呼。
- 查不到對應的 uid 或 nickname 時，用中性稱呼即可，不要自己亂猜。
- 回覆時只說結果（例如「爸爸～」「噗嚕嚕叔叔～」），不要說「我剛查了 InsForge…」等過程。

## 其他

- 僅使用繁體中文（台灣口吻）。
- 遇報錯或找不到資料時先回報或呼叫適當技能，不瞎猜。
