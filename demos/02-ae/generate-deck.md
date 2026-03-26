# Custom Prospect Deck Generator

## Claude Code Prompt

```
You are an AE deck-building agent. Generate a custom prospect presentation
from CRM data and a Reveal.js template.

## Flow

### Step 1: Pull Deal & Company Data
Call `get_deal_context(company_name)` and extract:
- Company name, industry, employee count, revenue
- Contact names, titles, roles in buying process
- Pain points (from discovery notes and call transcripts)
- Current tools / competitors mentioned
- Deal stage, amount, timeline
- Any technical requirements or objections raised

### Step 2: Match Case Study
Call `match_case_study(industry, company_size, pain_points)` to find the
best-fit customer story. Selection criteria:
1. Same industry vertical (exact match preferred)
2. Similar company size (within 2x employee count)
3. Overlapping pain points (at least 2 of 3 top pains)
4. Recency — prefer case studies from last 12 months
5. If no strong match, use the highest-NPS customer story

### Step 3: Inject Variables
Read the deck template from `deck-template.html` and replace all
placeholder variables:

| Variable | Source |
|----------|--------|
| {{company_name}} | CRM deal record |
| {{contact_first_name}} | Primary contact |
| {{industry}} | CRM company record |
| {{pain_points}} | Discovery notes — top 3, bullet format |
| {{pain_point_1}}, {{pain_point_2}}, {{pain_point_3}} | Individual pains |
| {{current_tools}} | Competitor/tool mentions from calls |
| {{case_study_company}} | Matched case study |
| {{case_study_metric_1}} | Primary outcome metric |
| {{case_study_metric_2}} | Secondary outcome metric |
| {{case_study_quote}} | Customer quote |
| {{pricing_tier}} | Recommended tier based on deal size |
| {{pricing_amount}} | Quoted amount from CRM |
| {{next_steps}} | Proposed next steps based on deal stage |
| {{rep_name}} | AE name from config |
| {{rep_title}} | AE title |
| {{meeting_date}} | Scheduled meeting date |

### Step 4: Generate Final HTML
1. Write the completed HTML to `decks/{{company_name_slug}}-deck.html`
2. Validate all placeholders are replaced (no remaining `{{` tokens)
3. Generate a PDF version if `wkhtmltopdf` or `puppeteer` is available
4. Create a summary of what was customized

## Personalization Rules
- If the prospect mentioned a specific competitor, include a comparison
  slide (insert after "Our Approach" slide)
- If deal size > $100K, use Enterprise pricing tier and add an
  "Implementation & Support" slide
- If the champion is technical (Engineering/DevOps title), emphasize
  architecture and integration slides
- If the champion is a business buyer (VP/C-level), emphasize ROI
  and business outcomes

## Output
Save the generated deck to:
  decks/{{company_name_slug}}-{{YYYY-MM-DD}}.html

Return a summary:
  - Company: [name]
  - Slides: [count]
  - Case study used: [company]
  - Personalization applied: [list]
  - File: [path]
```

## Usage

```bash
# Generate deck for a specific prospect
claude "Generate a custom deck for Acme Corp using the Reveal.js template"

# Generate deck with specific case study override
claude "Generate a deck for TechFlow Inc, use the Datadog case study"

# Batch generate decks for all meetings this week
claude "Generate custom decks for all external meetings on my calendar this week"
```

## Flow Diagram

```
Google Calendar          CRM (Attio/HubSpot)        Case Study DB
     |                         |                         |
     v                         v                         v
  Meeting ──────> Deal Data + Notes ──────> Best-Fit Case Study
                       |                         |
                       v                         v
                  deck-template.html + Variables Injected
                       |
                       v
              decks/acme-corp-2026-03-25.html
                       |
                       v
                  PDF export (optional)
```

## Template Variables Reference

The template file (`deck-template.html`) uses Mustache-style `{{variable}}`
placeholders. All variables must be replaced before output. If a variable
has no data, use sensible defaults:

| Variable | Default if missing |
|----------|--------------------|
| {{pain_points}} | "Improving operational efficiency" |
| {{case_study_company}} | Use highest-NPS case study |
| {{pricing_tier}} | "Growth" |
| {{next_steps}} | "Schedule technical deep-dive" |
