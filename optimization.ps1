# ==========================================================================
# ||  Script 2: Windows System Optimizer                                  ||
# ||  >> This script REQUIRES and will ask for Administrator privileges. << ||
# ==========================================================================

# --- Administrator Check & Elevation ---
# Check if the current session has admin rights.
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # If not, display a message and re-launch the script as an Administrator.
    Write-Warning "Administrator privileges are required for system optimization."
    Write-Host "Attempting to re-launch with an Administrator prompt..."
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit", "-File", $PSCommandPath
    exit
}

# If we are here, we have admin rights.
Write-Host "Administrator permissions granted. Starting system optimization..." -ForegroundColor Magenta
Write-Host "It is HIGHLY RECOMMENDED to create a System Restore Point before continuing." -ForegroundColor Yellow
Read-Host "Press Enter to begin the optimization process..."

# --- [ Section 1: Performance Enhancements ] ---
Write-Host "`n[1/4] Applying maximum performance tweaks..." -ForegroundColor Cyan
Write-Host "  - Activating Ultimate Performance power plan..."
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
$ultimatePerformanceGUID = (powercfg /list | Select-String "Ultimate Performance").ToString().Split(" ")[3]
if ($ultimatePerformanceGUID) { powercfg /setactive $ultimatePerformanceGUID } else { powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c }
Write-Host "  - Disabling mouse acceleration..."
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0"; Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0"; Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0"
Write-Host "  - Disabling unnecessary visual effects..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2

# --- [ Section 2: Privacy & Telemetry Disabling ] ---
Write-Host "`n[2/4] Disabling telemetry and tracking..." -ForegroundColor Cyan
Write-Host "  - Disabling telemetry services..."
Get-Service DiagTrack | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue; Get-Service dmwappushservice | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
Write-Host "  - Disabling telemetry & Recall via registry..."
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null; Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" -Force | Out-Null; Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" -Name "DisableAIDataAnalysis" -Value 1 -Type DWord -Force
Write-Host "  - Disabling global location tracking..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocation" -Value 1 -Type DWord -Force

# --- [ Section 3: Debloating and System Cleanup ] ---
Write-Host "`n[3/4] Debloating and cleaning up the system..." -ForegroundColor Cyan
Write-Host "  - Reducing Microsoft Edge & Brave background activity..."
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force | Out-Null; Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "StartupBoostEnabled" -Value 0 -Type DWord -Force; Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
New-Item -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Force | Out-Null; Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave" -Name "BackgroundModeEnabled" -Value 0 -Type DWord -Force
Write-Host "  - Disabling Bing search in Start Menu..."
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force | Out-Null; Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord -Force
Write-Host "  - Starting automated Disk Cleanup..."
Start-Process cleanmgr.exe -ArgumentList "/autoclean" -Wait -NoNewWindow -ErrorAction SilentlyContinue

# --- [ Section 4: UI and UX Customizations ] ---
Write-Host "`n[4/4] Applying UI customizations..." -ForegroundColor Cyan
Write-Host "  - Enabling system-wide dark theme..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Type DWord -Force; Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -Type DWord -Force
Write-Host "  - Enabling detailed Blue Screen of Death (BSOD) information..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -Name "DisplayParameters" -Value 1 -Type DWord -Force
Write-Host "  - Enabling 'Show file extensions'..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Type DWord -Force

# --- [ Completion ] ---
Write-Host "`nScript has finished!" -ForegroundColor Magenta
Write-Host "------------------------------------------------------------------" -ForegroundColor Magenta
Write-Host "All optimization tasks have been applied." -ForegroundColor Green
Write-Host "A system restart is required for all changes to take full effect." -ForegroundColor Yellow
Read-Host "Press Enter to exit..."
