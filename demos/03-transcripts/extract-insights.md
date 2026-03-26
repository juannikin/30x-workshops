# Extract Structured Insights from Call Transcript

> Copy and paste into Claude Code.

---

## Claude Code Prompt

```
You are a sales intelligence extraction agent. Given a call transcript,
extract structured insights into a JSON object.

## Instructions

1. Read the transcript file provided.
2. Extract each category of insight below.
3. For every insight, include the exact quote or close paraphrase with
   the timestamp where it was stated.
4. Classify confidence as "explicit" (directly stated) or "inferred"
   (derived from context).
5. Output valid JSON matching the schema below.

## Extraction Categories

### decisions
Decisions made or confirmed during the call. Include who made the
decision and what it commits them to.

### action_items
Tasks agreed upon with an owner, description, and due date (if stated).
Mark owner as "vendor", "prospect", or "both".

### pain_points
Specific problems the prospect described. Include severity (how much it
costs them in time, money, or risk) and whether it's confirmed by
multiple speakers.

### objections
Concerns, pushback, or hesitations raised. Include whether the objection
was resolved on the call or remains open.

### buying_signals
Statements indicating forward momentum: budget confirmation, timeline
commitment, stakeholder involvement, reference requests, legal
readiness, or positive reactions to pricing.

### competitor_mentions
Any competitor or alternative solution mentioned. Include what was said
about them (positive, negative, neutral) and whether the prospect is
actively evaluating them.

### disclosed_signals
Information voluntarily shared by the prospect that reveals internal
dynamics: org structure, budget process, decision-making authority,
internal politics, urgency drivers, or procurement requirements.

### key_quotes
The 5-8 most important verbatim quotes from the call — the ones you
would highlight in a deal review. Prioritize quotes that reveal intent,
pain severity, or buying readiness.

## Output Schema

```json
{
  "call_metadata": {
    "date": "YYYY-MM-DD",
    "duration_minutes": 0,
    "participants": [
      {
        "name": "string",
        "title": "string",
        "company": "string",
        "role": "vendor | prospect"
      }
    ],
    "call_type": "discovery | demo | proposal_review | negotiation | qbr | other",
    "overall_sentiment": "very_positive | positive | neutral | cautious | negative",
    "deal_advancement": "strong_advance | advance | neutral | stall | regress"
  },

  "decisions": [
    {
      "decision": "string — what was decided",
      "made_by": "string — who made or confirmed it",
      "timestamp": "MM:SS",
      "confidence": "explicit | inferred"
    }
  ],

  "action_items": [
    {
      "action": "string — what needs to be done",
      "owner": "vendor | prospect | both",
      "owner_name": "string",
      "due_date": "string or null",
      "priority": "high | medium | low",
      "timestamp": "MM:SS"
    }
  ],

  "pain_points": [
    {
      "pain": "string — the problem",
      "severity": "critical | high | medium | low",
      "quantified_impact": "string or null — e.g., '$230K waste', '15 hrs/week'",
      "confirmed_by": ["string — names of people who validated this"],
      "timestamp": "MM:SS",
      "confidence": "explicit | inferred"
    }
  ],

  "objections": [
    {
      "objection": "string — what was raised",
      "raised_by": "string",
      "status": "resolved | open | partially_resolved",
      "resolution": "string or null — how it was addressed",
      "timestamp": "MM:SS"
    }
  ],

  "buying_signals": [
    {
      "signal": "string — what was said or implied",
      "type": "budget | timeline | authority | need | champion | reference | legal | pricing",
      "strength": "strong | moderate | weak",
      "speaker": "string",
      "timestamp": "MM:SS",
      "confidence": "explicit | inferred"
    }
  ],

  "competitor_mentions": [
    {
      "competitor": "string",
      "context": "string — what was said",
      "sentiment": "positive | negative | neutral",
      "actively_evaluating": true,
      "vulnerability": "string or null — where they are weak",
      "timestamp": "MM:SS"
    }
  ],

  "disclosed_signals": [
    {
      "signal": "string — what was revealed",
      "category": "budget_process | decision_authority | org_structure | procurement | timeline | internal_politics | urgency",
      "speaker": "string",
      "timestamp": "MM:SS",
      "strategic_value": "high | medium | low"
    }
  ],

  "key_quotes": [
    {
      "quote": "string — exact or near-exact words",
      "speaker": "string",
      "timestamp": "MM:SS",
      "significance": "string — why this quote matters"
    }
  ],

  "summary": {
    "one_line": "string — one sentence summary of the call",
    "next_steps_summary": "string — paragraph summarizing agreed next steps",
    "risk_factors": ["string — potential risks identified"],
    "champion_assessment": "string — who is the champion and how strong",
    "recommended_follow_up": "string — what should happen next"
  }
}
```

## Quality Rules

- Never fabricate quotes. If you can't find an exact quote, paraphrase
  and mark confidence as "inferred".
- Timestamps must reference actual moments in the transcript.
- Every pain point must have at least one confirming speaker.
- Action items without clear owners should default to "vendor" (the
  seller owns ambiguity).
- If a buying signal is strong, explain why in the significance field.
- Competitor vulnerabilities should only be noted if evidence exists
  in the transcript (e.g., "they couldn't answer our HIPAA question").
```

## Usage

```bash
# Extract insights from a transcript file
claude "Extract structured insights from demos/03-transcripts/sample-transcript.txt"

# Extract and save as JSON
claude "Extract insights from transcript.txt and save as insights.json"

# Extract from multiple transcripts for the same deal
claude "Extract and merge insights from all transcripts in the acme-corp/ folder"

# Extract with focus on competitive intelligence
claude "Extract insights from this transcript, emphasizing competitor mentions and objection handling"
```

## Example Output (abbreviated)

```json
{
  "call_metadata": {
    "date": "2026-03-18",
    "duration_minutes": 15,
    "participants": [
      { "name": "Jordan Ellis", "title": "Account Executive", "company": "BrightSignal", "role": "vendor" },
      { "name": "Lisa Huang", "title": "VP of Marketing", "company": "Meridian Health Systems", "role": "prospect" },
      { "name": "Derek Patel", "title": "Director of Demand Gen", "company": "Meridian Health Systems", "role": "prospect" }
    ],
    "call_type": "discovery",
    "overall_sentiment": "very_positive",
    "deal_advancement": "strong_advance"
  },
  "pain_points": [
    {
      "pain": "Attribution fragmented across Google Analytics, Salesforce, and CallRail — three different lead counts, 2x variance in CPA",
      "severity": "critical",
      "quantified_impact": "CPA ranges from $128 to $256 depending on source; board target is under $150",
      "confirmed_by": ["Lisa Huang"],
      "timestamp": "01:34",
      "confidence": "explicit"
    },
    {
      "pain": "Manual reporting consuming 15 hours per week across a 4-person demand gen team",
      "severity": "high",
      "quantified_impact": "15 hrs/week = ~1 FTE equivalent on a 4-person team",
      "confirmed_by": ["Derek Patel"],
      "timestamp": "02:02",
      "confidence": "explicit"
    }
  ],
  "buying_signals": [
    {
      "signal": "Budget already approved: $300K line item for marketing analytics platform",
      "type": "budget",
      "strength": "strong",
      "speaker": "Lisa Huang",
      "timestamp": "05:28",
      "confidence": "explicit"
    },
    {
      "signal": "Agreed to start legal/BAA review in parallel with evaluation",
      "type": "legal",
      "strength": "strong",
      "speaker": "Lisa Huang",
      "timestamp": "11:26",
      "confidence": "explicit"
    }
  ]
}
```
