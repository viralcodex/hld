# Q15 · Search Autocomplete (Typeahead)

**Topic:** Trie · prefix sharding · ranking · heavy read caching · freshness
**Tier:** 5 — Search & web-scale
**Difficulty:** Hard

---

## The brief

Design **search autocomplete / typeahead** like Google's: as a user types, suggest the top
few completions after every keystroke, ranked by popularity, in a few milliseconds. The
suggestions are built from what millions of people search for, and must stay reasonably
fresh as trends change.

The challenge is **ultra-low-latency prefix lookup** served at enormous read volume, fed by
an offline pipeline that aggregates query popularity.

### Functional requirements

- Given a **prefix**, return the **top-k** (e.g. 5–10) suggestions, ranked by popularity.
- Suggestions reflect **what people actually search** (popularity-driven).
- Stay **fresh** — trending terms show up within hours.
- (Optional) personalization/locale.

### Non-functional requirements

- **Very low latency:** suggestions in **< 100 ms** (ideally < 50) per keystroke.
- **Enormous read volume:** a suggestion request on *every keystroke* of every search.
- Highly available; slightly stale suggestions are fine.

### Scale to design for

- **5 B** searches/day → tens of billions of **prefix queries/day**.
- Billions of distinct queries aggregated for ranking.

---

## What your diagram must show

1. The **serving data structure**: a **trie** (prefix tree) with top-k precomputed/cached at
   each node, or an equivalent prefix-indexed store — chosen for sub-100 ms prefix lookup.
2. The **read path**: keystroke → prefix lookup → top-k, with **heavy caching** (hot
   prefixes) and horizontal read scaling.
3. **Sharding** of the trie/index by prefix (and how a query routes to the right shard).
4. The **offline aggregation pipeline**: collect query logs → count/aggregate popularity →
   **rebuild/update** the trie's top-k → publish to serving tier (the write path).
5. The **freshness** mechanism — how trending terms propagate without rebuilding everything
   synchronously.
6. Trade-offs: precompute vs compute-on-read; staleness vs cost; ranking signals.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q15"**.
