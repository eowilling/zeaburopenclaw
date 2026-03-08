# InsForge 用戶稱呼：讓 elior 知道怎麼取得

用戶的**稱呼**（要怎麼叫對方）存在 **InsForge 的 `identities` 表**裡，欄位是 **`nickname`**。要讓 elior 會用這份資料，需要兩件事：**他能連到 InsForge**，以及**他知道要去哪裡查、怎麼用**。

---

## 一、資料在哪裡

| 項目 | 說明 |
|------|------|
| **表名** | `identities` |
| **稱呼欄位** | `nickname`（例如「爸爸」「噗嚕嚕叔叔」） |
| **對應誰** | `uid`（LINE / Telegram 等平台的使用者 ID） |

- 在 InsForge 後台（或 Admin 控制中心）維護 **identities**：一筆一筆填 `uid` + `nickname`（必要時可加 `source`、`display_name`）。
- elior 回話前用「目前對話的 uid」去查這張表，取回 **nickname** 當作稱呼。

---

## 二、讓 elior「能」取得：連線與工具

### 方式 A：使用技能 `insforge-identities`（推薦）

若你的部署裡有 **insforge-identities** 這支技能（例如從 openclaw-elior-lite-fresh 或同系列專案來的）：

1. **啟用技能**  
   在 `openclaw.json` 的 `plugins.entries` 或對應技能設定裡，把 **insforge-identities** 設為 `enabled: true`（若你的專案是用 `skills.entries` 之類結構，就啟用在那裡）。

2. **設定環境變數**（Zeabur 在服務的 Variables 裡設）：  
   - **INSFORGE_BASE_URL**：InsForge 專案 API 網址（例如 `https://你的專案.us-east.insforge.app`，勿加尾端 `/`）  
   - **INSFORGE_ANON_KEY**：該專案的 **Anon Key**（從 InsForge 後台 API／設定 複製，不是 `ik_` 開頭的 API Key）

3. **重新部署／重啟**  
   讓環境變數與設定生效，技能才能連到 InsForge 並查 `identities`。

這樣 elior 就可以透過 **呼叫 insforge-identities**（傳入目前使用者的 uid）取得該筆的 **nickname** 當稱呼。

### 方式 B：沒有 insforge-identities 時（用 API 查表）

若目前沒有這支技能，但你有 **可對外連線的 InsForge**：

- 用 **web-fetch** 或你已有的 HTTP 工具，對 InsForge 的 **Records API** 發請求，查 `identities` 表（依 `uid` 過濾），讀回 **nickname**。  
- 請求大致為：  
  `GET {INSFORGE_BASE_URL}/rest/v1/identities?uid=eq.{目前使用者的 uid}`  
  Header：`Authorization: Bearer {INSFORGE_ANON_KEY}`、`apikey: {INSFORGE_ANON_KEY}`（視你 InsForge 版本而定）。  
- 若環境裡無法直接拿到 `INSFORGE_ANON_KEY`，可改為在後端做一層小 API（例如「傳 uid，回 nickname」），再讓 elior 用 web-fetch 呼叫你這支 API。

---

## 三、讓 elior「知道」怎麼取得：寫進 workspace 記憶

光有連線與工具還不夠，要**明確告訴 elior 流程**，他才會在要稱呼人時先去查表。

請在 **OpenClaw 的 workspace**（Zeabur 上即 `/home/node/.openclaw/workspace`）裡放一份 **MEMORY.md**（或你專案實際會讀的記憶檔），內容包含下面這段（可依你習慣改寫）：

```markdown
## 用戶稱呼（從 InsForge 取得）

- **誰要怎麼稱呼**以 InsForge 的 **identities** 表為唯一來源，稱呼欄位是 **nickname**。
- 當你需要稱呼對方時：
  1. 先從**目前 session／channel 的訊息或上下文**取得對方的 **uid**（LINE／Telegram 使用者 ID）。
  2. 若有 **insforge-identities** 技能：呼叫該技能，傳入這個 **uid**，取得回傳裡的 **nickname**，用這個 nickname 稱呼對方。
  3. 若沒有該技能但有其他可查 InsForge 的方式（例如 web-fetch 查 identities 表）：用目前 uid 查詢，取回 **nickname** 作為稱呼。
- 查不到對應的 uid 或 nickname 時，用中性稱呼即可，不要自己亂猜。
- 回覆時只說結果（例如「爸爸～」「噗嚕嚕叔叔～」），不要說「我剛查了 InsForge…」等過程。
```

- **Zeabur**：可透過 Control UI 的檔案編輯，或登入容器後在 `/home/node/.openclaw/workspace/` 建立/編輯 **MEMORY.md**，把上面內容貼上。  
- 本 repo 已附 **`workspace-seed/MEMORY.md`**：可直接複製到上述 workspace 路徑，或貼進 Control UI 的 workspace 編輯區，省去手打。

這樣 elior 就會「知道」：要稱呼人時，先用 uid 查 InsForge identities，再用 **nickname** 當稱呼。

---

## 四、總結

| 步驟 | 要做的事 |
|------|----------|
| 1. 資料來源 | 在 InsForge **identities** 表維護 **uid** ↔ **nickname**（稱呼）。 |
| 2. 連線與工具 | Zeabur 設 **INSFORGE_BASE_URL**、**INSFORGE_ANON_KEY**；若有 **insforge-identities** 技能就啟用，沒有就改用 web-fetch 或自建小 API 查 identities。 |
| 3. 讓 agent 知道 | 在 workspace 的 **MEMORY.md**（或同類記憶檔）寫明：用目前 **uid** 查 identities，取 **nickname** 當稱呼。 |

完成後，elior 就會依 InsForge 資料表裡的設定來稱呼用戶。
