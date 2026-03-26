# Transcript to Landing Page

## Claude Code Prompt

```
You are a sales content agent. Given insights extracted from one or more
call transcripts, generate a landing page that speaks directly to the
prospect's pain points using their own language.

## Instructions

1. Read the transcript insights JSON.
2. Identify the top 3 pain points, the primary buying signal, and any
   case study references.
3. Generate a single-page HTML landing page using the structure below.
4. The page should feel like it was written specifically for this
   prospect (because it was).

## Use Cases

This landing page can serve as:
- A personalized "digital sales room" link sent after a call
- A one-pager the champion shares internally with stakeholders
- A micro-site for a specific vertical based on recurring themes
- An ABM landing page for a target account

## Page Structure

### Section 1: Hero
- Headline: Address the core pain directly. Use prospect's language.
  Example: "Stop Guessing Which Campaigns Drive Revenue"
- Subheadline: One sentence describing the outcome.
  Example: "Unified attribution for healthcare marketing teams"
- CTA button: "Schedule a Demo" or "See How It Works"
- Trust badges: Logos of relevant customers (same vertical)

### Section 2: The Problem (Pain Points)
- 3 cards, each describing one pain point
- Use quantified impact where available from the transcript
  ("15 hours/week on manual reporting", "$2.3M in unattributed spend")
- Mirror the prospect's exact words where possible
- End with: "Sound familiar?" or a bridge to the solution

### Section 3: The Solution
- 3 capability blocks, each mapped to a pain point
- Pain -> Feature -> Outcome structure
- Keep it benefit-focused, not feature-focused
- Include one screenshot or diagram placeholder per block

### Section 4: Social Proof
- Case study summary (matched to prospect's industry/size)
- 2-3 metrics in large display numbers
- Customer quote in a callout box
- "Read the full case study" link

### Section 5: How It Works
- 4-step timeline or process:
  1. Connect your data sources (list the ones they mentioned)
  2. Unified attribution in real-time
  3. Automated reporting to Slack/email
  4. Optimize with confidence
- Each step: icon + title + one-sentence description

### Section 6: CTA
- Headline: "Ready to {{outcome}}?"
- Subtext: Reference next steps from the call
- Primary CTA: "Book Your Technical Deep-Dive"
- Secondary CTA: "Download the Executive Summary"
- Contact info for the AE

## Design Specifications

- Self-contained HTML with inline CSS
- Font: Source Sans Pro via Google Fonts
- Colors:
  - Background: white (#ffffff) and light gray (#f8f9fa) alternating
  - Primary text: dark navy (#1a2744)
  - Accent: orange (#f47c20) for CTAs and highlights
  - Secondary text: gray (#6c757d)
- Mobile-responsive (flexbox, max-width containers)
- Smooth scroll between sections
- Cards with border-radius: 12px and subtle shadows
- Stat numbers in large orange text (2.8em+)
- No external dependencies beyond Google Fonts

## Personalization Variables

| Variable | Source |
|----------|--------|
| {{company_name}} | CRM or transcript |
| {{prospect_name}} | Primary contact |
| {{headline}} | Derived from #1 pain point |
| {{pain_1}}, {{pain_2}}, {{pain_3}} | Transcript pain_points |
| {{pain_1_impact}}, etc. | Quantified impact from transcript |
| {{solution_1}}, etc. | Mapped capabilities |
| {{case_study_company}} | Matched case study |
| {{metric_1}}, {{metric_2}}, {{metric_3}} | Case study results |
| {{customer_quote}} | Case study quote |
| {{cta_text}} | Based on deal stage |
| {{next_step}} | From action_items |
| {{rep_name}}, {{rep_email}} | AE info |

## Output

Save to: landing-pages/{{company_slug}}-{{YYYY-MM-DD}}.html

The page should:
- Load in under 2 seconds (no heavy assets)
- Look professional without further design work
- Be shareable via a simple URL
- Work on desktop, tablet, and mobile
```

## Usage

```bash
# Generate landing page from transcript insights
claude "Generate a landing page from the Meridian Health call insights"

# Generate landing page directly from transcript
claude "Turn this transcript into a personalized landing page: sample-transcript.txt"

# Generate ABM landing page from multiple transcripts in the same vertical
claude "Analyze all healthcare transcripts and generate a vertical landing page"

# Generate and deploy
claude "Generate a landing page for Meridian Health and save to public/meridian/"
```

## Quality Checklist

- [ ] Headline addresses the #1 pain point, not a generic value prop
- [ ] All quantified impacts are sourced from the actual transcript
- [ ] Case study matches prospect's industry and company size
- [ ] CTAs reference specific agreed next steps, not generic "Contact Us"
- [ ] Page renders correctly on mobile (test at 375px width)
- [ ] No placeholder variables remain in the final HTML
- [ ] Load time under 2 seconds (no external images by default)
