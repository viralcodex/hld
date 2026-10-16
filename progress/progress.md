# Your dashboard

Auto-ish: I update this each time I grade a design. **PASS = 7+/10.**

Last updated: 2026-10-13

## Progress

| # | Question | Tier | Difficulty | Status | Best score | Last graded | Notes |
|---|----------|------|-----------|--------|-----------|-------------|-------|
| 01 | URL Shortener | 1 | Easy | Passed | 9 | 2026-10-07 | Added estimation, sharding+replicas, PG-over-KV justification. For 10: state reads/s (~116K), uniqueness mechanism, consistency stance |
| 02 | Pastebin | 1 | Easy | Passed | 10 | 2026-10-09 | Blob/metadata split nailed; pre-signed direct upload + PENDING/SUCCESS status state machine; triple expiry. Nits: explicit id-gen, public listing, CDN purge-on-expiry |
| 03 | Distributed Rate Limiter | 1 | Medium | Passed | 9 | 2026-10-09 | Gateway placement, token bucket justified, fail-closed + config via etcd. For 10: counter TTL, name sync-interval leak bound, draw atomic Redis INCR/Lua fallback |
| 04 | Distributed Cache | 1 | Medium | Passed | 9 | 2026-10-09 | Ring + vnodes + gossip + master-slave HA + cache-aside + request collapsing. For 10: quantify hash%N remap, draw LRU map+DLL, show put/delete+TTL path, staggered-TTL for hot-key expiry |
| 05 | News Feed / Timeline | 2 | Medium | Passed | 10 | 2026-10-10 | Full hybrid fan-out (push non-celeb / pull celeb), async via MQ, estimates, media+CDN, ranking, pagination. Probe: celeb threshold (100k vs 100M), follow back-fill, bidirectional graph index |
| 06 | Chat System | 2 | Medium | Passed | 9 | 2026-10-12 | WS gateways + Redis conn registry + pub/sub routing + inbox store-and-forward + receipts-after-persist + clientId dedup. For 10: presence heartbeats/sampled fan-out, partition messages by chatId, define orderId assignment |
| 07 | Notification Service | 2 | Medium | Passed | 9 | 2026-10-13 | Kafka per-channel topics + async workers + EB/jitter retry + DLQ + Redis claim-based idempotency + separate batched/sharded promo pipeline + strong estimates (TPP latency = bottleneck). For 10: proactive per-provider rate limiter, adapter interface, state at-least-once+idempotent guarantee |
| 08 | Photo Sharing | 3 | Medium | Not started | – | – | |
| 09 | Video Streaming | 3 | Hard | Not started | – | – | |
| 10 | File Storage & Sync | 3 | Hard | Not started | – | – | |
| 11 | Ride-Sharing | 4 | Hard | Not started | – | – | |
| 12 | Proximity Service | 4 | Medium | Not started | – | – | |
| 13 | Ticket Booking | 4 | Hard | Not started | – | – | |
| 14 | Web Crawler | 5 | Medium | Not started | – | – | |
| 15 | Search Autocomplete | 5 | Hard | Not started | – | – | |
| 16 | E-commerce Platform (capstone) | Capstone | Hard | Not started | – | – | |

## Summary

- **Attempted:** 7 / 16
- **Passed (7+):** 7 / 16
- **Average score:** 9.3

## Legend

- **Not started** — no canvas submitted yet.
- **In progress** — graded below 7; redraw and resubmit.
- **Passed** — scored 7 or higher. 🎉
