# Q08 · Photo Sharing

**Topic:** Object storage · CDN · feed + media split · thumbnail pipeline
**Tier:** 3 — Media & large-file storage
**Difficulty:** Medium

---

## The brief

Design a photo-sharing service like **Instagram**: users upload photos, follow others, and
scroll a feed of recent photos from accounts they follow. Each photo renders in multiple
sizes (thumbnail in the grid, full-size on tap).

This builds on the feed problem (Q05) but the dominant concern shifts to **storing and
serving large binary media** cheaply and fast, globally.

### Functional requirements

- Upload a photo (+ caption); it's processed into multiple resolutions.
- Follow/unfollow; a **home feed** of followees' recent photos.
- View a user's profile grid.
- Like / comment (basic).

### Non-functional requirements

- **Read-heavy**; feed and image loads must be fast worldwide.
- Images served with **low latency globally** (edge).
- **Durable** storage — never lose a user's photos.
- Highly available; eventual consistency fine for feed/likes.

### Scale to design for

- **500 M** users, **100 M** DAU.
- **100 M** photo uploads/day; avg **~2 MB** raw.
- **Petabytes** of media, growing daily; billions of image reads/day.

---

## What your diagram must show

1. The **upload path**: client → service → where raw bytes land → **async processing**
   (resize/transcode to thumbnail/medium/full), including the queue + workers.
2. **Where media lives** (object storage) and how it's **served via CDN** globally.
3. The **metadata vs media split**: photo metadata, social graph, feed — in which stores.
4. The **feed path** (reuse fan-out thinking from Q05) returning **CDN URLs**, not bytes.
5. **Thumbnail/variant** strategy and how the right size is requested.
6. Durability (replication across AZs/regions) and estimates (storage/day, read bandwidth).

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q8"**.
