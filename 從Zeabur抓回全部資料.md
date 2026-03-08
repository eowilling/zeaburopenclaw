# 把 Zeabur 上的 OpenClaw 檔案與專案資料全部抓下來

兩種方式：**用終端機打包 + 檔案下載**（免付費）、**用備份功能**（需 Dev Plan 且有掛 Volume）。

---

## 方式一：終端機打包 + 檔案管理下載（推薦，免付費）

把容器裡的 `/home/node/.openclaw/` 打成一個壓縮檔，再從 Files 下載。

### 步驟

1. **開終端機**
   - Zeabur Dashboard → 你的專案 → **OpenClaw 服務** → **服務狀態**（或 Overview）→ **Command**（命令執行）。

2. **在終端機執行**（把整個 .openclaw 打成一個檔）：
   ```bash
   tar czvf /tmp/openclaw-full-backup.tar.gz -C /home/node .openclaw
   ```
   若上面報錯（例如權限），改試：
   ```bash
   cd /home/node && tar czvf /tmp/openclaw-full-backup.tar.gz .openclaw
   ```

3. **下載壓縮檔**
   - 同一個服務 → **Files**（檔案管理）。
   - 左側目錄點到 **`/tmp`**。
   - 找到 **`openclaw-full-backup.tar.gz`**，滑鼠移上去點 **下載**，存到本機。

4. **在本機解壓**
   - Windows：用 7-Zip 或 WinRAR 解開 `openclaw-full-backup.tar.gz`。
   - 解開後會得到 **`.openclaw`** 資料夾，裡面就是 Zeabur 上目前的設定與專案資料（例如 `openclaw.json`、`workspace`、`agents`、sessions 等）。

5. **（可選）清掉容器裡的暫存檔**
   - 回到 Command 執行：`rm /tmp/openclaw-full-backup.tar.gz`

### 這樣你會拿到什麼

- **`openclaw.json`**：目前 Zeabur 在用的設定。
- **`workspace/`**：工作區檔案。
- **`agents/`**：agent 設定、auth-profiles、sessions 等。
- 其他 `.openclaw` 底下的目錄與檔案。

之後你可以把本機的 `.openclaw` 當作「完整備份」，或把裡面的 `openclaw.json` 複製到 `zeaburOpnwclaw/openclaw.json` 再 push 到 GitHub。

---

## 方式二：Zeabur 備份功能（需 Dev Plan + 有掛 Volume）

若你的 OpenClaw 服務有掛 **持久儲存空間（Volume）**，且方案是 **Dev Plan 以上**：

1. **設定** → **暫停服務**。
2. 同一個服務 → **備份** 分頁 → 點 **備份**。
3. 備份完成後會出現 **下載** 按鈕，下載下來就是 Volume 裡那顆硬碟的完整內容（通常是某個目錄的 tar 或類似格式）。

注意：**備份只會備份「有掛 Volume」的那個目錄**，不會備份整個容器。若 OpenClaw 一鍵模板沒有把 `/home/node/.openclaw` 掛成 Volume，這個備份可能不存在或為空，請以方式一為主。

---

## 抓下來之後可以怎麼用

- **和 GitHub 一起用**：把抓下來的 `openclaw.json` 覆蓋到 `zeaburOpnwclaw/openclaw.json`，再 push，之後從 GitHub 部署就會用這份設定。
- **本機還原**：把解壓後的 `.openclaw` 放到本機 `~/.openclaw`（或你本機 OpenClaw 的 config 目錄），即可在本機還原同一份設定與資料。
- **純備份**：保留 `openclaw-full-backup.tar.gz`，需要時再解壓使用。
