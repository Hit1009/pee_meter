# Pee Meter - Progressive Web App (PWA) for iOS

Your Flutter app has been configured as a Progressive Web App optimized for iOS! 🎉

## What's Been Configured

### 1. **Web Manifest** (`web/manifest.json`)
- ✅ Proper name and description
- ✅ Icons configured for iOS (192x192, 512x512, maskable)
- ✅ Standalone display mode
- ✅ Theme colors and orientation settings

### 2. **iOS-Optimized HTML** (`web/index.html`)
- ✅ Apple-specific meta tags for PWA support
- ✅ Multiple icon sizes for iOS home screen
- ✅ Status bar styling (black-translucent)
- ✅ Viewport configuration to prevent zoom
- ✅ Loading indicator while app initializes
- ✅ Service Worker registration
- ✅ iOS overscroll prevention

### 3. **Flutter App** (`lib/main.dart`)
- ✅ Path-based URL strategy (removes # from URLs)
- ✅ Web platform detection
- ✅ Optimized for mobile web with adaptive density

### 4. **PWA Build**
- ✅ Built with offline-first strategy
- ✅ Service worker automatically generated
- ✅ Assets optimized and tree-shaken

## Deployment Options

### Option 1: Firebase Hosting (Recommended)
```powershell
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
cd c:\Users\hitar\Downloads\pee-meter\pee_meter
firebase init hosting

# Select or create a project
# Set 'build/web' as your public directory
# Configure as single-page app: Yes
# Don't overwrite index.html

# Deploy
firebase deploy --only hosting
```

### Option 2: Netlify
1. Sign up at https://netlify.com
2. Drag and drop the `build/web` folder to Netlify
3. Configure redirects for SPA:
   - Create `build/web/_redirects` file with: `/* /index.html 200`

### Option 3: GitHub Pages

#### Method A: Using GitHub Actions (Recommended)
1. Create `.github/workflows/deploy.yml` in your project root
2. Push your code to GitHub
3. GitHub Actions will automatically build and deploy

```yaml
# .github/workflows/deploy.yml
name: Deploy Flutter Web to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build web
        run: flutter build web --release --pwa-strategy=offline-first --base-href /pee_meter/
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

#### Method B: Manual Deployment
```powershell
# From project root
git checkout -b gh-pages
git rm -rf .
git checkout main -- build/web
mv build/web/* .
rm -rf build
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages --force
git checkout main
```

Then enable GitHub Pages in your repository settings:
1. Go to Settings > Pages
2. Select `gh-pages` branch as source
3. Your app will be available at: https://hit1009.github.io/pee_meter/

### Option 4: Vercel
```powershell
# Install Vercel CLI
npm install -g vercel

# Deploy
cd build/web
vercel --prod
```

## Installing on iOS as PWA

Once deployed, users can install your app on iOS:

1. **Open in Safari** (must use Safari, not Chrome)
2. Tap the **Share** button (square with arrow)
3. Scroll down and tap **"Add to Home Screen"**
4. Customize the name if desired
5. Tap **"Add"**

The app will now appear on the home screen like a native app!

## iOS PWA Features

✅ **Works Offline** - Service worker caches assets
✅ **Home Screen Icon** - Installs like a native app
✅ **Full Screen** - Runs without Safari UI
✅ **Splash Screen** - Professional launch experience
✅ **Status Bar Control** - Integrated with iOS status bar
✅ **No Bounce Effect** - Disabled overscroll for native feel
✅ **Local Storage** - Data persists using SharedPreferences

## Important Notes for iOS PWA

### Requirements:
- iOS 11.3+ required for PWA support
- Must be accessed via Safari browser initially
- HTTPS required (except localhost for testing)

### Limitations on iOS:
- No push notifications (iOS limitation)
- No background sync (iOS limitation)
- Must be opened from home screen for full PWA experience
- Service worker has limited storage (50MB)

### Server Configuration:
If using path-based URLs (no #), ensure your server redirects all routes to index.html:

**Firebase (firebase.json):**
```json
{
  "hosting": {
    "public": "build/web",
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

**Nginx:**
```nginx
location / {
    try_files $uri /index.html;
}
```

**Apache (.htaccess):**
```apache
RewriteEngine On
RewriteBase /
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]
```

## Testing Locally

To test your PWA locally:

```powershell
# Serve the built web app
cd build/web
python -m http.server 8000

# Or use dhttpd (Dart HTTP server)
dart pub global activate dhttpd
dhttpd --path build/web --port 8080
```

Then open: http://localhost:8000 in Safari on your iOS device (use your computer's local IP)

## Rebuilding

Whenever you make changes:

```powershell
# Rebuild the web app
flutter build web --release --pwa-strategy=offline-first
```

## Troubleshooting

### PWA not installing on iOS?
- Make sure you're using Safari (not Chrome)
- Ensure HTTPS is enabled (required for PWA)
- Clear Safari cache and try again

### Service Worker not updating?
- Hard refresh: Shift + Reload in browser
- Clear browser cache
- Increment version in manifest.json

### Icons not showing?
- Verify icons exist in `web/icons/` folder
- Check icon paths in manifest.json
- iOS caches icons - try clearing home screen cache

## Next Steps

1. **Customize Icons**: Replace icons in `web/icons/` with your own
2. **Add Splash Screens**: Create iOS-specific splash screen images
3. **Test Thoroughly**: Test on various iOS devices and versions
4. **Monitor Performance**: Use Lighthouse to audit PWA score
5. **Deploy**: Choose a hosting provider and deploy!

## Resources

- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [PWA on iOS](https://developer.apple.com/documentation/webkit/supporting_web_apps_on_ios)
- [Web App Manifest](https://web.dev/add-manifest/)
- [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers)

---

Built with ❤️ using Flutter
