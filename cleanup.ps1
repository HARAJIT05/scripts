# Run as Administrator
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator!"
    Exit
}

Write-Host "Starting C Drive Cleanup..." -ForegroundColor Cyan

# 1️⃣ Clear Windows Temp Files
Write-Host "Cleaning Windows Temp files..."
Remove-Item -Recurse -Force "C:\Windows\Temp\*" -ErrorAction SilentlyContinue

# 2️⃣ Clear User Temp Files
Write-Host "Cleaning User Temp files..."
Remove-Item -Recurse -Force "$env:TEMP\*" -ErrorAction SilentlyContinue

# 3️⃣ Empty Recycle Bin
Write-Host "Emptying Recycle Bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# 4️⃣ Delete Windows Update Cache
Write-Host "Cleaning Windows Update cache..."
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "C:\Windows\SoftwareDistribution\Download\*" -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue

# 5️⃣ Clear Browser Cache (Edge, Chrome, Firefox)
Write-Host "Cleaning browser cache..."

# Microsoft Edge
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -ErrorAction SilentlyContinue

# Google Chrome
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -ErrorAction SilentlyContinue

# Mozilla Firefox
Remove-Item -Recurse -Force "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release\cache2\entries\*" -ErrorAction SilentlyContinue

# 6️⃣ Remove Prefetch Files (Safe)
Write-Host "Cleaning Prefetch files..."
Remove-Item -Recurse -Force "C:\Windows\Prefetch\*" -ErrorAction SilentlyContinue

# 7️⃣ Run Windows Disk Cleanup (Silent)
Write-Host "Running Windows Disk Cleanup..."
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait

# 8️⃣ Clear Event Logs (Optional)
Write-Host "Clearing Event Logs..."
wevtutil el | ForEach-Object { wevtutil cl "$_" } 2>$null

Write-Host "✅ C Drive Cleanup Complete! Restart recommended." -ForegroundColor Green
