# Rubric — Q08 Photo Sharing

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Upload (+processing), follow, home feed, profile grid, like/comment have paths.

## Dimension 2 — Media storage & serving — THE KEY INSIGHT (2.5 pts)
- [ ] Raw + processed images in **object storage (S3/GCS)**, NOT in a database.
- [ ] Served through a **CDN** at the edge for global low latency; feed returns **URLs**.
- [ ] Upload ideally via **pre-signed URL** direct to object store (bytes bypass app servers),
      or at least an explicit reason the bytes don't stream through the DB.

## Dimension 3 — Processing pipeline (2 pts)
- [ ] Upload triggers **async** processing via **queue + workers** (don't block the user).
- [ ] Generates multiple **resolutions/variants** (thumbnail/medium/full); stores each.
- [ ] Metadata row updated when processing completes (status).

## Dimension 4 — Metadata, feed & data model (2 pts)
- [ ] **Photo metadata** DB: `photoId → ownerId, caption, variantUrls, ts` (NoSQL fits).
- [ ] **Social graph** + **feed** reuse Q05 fan-out (push/pull/hybrid) — brief is fine.
- [ ] Likes/comments stored separately; counts can be eventually consistent.

## Dimension 5 — Scale, durability & trade-offs (1.5 pts)
- [ ] Durability via cross-AZ/region replication of object storage.
- [ ] Estimates: ~200 TB/day of uploads, huge read bandwidth → CDN offload is essential.
- [ ] Caching of hot metadata; sharding by user/photo id.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Upload→process→store and feed→CDN paths both drawn and labelled.

## Common gaps to call out
- Storing image bytes in the DB → explodes cost and kills performance.
- Synchronous resize in the upload request → slow uploads, timeouts under spikes.
- Serving images from origin app servers instead of a CDN.
- Returning raw bytes in the feed API instead of CDN URLs.
- Generating variants on every read instead of once on upload.

## Follow-ups to push with
- Walk the bytes of a 5 MB upload — do they ever touch your app servers?
- A photo goes viral globally — what serves 1 M views/min across continents?
- How does the client get the thumbnail in the grid but the full-res on tap?
