# 🏃 跑步音樂隨機播放器 (Running Music Player)

一個專為跑步設計的網頁隨機音樂播放器，支援 YouTube MP3 自動下載、隨機播放、手機背景播放與鎖屏媒體控制。

---

## 🛠️ 工具準備 (本機設定)

確保專案根目錄包含以下關鍵檔案與工具：
* `songs/` ：存放所有下載好的 `.mp3` 音樂檔
* `download_yt.bat` ：自動下載 YouTube 音樂並直接存入 `songs/`
* `generate_playlist.bat` ：自動掃描 `songs/` 資料夾並產生 `playlist.js`
* `yt-dlp.exe` 與 `ffmpeg.exe` ：下載與轉檔的核心元件

---

## 🎵 如何新增與同步音樂 (日常操作 3 步驟)

### 步驟 1：下載新音樂
1. 雙擊執行 **`download_yt.bat`**。
2. 貼上 YouTube 單曲或播放清單網址後按下 Enter。
3. 程式會全自動下載轉檔至 `songs/` 資料夾，並自動調用 `generate_playlist.bat` 更新 `playlist.js`。

---

### 步驟 2：同步至 GitHub 雲端
1. 開啟 **GitHub Desktop** 應用程式。
2. 軟體會自動偵測到新新增的 `.mp3` 與被更新的 `playlist.js`。
3. 在左下角 **Summary** 欄位輸入變更紀錄（例如：`新增歌曲`）。
4. 點擊 **Commit to main** 按鈕。
5. 點擊右上角的 **Push origin** 將檔案推送至 GitHub。

---

### 步驟 3：手機端同步收聽
1. 推送完成後，等待約 **1 分鐘** 讓 GitHub Pages 自動完成網站更新。
2. 開啟手機瀏覽器造訪專屬網址：
   👉 `https://ltx3050.github.io/running_music/`
3. 重新整理網頁後，點擊 **「▶ 開始播放 (隨機)」** 即可聽到最新的音樂清單！

---

## 📱 手機背景與鎖屏控制說明
* **iOS (Safari)** / **Android (Chrome)**：必須手動點擊網頁上的按鈕才能授權背景與鎖屏播放。
* **鎖屏控制**：支援在手機鎖定畫面顯示歌名，並可使用系統媒體控制按鈕切換「下一首」。