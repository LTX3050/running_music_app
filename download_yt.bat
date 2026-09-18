@echo off
title YouTube Downloader & 165 BPM Converter

:LOOP
cls
echo ===================================================
echo    YouTube Running Music Downloader (165 BPM)
echo ===================================================
echo.
echo [Step 1] Please enter URL and BPM in the popup window...

:: Create interactive VBScript for input to eliminate CMD & character crashes
(
echo Set wshShell = CreateObject("WScript.Shell"^)
echo url = InputBox("Paste YouTube URL here:" ^& vbCrLf ^& "(Leave blank and click OK to exit)", "YouTube Downloader"^)
echo If url = "" Then WScript.Quit 1
echo bpm = InputBox("Enter Original Song BPM:" ^& vbCrLf ^& "(Press OK with blank to skip 165 BPM conversion)", "BPM Setting", "120"^)
echo Set fso = CreateObject("Scripting.FileSystemObject"^)
echo Set outFile = fso.CreateTextFile("input_data.txt", True^)
echo outFile.WriteLine url
echo outFile.WriteLine bpm
echo outFile.Close
) > get_input.vbs

cscript //nologo get_input.vbs
if errorlevel 1 (
    if exist get_input.vbs del get_input.vbs
    goto END
)
if exist get_input.vbs del get_input.vbs

:: Read inputs safely from input_data.txt
set /p URL=<input_data.txt
(
  set /p URL=
  set /p ORIG_BPM=
)<input_data.txt
if exist input_data.txt del input_data.txt

if not exist "temp_download" mkdir temp_download
if not exist "songs" mkdir songs

echo.
echo [1/4] Downloading audio...
echo ---------------------------------------------------
yt-dlp.exe -x --audio-format mp3 --audio-quality 0 -o "temp_download\%%(title)s.%%(ext)s" "%URL%"

if errorlevel 1 (
    echo.
    echo Download failed! Please check the URL.
    pause
    goto LOOP
)

echo.
echo ---------------------------------------------------
echo Download completed!
echo.

if "%ORIG_BPM%"=="" (
    echo.
    echo Copying original MP3 to songs folder...
    xcopy /y /q "temp_download\*.mp3" "songs\"
    goto UPDATE_LIST
)

echo.
echo [2/4 & 3/4] Processing 165 BPM Conversion...

(
echo Set wshShell = CreateObject("WScript.Shell"^)
echo origBpm = CDbl(%ORIG_BPM%^)
echo tempo = Round(165.0 / origBpm, 2^)
echo strTempo = Replace(CStr(tempo^), ",", "."^)
echo Set fso = CreateObject("Scripting.FileSystemObject"^)
echo Set folder = fso.GetFolder("temp_download"^)
echo For Each file In folder.Files
echo   If LCase(fso.GetExtensionName(file.Name^)^) = "mp3" Then
echo     cmd = "ffmpeg.exe -y -i """ ^& file.Path ^& """ -filter:a ""atempo=" ^& strTempo ^& """ -vn ""songs\" ^& file.Name ^& """"
echo     wshShell.Run cmd, 1, True
echo   End If
echo Next
) > run_convert.vbs

cscript //nologo run_convert.vbs
if exist run_convert.vbs del run_convert.vbs

echo.
echo Conversion finished!

:UPDATE_LIST
if exist temp_download rmdir /s /q temp_download

echo.
echo [4/4] Updating playlist.js...

echo const playlist = [ > playlist.js
for %%f in (songs\*.mp3) do (
    echo   "songs/%%~nxf", >> playlist.js
)
echo ]; >> playlist.js

echo.
echo ===================================================
echo ✅ Done with this song!
echo ===================================================
echo.
pause
goto LOOP

:END
echo.
echo Bye! Opening GitHub Desktop step next...
cmd /k