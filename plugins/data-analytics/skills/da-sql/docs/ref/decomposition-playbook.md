# Question Decomposition Playbook

> Patterns for breaking broad executive questions into concrete SQL queries.
> Built from real experience answering investor-grade questions.

## Core Principle

**One SQL query = one metric + one time range + one table.**

Broad questions require multiple queries across multiple tables. The DA's job is to decompose, route, execute, and synthesize.

---

## Question Types & Decomposition Patterns

### Type 1: Product Adoption

**Trigger:** "How is [product] doing?", "What's [product] adoption?", "Is [product] working?"

**6 dimensions to query:**

| Dimension | What to ask | Why it matters |
|-----------|-------------|----------------|
| **Scale** | MAU trend (monthly, 12 months) | Growth trajectory |
| **Frequency** | DAU + WAU for recent month | Habit formation |
| **Depth** | Sessions/user, events/session | Engagement quality |
| **Funnel** | Registered → Active (activation rate) | Conversion efficiency |
| **Context** | Product vs sub-feature penetration | Feature-level health |
| **Retention** | Month-over-month returning users | Stickiness |

**Computed metrics** (calculate from raw data, not queried directly):

- DAU/MAU ratio (daily engagement intensity, good = >20%)
- WAU/MAU ratio (weekly engagement, good = >50%)
- Activation rate (active/registered, good = >30%)
- Feature penetration (sub-feature users / total product users)

---

### Type 2: Business Health Overview

**Trigger:** "How's the business?", "YoY comparison?", "Business review?"

**Query each BU's primary metric:**

| Area | Metric to Query |
|------|----------------|
| Transactions | Total volume + GMV trend |
| Revenue | Revenue by product/segment |
| Users | MAU trend by product |
| Engagement | Active users / registered users |

**Synthesis pattern:** Lead with total volume, then revenue, then each product's growth story. Highlight trends, not just snapshots.

---

### Type 3: Revenue Breakdown

**Trigger:** "Revenue by business line?", "Where does money come from?", "Margin structure?"

**Query revenue/value from each revenue-generating area:**

- Revenue by product (monthly, quarterly)
- Transaction value vs. revenue (to understand take rates)
- YoY and QoQ comparisons for each line

**Note:** Some tables return GMV or disbursement instead of net revenue. Note the difference when presenting.

---

### Type 4: Competitive Position

**Trigger:** "Market share?", "How do we compare to competitors?"

**What your data CAN provide:** Your own metrics (volume, users, value)
**What your data CANNOT provide:** Competitor data (supplement with web research)

Query your metrics first, then supplement with external research via the `deep-research` skill.

---

### Type 5: Risk Assessment

**Trigger:** "Default rate?", "What risks?", "Delinquency?", "Fraud rate?"

Query risk-related tables and note any restricted/blocked datasets in `lt-memory/errors/`.

---

## Multi-Table Strategy

Some questions need data from **complementary tables** showing different angles:

| Question | Primary Table | Complementary Table | What complement adds |
|----------|---------------|---------------------|---------------------|
| User engagement | Activity events | Session table | Depth vs. breadth |
| Revenue health | Revenue table | Transaction table | Revenue alongside volume |
| Product funnel | Registration table | Activity table | Activation rate |
| Platform health | Aggregate metrics | Individual product tables | Drill-down from aggregate |

---

## Parallel Execution

For multi-metric questions, **execute all queries in parallel**, then collect all results:

```bash
# Submit N queries in parallel background jobs
# Collect results after all complete
```

This is dramatically faster than sequential execution.

---

## Investor Question Framework

Investor questions are hardest because they:

1. Require **multiple metrics across multiple tables**
2. Demand **computed ratios** (not just raw numbers)
3. Need **trend analysis** (not just snapshots)
4. Require **honest interpretation** (not just data dump)

**Framework for any investor question:**

1. Identify the **underlying concern** (growth? profitability? risk? moat?)
2. Map to **question type** above
3. Decompose into **6-10 sub-queries**
4. Execute in **parallel**
5. Compute **derived metrics**
6. Synthesize into a **board-level narrative** with honest assessment
