# Zeabur 設定說明：UI 設定與程式控制

專案已調整為可在 Control UI 修改設定，且改動會持久化；同時支援用程式（WebSocket RPC）讀寫設定。請在 Zeabur 依下列項目設定。

---

## 一、硬碟掛載（必做）

讓設定檔寫入持久化磁碟，重啟後才不會消失。

| 項目 | 設定值 |
|------|--------|
| **硬碟 ID** | `data`（或你自訂的名稱） |
| **掛載目錄** | **`/home/node`** |

- 路徑必須是 `/home/node`，OpenClaw 的設定檔會寫在 `/home/node/.openclaw/openclaw.json`。
- 若未掛載，UI 的修改在重啟後會消失。

---

## 二、啟動指令

維持你目前使用的指令即可，映像的 entrypoint 會先執行（把種子設定複製到磁碟），再跑你的腳本：

```
/bin/sh -c /opt/openclaw/startup.sh && /opt/openclaw/start_gateway.sh
```

若平台沒有帶入上述指令當成 CMD，可改為明確呼叫 entrypoint：

```
/entrypoint.sh /bin/sh -c "/opt/openclaw/startup.sh && /opt/openclaw/start_gateway.sh"
```

---

## 三、環境變數（必填／建議）

在 Zeabur 服務的「環境變數」中設定：

| 變數名稱 | 說明 | 是否必填 |
|----------|------|----------|
| **OPENCLAW_CONFIG_PATH** | 指定設定檔路徑，**必須**設為 `/home/node/.openclaw/openclaw.json`，Gateway 才會讀磁碟上的設定（含免裝置配對） | **必填** |
| **OPENCLAW_GATEWAY_TOKEN** | 與 `openclaw.json` 裡 `gateway.auth.token` 相同，用於瀏覽器 UI 與程式連線 | 建議設 |
| **GOOGLE_GENERATIVE_AI_API_KEY**（或你用的 Gemini 金鑰變數名） | Gemini API 金鑰，若 auth 用 env 注入 | 依你目前登入方式 |

- **為何必填 OPENCLAW_CONFIG_PATH**：Zeabur 的啟動腳本（`/opt/openclaw/start_gateway.sh`）若未指定，可能讀取映像內其他路徑的設定檔，就不會套用磁碟上的 `gateway.controlUi.dangerouslyDisableDeviceAuth`，會出現 `device identity required` 而無法連線。
- UI 連線時在「設定」頁輸入的 **Gateway 令牌**，請與 `gateway.auth.token` 一致；程式呼叫 Gateway 時，用同一組 token 做認證即可。

---

## 四、使用 Control UI 設定

1. **開啟 Control UI**  
   用 Zeabur 給的網址（例如 `https://你的服務.zeabur.app`），若有設路徑則加上對應 path（例如 `https://.../`）。

2. **連線**  
   - 在畫面上輸入 **Gateway 令牌**（與 `gateway.auth.token` 相同，例如本 repo 預設的 `d2es0O95q3khz4SbHJ18ilr6Wwx7LVYP`，建議改為自己專用的 token 並設成環境變數）。
   - 不需裝置配對（已設定 `dangerouslyDisableDeviceAuth`）。

3. **修改設定**  
   - 左側進入 **「設定」**（Config）標籤。  
   - 可從表單或 Raw JSON 編輯 `openclaw.json`，儲存後會寫入 `/home/node/.openclaw/openclaw.json`。  
   - 因已設 `gateway.reload.mode: "hybrid"`，變更會即時套用（必要時會重啟）。

4. **代理 / 工具**  
   - **「代理」**（Agents）標籤可管理 workspace、工具開關等；Tools 面板會依 runtime 的 `tools.catalog` 顯示，可調整 profile/override。

---

## 五、程式控制（WebSocket RPC）

用程式讀寫設定時，連到同一個 Gateway，並帶上 token：

- **WebSocket URL**：`wss://你的服務.zeabur.app`（或你實際的 Gateway WS 網址，含 path 若有的話）。
- **認證**：連線時在 `connect.params.auth.token` 帶入與 `gateway.auth.token` 相同的值（或 `OPENCLAW_GATEWAY_TOKEN`）。

常用 RPC：

- **config.get**：讀取目前設定（等同讀取 `openclaw.json`）。
- **config.set**：寫入完整設定（會寫入磁碟，需帶正確 `baseHash` 以防覆蓋）。
- **config.patch**：部分更新設定。
- **config.schema**：取得設定 schema，方便表單或驗證。

程式範例（概念）：

1. 建立 WebSocket 連到 Gateway URL。
2. 發送 `connect`，在 `params.auth.token` 帶入 token。
3. 連線成功後發送 `config.get` 取得目前設定與 hash。
4. 要寫入時呼叫 `config.set` 或 `config.patch`，並依文件帶上 `baseHash`（來自前一次 `config.get`）。

這樣即可用 UI 與程式雙向同步同一份設定，且都會持久化在 `/home/node` 的磁碟上。

---

## 六、定時自動重啟（03:00 UTC）

- 有掛載 **`/home/node`** 時，設定檔與 workspace 都在磁碟上，**定時重啟不會清掉 UI 或程式寫入的設定**。
- 重啟後會再跑一次啟動指令，entrypoint 只會在「磁碟上還沒有 `openclaw.json`」時才複製種子檔，不會覆蓋你已改過的設定。

---

## 七、檢查清單

部署後請確認：

- [ ] 硬碟已掛載到 **`/home/node`**
- [ ] 啟動指令為上述腳本（或含 `/entrypoint.sh` 的版本）
- [ ] 環境變數已設 **OPENCLAW_GATEWAY_TOKEN**（與 config 內 token 一致）
- [ ] 能用瀏覽器開 Control UI 並用 token 連線
- [ ] 在「設定」頁改一項後儲存，重啟服務再開設定頁，確認變更仍在
- [ ] 程式用同一 token 連 WebSocket，可成功呼叫 `config.get` / `config.set` 或 `config.patch`

若以上都符合，即表示 Zeabur 上已正確設定，可順利使用 UI 設定與程式控制。

---

## 八、故障排除：`device identity required`（1008）

若日誌出現 **`code=1008 reason=device identity required`**，代表 Gateway 讀到的設定裡沒有啟用「免裝置配對」。

**請依序檢查：**

1. **環境變數**  
   在 Zeabur 服務裡新增：  
   **`OPENCLAW_CONFIG_PATH`** = **`/home/node/.openclaw/openclaw.json`**  
   儲存後**重新部署**，讓 Gateway 改為讀取磁碟上的設定。

2. **磁碟上的設定內容**  
   若之前曾部署過舊版或沒掛 Volume，磁碟上的 `openclaw.json` 可能是舊的（沒有 `gateway.controlUi.dangerouslyDisableDeviceAuth`）。  
   - **方式 A**：在 Zeabur 的 **Files** 裡打開 `/home/node/.openclaw/openclaw.json`，確認有這一段（若沒有就補上）：
     ```json
     "controlUi": {
       "dangerouslyAllowHostHeaderOriginFallback": true,
       "allowInsecureAuth": true,
       "dangerouslyDisableDeviceAuth": true
     }
     ```
   - **方式 B**：刪除磁碟上的 `openclaw.json`（或整個 `/home/node/.openclaw` 後重啟服務），讓 entrypoint 重新從種子複製一份（內含上述設定）。

3. **重啟**  
   改完環境變數或設定檔後，務必**重新部署／重啟**服務，Gateway 才會載入新設定。
