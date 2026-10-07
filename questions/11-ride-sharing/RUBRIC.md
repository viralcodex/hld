# Rubric — Q11 Ride-Sharing

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Driver location streaming, nearby search, matching, live trip, trip lifecycle covered.

## Dimension 2 — Geo-indexing — THE KEY INSIGHT (3 pts)
- [ ] A real spatial index: **geohash** (prefix = region → range scan neighbours) or
      **quadtree / grid cells** — not "scan all drivers and compute distance".
- [ ] Explains how "near (lat,long)" becomes a cheap lookup (matching/adjacent cells).
- [ ] Index updates as drivers move (re-bucket on cell change); kept in a **fast in-memory
      geo store** (e.g. Redis geo), not a cold relational table.

## Dimension 3 — Location ingestion at scale (1.5 pts)
- [ ] Handles ~millions of pings/sec: lightweight location service, in-memory/geo store;
      durable history (if any) streamed async.
- [ ] Reasoning that a per-ping relational write won't scale.

## Dimension 4 — Matching & concurrency correctness (2 pts)
- [ ] Candidate selection from the geo index, then **atomic claim/lock** of the chosen
      driver so they can't be matched to two riders (the double-booking trap).
- [ ] Handles driver decline/timeout → next candidate.

## Dimension 5 — Real-time trip, data model & trade-offs (1.5 pts)
- [ ] Live location exchange via **websocket/push** during the trip.
- [ ] **Trip records** in a durable, consistent store (relational/strong) vs ephemeral
      location in-memory — distinction made.
- [ ] **Regional sharding** by geography; failure isolation; estimates present.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Ingestion, geo-query/match, and live-trip channels clearly separated and labelled.

## Common gaps to call out
- "Find nearby" by scanning all drivers / full-table distance computation.
- Writing every ping to a relational DB.
- No lock on match → one driver matched to multiple riders.
- Ignoring that location data is hot/ephemeral vs trips which must be durable.
- One global region with no sharding or failure isolation.

## Follow-ups to push with
- A rider in a dense downtown requests a ride — how do you find the 10 nearest drivers in ms?
- Two riders request at the same instant and the nearest driver is the same — who gets them?
- 10 M drivers ping every 4 s — where do those writes go and why not your SQL DB?
