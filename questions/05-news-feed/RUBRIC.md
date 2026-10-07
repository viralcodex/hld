# Rubric — Q05 News Feed / Timeline

Grade out of 10. PASS = 7+.

## Dimension 1 — Requirements coverage (1.5 pts)
- [ ] Post, follow/unfollow, home timeline, user timeline all have paths.
- [ ] Ordering by recency (ranking as a bonus).

## Dimension 2 — Fan-out strategy — THE KEY INSIGHT (3 pts)
- [ ] Names **fan-out-on-write (push)**: on post, insert the post id into each follower's
      precomputed feed. Fast reads, expensive writes, heavy for high-follower accounts.
- [ ] Names **fan-out-on-read (pull)**: build the feed at read time by merging followees'
      recent posts. Cheap writes, expensive reads.
- [ ] Chooses a **hybrid** (push for normal users, pull for celebrities) **with reasoning** —
      this is the senior answer.

## Dimension 3 — Celebrity / hot-key problem (1.5 pts)
- [ ] Explicitly identifies that pushing a celebrity post to 100 M feeds is infeasible/slow.
- [ ] Mitigation: don't fan-out celebrity posts; **merge them in at read time** for followers.
      (Or other justified approach.)

## Dimension 4 — Data model & storage (2 pts)
- [ ] **Posts** store (id, authorId, text, mediaRef, ts) — NoSQL/wide-column fits the scale.
- [ ] **Social graph** (follower/followee) — store/index that answers "who follows X" and
      "who does X follow" quickly.
- [ ] **Precomputed feed** per user in a fast store (Redis list / cache) of post ids.
- [ ] Media bytes in object storage + CDN; feed holds references, not blobs.

## Dimension 5 — Scale, trade-offs & async (1.5 pts)
- [ ] Fan-out done **asynchronously via a queue + workers**, not inline with the post request.
- [ ] Eventual consistency accepted for the feed; estimates (posts/s, fan-out writes/s) present.
- [ ] Sharding of posts/feed by user id; caching of hot timelines.

## Dimension 6 — Clarity (0.5 pt)
- [ ] Write (fan-out) path and read (assemble) path both labelled and followable.

## Common gaps to call out
- Pure push with no celebrity handling → fan-out storm, unbounded write amplification.
- Pure pull at this scale → every timeline read fans out to 200 DB queries.
- Fan-out done synchronously in the post request → slow posts, back-pressure.
- Storing media in the feed/posts DB instead of object storage + CDN.
- No social-graph index → can't answer "who follows me" efficiently.

## Follow-ups to push with
- A celebrity with 100 M followers posts — walk me through exactly what happens.
- A user with a 500 ms budget opens their feed — where does the time go?
- How does a brand-new follow back-fill (or not) the follower's existing feed?
