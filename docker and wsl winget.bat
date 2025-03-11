@echo off
:: Run as Administrator Check
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo This script must be run as Administrator!
    pause
    exit /b
)

echo Enabling Windows Subsystem for Linux (WSL)...
wsl --install -d Ubuntu

echo Setting WSL 2 as the default version...
wsl --set-default-version 2

echo Installing Docker Desktop via Winget...
winget install --id Docker.DockerDesktop -e --silent

echo Installation complete! Restarting the PC in 10 seconds...
timeout /t 10 /nobreak
shutdown /r /t 0
