# Rubric — Q14 Web Crawler

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Fetch, extract-links, store content, robots/politeness, dedup, freshness all covered.

## Dimension 2 — URL frontier & politeness — THE KEY INSIGHT (3 pts)
- [ ] A **URL frontier** queue drives a producer/consumer loop (fetch → extract → enqueue).
- [ ] **Politeness**: per-domain queues / rate limiting so one domain isn't hammered;
      robots.txt respected and cached per domain.
- [ ] Prioritisation (important/fresh pages first) mentioned; frontier is **durable** so it
      survives crashes.

## Dimension 3 — Distributed workers (1.5 pts)
- [ ] Many **fetcher workers** consume the frontier in parallel across machines.
- [ ] DNS resolution/caching considered; workers are stateless and scale horizontally.

## Dimension 4 — Deduplication (2 pts)
- [ ] **Seen-URL** set/dedup (e.g. hash set / Bloom filter) to avoid re-queuing the same URL.
- [ ] **Content dedup** via content hash to skip identical/near-identical pages (mirrors).
- [ ] Prevents infinite loops / crawler traps (depth limits, URL normalisation).

## Dimension 5 — Storage, fault tolerance & trade-offs (1.5 pts)
- [ ] Content store (object/blob or wide-column) for pages; metadata/URL store for state.
- [ ] **Resumable**: durable frontier + checkpoints → crashed worker loses no work.
- [ ] **Re-crawl/freshness** policy; estimates (pages/sec, storage) present.

## Dimension 6 — Clarity (0.5 pt)
- [ ] The fetch→extract→dedup→enqueue loop is clearly drawn as a cycle.

## Common gaps to call out
- No politeness / per-domain throttle → you DDoS sites and get blocked.
- No dedup → infinite re-crawl, crawler traps, wasted capacity.
- In-memory frontier only → crash loses all pending URLs.
- Ignoring robots.txt.
- No URL normalisation (treating `/a` and `/a/` and `?utm=...` as distinct forever).

## Follow-ups to push with
- Two workers both discover the same popular URL — how do you crawl it once?
- How do you avoid sending 10k requests/sec to a single small website?
- A worker dies mid-batch — what happens to the URLs it was processing?
