# Rubric — Q02 Pastebin

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (2 pts)
- [ ] Create + read paths shown; unique id generation (same ideas as Q1).
- [ ] Expiry handled explicitly.
- [ ] Visibility (public/unlisted) represented; optional recent-public listing considered.

## Dimension 2 — Core architecture (2 pts)
- [ ] Client → LB → app service → metadata store **+** object/blob store.
- [ ] Reads served from CDN/object store or cache, not the metadata DB directly.

## Dimension 3 — Data model & storage — THE KEY INSIGHT (2.5 pts)
- [ ] **Content bytes in object storage (S3/GCS)**, not inline in the DB — large blobs
      don't belong in a row/KV value.
- [ ] **Metadata in a DB/KV**: `pasteId → {blobUrl/key, createdAt, expiry, visibility, ownerId}`.
- [ ] Clear reasoning for the split (DB stays small & fast; blobs are cheap, durable, CDN-able).

## Dimension 4 — Scale & bottlenecks (1.5 pts)
- [ ] CDN caches popular pastes at the edge; cache-aside for metadata.
- [ ] Metadata store sharded by pasteId; object store scales independently.
- [ ] Rough estimates (writes/s, storage/day) present.

## Dimension 5 — Trade-offs & expiry (1.5 pts)
- [ ] Expiry strategy chosen and justified: object-store lifecycle/TTL rules and/or a
      cleanup worker and/or lazy-delete-on-read. Notes CDN cache invalidation on expiry.
- [ ] Durability/consistency: write metadata only after blob is stored (or vice-versa) —
      ordering to avoid dangling pointers.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Metadata path vs blob path visually distinct and labelled.

## Common gaps to call out
- Storing multi-MB content as a DB column/value → bloated, slow, expensive.
- No CDN → every read hits origin.
- Expiry not actually enforced (just a timestamp nobody acts on); stale CDN copies after expiry.
- Serving unlisted pastes from a public listing index.

## Follow-ups to push with
- Where exactly do the bytes live, and how does a read reach them without touching the DB?
- A paste goes viral — what serves the 1 M reads/min?
- How do you guarantee an expired paste is actually unreachable (including the CDN)?
