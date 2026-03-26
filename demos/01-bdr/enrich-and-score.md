# Enrich & Score Leads — Claude Code Prompt

> Copy and paste the block below into Claude Code.

---

```
Read the file `sample-leads.csv` in this directory. For each lead, perform the following enrichment and scoring workflow.

## Step 1 — Enrich

For every row, research and add these columns. Use the Exa web search MCP tool (or fall back to general knowledge) to fill in realistic values:

| New Column             | Description                                              |
|------------------------|----------------------------------------------------------|
| annual_revenue_est     | Estimated ARR in USD (e.g., "$4M")                       |
| tech_stack             | Comma-separated list of key technologies (max 5)         |
| recent_news            | One-sentence summary of most recent press/blog (last 6mo)|
| hiring_signal          | true/false — are they actively hiring for sales or ops?  |
| icp_match              | true/false — matches our ICP (B2B SaaS, 50-500 emp, NA) |
| pain_hypothesis        | 1-sentence hypothesis of their biggest GTM pain point    |

## Step 2 — Score (0-100)

Calculate a lead_score using these weights:

| Factor                     | Weight | Scoring Rule                                                      |
|----------------------------|--------|-------------------------------------------------------------------|
| ICP Fit                    | 30%    | icp_match=true → 30, else 5                                       |
| Funding Stage              | 20%    | Seed → 10, Series A → 16, Series B → 20, Series C+ → 14          |
| Employee Count Sweet Spot  | 15%    | 50-200 → 15, 201-400 → 10, <50 or >400 → 5                       |
| Hiring Signal              | 15%    | hiring_signal=true → 15, else 0                                   |
| Recent News Relevance      | 10%    | Relevant growth/funding news → 10, generic → 5, none → 0          |
| Title Seniority            | 10%    | C-level/VP → 10, Director → 7, Manager → 4, Other → 2            |

Formula: `lead_score = sum of factor scores (capped at 100)`

## Step 3 — Output

1. Write the enriched + scored data to `output/enriched-leads.csv` with ALL original columns plus the new ones plus `lead_score`.
2. Sort rows by `lead_score` descending.
3. Print a summary table to the console showing: company_name, lead_score, icp_match, pain_hypothesis.
4. Print the average score and how many leads scored above 70.

Do NOT hallucinate data — if you cannot find real information, write "unknown" and score conservatively.
```

---

## Expected Output Columns

```
company_name, domain, industry, hq_location, employee_count, funding_stage,
linkedin_url, contact_name, contact_title, contact_email,
annual_revenue_est, tech_stack, recent_news, hiring_signal, icp_match,
pain_hypothesis, lead_score
```
