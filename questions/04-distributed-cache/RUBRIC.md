# Rubric — Q04 Distributed Cache

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] get/put/delete with TTL shown; multi-node cluster, not a single box.
- [ ] Node-loss survival addressed.

## Dimension 2 — Key→node mapping — THE KEY INSIGHT (2.5 pts)
- [ ] **Consistent hashing** on a ring, with **virtual nodes** for even distribution.
- [ ] Explicitly contrasts with `hash % N` (which remaps **almost all** keys when N changes).
- [ ] Client-side routing or a proxy/router layer that owns the ring and finds the node.

## Dimension 3 — Eviction & data model (2 pts)
- [ ] Eviction policy named and justified: **LRU** (recency), LFU (frequency), or TTL-only.
- [ ] Mentions how it's implemented (e.g. LRU via hash map + doubly linked list for O(1)).
- [ ] Per-node memory bound; values + TTL stored in RAM.

## Dimension 4 — Replication & availability (2 pts)
- [ ] N replicas per key (e.g. primary + 1–2 replicas on the next ring nodes).
- [ ] Read/write routing to primary; replica promotion / rehash on node failure.
- [ ] Node join/leave moves only the keys between adjacent ring positions (small fraction).

## Dimension 5 — Coherence & trade-offs (1.5 pts)
- [ ] Cache-DB consistency strategy: **cache-aside** (lazy, with invalidation on write),
      write-through, or write-back — with the staleness trade-off named.
- [ ] Handles **thundering herd** on a hot-key miss (locking / request coalescing / staggered TTL).
- [ ] Accepts cache as best-effort: a lost node = cache misses, not data loss (DB is truth).

## Dimension 6 — Clarity (0.5 pt)
- [ ] The ring, a node, and the client lookup path are clearly drawn and labelled.

## Common gaps to call out
- `hash % N` sharding → every scale event cold-starts the whole cache.
- No virtual nodes → lumpy, hot-skewed distribution.
- No eviction policy → OOM.
- Treating the cache as source of truth / ignoring DB coherence.
- Ignoring the stampede when a hot key expires everywhere at once.

## Follow-ups to push with
- You add 1 node to a 100-node ring — what fraction of keys move, and why?
- A node dies mid-request — what does the client see, and how do replicas help?
- A hugely popular key expires — how do you stop 1 M requests stampeding the DB?
