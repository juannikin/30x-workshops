# Generate Email Sequences — Claude Code Prompt

> Copy and paste the block below into Claude Code.

---

```
Read the file `output/enriched-leads.csv`. For each lead, generate a personalized 3-email outbound sequence. Follow these rules precisely.

## Inputs

- enriched-leads.csv — contains company info, contact info, pain_hypothesis, lead_score
- Only generate sequences for leads with lead_score >= 50

## Email Framework

### Email 1 — "The Hook" (Day 1)
- Subject line: Short, curiosity-driven, no spam words. Reference something specific to their company.
- Opening line: Reference their recent_news, hiring_signal, or a specific pain_hypothesis. NO generic openers like "Hope this finds you well."
- Body: 2-3 sentences max. Connect THEIR pain to OUR value prop. Use "you/your" 3x more than "we/our."
- CTA: Soft ask — "Worth a 15-min chat?" or "Open to exploring this?"
- Length: Under 100 words total.

### Email 2 — "The Value Drop" (Day 5)
- Subject line: Re: [Email 1 subject] (keep in same thread)
- Opening: "Quick follow-up" — then immediately provide value (a stat, insight, or mini case study).
- Body: Share a specific, quantified result from a similar company. Format: "[Similar company type] achieved [metric] in [timeframe]."
- CTA: Slightly more direct — "Can I send you the case study?" or "Would [specific day] work for a quick call?"
- Length: Under 80 words total.

### Email 3 — "The Breakup" (Day 12)
- Subject line: "Closing the loop" or similar low-pressure subject
- Opening: Acknowledge you have been reaching out.
- Body: 1-2 sentences. Restate the core value prop in one line. Provide an easy out.
- CTA: "If timing is off, no worries — happy to reconnect next quarter. But if [pain_hypothesis] is still top of mind, I am here."
- Length: Under 60 words total.

## Personalization Rules

1. Every email MUST reference at least one specific detail from the enriched data (company name alone does NOT count).
2. Match tone to the contact's seniority:
   - C-level / VP: Strategic, peer-to-peer, concise. No fluff.
   - Director: Results-oriented, slightly more detail allowed.
   - Manager: Tactical, emphasize ease of implementation.
3. If industry is HealthTech or FinTech, add a compliance-awareness sentence where relevant.
4. If funding_stage is Seed, emphasize efficiency and speed to revenue.
5. If funding_stage is Series B+, emphasize scale and competitive edge.

## Output Format

For each qualifying lead, write a markdown file to `output/sequences/` named `{company_domain}-sequence.md` with this structure:

```markdown
# Email Sequence: {company_name}
**Contact:** {contact_name} ({contact_title})
**Email:** {contact_email}
**Lead Score:** {lead_score}
**Pain Hypothesis:** {pain_hypothesis}

---

## Email 1 — The Hook (Day 1)
**Subject:** [subject line]

[email body]

---

## Email 2 — The Value Drop (Day 5)
**Subject:** Re: [same subject]

[email body]

---

## Email 3 — The Breakup (Day 12)
**Subject:** [subject line]

[email body]
```

After generating all sequences, print a summary:
- Total sequences generated
- List of files written
- Average word count per email
```

---

## Tips for the Workshop

- Run this prompt AFTER `enrich-and-score.md` so that `output/enriched-leads.csv` exists.
- Review the generated sequences and ask Claude Code to refine specific ones, e.g.:
  - "Make the Clearpath Security hook email reference their Series B funding."
  - "The Pinnacle HR breakup email is too long — tighten it."
- To regenerate a single sequence: "Regenerate just the sequence for converge-ai.com with a more technical tone."
