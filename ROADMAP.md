# Curriculum Roadmap

15 questions + an e-commerce capstone, ordered from "shorten a URL" to a full
multi-subsystem platform. Each question teaches **one core class of problem** through a
**real product**, and I grade your Excalidraw diagram against a hidden rubric.

Difficulty: Easy · Medium · Hard

> First time? Read **`HOW-TO-APPROACH-HLD.md`** — the method you'll apply to every one.

---

## Tier 1 — Fundamentals & building blocks

| # | Question | Real product | Core ideas you'll practise |
|---|----------|--------------|----------------------------|
| 01 | URL Shortener | TinyURL / Bit.ly | Key generation, read-heavy caching, 302 redirect, estimation |
| 02 | Pastebin | Pastebin / GitHub Gist | Blob storage vs metadata DB, TTL/expiry, CDN for reads |
| 03 | Distributed Rate Limiter | API gateway guard | Token/leaky bucket, Redis counters, where to enforce |
| 04 | Distributed Cache | Redis/Memcached-as-a-service | Consistent hashing, eviction (LRU), replication, cache coherence |

## Tier 2 — Social graphs, feeds & messaging

| # | Question | Real product | Core ideas you'll practise |
|---|----------|--------------|----------------------------|
| 05 | News Feed / Timeline | Twitter / X | Fan-out on write vs read, the celebrity problem, feed ranking |
| 06 | Chat System | WhatsApp / Messenger | WebSockets, presence, delivery/read receipts, message store |
| 07 | Notification Service | Push / SMS / email fan-out | Queues, provider adapters, retries, dedup, user preferences |

## Tier 3 — Media & large-file storage

| # | Question | Real product | Core ideas you'll practise |
|---|----------|--------------|----------------------------|
| 08 | Photo Sharing | Instagram | Object storage, CDN, feed + media split, thumbnails pipeline |
| 09 | Video Streaming | YouTube / Netflix | Upload→transcode pipeline, ABR + CDN, metadata vs blobs |
| 10 | File Storage & Sync | Dropbox / Google Drive | Chunking, dedup, sync/conflict, metadata vs block storage |

## Tier 4 — Real-time, geo & transactions

| # | Question | Real product | Core ideas you'll practise |
|---|----------|--------------|----------------------------|
| 11 | Ride-Sharing | Uber / Lyft | Geo-indexing (geohash/quadtree), matching, real-time location |
| 12 | Proximity Service | Yelp / "nearby places" | Spatial indexing, read-heavy geo queries, ranking |
| 13 | Ticket Booking | BookMyShow / Ticketmaster | Inventory concurrency, holds/locks, no double-booking, ACID |

## Tier 5 — Search & web-scale

| # | Question | Real product | Core ideas you'll practise |
|---|----------|--------------|----------------------------|
| 14 | Web Crawler | Googlebot | BFS frontier, politeness, dedup, distributed workers, storage |
| 15 | Search Autocomplete | Google typeahead | Trie, prefix sharding, ranking, heavy read caching, freshness |

## Capstone — E-commerce Platform

| Module | Real product | Core ideas you'll practise |
|--------|--------------|----------------------------|
| `16-ecommerce-platform` | Amazon | Catalog + search, cart, **inventory & payment with strong consistency**, order orchestration (saga), notifications — composing many subsystems into one coherent, failure-aware design |

---

## How to progress

```bash
./judge/run.sh 1          # read Q1 + open its canvas
# ...draw in Excalidraw, save canvas.excalidraw...
# then in chat:  "Judge my design for Q1"
./judge/run.sh 2          # ... and so on
./judge/run.sh 16         # the capstone
```

Your dashboard updates at `progress/progress.md` each time I grade you.

## What's next after this?

HLD is the **boxes-and-arrows** view: how systems scale, replicate, and stay available.
The complementary skill is **LLD** — designing the clean classes *inside* one of those
boxes. If you have the sibling **LLD Dojo** (`../javat/lld/`), pair them: design the
system here, then design one service's object model there.
