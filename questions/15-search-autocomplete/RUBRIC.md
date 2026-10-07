# Rubric — Q15 Search Autocomplete

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Prefix → top-k ranked suggestions; popularity-driven; freshness addressed.

## Dimension 2 — Serving structure — THE KEY INSIGHT A (2.5 pts)
- [ ] A **trie / prefix tree** (or prefix-indexed store) for fast prefix matching.
- [ ] **Top-k precomputed and stored at each node** so a lookup is O(prefix length), not a
      scan+sort at request time.
- [ ] Explains why this hits the <100 ms budget.

## Dimension 3 — Read scaling & caching — THE KEY INSIGHT B (2 pts)
- [ ] **Aggressive caching** of hot prefixes (a tiny set of prefixes serve most traffic).
- [ ] Horizontal read fleet; trie served from **memory**.
- [ ] **Sharding** the trie by prefix (e.g. first letters / hash) with request routing.

## Dimension 4 — Offline aggregation pipeline — THE WRITE PATH (2 pts)
- [ ] Query logs → **batch/stream aggregation** (count popularity, e.g. MapReduce/Spark/
      streaming) → recompute top-k per node.
- [ ] Updated trie **published** to the serving tier (swap/replicate), decoupled from reads.
- [ ] Reasoning that you don't update popularity counts synchronously on the read path.

## Dimension 5 — Freshness & trade-offs (1.5 pts)
- [ ] Freshness mechanism: periodic rebuilds + a faster path for trending terms;
      staleness-vs-cost trade-off named.
- [ ] Ranking signals (frequency, recency, maybe personalization/locale) mentioned.
- [ ] Estimates (prefix QPS, cache hit rate) present.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Read (prefix→top-k) and offline (logs→aggregate→publish) paths both drawn.

## Common gaps to call out
- Scanning/sorting all matching queries at request time (misses the latency budget).
- Updating popularity counts synchronously on each keystroke/read.
- No caching despite tens of billions of prefix lookups/day.
- One un-sharded trie that can't fit/serve the load.
- No freshness story (static suggestions forever).

## Follow-ups to push with
- A user types "ne" — exactly what lookup happens and how is it under 50 ms?
- A term suddenly trends — how long until it appears, and what updates?
- You can't rebuild the whole trie every minute — how do you stay fresh cheaply?
