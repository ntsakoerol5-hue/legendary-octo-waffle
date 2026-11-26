/* GlowBook service worker — scoped to /legendary-octo-waffle/ */
const CACHE_NAME = "glowbook-shell-v2";
const APP_SHELL = [
  "./", "./index.html", "./manifest.json", "./icon.svg",
  "./icons/icon-192.png", "./icons/icon-512.png"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(APP_SHELL))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", event => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== "GET" || url.origin !== self.location.origin) return;

  if (request.mode === "navigate") {
    event.respondWith(
      fetch(request).then(response => {
        const copy = response.clone();
        caches.open(CACHE_NAME).then(cache => cache.put("./", copy));
        return response;
      }).catch(() => caches.match("./").then(cached => cached || new Response(
        "<!doctype html><html lang='en'><meta name='viewport' content='width=device-width,initial-scale=1'><title>GlowBook offline</title><body style='font:16px system-ui;padding:2rem;background:#faf8f5;color:#211d25'><h1>GlowBook</h1><p>You are offline. Reconnect to browse salons and submit bookings.</p></body></html>",
        {headers: {"Content-Type":"text/html; charset=utf-8"}}
      )))
    );
    return;
  }

  if (url.pathname.startsWith(new URL("./", self.registration.scope).pathname)) {
    event.respondWith(caches.match(request).then(cached => cached || fetch(request).then(response => {
      if (response.ok) {
        const copy = response.clone();
        caches.open(CACHE_NAME).then(cache => cache.put(request, copy));
      }
      return response;
    })));
  }
});
