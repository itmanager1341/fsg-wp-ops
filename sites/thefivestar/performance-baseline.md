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

**Captured 2026-07-11 (R0, pre-rebuild)** via PageSpeed Insights API (`PAGESPEED_API_KEY`
in `.env`). Full data: `audits/2026-07-11-performance.csv`. This is the pre-rebuild baseline
— re-run the same 6 URLs post-cutover to prove Hello Elementor improved things.

**Headline:** mobile is poor (perf 25–56, LCP 9–20s) — The7 + WPBakery + Slider Revolution
weight. Desktop is middling (41–85). SEO 85–100. Hello Elementor + native widgets should move
these materially; this table is the "before".

### Mobile (2026-07-11)

| URL | Perf | LCP | CLS | TBT | SEO |
|-----|------|-----|-----|-----|-----|
| / | 25 | 11.7 s | 0.1 | 1,860 ms | 92 |
| /five-star-conference/ | 27 | 11.2 s | 0.07 | 2,360 ms | 100 |
| /careers/ | 35 | 9.0 s | 0.45 | 240 ms | 92 |
| /contact/ | 37 | 16.1 s | 0 | 830 ms | 100 |
| /five-star-academy/ | 44 | 19.6 s | 0 | 450 ms | 100 |
| /events/ | 56 | 5.0 s | 0.134 | 350 ms | 85 |

### Desktop (2026-07-11)

| URL | Perf | LCP | CLS | TBT | SEO |
|-----|------|-----|-----|-----|-----|
| / | 41 | 4.0 s | 0.001 | 910 ms | 92 |
| /five-star-conference/ | 58 | 2.5 s | 0.026 | 530 ms | 100 |
| /careers/ | 41 | 1.5 s | 0.369 | 1,090 ms | 92 |
| /contact/ | 62 | 2.0 s | 0.03 | 540 ms | 100 |
| /five-star-academy/ | 70 | 1.4 s | 0.009 | 420 ms | 100 |
| /events/ | 85 | 1.2 s | 0.024 | 260 ms | 85 |

---

_Legacy single-score template retained below for reference._

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
