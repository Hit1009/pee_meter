# iOS Offline PWA Guide

This guide explains how to make your Pee Meter PWA work offline on iOS devices.

## ✅ What's Been Implemented

### 1. Custom Service Worker (`sw.js`)
- **Cache-first strategy**: Serves cached content immediately for fast offline access
- **Network fallback**: Attempts to fetch from network and updates cache
- **Runtime caching**: Dynamically caches resources as they're accessed
- **iOS-compatible caching**: Properly handles iOS Safari's service worker limitations

### 2. Enhanced Manifest (`manifest.json`)
- Added `display_override` for better iOS standalone support
- Multiple icon sizes including iOS-specific 180x180
- Proper scope and start URL configuration

### 3. Updated Index.html
- Registers custom service worker with iOS-specific configurations
- Periodic service worker updates (important for iOS)
- Network status monitoring with visual feedback
- iOS standalone mode detection
- Prevents iOS pull-to-refresh in PWA mode
- Safe area support for notch devices

## 🚀 How to Build and Deploy

### Step 1: Build the Flutter Web App
```powershell
# Navigate to your project directory
cd c:\Users\hitar\Downloads\pee-meter\pee_meter

# Build for web with PWA support
flutter build web --release --web-renderer canvaskit
```

### Step 2: Deploy to Your Hosting
Deploy the contents of `build/web` to your hosting service:

**GitHub Pages:**
```powershell
.\deploy-github-pages.ps1
```

**Netlify/Vercel:**
- Upload the `build/web` folder via their UI
- Or use their CLI tools

### Step 3: Test on iOS

#### Installing the PWA on iOS:
1. Open Safari on your iPhone/iPad
2. Navigate to your deployed website (must be HTTPS)
3. Tap the Share button (square with arrow)
4. Scroll down and tap "Add to Home Screen"
5. Name it "Pee Meter" and tap "Add"
6. The app icon will appear on your home screen

#### Testing Offline Mode:
1. Open the PWA from your home screen
2. Use the app normally (increment count, check timestamps)
3. Enable Airplane Mode or turn off WiFi
4. Close and reopen the app - it should still work!
5. The app will show "Offline Mode" banner when offline
6. All your data is stored locally and will sync when back online

## 📱 iOS-Specific Features

### Data Persistence
- Uses `shared_preferences` which stores data in iOS's UserDefaults
- Data persists even when offline
- No internet connection required for core functionality

### Offline Capabilities
- Full app functionality works offline
- UI loads instantly from cache
- No network requests needed after first load
- Updates cache automatically when online

### Visual Indicators
- Orange "Offline Mode" banner appears when offline
- Automatic detection of network status
- Smooth transitions between online/offline states

## 🔍 Testing Checklist

- [ ] Install PWA on iOS home screen
- [ ] Open app while online - verify it works
- [ ] Turn on Airplane Mode
- [ ] Close app completely (swipe up from app switcher)
- [ ] Reopen app - should load instantly
- [ ] Verify offline banner appears
- [ ] Test incrementing count - should work offline
- [ ] Check recent timestamps - should display
- [ ] Turn off Airplane Mode
- [ ] Offline banner should disappear
- [ ] App continues working normally

## 🛠️ Troubleshooting

### PWA Not Installing
- Ensure you're using HTTPS (required for PWAs)
- Clear Safari cache and try again
- Make sure manifest.json is accessible

### Offline Mode Not Working
- Check Service Worker registration in Safari Developer Tools
- Ensure sw.js is being served from the root directory
- Verify HTTPS is being used (Service Workers require HTTPS)

### Data Not Persisting
- Check iOS Settings > Safari > Advanced > Website Data
- Ensure "Prevent Cross-Site Tracking" isn't blocking storage
- Verify shared_preferences plugin is properly configured

### App Not Updating
- The service worker checks for updates every minute
- Force update by clearing website data in iOS Settings
- Reinstall the PWA if needed

## 🔧 Advanced Configuration

### Adjusting Cache Strategy
Edit `sw.js` to customize caching behavior:
- `CACHE_NAME`: Main cache version (increment to force refresh)
- `PRECACHE_ASSETS`: Assets cached during installation
- Cache strategies: `cacheFirst()` or `networkFirst()`

### Customizing Offline Behavior
Edit the service worker fetch event handler to:
- Add more sophisticated caching rules
- Implement custom offline pages
- Cache API responses selectively

## 📊 Performance Tips

1. **Keep Cache Small**: Only cache essential assets
2. **Use Cache Versioning**: Increment version numbers when updating
3. **Monitor Cache Size**: iOS has storage limits (~50MB for PWAs)
4. **Test on Real Devices**: iOS simulator doesn't fully support PWAs

## 🎯 iOS Limitations to Know

- Service Workers have limited background activity
- Push notifications not supported via web APIs
- Some iOS versions may have PWA bugs
- Storage can be cleared by iOS if device is low on space
- Must use Safari to install (Chrome/Firefox won't work)

## 📝 Next Steps

1. Test thoroughly on real iOS devices
2. Monitor user feedback about offline experience
3. Consider adding offline sync queue for future API calls
4. Implement update notifications for new app versions

---

**Need Help?** Check Safari's Developer Console for service worker logs and errors.
