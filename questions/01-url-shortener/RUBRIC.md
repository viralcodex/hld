# Rubric — Q01 URL Shortener

Grade out of 10 across the six dimensions. PASS = 7+. Peek only if stuck.

## Dimension 1 — Requirements coverage (2 pts)
- [ ] Shorten endpoint and redirect (302) path both shown.
- [ ] Redirect uses **302** (or justifies 301 vs 302: 301 is cached by browsers → kills
      analytics and makes expiry impossible; 302 keeps control server-side).
- [ ] At least mentions expiry and/or click analytics path.

## Dimension 2 — Core architecture (2 pts)
- [ ] Client → LB → stateless app servers → store, with a cache in the read path.
- [ ] Clean separation of write (create mapping) and read (resolve + redirect).

## Dimension 3 — Data model & storage (1.5 pts)
- [ ] Mapping modelled as `shortCode (PK) → longUrl, createdAt, expiry, ownerId`.
- [ ] Store is a **key-value / NoSQL** store (lookup is a single-key get) — justified over
      a relational DB, OR relational justified for the modest write rate. Either is fine
      **with reasoning**.

## Dimension 4 — Scale & bottlenecks (2 pts)
- [ ] Estimates present: ~1,160 writes/s, ~116K reads/s, ~tens of TB over 5 yrs.
- [ ] **Cache** (Redis) in front for hot links — cache-aside with TTL. Ideally notes the
      80/20 hot-link skew.
- [ ] **Sharding/partitioning** of the mapping store by short code (hash).
- [ ] Read **replicas** and/or CDN edge caching of redirects considered.

## Dimension 5 — Trade-offs & key generation (2 pts)
Key generation — one of these, with reasoning:
- [ ] **Counter + base-62 encode** (needs a distributed, collision-free counter — e.g. a
      range/ticket server or Zookeeper; note the sequential-guessing risk and mitigation).
- [ ] **Hash (MD5/SHA) + take N chars** (note collision handling: re-hash/append on clash).
- [ ] **Pre-generated key pool / KGS** handed out to app servers (notes dedup & concurrency).
- [ ] Uniqueness guarantee explained (no two creates get the same code under concurrency).
- [ ] Consistency: creation is strongly consistent on the code; reads can be eventually
      consistent / cached.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Boxes and arrows labelled; the two paths are followable.

## Common gaps to call out
- Using an auto-increment integer directly → guessable, leaks volume, hot shard.
- No cache → DB melts at 116K reads/s.
- Ignoring the single-point-of-failure in a lone KGS/counter.
- Forgetting that 301 is browser-cached and breaks analytics/expiry.

## Follow-ups to push with
- How do you avoid a DB round-trip to check uniqueness on every create?
- A link goes viral — how does one hot key behave in your cache/shard?
- How would you add per-link analytics without slowing the redirect?
