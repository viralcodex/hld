# Q01 · URL Shortener

**Topic:** Key generation · read-heavy caching · estimation
**Tier:** 1 — Fundamentals & building blocks
**Difficulty:** Easy

---

## The brief

Design a URL shortening service like **TinyURL** or **Bit.ly**. A user submits a long URL
and gets back a short one (e.g. `https://sho.rt/aK9f2`). Anyone who visits the short URL is
redirected to the original.

This is the "hello world" of system design — but it still touches estimation, key design,
caching, and the read-vs-write trade-off that recurs everywhere.

### Functional requirements

- `POST /shorten {longUrl}` → returns a unique short URL.
- `GET /{shortCode}` → **HTTP 302** redirect to the long URL.
- (Optional) custom alias and an expiry date on a short link.
- (Optional) basic analytics: click count per short link.

### Non-functional requirements

- **Read-heavy:** ~**100:1** read:write. Redirects must feel instant.
- **Low latency:** redirect in **< 100 ms** at p99.
- **High availability** for reads — a dead redirect is a broken link on the whole internet.
- Short codes are **short** (≤ 7 chars) and **not guessable in bulk** (no simple +1 counter leak).

### Scale to design for

- **100 M** new URLs/day.
- **100:1** reads → ~**10 B** redirects/day.
- Store links for **5 years**.

> Do the back-of-envelope math on the canvas: writes/sec, reads/sec, total storage. Those
> numbers justify your caching and sharding choices.

---

## What your diagram must show

1. The **write path**: client → how a unique short code is generated → where the mapping is
   stored.
2. The **read/redirect path**: client → how the long URL is resolved → the 302, including
   your **cache**.
3. Your **key-generation** strategy (and why it avoids collisions and bulk-guessing).
4. The **data model** for the `shortCode → longUrl` mapping and which **store** holds it.
5. How you **scale reads** to ~100K+/sec (cache, CDN, replicas) and **partition** the data.
6. A text note on your **consistency** and **uniqueness** guarantees.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q1"**.

> Spend ~30 minutes. Read `../../HOW-TO-APPROACH-HLD.md` if you want the method first.
