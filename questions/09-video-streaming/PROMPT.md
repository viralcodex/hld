# Q09 · Video Streaming

**Topic:** Upload→transcode pipeline · ABR + CDN · metadata vs blobs
**Tier:** 3 — Media & large-file storage
**Difficulty:** Hard

---

## The brief

Design a video platform like **YouTube / Netflix**. Creators upload videos; viewers watch
them smoothly on any device and connection, anywhere in the world. A video is huge, must be
converted into many formats/qualities, and streamed adaptively so playback doesn't stall.

This is the heavyweight media problem: a long **processing pipeline** on write, and
**adaptive streaming over a CDN** on read.

### Functional requirements

- Upload a video; it's processed into multiple resolutions/formats.
- Watch a video with **smooth, adaptive** playback (quality adjusts to bandwidth).
- Search / browse; view counts; (basic) recommendations out of scope beyond a mention.
- Resumable uploads for large files.

### Non-functional requirements

- **Smooth playback** with minimal buffering, globally.
- Handle **very large** files (GBs) and long processing.
- **Durable** storage; highly available reads.
- Read-heavy (views ≫ uploads), with huge **egress bandwidth**.

### Scale to design for

- **2 B** users; **1 B** hours watched/day.
- **500 hours** of video uploaded **per minute**.
- **Exabytes** of storage; the dominant cost is **bandwidth**.

---

## What your diagram must show

1. The **upload path**: resumable/chunked upload → raw store → **transcoding pipeline**
   (queue + worker fleet) producing multiple bitrates/resolutions and segments.
2. **Adaptive Bitrate (ABR)** streaming: segmented files (HLS/DASH), a manifest, and how the
   player picks quality — all served from a **CDN**.
3. The **storage model**: raw vs transcoded **blobs in object storage**; **metadata in a DB**.
4. The **watch path**: client → manifest → CDN segments; cache strategy and edge placement.
5. How the pipeline **scales** for 500 hours/min of ingest (parallel transcoding, queues).
6. View counting (async/eventually consistent) and durability.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q9"**.
