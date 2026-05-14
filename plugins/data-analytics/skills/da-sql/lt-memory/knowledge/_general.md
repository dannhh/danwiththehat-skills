# General SQL & BigQuery Knowledge

> Cross-cutting gotchas, BQ access patterns, and SQL rules.
> Update this file when you discover general rules that apply across multiple domains.

---

## BigQuery Setup

```bash
# Set these before every BQ command
export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3.9
export PATH="/path/to/google-cloud-sdk/bin:$PATH"

# Job project (billing): REDACTED
# Data project (where data lives): varies per query
```

**Configure your projects:**
- Job/billing project: `REDACTED`
- Data project: _(varies — specify per query)_

---

## SQL Gotchas

### Reserved Words
Always backtick-quote BigQuery reserved words used as column/table names:
- `date`, `time`, `timestamp`, `user`, `type`, `value`, `status`, `month`, `year`

### Date Filtering
- Always include a date filter — bare table scans on large tables exceed quota fast
- Use partition columns when available (check domain file)
- BQ DATE type: `WHERE date_col = '2025-01-15'`
- BQ DATETIME type: `WHERE datetime_col BETWEEN '2025-01-01' AND '2025-01-31'`
- February: 28 days in non-leap years, 29 in leap years. Never use Feb 29 in non-leap years.

### Aggregation
- `COUNT(DISTINCT user_id)` for unique user counts — not `COUNT(*)`
- `SUM(amount)` for totals — verify the column is NOT already pre-aggregated
- When a table is a daily snapshot (one row per user per day), use `COUNT(DISTINCT user_id)` filtered to the month, not `SUM(user_count)`

### NULL handling
- `SUM(col)` returns NULL if all values are NULL — use `COALESCE(SUM(col), 0)`
- `COUNT(col)` ignores NULLs — use `COUNT(*)` to count all rows

---

## BQ Access Notes

> Add entries here as you discover access issues.

| Dataset | Status | Notes |
|---------|--------|-------|
| _(empty — add as you discover)_ | | |

---

## Dashboard Style Guidelines

Always apply these rules when building HTML dashboards:

- **Background:** White (`#ffffff` / `#f8f9fa` for cards)
- **Color theme:** Black · Deep pink · Blue · Red
  - Primary: `#111827` (near-black text)
  - Accent 1: `#db2777` (deep pink) — key metrics, highlights
  - Accent 2: `#2563eb` (blue) — charts, links
  - Accent 3: `#dc2626` (red) — alerts, negative metrics
  - Supporting: `#64748b` (slate gray) for labels/secondary text
- **SQL in dashboards:** Always include SQL per section, but **hidden by default**. Use a toggle button ("Show SQL ▼") that expands/collapses a `<pre>` block on click.

```html
<!-- SQL toggle pattern -->
<button class="sql-toggle" onclick="toggleSql(this)">Show SQL ▼</button>
<pre class="sql-block" style="display:none">SELECT ...</pre>
<script>
function toggleSql(btn) {
  const pre = btn.nextElementSibling;
  const hidden = pre.style.display === 'none';
  pre.style.display = hidden ? 'block' : 'none';
  btn.textContent = hidden ? 'Hide SQL ▲' : 'Show SQL ▼';
}
</script>
```

---

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `Unrecognized name: COLUMN` | Column doesn't exist in table | Check schema with INFORMATION_SCHEMA |
| `Could not cast literal "2026-02-29"` | Feb 29 in non-leap year | Use Feb 28 |
| `Permission denied` | Dataset is restricted | Note in lt-memory/errors/, move on |
| `Syntax error: Expected end of input but got...` | BQ reserved word not backtick-quoted | Add backticks |
| `Table not found` | Wrong dataset or table name | Check with INFORMATION_SCHEMA.TABLES |
