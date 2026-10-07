# Q02 · Pastebin

**Topic:** Blob vs metadata split · TTL/expiry · CDN reads
**Tier:** 1 — Fundamentals & building blocks
**Difficulty:** Easy

---

## The brief

Design **Pastebin** (or GitHub Gist): a user pastes a block of text (or code), gets a short
URL, and anyone with that URL can read the paste. Pastes can expire and can be public or
unlisted.

The twist versus the URL shortener: now you're storing **large, arbitrary content**, not a
tiny string — so where the bytes live becomes the central decision.

### Functional requirements

- `POST /paste {content, expiry?, visibility?}` → returns a unique paste URL.
- `GET /{pasteId}` → returns the paste content (rendered page or raw).
- Pastes can **expire** (e.g. 10 min, 1 day, 1 month, never).
- Pastes can be **public** (listed) or **unlisted** (only via link).
- (Optional) a page of recent public pastes.

### Non-functional requirements

- **Read-heavy**, like the shortener (popular pastes get hammered).
- Content can be up to a few **MB** of text.
- Reads should be fast and cheap — ideally served from a **CDN / object store**, not the DB.
- Durable: a saved paste must not be lost; expiry must be honoured.

### Scale to design for

- **10 M** new pastes/day.
- Avg paste **~10 KB**, max a few MB.
- **5:1** read:write.
- Retain for the paste's TTL (many "never expire").

---

## What your diagram must show

1. Write path: client → service → **where the content bytes go** vs **where the metadata goes**.
2. Read path: client → how content is fetched, including **CDN / object-store** serving.
3. The **data model**: metadata record vs the blob; what the `pasteId` keys into.
4. How **expiry** is enforced (lazy on read? a cleanup job? object-store lifecycle rules?).
5. How you keep reads cheap at scale (CDN, cache) and how you shard the metadata.
6. A note on **public listing** vs **unlisted** and how visibility is enforced.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q2"**.
