# Q14 · Web Crawler

**Topic:** BFS frontier · politeness · dedup · distributed workers
**Tier:** 5 — Search & web-scale
**Difficulty:** Medium

---

## The brief

Design a **web crawler** like Googlebot: starting from a set of seed URLs, fetch pages,
extract their links, and keep crawling outward — building a corpus of the web for a search
index. It must run across many machines, be polite to the sites it visits, and avoid
crawling the same thing endlessly.

This is a **distributed producer/consumer + graph traversal** problem at planetary scale,
with real-world etiquette constraints baked in.

### Functional requirements

- Start from seed URLs; **fetch** pages and **extract links** to enqueue.
- Traverse the web graph (effectively **BFS**) with bounded depth/scope.
- **Store** fetched content for downstream indexing.
- **Respect robots.txt** and per-domain rate limits (politeness).
- **Avoid duplicates** — don't re-crawl the same URL or identical content.

### Non-functional requirements

- **Massively parallel** across many worker machines.
- **Polite:** never hammer a single domain.
- **Fault-tolerant:** a crashed worker loses no URLs; crawl is resumable.
- **Fresh:** periodically re-crawl to catch updates.

### Scale to design for

- **Billions** of pages; **tens of thousands** of pages/sec.
- Must finish a full pass in a reasonable window and refresh continuously.

---

## What your diagram must show

1. The **URL frontier**: the queue(s) of URLs to crawl, how it's prioritised, and how
   **politeness** is enforced (per-domain queues / rate control).
2. The **fetcher workers**: distributed consumers that download pages, plus DNS resolution.
3. **Link extraction** → **dedup** (seen-URL set) → enqueue new URLs (closing the loop).
4. **Content dedup** (hash of page content to skip near-identical pages).
5. **Storage**: raw/parsed content store + the URL/metadata store; which store and why.
6. **Fault tolerance & resumability** (durable frontier, checkpoints) and **re-crawl/freshness**.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q14"**.
