# ===================================================================
# ||  Script 1: Scoop & Application Installer                      ||
# ||  >> This script DOES NOT require Administrator privileges. <<   ||
# ===================================================================

Write-Host "Starting Application and Wallpaper Setup..." -ForegroundColor Magenta

# --- [ Section 1: Scoop Package Manager Setup ] ---
Write-Host "`n[1/3] Checking and installing Scoop Package Manager..." -ForegroundColor Cyan
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "  - Scoop is already installed. Skipping installation." -ForegroundColor Green
} else {
    Write-Host "  - Scoop not found. Installing now..." -ForegroundColor Yellow
    # Set execution policy for the current user only
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    # Install Scoop
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    Write-Host "  - Scoop installation complete." -ForegroundColor Green
}
# Add the 'extras' bucket for more apps
Write-Host "  - Adding the Scoop 'extras' bucket..."
scoop bucket add extras | Out-Null
scoop bucket add games | Out-Null


# --- [ Section 2: Application Installation ] ---
Write-Host "`n[2/3] Installing all requested applications via Scoop..." -ForegroundColor Cyan
# List of apps to install
$apps = "git", "python", "vscode", "vlc", "brave", "translucenttb", "powertoys", "heroic-games-launcher", "tinynvidiaupdatechecker"

try {
    scoop install $apps
    Write-Host "  - All applications installed successfully." -ForegroundColor Green
} catch {
    Write-Warning "  - Could not install one or more applications. Please check for errors above."
}


# --- [ Section 3: Wallpaper Setup ] ---
Write-Host "`n[3/3] Downloading and setting desktop wallpaper..." -ForegroundColor Cyan
$imageUrl = "https://raw.githubusercontent.com/BitterSweetcandyshop/wallpapers/main/unixporn_wallpapers/Jellyfish-2BEF7.png"
$picturesPath = [Environment]::GetFolderPath("MyPictures")
$wallpaperPath = Join-Path -Path $picturesPath -ChildPath "desktop_wallpaper.jpg"

try {
    # Download the image
    Invoke-WebRequest -Uri $imageUrl -OutFile $wallpaperPath
    Write-Host "  - Wallpaper downloaded successfully." -ForegroundColor Green

    # Use C# code to call the Windows API to set the wallpaper
    $code = @"
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        public static void SetWallpaper(string path) {
            SystemParametersInfo(20, 0, path, 0x01 | 0x02); // SPI_SETDESKWALLPAPER
        }
    }
"@
    Add-Type -TypeDefinition $code
    [Wallpaper]::SetWallpaper($wallpaperPath)
    Write-Host "  - Wallpaper has been set successfully!" -ForegroundColor Green
} catch {
    Write-Host "  - Error: Failed to download or set the wallpaper." -ForegroundColor Red
}

Write-Host "`nAll user-level tasks are complete!" -ForegroundColor Magenta
