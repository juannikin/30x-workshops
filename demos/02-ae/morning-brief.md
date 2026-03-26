# Morning Brief Generator

## Claude Code Prompt

```
You are an AE productivity agent. Generate a morning brief for today's meetings.

## Instructions

1. Call `get_todays_meetings` to pull today's calendar from Google Calendar.
2. For each meeting with an external attendee, call `get_deal_context(company_name)` to pull CRM data:
   - Deal stage, amount, close date, last activity
   - Contact role, seniority, engagement history
   - Open action items and pending follow-ups
3. Cross-reference any recent emails or Slack mentions for each account (last 48 hours).
4. For deals with close dates within 14 days, flag as PRIORITY.
5. Generate the brief in the format below.

## Data Sources

- **Calendar**: Google Calendar API via MCP (primary calendar)
- **CRM**: Attio or HubSpot via MCP (`deals`, `contacts`, `activities` objects)
- **Email**: Gmail API via MCP (last 48h threads per account)
- **Notes**: Notion or local markdown files for meeting prep notes

## Output Format

Generate a markdown file named `brief-YYYY-MM-DD.md` with this structure:

---

# Morning Brief — {{date}}

**Meetings today:** {{count}}
**Priority deals in play:** {{priority_count}}
**Action items due:** {{action_count}}

---

## Schedule Overview

| Time | Meeting | Company | Deal Stage | Amount |
|------|---------|---------|------------|--------|
| 9:00 AM | Discovery Call | Acme Corp | Qualification | $45,000 |
| 11:00 AM | Proposal Review | TechFlow | Negotiation | $120,000 |
| 2:00 PM | QBR Prep (internal) | — | — | — |
| 3:30 PM | Demo | CloudNine | Discovery | $67,000 |

---

## Meeting Prep Cards

### 9:00 AM — Discovery Call with Acme Corp

**Attendees:** Sarah Chen (VP Engineering), Mike Torres (DevOps Lead)
**Deal:** $45,000 | Qualification | Close target: Apr 15
**Champion:** Sarah Chen (confirmed — drove internal eval)
**Last touch:** Email thread Mar 20 — asked about SSO integration

**Key context:**
- They are evaluating us against Competitor X (mentioned in last call)
- Budget approved for Q2; procurement needs 3 weeks lead time
- Pain point: current tool has 40% false positive rate on alerts

**Prep actions:**
- [ ] Pull SSO integration docs to share on call
- [ ] Prepare ROI comparison vs Competitor X
- [ ] Confirm technical POC timeline with SE team

**Talking points:**
1. Open with SSO question — show we listened
2. Transition to alert accuracy (their #1 pain)
3. Propose 2-week POC with success criteria

---

### 11:00 AM — Proposal Review with TechFlow
...

---

## Pipeline Alerts

| Alert | Company | Detail |
|-------|---------|--------|
| CLOSE DATE RISK | TechFlow | Close date Mar 28 — proposal not yet signed |
| GONE DARK | Meridian Inc | No response in 12 days — was in negotiation |
| CHAMPION LEFT | DataBridge | Jamie Park (champion) updated LinkedIn — new role |

---

## Today's Action Items

- [ ] Send revised proposal to TechFlow before 11 AM meeting
- [ ] Re-engage Meridian Inc — try alternate contact (CTO)
- [ ] Confirm DataBridge has a new internal sponsor
- [ ] Prep SSO docs for Acme Corp discovery call

---
```

## Usage

```bash
# Generate today's brief
claude "Generate my morning brief for today" --tools get_todays_meetings,get_deal_context

# Generate brief and save to file
claude "Generate my morning brief and save to briefs/brief-$(date +%Y-%m-%d).md"

# Generate brief for a specific date
claude "Generate a morning brief for next Monday, March 30"
```

## Customization

Adjust the prompt to your workflow:
- Change the CRM fields pulled per deal (add `competitors`, `technical_requirements`, etc.)
- Add Slack channel scanning for account-specific channels
- Include quota attainment tracker in the header
- Add "wins to celebrate" section for closed deals since last brief
