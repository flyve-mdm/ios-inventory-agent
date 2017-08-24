self.addEventListener('install', function(e) { 
  
   

  var CACHE_NAME = 'ios-inventory-agent-version-8'

  caches.keys().then(function(cacheNames) {
    return Promise.all(
      cacheNames.map(function(cacheName) {
        if(cacheName != CACHE_NAME) {
          return caches.delete(cacheName)
        }
      })
    ) 
  })
  
  e.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.addAll([
        '/flyve-mdm-ios-inventory-agent/',
        '/flyve-mdm-ios-inventory-agent/?homescreen=1',
        '/flyve-mdm-ios-inventory-agent/index.html',
        '/flyve-mdm-ios-inventory-agent/index.html?homescreen=1',
        '/flyve-mdm-ios-inventory-agent/css/flyve-mdm.min.css',
        '/flyve-mdm-ios-inventory-agent/css/main.css',
        '/flyve-mdm-ios-inventory-agent/css/syntax.css',
        '/flyve-mdm-ios-inventory-agent/images/typo.png',
        '/flyve-mdm-ios-inventory-agent/images/ipodTouch.png',
        '/flyve-mdm-ios-inventory-agent/images/ipad.png',
        '/flyve-mdm-ios-inventory-agent/images/IPhone6.png',
        '/flyve-mdm-ios-inventory-agent/images/logo.png',
        '/flyve-mdm-ios-inventory-agent/js/app.js',
        '/flyve-mdm-ios-inventory-agent/js/jquery.min.js',
        '/flyve-mdm-ios-inventory-agent/js/bootstrap.min.js',
        '/flyve-mdm-ios-inventory-agent/manifest.json',
        '/flyve-mdm-ios-inventory-agent/fonts/glyphs/winjs-symbols.ttf',
        '/flyve-mdm-ios-inventory-agent/fonts/selawk.ttf',
      ])
    })
  )
})

self.addEventListener('fetch', function(event) {
  console.log(event.request.url)
  event.respondWith(
    caches.match(event.request).then(function(response) {
      return response || fetch(event.request)
    })
  )
})