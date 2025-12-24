# Vibe Coding Setup Script for Windows
# Run this with: Right-click > Run with PowerShell
# Or open PowerShell as Admin and run: .\setup-vibe-coding.ps1

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Vibe Coding Setup - Sandbox Web" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will install:" -ForegroundColor Yellow
Write-Host "  - VS Code"
Write-Host "  - Git"
Write-Host "  - Node.js"
Write-Host "  - Claude Code"
Write-Host ""
Write-Host "Grab a coffee - this takes about 5 minutes." -ForegroundColor Yellow
Write-Host ""

# Create temp directory for downloads
$tempDir = "$env:TEMP\vibe-coding-setup"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

# Function to check if a command exists
function Test-Command($command) {
    try {
        if (Get-Command $command -ErrorAction Stop) {
            return $true
        }
    } catch {
        return $false
    }
}

# Function to refresh environment variables
function Update-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# ============================================
# STEP 1: Install VS Code
# ============================================
Write-Host "[1/4] Checking VS Code..." -ForegroundColor Green

if (Test-Command "code") {
    Write-Host "  VS Code is already installed. Skipping." -ForegroundColor Gray
} else {
    Write-Host "  Downloading VS Code..." -ForegroundColor Gray
    $vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
    $vscodeInstaller = "$tempDir\vscode-installer.exe"
    
    Invoke-WebRequest -Uri $vscodeUrl -OutFile $vscodeInstaller -UseBasicParsing
    
    Write-Host "  Installing VS Code (this may take a minute)..." -ForegroundColor Gray
    Start-Process -FilePath $vscodeInstaller -ArgumentList "/VERYSILENT /MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,addtopath" -Wait
    
    Update-Path
    Write-Host "  VS Code installed!" -ForegroundColor Green
}

# ============================================
# STEP 2: Install Git
# ============================================
Write-Host "[2/4] Checking Git..." -ForegroundColor Green

if (Test-Command "git") {
    Write-Host "  Git is already installed. Skipping." -ForegroundColor Gray
} else {
    Write-Host "  Downloading Git..." -ForegroundColor Gray
    
    # Get latest Git version
    $gitReleasesUrl = "https://api.github.com/repos/git-for-windows/git/releases/latest"
    $gitRelease = Invoke-RestMethod -Uri $gitReleasesUrl -UseBasicParsing
    $gitAsset = $gitRelease.assets | Where-Object { $_.name -match "64-bit\.exe$" -and $_.name -notmatch "portable" } | Select-Object -First 1
    $gitUrl = $gitAsset.browser_download_url
    $gitInstaller = "$tempDir\git-installer.exe"
    
    Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller -UseBasicParsing
    
    Write-Host "  Installing Git (this may take a minute)..." -ForegroundColor Gray
    Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT /NORESTART" -Wait
    
    Update-Path
    Write-Host "  Git installed!" -ForegroundColor Green
}

# ============================================
# STEP 3: Install Node.js
# ============================================
Write-Host "[3/4] Checking Node.js..." -ForegroundColor Green

if (Test-Command "node") {
    Write-Host "  Node.js is already installed. Skipping." -ForegroundColor Gray
} else {
    Write-Host "  Downloading Node.js LTS..." -ForegroundColor Gray
    $nodeUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi"
    $nodeInstaller = "$tempDir\node-installer.msi"
    
    Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstaller -UseBasicParsing
    
    Write-Host "  Installing Node.js (this may take a minute)..." -ForegroundColor Gray
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$nodeInstaller`" /quiet /norestart" -Wait
    
    Update-Path
    Write-Host "  Node.js installed!" -ForegroundColor Green
}

# ============================================
# STEP 4: Install Claude Code
# ============================================
Write-Host "[4/4] Installing Claude Code..." -ForegroundColor Green

# Refresh path one more time to ensure npm is available
Update-Path

# Check if npm is available
if (-not (Test-Command "npm")) {
    Write-Host "  ERROR: npm not found. Please restart your computer and run this script again." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Install Claude Code globally
npm install -g @anthropic-ai/claude-code 2>&1 | Out-Null

if (Test-Command "claude") {
    Write-Host "  Claude Code installed!" -ForegroundColor Green
} else {
    Write-Host "  Claude Code installed (you may need to restart your terminal)" -ForegroundColor Yellow
}

# ============================================
# CLEANUP
# ============================================
Write-Host ""
Write-Host "Cleaning up temporary files..." -ForegroundColor Gray
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# ============================================
# DONE - Launch VS Code
# ============================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. VS Code is about to open" -ForegroundColor White
Write-Host "  2. Open the terminal: View > Terminal (or press Ctrl+`)" -ForegroundColor White
Write-Host "  3. Type: claude" -ForegroundColor White
Write-Host "  4. Log in when the browser opens" -ForegroundColor White
Write-Host "  5. Start vibing!" -ForegroundColor White
Write-Host ""
Write-Host "Launching VS Code in 3 seconds..." -ForegroundColor Green
Start-Sleep -Seconds 3

# Launch VS Code
Start-Process "code"

Write-Host ""
Write-Host "Happy vibe coding! - Sandbox Web" -ForegroundColor Cyan
Write-Host ""
