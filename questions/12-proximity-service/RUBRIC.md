# Rubric — Q12 Proximity Service

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Nearby search (radius / k-nearest, category filter), place details, owner updates covered.

## Dimension 2 — Spatial index — THE KEY INSIGHT (3 pts)
- [ ] A concrete index: **geohash**, **quadtree**, or uniform **grid**; justified for
      **static, read-heavy** data (vs ride-sharing's constantly-moving points).
- [ ] Search = look up the user's cell **+ neighbouring cells**, then distance-filter & rank.
- [ ] Handles the radius-vs-cell-size issue (query multiple cells to cover the radius);
      quadtree adapts to density (dense cities vs sparse rural).

## Dimension 3 — Data model & storage (1.5 pts)
- [ ] Places store: `placeId → {name, lat, long, geohash/cell, category, rating, detailsRef}`.
- [ ] Index can be **precomputed** and replicated widely because writes are rare.

## Dimension 4 — Read scaling & caching (2 pts)
- [ ] Heavy **caching** of hot regions/popular queries (billions of reads/day).
- [ ] **Read replicas**; place details/photos via CDN.
- [ ] Geographic **sharding/replication** of the index.

## Dimension 5 — Ranking, updates & trade-offs (1.5 pts)
- [ ] Ranking by distance + rating/popularity mentioned.
- [ ] Rare writes → index rebuild/update is cheap and can be async; staleness acceptable.
- [ ] Contrasts with Q11: here data is static → optimise for read fan-out, not write ingest.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Index lookup → filter → rank path clearly drawn.

## Common gaps to call out
- Scanning all 200 M places and computing distance per query.
- Treating it like ride-sharing (optimising for high-frequency location writes).
- No caching despite billions of reads.
- Fixed grid that behaves terribly in dense vs sparse areas (quadtree better; or note it).
- Ignoring that a radius can span multiple cells.

## Follow-ups to push with
- The user asks for places within 5 km but your cell is 1 km — which cells do you query?
- A dense city has 50k places in one cell — how does your index cope?
- Reads dominate 1000:1 — what's precomputed and what's cached?
