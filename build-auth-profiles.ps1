# 從環境變數 GEMINI_API_KEY_1 ~ 5 建置 auth-profiles.json（僅供本機使用，勿 commit）
# 用法：先設好環境變數，再執行 .\build-auth-profiles.ps1

$dir = Join-Path $PSScriptRoot ".openclaw-auth-build"
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

$k1 = $env:GEMINI_API_KEY_1
$k2 = $env:GEMINI_API_KEY_2
$k3 = $env:GEMINI_API_KEY_3
$k4 = $env:GEMINI_API_KEY_4
$k5 = $env:GEMINI_API_KEY_5

if (-not $k1 -or -not $k2 -or -not $k3 -or -not $k4 -or -not $k5) {
    Write-Host "錯誤：請先設定環境變數 GEMINI_API_KEY_1 ~ GEMINI_API_KEY_5" -ForegroundColor Red
    exit 1
}

$json = @"
{
  "profiles": {
    "google:key1": {
      "type": "api_key",
      "provider": "google",
      "key": "$($k1 -replace '\\','\\\\' -replace '"','\"')"
    },
    "google:key2": {
      "type": "api_key",
      "provider": "google",
      "key": "$($k2 -replace '\\','\\\\' -replace '"','\"')"
    },
    "google:key3": {
      "type": "api_key",
      "provider": "google",
      "key": "$($k3 -replace '\\','\\\\' -replace '"','\"')"
    },
    "google:key4": {
      "type": "api_key",
      "provider": "google",
      "key": "$($k4 -replace '\\','\\\\' -replace '"','\"')"
    },
    "google:key5": {
      "type": "api_key",
      "provider": "google",
      "key": "$($k5 -replace '\\','\\\\' -replace '"','\"')"
    }
  }
}
"@

$outPath = Join-Path $dir "auth-profiles.json"
$json | Set-Content -Path $outPath -Encoding UTF8 -NoNewline
Write-Host "已寫入: $outPath" -ForegroundColor Green
Write-Host "請將此檔上傳到 Zeabur 的 /home/node/.openclaw/ 後重啟服務。"
