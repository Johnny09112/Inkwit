/**
 * Service worker — offline skořápka (krok G1).
 *
 * Vědomě konzervativní. Aplikace stojí na přihlášení a na čerstvých datech
 * z databáze, takže agresivní cache by přinesla víc škody než užitku:
 * hráč by viděl cizí kresbu, kterou už někdo uhodl, nebo starý stav pokusů.
 *
 * Pravidla:
 *   - statické soubory Next.js (hash v názvu) → z cache, jsou neměnné
 *   - všechno ostatní → nejdřív ze sítě
 *   - když síť selže a jde o navigaci → offline stránka
 *   - nic z API ani z auth se necachuje NIKDY
 */

const CACHE = "inkwit-v2";
const OFFLINE_URL = "/offline.html";

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE).then((c) => c.addAll([OFFLINE_URL, "/icon.svg"])),
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches
      .keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
      .then(() => self.clients.claim()),
  );
});

self.addEventListener("fetch", (event) => {
  const { request } = event;
  if (request.method !== "GET") return;

  const url = new URL(request.url);

  // Cizí původ = Supabase. Data hry ani přihlášení se nikdy necachují.
  if (url.origin !== self.location.origin) return;

  // Neměnné buildové soubory: z cache, a doplnit ji na pozadí.
  if (url.pathname.startsWith("/_next/static/")) {
    event.respondWith(
      caches.match(request).then(
        (hit) =>
          hit ||
          fetch(request).then((res) => {
            const copy = res.clone();
            caches.open(CACHE).then((c) => c.put(request, copy));
            return res;
          }),
      ),
    );
    return;
  }

  // Zbytek ze sítě. Offline stránka jen pro navigaci, ať se nezobrazí
  // místo obrázku nebo dat.
  event.respondWith(
    fetch(request).catch(() => {
      if (request.mode === "navigate") return caches.match(OFFLINE_URL);
      return Response.error();
    }),
  );
});
