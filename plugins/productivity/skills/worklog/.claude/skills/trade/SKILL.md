---
name: trade
description: |
  Use this skill when the user wants to journal a trade or review their trading:
  planning a trade before entry, recording an entry or exit, a setup they skipped,
  or stats by setup / week. Triggers: "/trade", "trade journal", "log a trade",
  "vừa vào lệnh", "đóng lệnh", "nhật ký trade", "ghi lệnh", "bỏ lệnh",
  "review trade tuần này", "setup nào thắng nhiều". One note per trade in the
  Obsidian vault, plus a line in today's daily note.
---

# Trade

Three modes: **log** (default) → create or update one trade note. **skip** → record a setup that was seen but not taken. **review** → stats and lessons over past trades.

> **Vault:** resolve `<VAULT>` and read `<VAULT>/_CLAUDE.md` first — see "Vault" in the worklog `CLAUDE.md`. The trade frontmatter schema lives there; this skill does not restate it.

## Log Mode

### 1. Parse

Pull what the user gave: symbol, direction, setup, timeframe, session, entry / SL / TP, risk %, account (`demo` default), and the reasoning. Then decide which stage it is:

| Stage | Signal | `status` |
|---|---|---|
| Plan | "định vào", "plan", levels but no fill | `planned` |
| Open | "vừa vào lệnh", "entered" | `open` |
| Close | "đóng lệnh", "hit TP / SL", a result | `closed` |

If an `open` or `planned` note for the same symbol exists in `<VAULT>/wiki/trades/` from the last few days, **update that note** instead of creating a new one. Ask if it is ambiguous.

Ask once, briefly, only for what changes the record: the stop (no stop means `result_r` can't be computed), and on close, whether the plan was followed. Never invent levels or reasons.

### 2. Setup link

`setup` must link a concept note (`[[Fair Value Gap]]`, `[[Break of Structure]]`). Search `<VAULT>/index.md` and `<VAULT>/wiki/concepts/` by every plausible name first. If none exists, create a stub per the vault rules (tag `trading`, `confidence: stated`) and suggest `/study <setup>` in the learning workspace.

### 3. Write

New trade: `<VAULT>/wiki/trades/<YYYY-MM-DD> - <SYMBOL> <Setup short> <Long|Short>.md` from `<VAULT>/templates/trade.md`, replacing every `{{...}}` placeholder.

- `## Plan` holds the reasoning as given *before* entry. Once the trade is open, never rewrite it; later thoughts go under `## Execution` or `## Review`
- On close compute `result_r = (exit − entry) / (entry − sl)` for longs (mirror for shorts), rounded to 0.1. Show the arithmetic in `## Execution`
- Screenshots: if the user gives an image path, copy it to `<VAULT>/raw/_attachments/<YYYY-MM-DD> <symbol>-<tf>.png` and embed it under `## Charts`
- Times are UTC+7 unless the user says otherwise

### 4. Propagate

- Append one line under `## Trading` in `<VAULT>/wiki/daily/<YYYY-MM-DD>.md` (create the daily note from its template if missing; add the heading if an older note lacks it):

  ```markdown
  - 09:40 📈 [[2026-10-31 - XAUUSD FVG Long]] planned, risk 0.5%
  - 13:15 ✅ [[2026-10-31 - XAUUSD FVG Long]] closed +1.8R, followed plan
  - 13:15 ❌ [[2026-10-31 - EURUSD OB Short]] closed −1R, entered early
  ```

- Append `## [YYYY-MM-DD] trade | <note name> (<status>)` to `<VAULT>/log.md`
- Do **not** add trades to `index.md`; [[Trading]] is their entry point

### 5. Confirm

One line: what was recorded, and the R if closed.

## Skip Mode

A setup that formed but wasn't taken ("thấy setup nhưng không vào"). Same note with `status: skipped`, no entry levels needed, and `## Review` saying why. Skipped setups count in review, so the journal isn't only the trades that were taken.

## Review Mode

Triggered by "review", "tuần này", "this month", "setup nào...", "/trade review".

1. Read every note in `<VAULT>/wiki/trades/` in range (default: last 7 days) from its frontmatter.
2. Report in chat:
   - trades, win rate, average R, total R; demo and live kept apart
   - the same per `setup`, per `session`, and `followed_plan: true` vs `false`
   - repeated lessons from `## Review` sections
   - skipped setups and, where the user later noted the outcome, how they would have done
3. Be honest about sample size: under ~20 trades per setup, say the numbers can't separate skill from luck yet.

Save only if asked: append a `## Trading` section to `<VAULT>/wiki/reviews/<YYYY>-W<ww>.md` (create with review frontmatter and preamble if missing), index the review, log it. A lesson the owner wants to keep goes to the setup's concept note or the [[Trading]] project's `## Key Decisions`, with the trades cited as `[[links]]`.

## Rules

- Record, don't advise: no trade signals, no "you should enter", no predictions about price
- Never invent levels, fills, or reasons; leave a field empty if unknown
- Never edit `## Plan` after entry, and never change a closed result unless the user corrects it
- Daily notes stay append only; never touch `.obsidian/`
