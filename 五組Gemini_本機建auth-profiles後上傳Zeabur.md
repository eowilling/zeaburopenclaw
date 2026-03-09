# 方法 A：本機用 CLI 建 auth-profiles.json，上傳到 Zeabur 做五組 key 輪替

用 OpenClaw CLI 在本機建立包含 5 個 Gemini API key 的 auth 設定檔，上傳到 Zeabur 的 Volume，讓 Gateway 依 `auth.order` 輪替使用。

---

## 方式一：在 Zeabur 上用指令建置（推薦）

Zeabur 已把 5 組 key 設在環境變數時，可直接在 **Zeabur → OpenClaw 服務 → Command** 執行：

```bash
sh /opt/openclaw-seed/build-auth-profiles.sh
```

- 腳本會從 `GEMINI_API_KEY_1`～`GEMINI_API_KEY_5` 讀取，寫入 `/home/node/.openclaw/auth-profiles.json`。
- 執行完後在 Zeabur 對該服務做 **Restart**，Gateway 即會依 `auth.order` 輪替 5 組 key。

（腳本隨 repo 部署在映像內，需先 push 含 `build-auth-profiles.sh` 的版本並完成部署後再執行上述指令。）

---

## 方式二：本機用 PowerShell 腳本建置

本 repo 有 **`build-auth-profiles.ps1`**，從環境變數讀取 5 組 key 並產生 `.openclaw-auth-build/auth-profiles.json`。

### 步驟

1. **開啟 PowerShell**，切到專案目錄：
   ```powershell
   cd c:\xampp\htdocs\zeaburopenclaw
   ```

2. **設定 5 個環境變數**（本機當次視窗有效，勿 commit）：
   ```powershell
   $env:GEMINI_API_KEY_1 = "你的第1組key"
   $env:GEMINI_API_KEY_2 = "你的第2組key"
   $env:GEMINI_API_KEY_3 = "你的第3組key"
   $env:GEMINI_API_KEY_4 = "你的第4組key"
   $env:GEMINI_API_KEY_5 = "你的第5組key"
   ```

3. **執行腳本**：
   ```powershell
   .\build-auth-profiles.ps1
   ```

4. 完成後會產生 **`.openclaw-auth-build\auth-profiles.json`**，再上傳到 Zeabur 的 `/home/node/.openclaw/` 並重啟服務。

---

## 方式三：用 OpenClaw CLI（paste-token）建置

### 1. 安裝 OpenClaw CLI（若要用 CLI 才需安裝）

- 若尚未安裝：依 [OpenClaw 官方](https://docs.openclaw.ai/) 說明安裝 CLI（例如 `npm install -g openclaw` 或官方提供的安裝方式）。

### 2. 指定一個「只給這次建檔用」的目錄

在 PowerShell 或終端機：

```bash
# 例如在專案底下建一個暫存目錄（不要 commit 到 git）
mkdir -p .openclaw-auth-build
export OPENCLAW_CONFIG_PATH="$(pwd)/.openclaw-auth-build/openclaw.json"
# 若目錄內沒有 openclaw.json，先複製一份（讓 CLI 有基本 config）
# Windows PowerShell 範例：
Copy-Item openclaw.json .openclaw-auth-build\
```

或直接把 `OPENCLAW_CONFIG_PATH` 指到你本機已有的 `~/.openclaw`（若你願意讓這次寫入和現有 openclaw 混用）。

### 3. 用 paste-token 建立 5 個 profile

對應你 Zeabur 上的 `GEMINI_API_KEY_1`～`GEMINI_API_KEY_5`，依序執行 5 次，**每次貼上該組 key**：

```bash
openclaw models auth paste-token --provider google --profile-id "google:key1"
# 貼上第 1 個 key 後 Enter

openclaw models auth paste-token --provider google --profile-id "google:key2"
# 貼上第 2 個 key

openclaw models auth paste-token --provider google --profile-id "google:key3"
# 貼上第 3 個 key

openclaw models auth paste-token --provider google --profile-id "google:key4"
# 貼上第 4 個 key

openclaw models auth paste-token --provider google --profile-id "google:key5"
# 貼上第 5 個 key
```

CLI 會把這 5 個 profile 寫入 `OPENCLAW_CONFIG_PATH` 對應目錄底下的 **auth-profiles.json**（或該版本使用的 auth 檔名）。

### 4. 找到產生的 auth 檔

- 檔名可能是 **auth-profiles.json** 或 **auth-profiles.json5**，位置在你在步驟 2 設定的目錄裡（例如 `.openclaw-auth-build/` 或 `~/.openclaw/`）。
- **不要**把這個檔案 commit 到 GitHub（內含 API key）。

---

## 二、上傳到 Zeabur

### 1. 開 Zeabur 的 OpenClaw 服務 → Files（檔案管理）

### 2. 導到 Volume 掛載的目錄

- 路徑為 **`/home/node/.openclaw/`**（與 `OPENCLAW_CONFIG_PATH` 的目錄一致）。

### 3. 上傳本機的 auth-profiles.json

- 把本機剛產生的 **auth-profiles.json**（或該目錄內對應的 auth 檔）上傳到 `/home/node/.openclaw/`。
- 若該路徑已存在同名檔，會覆蓋；若沒有，就新增。

### 4. 重啟 OpenClaw 服務

- 在 Zeabur 對該服務做 **Restart**，讓 Gateway 重新讀取 config 與 auth。

---

## 三、確認

- 本 repo 的 **openclaw.json** 已包含 `auth.order`：`"google": ["google:key1", "google:key2", "google:key3", "google:key4", "google:key5"]`。
- Gateway 會依此順序使用 auth-profiles.json 裡的 5 個 profile；遇 429 會換下一組。
- 在 Telegram / LINE 發幾則訊息測試；若仍 429，可看 runtime log 是否有切換 profile 的訊息。

---

## 四、注意

- **auth-profiles.json 內含 API key**，請勿放進 GitHub，只透過 Zeabur Files 上傳或放在本機。
- 之後若更換其中一組 key，可重新在本機對該 profile-id 再執行一次 `paste-token`，產生新的 auth-profiles.json 後再上傳覆蓋 Zeabur 上的檔案並重啟。
