# Deploy to GitHub Pages Script
# Run this from the project root

Write-Host "🚀 Deploying Pee Meter to GitHub Pages..." -ForegroundColor Cyan
Write-Host ""

# Check if build exists
if (-Not (Test-Path "build\web")) {
    Write-Host "❌ Build folder not found. Building app..." -ForegroundColor Yellow
    flutter build web --release --base-href /pee_meter/
} else {
    Write-Host "✅ Build folder found!" -ForegroundColor Green
}

Write-Host ""
Write-Host "📦 Preparing deployment..." -ForegroundColor Cyan

# Check current branch
$currentBranch = git branch --show-current
Write-Host "Current branch: $currentBranch" -ForegroundColor Yellow

# Stash any changes
Write-Host "Stashing any uncommitted changes..." -ForegroundColor Yellow
git stash

# Create or switch to gh-pages branch
$ghPagesBranch = git branch --list gh-pages
if ($ghPagesBranch) {
    Write-Host "Switching to gh-pages branch..." -ForegroundColor Yellow
    git checkout gh-pages
} else {
    Write-Host "Creating gh-pages branch..." -ForegroundColor Yellow
    git checkout --orphan gh-pages
}

# Clear branch (keep .git)
Write-Host "Clearing branch..." -ForegroundColor Yellow
Get-ChildItem -Exclude .git | Remove-Item -Recurse -Force

# Copy build files
Write-Host "Copying build files..." -ForegroundColor Yellow
git checkout $currentBranch -- build/web
Copy-Item -Path "build\web\*" -Destination "." -Recurse -Force
Remove-Item -Path "build" -Recurse -Force

# Create .nojekyll file (important for GitHub Pages)
New-Item -Path ".nojekyll" -ItemType File -Force | Out-Null

# Commit and push
Write-Host "Committing changes..." -ForegroundColor Yellow
git add .
git commit -m "Deploy PWA to GitHub Pages - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

Write-Host ""
Write-Host "📤 Pushing to GitHub..." -ForegroundColor Cyan
git push origin gh-pages --force

# Switch back to original branch
Write-Host ""
Write-Host "🔄 Switching back to $currentBranch..." -ForegroundColor Yellow
git checkout $currentBranch

# Restore stashed changes
$stashList = git stash list
if ($stashList) {
    Write-Host "Restoring stashed changes..." -ForegroundColor Yellow
    git stash pop
}

Write-Host ""
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Your app should be available at:" -ForegroundColor Cyan
Write-Host "   https://hit1009.github.io/pee_meter/" -ForegroundColor Yellow
Write-Host ""
Write-Host "⚙️  Configure GitHub Pages:" -ForegroundColor Cyan
Write-Host "   1. Go to: https://github.com/Hit1009/pee_meter/settings/pages" -ForegroundColor White
Write-Host "   2. Set Source to 'Deploy from a branch'" -ForegroundColor White
Write-Host "   3. Select branch: gh-pages" -ForegroundColor White
Write-Host "   4. Select folder: / (root)" -ForegroundColor White
Write-Host "   5. Click Save" -ForegroundColor White
Write-Host ""
Write-Host "⏱️  It may take a few minutes for the site to be live." -ForegroundColor Yellow
