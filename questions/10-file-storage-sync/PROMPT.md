# Q10 · File Storage & Sync

**Topic:** Chunking · dedup · sync/conflict · metadata vs blocks
**Tier:** 3 — Media & large-file storage
**Difficulty:** Hard

---

## The brief

Design a file storage and sync service like **Dropbox / Google Drive**. A user's files live
in the cloud and stay **in sync** across all their devices: edit a file on a laptop, and the
change appears on their phone shortly after. Sharing and large files are in scope.

The defining challenge is **efficient sync**: don't re-upload a whole 1 GB file because one
byte changed, and resolve what happens when two devices edit while offline.

### Functional requirements

- Upload / download files; organise in folders.
- **Sync** changes across a user's devices automatically.
- **Share** files/folders with other users (view/edit).
- Handle **large files** and **resumable** uploads.
- Basic **version history**; conflict handling.

### Non-functional requirements

- **Bandwidth-efficient** sync (transfer only what changed).
- **Durable** and consistent per-user metadata (no lost files).
- Available offline → sync on reconnect.
- Scales to huge total storage.

### Scale to design for

- **500 M** users; avg **tens of GB** each → **exabytes** total.
- Many devices per user; frequent small edits.

---

## What your diagram must show

1. **Chunking**: files split into fixed/variable blocks; only **changed chunks** are
   transferred and stored.
2. **Deduplication**: identical chunks (content-hash addressed) stored once across users.
3. The **metadata vs block storage** split: a metadata service (file tree, versions, chunk
   lists) vs **block/object storage** for chunk bytes.
4. The **sync protocol**: client detects local changes → uploads new chunks → updates
   metadata → **notifies other devices** (long-poll/websocket/notification service) to pull.
5. **Conflict resolution** when two devices edit the same file offline (versioning / conflict
   copy).
6. Durability, caching, and estimates.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q10"**.
