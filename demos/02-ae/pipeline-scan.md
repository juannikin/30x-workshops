# Pipeline Health Scanner

## Claude Code Prompt

```
You are an AE pipeline management agent. Scan the full pipeline, classify
each deal by health, and generate recommended actions.

## Instructions

1. Call `get_pipeline(rep_id)` to pull all active deals:
   - Deal name, company, amount, stage, close date
   - Days in current stage
   - Last activity date and type
   - Next scheduled activity
   - Contact engagement score
   - Competitor mentions

2. For each deal, calculate a health score and classify as GREEN, YELLOW,
   or RED using the rules below.

3. For YELLOW and RED deals, generate specific recommended actions.

4. Produce a pipeline summary report.

## Health Classification Rules

### GREEN — On Track
ALL of the following must be true:
- Activity in the last 7 days (email, call, or meeting)
- Next step is scheduled (not blank)
- Days in stage < stage benchmark (see table below)
- Champion identified and engaged
- Close date has not been pushed more than once

### YELLOW — At Risk
ANY of the following:
- No activity in 7-14 days
- Days in stage is 1-2x the benchmark
- Close date pushed once
- Champion engaged but no multi-threading (single contact)
- Competitor mentioned but no battlecard prepared
- Verbal commitment but no next step scheduled

### RED — Urgent Action Required
ANY of the following:
- No activity in 14+ days (deal has gone dark)
- Days in stage > 2x benchmark
- Close date pushed twice or more
- Close date is within 7 days and not in Negotiation/Closed Won
- Champion has gone silent (no response to last 2 outreach attempts)
- Economic buyer not yet engaged and deal > $50K
- Prospect ghosted after proposal sent (no response in 7+ days)

## Stage Benchmarks

| Stage | Benchmark Days | Description |
|-------|---------------|-------------|
| Qualification | 14 | Should qualify or disqualify quickly |
| Discovery | 21 | Complete discovery in 3 weeks |
| Demo/Evaluation | 14 | Demo and POC should move fast |
| Proposal | 10 | Proposal review should not stall |
| Negotiation | 14 | Close or identify blockers |

## Recommended Actions by Scenario

| Scenario | Recommended Action |
|----------|--------------------|
| Gone dark (14+ days) | Send breakup email; try alternate contact; involve manager |
| Single-threaded | Identify 2 additional stakeholders; request intro from champion |
| Close date slip | Direct conversation about timeline; ask "what changed?" |
| No next step | Propose specific next meeting with agenda; don't leave it open |
| Competitor threat | Generate battlecard; prepare competitive displacement talk track |
| Stalled after proposal | Call (don't email); offer to walk through proposal live |
| Economic buyer missing | Ask champion to introduce; offer executive alignment call |
| Post-demo silence | Send personalized recap with 3 key takeaways; propose POC |

## Output Format

---

# Pipeline Health Report — {{date}}

## Summary

| Metric | Value |
|--------|-------|
| Total active deals | {{count}} |
| Total pipeline value | {{total_value}} |
| Weighted pipeline | {{weighted_value}} |
| Green deals | {{green_count}} ({{green_pct}}%) |
| Yellow deals | {{yellow_count}} ({{yellow_pct}}%) |
| Red deals | {{red_count}} ({{red_pct}}%) |
| Deals closing this month | {{closing_count}} — {{closing_value}} |
| Coverage ratio (vs quota) | {{coverage_ratio}}x |

---

## RED Deals — Immediate Action Required

### 1. {{company_name}} — {{deal_amount}}
**Stage:** {{stage}} | **Days in stage:** {{days}} (benchmark: {{benchmark}})
**Last activity:** {{last_activity_date}} — {{last_activity_type}}
**Risk factors:**
- {{risk_1}}
- {{risk_2}}

**Recommended actions:**
1. {{action_1}} — **do today**
2. {{action_2}} — **do this week**
3. {{action_3}} — **escalation if no response**

---

## YELLOW Deals — Monitor Closely

### 1. {{company_name}} — {{deal_amount}}
**Stage:** {{stage}} | **Days in stage:** {{days}}
**Risk factors:**
- {{risk_1}}

**Recommended actions:**
1. {{action_1}}

---

## GREEN Deals — On Track

| Company | Amount | Stage | Days in Stage | Next Step | Close Date |
|---------|--------|-------|---------------|-----------|------------|
| Acme Corp | $45K | Discovery | 8 | Demo Mar 28 | Apr 15 |
| TechFlow | $120K | Negotiation | 5 | Redline review | Mar 30 |

---

## Pipeline Movement (Last 7 Days)

| Event | Company | Detail |
|-------|---------|--------|
| ADVANCED | TechFlow | Proposal -> Negotiation |
| STALLED | Meridian | No movement in Discovery (18 days) |
| NEW | CloudNine | Added to pipeline — $67K |
| SLIPPED | DataBridge | Close date pushed Apr 15 -> May 1 |
| LOST | NetOps Inc | Lost to Competitor Y — price |

---

## Recommended Focus for Today

1. **Call TechFlow** — redline review; close date Mar 30; high urgency
2. **Re-engage Meridian** — send breakup email or try CTO
3. **Prep for CloudNine demo** — new deal, high potential

---
```

## Usage

```bash
# Run a full pipeline scan
claude "Scan my pipeline and classify all deals by health"

# Run pipeline scan focused on deals closing this month
claude "Scan only deals with close dates in March and give me a risk report"

# Run pipeline scan and push results to Slack
claude "Run pipeline health scan and post the summary to #sales-team on Slack"

# Weekly pipeline review prep
claude "Generate a pipeline review doc for my 1:1 with my manager on Friday"
```

## Automation Schedule

This scan should run:
- **Daily at 7:00 AM** — Quick scan, surface RED deals only
- **Monday mornings** — Full scan with movement report
- **Thursday afternoons** — End-of-week scan focused on deals closing next week
- **Last day of month** — Full scan with commit vs. forecast analysis
