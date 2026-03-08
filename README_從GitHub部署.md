# 從 GitHub 推播部署 OpenClaw（Zeabur）

讓 Zeabur 使用 **你 repo 裡的 openclaw.json**，之後改設定只要 push 到 GitHub 就會自動重新部署。

## 步驟一：把這個資料夾推到 GitHub

1. 在 GitHub 建立一個 **新 repo**（或使用現有 repo）。
2. 本機在 `zeaburOpnwclaw` 資料夾內執行：

   ```bash
   git init
   git add openclaw.json Dockerfile .dockerignore
   git add ENV_五組Gemini_API_Key.md
   git commit -m "OpenClaw config for Zeabur (Gemini only)"
   git remote add origin https://github.com/你的帳號/你的repo名稱.git
   git branch -M main
   git push -u origin main
   ```

3. 之後只要改 `openclaw.json`，執行 `git add openclaw.json && git commit -m "更新設定" && git push`，Zeabur 就會用新設定重新部署。

## 步驟二：在 Zeabur 改為「從 GitHub 建置」

1. 登入 **Zeabur Dashboard** → 你的專案。
2. 找到目前的 **OpenClaw 服務**（一鍵模板建立的）。
3. 兩種做法擇一：

   **做法 A：同專案改用 GitHub 建置（建議）**

   - 在專案裡新增 **「從 GitHub 部署」** 的服務。
   - 選擇你剛 push 的 **repo**（只放 zeaburOpnwclaw 的內容，或 repo 根目錄就是 zeaburOpnwclaw 的檔案）。
   - Zeabur 會偵測到 **Dockerfile** 並用其建置，建出來的映像裡會帶入 repo 的 `openclaw.json`。
   - 若你的 repo 根目錄是「整個 OpenClaw 專案」、Dockerfile 在 `zeaburOpnwclaw/` 底下，需在 Zeabur 的服務設定裡把 **Root Directory** 或 **Dockerfile 路徑** 指到 `zeaburOpnwclaw`（依 Zeabur 介面為準）。

   **做法 B：新專案只部署這個 repo**

   - 新專案 → **Import from GitHub** → 選這個 repo。
   - 建置方式選 **Dockerfile**（Zeabur 會自動偵測）。
   - 部署完成後，到 **Variables** 設定環境變數（見下方）。

4. **環境變數**：和現在一樣在 Zeabur 的 **Variables** 設定，例如：
   - `GEMINI_API_KEY_1`～`GEMINI_API_KEY_5`（或至少一個）
   - Telegram、LINE 的 token 等（若 openclaw.json 裡有寫就照舊）。

5. **重啟服務**，之後就會用 GitHub 上的 `openclaw.json`，不再需要到 Zeabur Files 手動覆蓋。

## 若 repo 根目錄不是 zeaburOpnwclaw

若你的 GitHub repo 是「整個 OpenClaw 專案」、而 `zeaburOpnwclaw` 只是其中一個子資料夾：

- 在 Zeabur 建立/編輯服務時，把 **Root Directory** 設成 **`zeaburOpnwclaw`**，這樣建置時會以該目錄為根，Dockerfile 和 `openclaw.json` 都會被正確找到。

## 這樣做的好處

- 設定改動有 **Git 紀錄**，可還原、可比對。
- **push 即部署**，不用再開 Zeabur Files 貼內容。
- 本機編輯 `openclaw.json` → commit → push，就完成更新。
