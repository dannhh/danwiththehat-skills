---
name: deep-analyze
description: >
  Deep data analysis skill for a given topic. Runs a structured, end-to-end analysis workflow:
  (1) clarify success metrics with the user, (2) build and confirm an analysis plan,
  (3) analyze overall picture and trends over time, (4) break down by user dimensions
  (demographics, behaviors, segments), (5) break down by product dimensions (touchpoints,
  features, funnel steps), (6) synthesize findings into product recommendations for improving
  user engagement. Use when the user asks to "deep analyze", "run a deep dive on",
  "analyze [topic] in depth", or wants a comprehensive breakdown of a product metric,
  feature performance, or user cohort. Works with BigQuery SQL via lt-memory or any data source.
---

# Deep Analyze

Structured workflow: scope → overall → trend → user breakdown → product breakdown → recommendations.

## Phase 0 — Scope & Success Metrics (always first)

Before any SQL, clarify with the user. Ask only what's missing:

| What to clarify | Examples |
|---|---|
| **Topic** | "CTR of home widget ranking", "checkout conversion", "D7 retention" |
| **Primary metric** | CTR, conversion rate, DAU, revenue, retention rate |
| **Guardrail metrics** | Don't tank X while improving Y |
| **Time window** | Last 30 days? Since launch? Around a specific event? |
| **Scope** | All users or a segment? All surfaces or one? |

After clarifying, output a **1-paragraph analysis plan** (phases + key questions per phase) and wait for confirmation before running queries.

---

## Phase 1 — Overall Picture

Top-level summary query:
- Primary metric (absolute value + rate)
- Volume (impressions / users / events) — establish scale
- Comparison: same period last week/month, or vs baseline

**Output:** 2–3 sentence headline finding. Example:
> "CTR is 10.0% over Feb 20–Mar 8 (6.75M impressions). This is +2.1pp vs the prior period, driven primarily by the Mar 1–3 campaign spike."

---

## Phase 2 — Trend Over Time

Query the metric daily (or weekly if low volume). Look for:
- **Direction**: flat / rising / declining / volatile
- **Change points**: annotate spikes/drops with known events (campaigns, launches, incidents)
- **Seasonality**: weekday vs weekend, monthly rhythms

**Output:** time-series table + 2–3 bullet observations.

---

## Phase 3 — User Dimension Breakdown

Break down by available user dimensions. Common ones:

| Dimension | What to look for |
|---|---|
| New vs returning | Do new users behave differently? |
| User tenure cohort | Do older users have higher/lower engagement? |
| Activity level | Power / casual / dormant — which segment drives the metric? |
| Demographics | Age group, city/region if available |
| Acquisition channel | Organic vs paid vs push vs email |

For each dimension:
- Metric per segment + volume
- Flag segments that **significantly** over/underperform (>2pp or >20% relative)
- Suppress segments with <500 impressions or <100 users (too noisy)

**Output:** one table per dimension, highlight top winners and laggards.

---

## Phase 4 — Product Dimension Breakdown

Break down by product/surface dimensions. Common ones:

| Dimension | What to look for |
|---|---|
| Entry point / surface | Home, push notification, email, search |
| Feature or item category | Gift type, content category, price tier |
| Funnel position | Impression → click → conversion → repeat |
| Rank / position | Does position 0 underperform vs position 3? |
| A/B variant (if applicable) | Which variant drives the metric? |

For each dimension:
- Metric per segment + volume
- Identify where drop-offs or outperformance **concentrate** — that's where to invest

**Output:** one table per dimension, note biggest leverage points.

---

## Phase 5 — Synthesis & Recommendations

Write structured findings:

```markdown
## Key Findings

1. [Overall headline — number + direction]
2. [User segment insight — who's driving / dragging]
3. [Product dimension insight — where opportunity concentrates]
4. [Anomaly or risk — needs investigation]

## Product Recommendations

### Quick wins (low effort, high confidence)
- [Action] → [Expected impact] · [Evidence from findings]

### Strategic bets (higher effort, bigger upside)
- [Action] → [Expected impact] · [Evidence from findings]

### Watch / investigate
- [Open question that needs more data or a follow-up query]
```

Every recommendation must link back to a specific finding from Phases 1–4.

---

## Execution Rules

- **Read lt-memory first** — load `lt-memory/_index.md` → relevant domain + knowledge files before any query
- **Never fabricate columns** — run `INFORMATION_SCHEMA` discovery if schema is unknown
- **Always include date filters** — bare table scans burn quota fast
- **One phase at a time** — present findings after each phase, confirm before proceeding
- **Save outputs** → `data/output/YYYY-MM-DD_<slug>/`
- **Save successful SQL patterns** → append to `lt-memory/patterns/`
- **Update lt-memory/knowledge/** with any new schema discoveries or gotchas

## Reference

- Detailed breakdown patterns and SQL templates: `references/framework.md`
