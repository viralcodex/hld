# Q05 · News Feed / Timeline

**Topic:** Fan-out on write vs read · the celebrity problem · ranking
**Tier:** 2 — Social graphs, feeds & messaging
**Difficulty:** Medium

---

## The brief

Design the **home timeline / news feed** for a service like **Twitter/X**. A user follows
many accounts; when they open the app they see a feed of recent posts from the people they
follow, newest-ish first. When someone they follow posts, it should appear in their feed
quickly.

The central tension: do you build each user's feed **when a post is written** (push it to
all followers) or **when the feed is read** (pull from everyone they follow)? That one
decision — and how you handle users with millions of followers — is the whole question.

### Functional requirements

- Post a tweet (text + optional media ref).
- Follow / unfollow a user.
- Get my **home timeline**: recent posts from accounts I follow.
- Get a **user timeline**: a single user's own posts.
- Feed ordered by recency (bonus: simple ranking/relevance).

### Non-functional requirements

- **Read-heavy:** timeline reads vastly outnumber posts.
- **Low latency:** timeline loads in **< 500 ms**.
- Feed can be **eventually consistent** — a post appearing a few seconds late is fine.
- High availability over strong consistency for the feed.

### Scale to design for

- **500 M** users, **200 M** daily active.
- **100 M** posts/day; average user follows **~200** accounts.
- Some accounts have **100 M+** followers (celebrities).

---

## What your diagram must show

1. The **write path** when a user posts — including how followers' feeds get updated.
2. The **read path** when a user opens their timeline.
3. Your **fan-out strategy**: fan-out-on-write (push), fan-out-on-read (pull), or a
   **hybrid** — and clearly why.
4. The **celebrity / hot-key problem** and your specific mitigation.
5. **Data model & stores**: posts, the social graph (followers), and the per-user feed
   (precomputed timeline cache?). Which store for each, and why.
6. How media is served (CDN/object store) and how the feed references it.

## Deliverable

Draw it in `canvas.excalidraw`, save, then tell me: **"Judge my design for Q5"**.
