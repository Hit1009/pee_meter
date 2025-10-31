// Service Worker for iOS PWA Offline Support
const CACHE_NAME = 'pee-meter-v1';
const RUNTIME_CACHE = 'pee-meter-runtime-v1';

// Assets to cache on install
const PRECACHE_ASSETS = [
  './',
  './index.html',
  './main.dart.js',
  './flutter.js',
  './flutter_bootstrap.js',
  './manifest.json',
  './icons/Icon-192.png',
  './icons/Icon-512.png',
  './icons/Icon-maskable-192.png',
  './icons/Icon-maskable-512.png',
  './favicon.png'
];

// Install event - cache critical assets
self.addEventListener('install', (event) => {
  console.log('[SW] Installing service worker...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[SW] Precaching assets');
        return cache.addAll(PRECACHE_ASSETS.map(url => new Request(url, {
          cache: 'reload'
        })));
      })
      .then(() => {
        console.log('[SW] Skip waiting');
        return self.skipWaiting();
      })
      .catch((error) => {
        console.error('[SW] Precache error:', error);
      })
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('[SW] Activating service worker...');
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME && cacheName !== RUNTIME_CACHE) {
            console.log('[SW] Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => {
      console.log('[SW] Claiming clients');
      return self.clients.claim();
    })
  );
});

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Skip non-GET requests
  if (request.method !== 'GET') {
    return;
  }

  // Skip chrome extensions
  if (url.protocol === 'chrome-extension:') {
    return;
  }

  // Network first for API calls
  if (url.pathname.includes('/api/')) {
    event.respondWith(networkFirst(request));
    return;
  }

  // Cache first for static assets
  event.respondWith(cacheFirst(request));
});

// Cache-first strategy with network fallback
async function cacheFirst(request) {
  const cache = await caches.open(CACHE_NAME);
  const cached = await cache.match(request);
  
  if (cached) {
    console.log('[SW] Serving from cache:', request.url);
    return cached;
  }

  try {
    const response = await fetch(request);
    
    // Cache successful responses
    if (response && response.status === 200) {
      const responseClone = response.clone();
      caches.open(RUNTIME_CACHE).then((cache) => {
        cache.put(request, responseClone);
      });
    }
    
    return response;
  } catch (error) {
    console.error('[SW] Fetch failed:', error);
    
    // Try runtime cache
    const runtimeCache = await caches.open(RUNTIME_CACHE);
    const runtimeCached = await runtimeCache.match(request);
    
    if (runtimeCached) {
      return runtimeCached;
    }

    // Return offline page for HTML requests
    if (request.headers.get('accept').includes('text/html')) {
      const offlineCache = await caches.open(CACHE_NAME);
      return offlineCache.match('./index.html');
    }
    
    throw error;
  }
}

// Network-first strategy with cache fallback
async function networkFirst(request) {
  try {
    const response = await fetch(request);
    
    // Cache successful responses
    if (response && response.status === 200) {
      const responseClone = response.clone();
      caches.open(RUNTIME_CACHE).then((cache) => {
        cache.put(request, responseClone);
      });
    }
    
    return response;
  } catch (error) {
    console.error('[SW] Network request failed:', error);
    
    // Fallback to cache
    const cache = await caches.open(RUNTIME_CACHE);
    const cached = await cache.match(request);
    
    if (cached) {
      return cached;
    }
    
    throw error;
  }
}

// Handle messages from clients
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
  
  if (event.data && event.data.type === 'CACHE_URLS') {
    const urls = event.data.urls || [];
    caches.open(RUNTIME_CACHE).then((cache) => {
      cache.addAll(urls);
    });
  }
});
