# Performance Baseline: thefivestar.com

Establish this baseline before any significant plugin updates or theme changes.
Re-run after changes to measure impact.

## How to capture

Run PageSpeed Insights:
```
https://pagespeed.web.dev/analysis?url=https://thefivestar.com
```

Or via API (add to `.env` as `PAGESPEED_API_KEY`):
```bash
curl "https://www.googleapis.com/pagespeedonline/v5/runPagespeed\
?url=https://thefivestar.com&strategy=mobile&key=$PAGESPEED_API_KEY" \
| jq '.lighthouseResult.categories | {
  performance: .performance.score,
  accessibility: .accessibility.score,
  seo: .seo.score
}'
```

## Baseline scores

**Capture status (2026-06-17, R0):** BLOCKED — PageSpeed Insights anonymous quota is
exhausted; the API needs a key. Add `PAGESPEED_API_KEY` to `.env` (Google Cloud → enable
"PageSpeed Insights API" on the `mortgagepoint` project → create an API key), or run the six
target URLs manually at <https://pagespeed.web.dev>. This is the **pre-rebuild** baseline and
must be captured before R1 clone/cutover work changes anything.

**Target URLs (homepage + top-5 by organic traffic, per `seo-baseline.md`):**
`/`, `/five-star-conference/`, `/careers/`, `/contact/`, `/five-star-academy/`, `/events/`.

_Populate the tables below after the audit run._

### Mobile

| Metric | Score | Date |
|--------|-------|------|
| Performance | — | — |
| LCP | — | — |
| INP | — | — |
| CLS | — | — |
| Accessibility | — | — |
| SEO | — | — |

### Desktop

| Metric | Score | Date |
|--------|-------|------|
| Performance | — | — |
| LCP | — | — |
| INP | — | — |
| CLS | — | — |

## Known performance factors

**Positive:** WP Rocket (caching, minification, lazy load), WP Engine
server cache, image optimizer plugin active.

**Risks to monitor:**
- WP Rocket v2.6.1 is outdated — update may improve optimization
- Slider Revolution adds JS weight on pages with heroes
- Advanced Ads stack adds JS for ad targeting and tracking
- HubSpot plugin loads HubSpot tracking script on every page
- MonsterInsights + Site Kit = two GA4 beacon scripts (consider consolidating)
- WPBakery renders inline styles — harder to consolidate CSS

## Re-audit triggers

Run a new baseline after: WP Rocket update, The7/WPBakery updates,
homepage redesign, new ad placements, quarterly cadence.

Store results in: `sites/thefivestar/audits/YYYY-MM-DD-performance.md`
