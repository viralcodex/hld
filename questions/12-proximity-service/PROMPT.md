# Q12 · Proximity Service

**Topic:** Spatial indexing · read-heavy geo queries · ranking
**Tier:** 4 — Real-time, geo & transactions
**Difficulty:** Medium

---

## The brief

Design a "**find nearby places**" service like **Yelp** or Google Maps' nearby search:
given a user's location and a radius (or "20 nearest"), return matching businesses —
restaurants, ATMs, gas stations — ranked by distance/rating. Unlike ride-sharing, the data
(places) is **mostly static** and reads dominate massively.

The focus: the right **static spatial index** and serving an enormous volume of read-only
geo queries cheaply.

### Functional requirements

- `search(lat, long, radius or k, category?)` → nearby places, ranked.
- View a place's details (hours, rating, photos).
- Business owners add/update places (low write rate).

### Non-functional requirements

- **Extremely read-heavy**; places change rarely.
- **Low latency** for search (< 200 ms).
- High availability; stale-by-minutes data is fine.
- Global coverage.

### Scale to design for

- **200 M** places worldwide.
- **Billions** of searches/day; writes negligible by comparison.

---

## What your diagram must show

1. The **spatial index** choice for mostly-static data — **geohash buckets**, **quadtree**,
   or an evenly-sized grid — and why it fits read-heavy, rarely-changing data.
2. How a search turns into an **index lookup** (this cell + neighbours) then distance filter
   + ranking.
3. The **data model**: places, their geo-bucket, categories, and the details store.
4. **Caching** strategy — hot regions/queries, since reads dominate (and the index can be
   largely precomputed/replicated).
5. How you **scale reads** (replicas, cache, CDN for place details/photos) and shard by
   geography.
6. How index updates happen when a (rare) place is added/moved.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q12"**.
