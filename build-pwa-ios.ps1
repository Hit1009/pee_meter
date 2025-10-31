# Build and Deploy PWA with iOS Offline Support
# This script builds the Flutter web app and ensures all PWA files are included

Write-Host "🚀 Building Pee Meter PWA with iOS Offline Support..." -ForegroundColor Cyan

# Build the Flutter web app
Write-Host "`n📦 Building Flutter web app..." -ForegroundColor Yellow
flutter build web --release

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

# Copy custom service worker to build directory
Write-Host "`n📋 Copying custom service worker..." -ForegroundColor Yellow
Copy-Item "web\sw.js" -Destination "build\web\sw.js" -Force

# Verify important PWA files exist
Write-Host "`n✅ Verifying PWA files..." -ForegroundColor Yellow
$pwaFiles = @(
    "build\web\index.html",
    "build\web\manifest.json",
    "build\web\sw.js",
    "build\web\icons\Icon-192.png",
    "build\web\icons\Icon-512.png"
)

$allFilesExist = $true
foreach ($file in $pwaFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file (missing!)" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if ($allFilesExist) {
    Write-Host "`n✨ Build complete! Your PWA is ready for deployment." -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "  1. Deploy the 'build/web' folder to your hosting service" -ForegroundColor White
    Write-Host "  2. Ensure your site uses HTTPS (required for PWAs)" -ForegroundColor White
    Write-Host "  3. Test on iOS: Open in Safari > Share > Add to Home Screen" -ForegroundColor White
    Write-Host "  4. Test offline: Enable Airplane Mode and reopen the app" -ForegroundColor White
    Write-Host "`n📖 See IOS_OFFLINE_PWA_GUIDE.md for detailed instructions" -ForegroundColor Yellow
} else {
    Write-Host "`n⚠️  Some PWA files are missing. Please check the build output." -ForegroundColor Red
    exit 1
}

# Option to deploy to GitHub Pages
Write-Host "`n❓ Deploy to GitHub Pages now? (y/n): " -ForegroundColor Cyan -NoNewline
$response = Read-Host

if ($response -eq 'y' -or $response -eq 'Y') {
    Write-Host "`n🌐 Deploying to GitHub Pages..." -ForegroundColor Yellow
    .\deploy-github-pages.ps1
}
