@echo off
title Update Playlist.js (UTF-8 Fix)
echo [1/1] Scanning songs directory and generating UTF-8 playlist.js...

powershell -NoProfile -ExecutionPolicy Bypass -Command "$files = Get-ChildItem -Path 'songs/*.mp3' | ForEach-Object { '  \"songs/' + $_.Name + '\",' }; $content = 'const playlist = [' + [Environment]::NewLine + ($files -join [Environment]::NewLine) + [Environment]::NewLine + '];'; [System.IO.File]::WriteAllText('playlist.js', $content, [System.Text.Encoding]::UTF8)"

echo.
echo ===================================================
echo Done! playlist.js has been regenerated in UTF-8.
echo ===================================================
echo.
pause