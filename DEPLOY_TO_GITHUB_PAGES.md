# 🍎 Deploy to GitHub Pages for iOS PWA

## The iOS Safari Issue

iOS Safari requires PWAs to be at a **root domain** to work properly with "Add to Home Screen".

❌ **Doesn't work well on iOS**: `https://hit1009.github.io/pee_meter/`  
✅ **Works on iOS**: `https://hit1009.github.io/`

## Solution: Deploy to Your User Site

GitHub gives every user a root domain site at: `https://yourusername.github.io/`

### Option 1: Deploy to https://hit1009.github.io/ (Recommended)

This will make your Pee Meter app the main site at your root GitHub Pages domain.

**Steps:**

1. **Rename this repository to `hit1009.github.io`** (or create a new one with that name)
   - Go to: https://github.com/Hit1009/pee_meter/settings
   - Scroll to "Repository name"
   - Change to: `Hit1009.github.io` (case-insensitive)
   - Click "Rename"

2. **Update the remote URL** (if you renamed):
   ```powershell
   git remote set-url origin https://github.com/Hit1009/Hit1009.github.io.git
   ```

3. **Deploy using the script**:
   ```powershell
   .\deploy-github-pages.ps1
   ```

4. **Enable GitHub Pages**:
   - Go to: https://github.com/Hit1009/Hit1009.github.io/settings/pages
   - Source: "Deploy from a branch"
   - Branch: "gh-pages"
   - Folder: "/ (root)"
   - Click "Save"

5. **Your PWA will be at**: `https://hit1009.github.io/`

### Option 2: Add a Custom Domain (Alternative)

If you don't want to use your user site, you can:

1. Buy a domain (e.g., `peemeter.com` from Namecheap, Google Domains)
2. Configure GitHub Pages with custom domain:
   - Settings > Pages > Custom domain
   - Enter your domain
   - Follow DNS setup instructions
3. Your PWA will work at: `https://peemeter.com/`

## Quick Deploy Now

If you renamed the repo or want to use your current setup:

```powershell
# Make sure changes are committed
git add .
git commit -m "Configure for iOS PWA deployment"

# Push to main (triggers GitHub Actions)
git push origin main

# Or use the manual deploy script
.\deploy-github-pages.ps1
```

Then enable GitHub Pages in repository settings!

## Testing on iOS

Once deployed:
1. Open `https://hit1009.github.io/` in Safari
2. Tap Share → Add to Home Screen
3. It works! 🎉

---

**Recommendation**: Rename your repository to `Hit1009.github.io` for the best iOS PWA experience without needing a custom domain!
