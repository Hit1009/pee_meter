# Quick Start Script for Testing PWA Locally
# Run this from PowerShell

Write-Host "🚀 Starting Pee Meter PWA..." -ForegroundColor Cyan
Write-Host ""

# Check if build exists
if (-Not (Test-Path "build\web")) {
    Write-Host "❌ Build folder not found. Building app..." -ForegroundColor Yellow
    flutter build web --release --pwa-strategy=offline-first
}

Write-Host "✅ Build found!" -ForegroundColor Green
Write-Host ""

# Get local IP address
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -like "192.168.*"}).IPAddress

Write-Host "📱 To test on iOS device:" -ForegroundColor Cyan
Write-Host "1. Make sure your iOS device is on the same WiFi network" -ForegroundColor White
Write-Host "2. Open Safari on your iOS device" -ForegroundColor White
Write-Host "3. Navigate to: http://$localIP:8080" -ForegroundColor Yellow
Write-Host ""
Write-Host "💻 To test on this computer:" -ForegroundColor Cyan
Write-Host "Navigate to: http://localhost:8080" -ForegroundColor Yellow
Write-Host ""
Write-Host "🌐 Starting server..." -ForegroundColor Green
Write-Host ""

# Start Python HTTP server
Set-Location "build\web"
python -m http.server 8080
