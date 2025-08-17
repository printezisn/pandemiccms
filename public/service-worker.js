const cacheName = 'pandemiccms-v1';

const deleteOldCaches = async () => {
  const keys = await caches.keys();
  await Promise.allSettled(
    keys.map(async (key) => {
      if (key !== cacheName) return;

      await caches.delete(key);
    }),
  );
};

self.addEventListener('activate', (event) => {
  event.waitUntil(deleteOldCaches());
});

const cacheFirst = async (event) => {
  const cache = await caches.open(cacheName);
  const cachedResponse = await cache.match(event.request);
  if (cachedResponse) return cachedResponse;

  const fetchResponse = await fetch(event.request);
  if (fetchResponse.status < 300) {
    cache.put(event.request, fetchResponse.clone());
  }

  return fetchResponse;
};

self.addEventListener('fetch', async (event) => {
  if (!event.request.url.startsWith('http')) return;
  if (new URL(event.request.url).origin !== self.location.origin) {
    return;
  }

  const cacheFirstDestinations = [
    'script',
    'image',
    'font',
    'style',
  ];

  if (cacheFirstDestinations.includes(event.request.destination)) {
    await event.respondWith(cacheFirst(event));
  }
});
