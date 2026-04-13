@echo off
setlocal enabledelayedexpansion
set "ZIP_URL=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl-shared.zip"
set "ZIP_FILE=ffmpeg-latest.zip"
set "TEMP=ffmpeg_temp"
for /f "delims=" %%D in ('powershell -NoProfile -Command "(Get-Date).ToString('yyyy-MM-dd')"') do set "TODAY=%%D"
set "DL=1"
if exist "%ZIP_FILE%" (
    for /f "delims=" %%D in ('powershell -NoProfile -Command "(Get-Item '%ZIP_FILE%').LastWriteTime.ToString('yyyy-MM-dd')"') do set "ZIP_DATE=%%D"
    echo Existing ZIP date = !ZIP_DATE!
    if "!ZIP_DATE!"=="!TODAY!" (
        echo ZIP is current. Skipping download and extraction.
        set "DL=0"
    ) else (
        echo ZIP outdated. Deleting old file.
        del /f /q "%ZIP_FILE%"
    )
)
if "!DL!"=="1" (
    echo Downloading FFmpeg...
    curl -# -L "%ZIP_URL%" -o "%ZIP_FILE%" --retry 3 --retry-delay 5 --max-time 180
)
if "!DL!"=="1" (
    if exist "%TEMP%" rd /s /q "%TEMP%"
    powershell -NoProfile -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%TEMP%' -Force"
    for /d %%d in ("%TEMP%\*") do set "BIN=%%d\bin"
    if exist "!BIN!" xcopy /y /q "!BIN!\*" "%cd%\"
    rd /s /q "%TEMP%" 2>nul
)
echo FFmpeg update completed.
timeout /t 3 >nul