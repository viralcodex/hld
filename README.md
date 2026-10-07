# HLD Dojo — High-Level / System Design, on a whiteboard

A LeetCode-style, self-paced curriculum for **high-level system design**. Each question
hands you a real product ("design a URL shortener", "design WhatsApp"), its requirements,
and the scale numbers. You **draw the architecture in [Excalidraw](https://excalidraw.com)**,
save it into the question folder, and then I (**GitHub Copilot**) grade your diagram
against a hidden rubric — the same way a senior interviewer would push on your design.

You don't write code here. You think in **boxes, arrows, and trade-offs**: clients, load
balancers, services, queues, caches, databases, replication, sharding, and the consistency
calls that hold it all together.

> **New here?** Read **`HOW-TO-APPROACH-HLD.md`** first — a repeatable method for cracking
> *any* system-design prompt. Then open **`ROADMAP.md`** and start at question 01.

---

## The loop

```text
read PROMPT.md  →  draw in Excalidraw  →  save canvas.excalidraw  →  ask me to judge  →  read feedback  →  redraw
```

### 1. Read the question

```bash
open questions/01-url-shortener/PROMPT.md
```

It gives you the scenario, the **functional** and **non-functional** requirements, the
**scale estimates** to design for, and exactly **what your diagram must show**.

### 2. Draw it

Open the starter canvas for that question in Excalidraw:

```bash
./judge/run.sh 1        # prints the question + opens its canvas.excalidraw
```

Drag it onto [excalidraw.com](https://excalidraw.com) (File → Open), or open it in VS Code
with the **Excalidraw extension** (`pomdtr.excalidraw-editor`). The canvas is pre-seeded
with the title and a few labelled lanes to get you going. Draw your boxes and arrows.

### 3. Save your work

Save/export back over `questions/01-url-shortener/canvas.excalidraw` (keep the `.excalidraw`
format so I can read your boxes and labels). A `.png` export also works if you prefer.

### 4. Get judged

Just tell me in chat:

> **"Judge my design for Q1"**

I read your canvas, score it against the rubric (requirements coverage, scaling, data
model, bottlenecks, trade-offs), and reply with **what's strong, what's missing, and the
follow-up questions an interviewer would ask**. Then I update your dashboard.

### 5. Check your dashboard

```bash
open progress/progress.md
```

---

## How it's organised

```text
design/
├── README.md                   ← you are here
├── HOW-TO-APPROACH-HLD.md       ← the method: how to crack any system-design prompt
├── ROADMAP.md                   ← the full curriculum, tier by tier
├── GLOSSARY.md                  ← the vocabulary (CAP, sharding, quorum, CDN, …)
├── judge/
│   ├── run.sh                   ← open a question + its canvas: ./judge/run.sh <n>
│   ├── new-canvas.sh            ← (re)generate a blank starter canvas for a question
│   └── HOW-JUDGING-WORKS.md     ← what the grade means and how I read your diagram
├── progress/
│   └── progress.md              ← your dashboard (I keep it updated as I grade)
└── questions/
    ├── 01-url-shortener/
    │   ├── PROMPT.md             ← the problem: scenario + requirements + what to draw
    │   ├── RUBRIC.md             ← the grading key (peek only if truly stuck)
    │   ├── canvas.excalidraw     ← YOU DRAW HERE
    │   └── meta.txt             ← topic + difficulty (the dashboard reads this)
    ├── 02-...
    └── 16-ecommerce-platform/   ← the capstone
```

Every question folder has the same shape:

| File | What it is |
|------|------------|
| `PROMPT.md` | Scenario, functional + non-functional requirements, scale numbers, deliverables |
| `canvas.excalidraw` | The whiteboard **you** draw on (pre-seeded with the title + lanes) |
| `RUBRIC.md` | The grading key I score against — treat as the answer sheet of last resort |
| `meta.txt` | Metadata (topic, difficulty) the dashboard reads |

---

## The learning path

Work top to bottom — each tier adds a new class of problem. See **`ROADMAP.md`** for a
one-line description of every question.

| Tier | Theme | Questions |
|------|-------|-----------|
| 1 | Fundamentals & building blocks | 01 – 04 |
| 2 | Social graphs, feeds & messaging | 05 – 07 |
| 3 | Media & large-file storage | 08 – 10 |
| 4 | Real-time, geo & transactions | 11 – 13 |
| 5 | Search & web-scale | 14 – 15 |
| Capstone | E-commerce platform (Amazon) | `16-ecommerce-platform` |

---

## Requirements

- **[Excalidraw](https://excalidraw.com)** — the browser version needs nothing installed.
  For an in-editor flow, install the VS Code extension **`pomdtr.excalidraw-editor`** so
  `.excalidraw` files open as a canvas.
- **bash** (macOS/Linux ship with it) — only used by the two small helper scripts.
- **Me** — the judging happens in chat. There's no auto-grader; a diagram needs a human
  (or an AI pretending to be a tough interviewer) to read it.

No build tools, no dependencies, no account required.

---

## How to get the most out of this

1. **Time-box like a real interview.** Give yourself ~40 minutes per question before you
   ask me to judge. The constraint is the point.
2. **Requirements first, boxes second.** The rubric rewards a design that *maps to the
   stated requirements and scale* — not the most boxes.
3. **Say the trade-off out loud.** In your canvas, drop a text note next to risky choices
   ("SQL for orders — need ACID; Cassandra for the feed — need write throughput"). I grade
   reasoning, not just topology.
4. **Redraw after feedback.** The second attempt is where the learning sticks. Ask me to
   re-judge.
5. **Stuck?** `RUBRIC.md` is readable — but you'll learn far more by drawing *something*
   wrong and letting me correct it than by copying the key.

Start here → **`questions/01-url-shortener/PROMPT.md`**
