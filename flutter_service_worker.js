'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "f1aa181ba8ee3621dcd3ad02dc1c87f9",
"assets/AssetManifest.bin.json": "f3209c276725a945eb825a49f5f9532b",
"assets/AssetManifest.json": "35e317f7d09f43e078cba3f0678f4256",
"assets/FontManifest.json": "37f36fceae2693c65139f978d4e0d9ba",
"assets/fonts/MaterialIcons-Regular.otf": "4da1da87576c99c2b39dbd0e16583f2b",
"assets/lib/assets/fonts/Lato-Black.ttf": "d83ab24f5cf2be8b7a9873dd64f6060a",
"assets/lib/assets/fonts/Lato-Bold.ttf": "24b516c266d7341c954cb2918f1c8f38",
"assets/lib/assets/fonts/Lato-Light.ttf": "2bcc211c05fc425a57b2767a4cdcf174",
"assets/lib/assets/fonts/Lato-Regular.ttf": "122dd68d69fe9587e062d20d9ff5de2a",
"assets/lib/assets/fonts/Lato-Thin.ttf": "7ab0bc06eecc1b75f8708aba3d3b044a",
"assets/lib/assets/images/2paper.png": "743a664482c027e14b713148111df839",
"assets/lib/assets/images/adtyphon.png": "9f509a3688f4a5418b2b994e91ad9d9d",
"assets/lib/assets/images/basil_add-outline.png": "0916d19482d6b6bf521da47e136ffa5b",
"assets/lib/assets/images/dashboard.png": "e92bdcfe5ebdd17f5e5edcbe08977414",
"assets/lib/assets/images/documents.png": "04f5dc8c95d775cab5a41cb073c6f37b",
"assets/lib/assets/images/estimator.png": "3e7def206f835b1178dd85ac5cb62caf",
"assets/lib/assets/images/history.png": "0cc89488ca6e60d23f23ebf35b655996",
"assets/lib/assets/images/largevector.png": "893caa34c36af36cf69f40efc754974e",
"assets/lib/assets/images/largevector_2.png": "a97e8bc41345bcb7a41a51f5121684bd",
"assets/lib/assets/images/loading.gif": "a28284d06c603e4cc3aad204a1c83e16",
"assets/lib/assets/images/loadingnobackground.gif": "80d5f15c123ea77c2c50b03458787801",
"assets/lib/assets/images/Login-Screen.jpg": "ece3ba3e9908c527840bc908078b1e8e",
"assets/lib/assets/images/login_screen_bg.png": "38775a8272a1724b065c1e791b29f928",
"assets/lib/assets/images/logout.png": "11ba8b36558a198b4e9ce26bc16fc718",
"assets/lib/assets/images/markfinisehd.png": "8442c14e6ec9a0989154d148c64adce2",
"assets/lib/assets/images/settings.png": "0cc89488ca6e60d23f23ebf35b655996",
"assets/lib/assets/images/typhoonicon.png": "ae807d40859750d0516cdc16129c86c4",
"assets/lib/assets/images/typhoonistavectorlarge.png": "45576fedb398a636bcb17b2aa632253c",
"assets/lib/assets/images/typhoonista_logo.png": "ee43aff18b22320baaad8e5cbd4029a3",
"assets/lib/assets/images/typhoonista_logo_smallest.png": "a998d65433d37fbd401204e9f26e9bf6",
"assets/lib/assets/images/typhoonista_logo_white.png": "68d9b507162e9b5de3713624c00dd2e3",
"assets/lib/assets/images/typhoons.png": "ede027ce2507971ac9c3dce1f7d327fa",
"assets/lib/assets/images/Vector%2520(1).png": "30859921974bf1fa4a6b858a1b2dbe9f",
"assets/lib/assets/images/Vector%2520(2).png": "23bcd1b7bbd9caf66963a406a59c209e",
"assets/lib/assets/images/wind.png": "e987c1e55243453fbfc7f633f1e3adf8",
"assets/lib/philippines-with-regions_%2520(2).geojson": "bf3177c2073daf61fa557c4881694c52",
"assets/lib/services/MuniCities.minimal.json": "03e3e72b2156ec85d9639dad9d785063",
"assets/lib%255Cphilippines-with-regions_%2520(2).geojson": "bf3177c2073daf61fa557c4881694c52",
"assets/lib%255Cservices%255CMuniCities.minimal.json": "03e3e72b2156ec85d9639dad9d785063",
"assets/NOTICES": "cba5b68506dfdf396e62cb7ba50e046a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "36574472a38a2ec13d2275f3bd423bc0",
"/": "36574472a38a2ec13d2275f3bd423bc0",
"main.dart.js": "1f314f1e50540f9e31b7451ff49467a1",
"manifest.json": "c3115a6aa2e7dba0f8d84cdc063e9e92",
"version.json": "73c6f3fd7f893aadc3b319ca3836060e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
