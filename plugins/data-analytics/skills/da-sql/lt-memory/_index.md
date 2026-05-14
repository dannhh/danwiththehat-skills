# lt-memory Index

> Catalog of everything learned. Read this FIRST before writing SQL.

## How to use this index

1. Scan the tables below for relevant entries
2. Load the linked files before querying
3. After a session, add new entries here

---

## Domains (Schema Knowledge)

> Auto-populated from schema discovery. See `lt-memory/domains/`.

| Domain / Table | File | Key Tables | Last Updated |
|----------------|------|------------|--------------|
| DNN Ranking (Reward & Voucher) | `domains/dnn-ranking.md` | `REDACTED.REDACTED.REDACTED_*`, `REDACTED` | 2026-03-09 |
| TLAC (Chatbot / GenAI) | `domains/tlac.md` | `REDACTED.REDACTED.fact_chatbot_event`, `REDACTED.REDACTED.genai_raw`, `REDACTED.REDACTED.CONVERSATION_ANALYSIS` | 2026-03-16 |

---

## Knowledge (Learned Gotchas)

> Human-curated corrections. See `lt-memory/knowledge/`.

| Topic | File | What's in it |
|-------|------|-------------|
| General | `knowledge/_general.md` | BQ access, SQL gotchas, reserved words |
| DNN Ranking | `knowledge/dnn-ranking.md` | `voucher_service_name` (not `service_name`), dedup pattern, REDACTED anomaly, pipeline lag |
| TLAC | `knowledge/tlac.md` | genai_raw NULL filter, partial quality labeling, CONVERSATION_ANALYSIS JSON response, reserved word `rows`, topic/quality distributions |

---

## Patterns (Reusable SQL)

> SQL queries that worked. See `lt-memory/patterns/`.

| Pattern | File | What it answers |
|---------|------|----------------|
| DNN vs MAB CTR comparison | `patterns/2026-03-13_dnn-mab-ctr-comparison.md` | Overall CTR, daily trend, position CTR, gift cohort — Feb20–Mar08 |
| TLAC User Engagement | `patterns/2026-03-16_tlac-engagement.md` | MEU, monthly retention, stickiness, churn by topic, entry source — Dec25–Mar26 |

---

## Errors

> Access issues, schema mismatches. See `lt-memory/errors/`.

| Error | File | Description |
|-------|------|-------------|
| _(empty — add as you encounter errors)_ | | |
