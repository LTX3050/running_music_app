# 設定 UTF-8 編碼
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "===================================================" -ForegroundColor Green
Write-Host "    🏃 YouTube 跑步音樂下載 & 165 BPM 調整器" -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
Write-Host ""

$URL = Read-Host "請貼上 YouTube 網址"

if ([string]::IsNullOrWhiteSpace($URL)) {
    Write-Host "❌ 未輸入網址，程式結束。" -ForegroundColor Red
    Read-Host "按 Enter 鍵離開..."
    exit
}

if (-not (Test-Path "temp_download")) { New-Item -ItemType Directory -Path "temp_download" | Out-Null }
if (-not (Test-Path "songs")) { New-Item -ItemType Directory -Path "songs" | Out-Null }

Write-Host "`n⬇️ [1/4] 正在下載歌曲..." -ForegroundColor Yellow
Write-Host "---------------------------------------------------"
& .\yt-dlp.exe -x --audio-format mp3 --audio-quality 0 -o "temp_download\%(title)s.%(ext)s" $URL

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n❌ 下載失敗，請檢查網址或 yt-dlp 是否存在！" -ForegroundColor Red
    Read-Host "按 Enter 鍵離開..."
    exit
}

Write-Host "`n✅ 下載成功！`n" -ForegroundColor Green

$NEED_BPM = Read-Host "請問是否要調整為 165 BPM？(輸入 y 或 n)"

if ($NEED_BPM -eq "y" -or $NEED_BPM -eq "Y") {
    $ORIG_BPM_INPUT = Read-Host "請輸入歌曲原本的 BPM (例如 120，預設 120)"
    if ([string]::IsNullOrWhiteSpace($ORIG_BPM_INPUT)) {$ORIG_BPM = 120 } else { $ORIG_BPM = [double]$ORIG_BPM_INPUT }

    $TEMPO = [math]::Round(165 / $ORIG_BPM, 4)
    Write-Host "`n⚡ [2/4] 變速倍率計算完成：$TEMPO 倍" -ForegroundColor Cyan
    Write-Host "🔄 [3/4] 正在調整為 165 BPM..." -ForegroundColor Yellow

    Get-ChildItem -Path "temp_download\*.mp3" | ForEach-Object {
        $inputFile = $_.FullName
        $outputFile = Join-Path "songs" $_.Name
        Write-Host "正在轉檔: $($_.Name)..."
        & .\ffmpeg.exe -y -i $inputFile -filter:a "atempo=$TEMPO" -vn $outputFile *>$null
    }
    Write-Host "✅ 165 BPM 轉檔完成並已存入 songs/ 資料夾！" -ForegroundColor Green
} else {
    Write-Host "`n📁 不調整 BPM，直接複製 MP3 到 songs/..." -ForegroundColor Yellow
    Copy-Item "temp_download\*.mp3" "songs\" -Force
}

# 清除臨時資料夾
if (Test-Path "temp_download") { Remove-Item "temp_download" -Recurse -Force }

Write-Host "`n📜 [4/4] 正在更新播放清單..." -ForegroundColor Yellow
if (Test-Path "generate_playlist.bat") {
    Start-Process -FilePath "generate_playlist.bat" -Wait -NoNewWindow
}

Write-Host "`n===================================================" -ForegroundColor Green
Write-Host "🎉 全部操作完成！請打開 GitHub Desktop 上傳。" -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
Write-Host ""
Read-Host "按 Enter 鍵離開..."