# Deep Analyze — Framework Reference

## Table of Contents

1. [Success Metric Selection Guide](#1-success-metric-selection-guide)
2. [Dimension Discovery Patterns](#2-dimension-discovery-patterns)
3. [SQL Patterns by Phase](#3-sql-patterns-by-phase)
4. [Recommendation Writing Guide](#4-recommendation-writing-guide)
5. [Common Pitfalls](#5-common-pitfalls)

---

## 1. Success Metric Selection Guide

### Choosing the right primary metric

| Topic type | Typical primary metric | Common guardrails |
|---|---|---|
| Recommendation / ranking | CTR, conversion rate | Impression volume, diversity of shown items |
| Feature adoption | DAU/MAU using feature, feature retention | Session length, overall DAU |
| Monetization | Revenue, GMV, conversion rate | Refund rate, customer satisfaction |
| Retention | D1/D7/D30 retention, churn rate | New user acquisition cost |
| Engagement | Sessions/user, time in app, actions/session | Notification opt-out rate |

### When to use rate vs absolute

- **Rate (CTR, conversion %)**: Use when comparing across segments with different volumes
- **Absolute (clicks, revenue)**: Use alongside rate to understand business impact scale
- Always report both: `12.3% CTR on 450k impressions = 55k clicks`

---

## 2. Dimension Discovery Patterns

### Discovering available user dimensions

If unsure which user dimensions exist, query:

```sql
SELECT column_name, data_type
FROM `<project>.<dataset>.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = '<user_table>'
ORDER BY column_name
```

### Common user dimension SQL patterns

**New vs returning:**

```sql
IF(user_first_seen_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY), 'new', 'returning')
```

**Activity level buckets (example thresholds — adjust to your domain):**

```sql
CASE
  WHEN txn_count_30d >= 10 THEN 'power'
  WHEN txn_count_30d >= 2  THEN 'casual'
  ELSE 'dormant'
END AS activity_level
```

**Tenure cohort:**

```sql
DATE_DIFF(event_date, user_first_seen_date, DAY) AS user_age_days,
CASE
  WHEN DATE_DIFF(event_date, user_first_seen_date, DAY) < 7   THEN '0-7d'
  WHEN DATE_DIFF(event_date, user_first_seen_date, DAY) < 30  THEN '7-30d'
  WHEN DATE_DIFF(event_date, user_first_seen_date, DAY) < 90  THEN '30-90d'
  ELSE '90d+'
END AS tenure_cohort
```

---

## 3. SQL Patterns by Phase

### Phase 1 — Overall (BigQuery sharded event table example)

```sql
SELECT
  variant,
  SUM(CAST(is_impression AS INT64))  AS impressions,
  SUM(CAST(is_click AS INT64)) AS clicks,
  ROUND(SUM(CAST(is_click AS INT64)) / NULLIF(SUM(CAST(is_impression AS INT64)), 0) * 100, 2) AS ctr_pct,
  COUNT(DISTINCT user_id) AS unique_users
FROM `<project>.<dataset>.<table_*>`
WHERE _TABLE_SUFFIX BETWEEN '<start_yyyymmdd>' AND '<end_yyyymmdd>'
GROUP BY variant
ORDER BY impressions DESC
```

### Phase 2 — Daily Trend

```sql
SELECT
  PARSE_DATE('%Y%m%d', _TABLE_SUFFIX) AS dt,
  variant,
  SUM(CAST(is_impression AS INT64))  AS impressions,
  ROUND(SUM(CAST(is_click AS INT64)) / NULLIF(SUM(CAST(is_impression AS INT64)), 0) * 100, 2) AS ctr_pct
FROM `<project>.<dataset>.<table_*>`
WHERE _TABLE_SUFFIX BETWEEN '<start>' AND '<end>'
  AND variant IN (<variants>)
GROUP BY dt, variant
ORDER BY dt, variant
```

### Phase 3 — Segment breakdown template

```sql
WITH events AS (
  SELECT
    user_id,
    <metric_numerator> AS num,
    <metric_denominator> AS denom,
    <dimension_col> AS segment
  FROM <table>
  WHERE <date_filter>
)
SELECT
  segment,
  COUNT(DISTINCT user_id) AS users,
  SUM(denom) AS total_denom,
  ROUND(SUM(num) / NULLIF(SUM(denom), 0) * 100, 2) AS rate_pct
FROM events
GROUP BY segment
HAVING total_denom >= 500   -- noise filter
ORDER BY rate_pct DESC
```

### Phase 4 — Funnel position pattern

```sql
SELECT
  CAST(position AS INT64) AS position,
  variant,
  SUM(CAST(is_impression AS INT64))  AS impressions,
  ROUND(SUM(CAST(is_click AS INT64)) / NULLIF(SUM(CAST(is_impression AS INT64)), 0) * 100, 2) AS ctr_pct
FROM `<project>.<dataset>.<table_*>`
WHERE _TABLE_SUFFIX BETWEEN '<start>' AND '<end>'
  AND CAST(position AS INT64) <= 9
GROUP BY position, variant
ORDER BY variant, position
```

---

## 4. Recommendation Writing Guide

### Strength of evidence scale

| Label | Threshold | Example |
|---|---|---|
| **High confidence** | >10k impressions, >2pp or >20% relative delta, consistent across days | "Variant A CTR 10.0% vs B 9.9% on 6M+ impressions" |
| **Medium confidence** | 1k–10k impressions, or pattern visible but with some noise | "Category X: variant B CTR 2.6× A on 97k impr" |
| **Low confidence / hypothesis** | <1k impressions or single-day observation | "Item Y: variant B CTR 33% on only 169 impr" |

### Recommendation format

```markdown
**[Action verb] [specific action]**
→ Expected impact: [metric] improves by [estimated magnitude]
· Evidence: [Phase N finding, segment, numbers]
· Confidence: High / Medium / Low
· Effort: Low (1 sprint) / Medium (1 quarter) / High (multi-quarter)
```

### Common recommendation archetypes

| Observation | Recommendation archetype |
|---|---|
| Model-based ranker beats bandit on new items | Increase model traffic allocation for newly-launched items |
| Bandit beats model on established items | Preserve bandit for high-volume established inventory |
| Position 0 underperforms | Investigate top-slot ranking logic; consider re-ranking or diversity injection |
| Power users drive 80% of engagement | Build power-user specific features; monitor casual user conversion |
| One touchpoint dominates | Invest in under-developed touchpoints as growth levers |
| CTR spike on campaign days | Replicate campaign mechanics in organic ranking |

---

## 5. Common Pitfalls

| Pitfall | How to avoid |
|---|---|
| Confusing correlation with causation | Note "associated with" not "causes"; suggest A/B test to confirm |
| Reporting rates without volume | Always show impressions/users alongside rate |
| Comparing unequal time windows | Use same number of days for all comparisons |
| Ignoring data lag | Check pipeline lag (some event tables land days late; check the domain file) |
| Multiple testing: data-mining for significance | Pre-specify hypotheses in Phase 0; treat post-hoc findings as hypotheses |
| Survivorship bias in cohort analysis | Use event-time anchoring, not calendar-time |
