# Rubric — Q09 Video Streaming

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Upload+process, adaptive watch, browse/search, view counts covered; resumable upload noted.

## Dimension 2 — Transcoding pipeline — THE KEY INSIGHT A (2.5 pts)
- [ ] Upload lands raw in object storage; **async transcoding** via **queue + large worker fleet**.
- [ ] Produces **multiple resolutions/bitrates** and **segments** (chunks) per video.
- [ ] Pipeline parallelises (split video → transcode segments in parallel) to keep up with ingest.
- [ ] Metadata status flips to "ready" when processing completes.

## Dimension 3 — Adaptive streaming + CDN — THE KEY INSIGHT B (2.5 pts)
- [ ] **ABR** via **HLS/DASH**: a **manifest** listing segments at each quality; player
      switches quality by bandwidth to avoid buffering.
- [ ] Segments + manifest served from a **CDN** globally (origin = object store).
- [ ] Explains why segmented ABR beats a single-file download (seek, quality switching, caching).

## Dimension 4 — Storage & data model (1.5 pts)
- [ ] **Blobs (raw + transcoded segments) in object storage**; **metadata in a DB**
      (videoId → title, owner, variantManifests, status, counts).
- [ ] Clear blob-vs-metadata separation and reasoning.

## Dimension 5 — Scale, cost & trade-offs (1.5 pts)
- [ ] Acknowledges **bandwidth/egress is the dominant cost** → CDN offload + caching tiers.
- [ ] Durable multi-region object storage; estimates (ingest hrs/min, storage, egress).
- [ ] View counts handled async/eventually consistent (don't write-contend per view).

## Dimension 6 — Clarity (0.5 pt)
- [ ] Upload→transcode→store and watch→manifest→CDN-segments both clearly drawn.

## Common gaps to call out
- Serving one giant MP4 file (no segmentation/ABR) → buffering, no quality adaptation.
- Transcoding synchronously or on a tiny pool → can't keep up with 500 hrs/min.
- Storing video in a database.
- No CDN → origin bandwidth bill + global latency.
- Counting views with a synchronous DB increment per play.

## Follow-ups to push with
- A viewer's bandwidth drops mid-video — how does playback stay smooth?
- 500 hours upload every minute — how does your transcoding fleet keep pace?
- A new blockbuster drops — how do you pre-warm/serve it to millions at once?
