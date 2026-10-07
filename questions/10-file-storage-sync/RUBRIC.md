# Rubric — Q10 File Storage & Sync

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Upload/download, folders, cross-device sync, sharing, large/resumable, versions covered.

## Dimension 2 — Chunking & dedup — THE KEY INSIGHT (2.5 pts)
- [ ] Files split into **chunks/blocks**; only **modified chunks** are uploaded/downloaded
      (bandwidth-efficient sync — not whole-file re-upload).
- [ ] **Content-addressed dedup**: chunk identified by its **hash**; identical chunks stored
      once (within a user, ideally across users).
- [ ] Resumable uploads fall out naturally (per-chunk).

## Dimension 3 — Metadata vs block storage (2 pts)
- [ ] **Metadata service/DB**: file tree, file→ordered chunk-hash list, versions, sharing ACLs.
      Needs consistency (relational or a consistent store) — losing metadata = losing files.
- [ ] **Block/object storage** for chunk bytes (S3/GCS); cheap, durable, dedup-friendly.
- [ ] Clear reasoning for the split and the consistency difference between the two.

## Dimension 4 — Sync protocol (2 pts)
- [ ] Client watches for local changes → uploads new chunks → commits new metadata version.
- [ ] **Notify other devices** to pull: long-poll / websocket / notification service
      (don't poll aggressively).
- [ ] Download path: fetch metadata diff → fetch only missing chunks → reassemble.

## Dimension 5 — Conflicts, durability & trade-offs (1.5 pts)
- [ ] **Conflict handling** for concurrent offline edits: versioning + **conflict copy**
      ("file (conflicted copy from device X)") or last-writer-wins with history — justified.
- [ ] Metadata consistency vs block-store eventual durability distinguished.
- [ ] Caching + estimates (storage, dedup savings) present.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Chunk upload path and metadata/notify path both drawn and labelled.

## Common gaps to call out
- Re-uploading the entire file on any change (ignores the core bandwidth problem).
- No dedup / not content-addressing chunks.
- One store for both metadata and bytes (loses the consistency-vs-cost distinction).
- Clients **polling** constantly instead of being notified.
- No answer for two offline edits colliding.

## Follow-ups to push with
- A user changes 1 byte in a 1 GB file — what exactly is transferred?
- Two devices edit the same doc offline, then both come online — what happens?
- How do other devices learn about a change without hammering your servers?
