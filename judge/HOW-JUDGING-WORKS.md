# How judging works

This dojo has **no auto-grader**. A diagram needs a reader who can follow boxes, arrows,
and the reasoning behind them — so **I (GitHub Copilot) am the judge**. You draw, you save,
you ask, I grade. Here's exactly what that looks like so there are no surprises.

## How to submit

1. Finish your diagram in Excalidraw.
2. Save it over the question's `canvas.excalidraw` (keep the `.excalidraw` format — it's
   JSON, so I can read every box label, text note, and arrow). A `.png` export in the same
   folder also works; I'll read the image instead.
3. In chat, say any of:
   - *"Judge my design for Q1"*
   - *"Grade questions/05-news-feed"*
   - *"Review my Uber diagram"*

That's it. I'll open the canvas, open that question's `RUBRIC.md`, and grade.

## What I read from your canvas

- **Boxes & labels** — your components (services, DBs, caches, queues, CDNs, LBs).
- **Arrows & their labels** — the request/data flow and direction.
- **Text notes** — your trade-off reasoning. *These matter.* A box labelled "Cassandra"
  earns little; a note "Cassandra for the feed — need high write throughput, eventual
  consistency is fine" earns a lot.
- **Grouping / lanes** — how you've separated client, edge, service, and data tiers.

Because I read labels, **write real words on your boxes and arrows**. An unlabelled
rectangle is just a rectangle.

## How I score — the 6 dimensions

Every rubric grades the same six dimensions, weighted per question:

| # | Dimension | What I look for |
|---|-----------|-----------------|
| 1 | **Requirements coverage** | Every functional requirement has a path through your diagram |
| 2 | **Core architecture** | A sane end-to-end happy path; right components in the right place |
| 3 | **Data model & storage** | Right store per access pattern; SQL vs NoSQL justified; schema sketched |
| 4 | **Scale & bottlenecks** | Design matches the scale numbers; caching/sharding/replication/queues where needed |
| 5 | **Trade-offs & consistency** | CAP choices named; failure modes & SPOFs addressed; hot-key/celebrity handled |
| 6 | **Clarity** | Labelled boxes and arrows; an interviewer could follow it unaided |

## What a grade looks like

I reply with a structured review, not just a number:

```text
SCORE: 7/10  —  Solid core, under-specified at scale.

STRONG
  ✓ Clean 302-redirect path; cache-aside in front of the KV store.
  ✓ Base-62 key generation with a justified key length.

MISSING / WEAK
  ✗ No sharding strategy — at 116K reads/s one DB won't hold. (dim 4)
  ✗ Consistency on create not addressed — two writers could collide. (dim 5)
  ✗ Analytics/click-count path absent though it's a functional req. (dim 1)

INTERVIEWER WOULD ASK
  • How do you guarantee short-code uniqueness without a round-trip per write?
  • What happens when a single short code goes viral (hot key)?

VERDICT: PASS (≥7). Redraw addressing the two consistency/scale gaps to reach 9+.
```

## The scale

- **9–10** — Senior/staff. Covers requirements, scales correctly, names trade-offs, handles
  failure and edge cases. Interview-strong.
- **7–8** — **PASS.** Solid, correct core with a couple of gaps a follow-up would expose.
- **5–6** — On the right track; missing scaling or consistency depth. Redraw.
- **≤4** — Core happy path incomplete or mismatched to the requirements. Reread the prompt
  and the method, then try again.

**PASS = 7+.** Clearing a question means a 7 or higher. I'll always tell you precisely what
to change to climb higher, and you're encouraged to **redraw and re-submit** — the second
pass is where it clicks.

## After grading

I update `progress/progress.md` with your score, the date, and a one-line note. Ask for
*"my dashboard"* any time.
