# Runbook: R0 — Baselines + Provisioning

Phase R0 of `../rebuild-plan.md`. **Read-only.** Captures the regression oracle before any
rebuild change. No writes to prod or dev. Gate R0 = baselines committed, dev cleared, Yoast
disposition confirmed, deploy scope confirmed wp-content-only.

## Status (2026-06-17)

| Item | Status | Evidence |
|------|--------|----------|
| SEO baseline | ✅ (Semrush) | `sites/thefivestar/seo-baseline.md`, `audits/2026-06-16-semrush-*.csv` |
| GSC 28d metrics | ⚠️ N/A | GSC history in inaccessible account; new property forward-only |
| Full URL inventory | ✅ | `audits/2026-06-16-url-inventory.csv` (277 URLs) |
| Performance baseline | ⛔ blocked | needs `PAGESPEED_API_KEY` (see `performance-baseline.md`) |
| Dev env exists + PHP 8.4 | ✅ | WPE API: `thefivestardev` active, PHP 8.4 |
| Deploy scope wp-content only | ✅ | `../thefivestar-wp/.github/workflows/deploy.yml` L41/42/65/66 |
| Redirect table dump | 🔒 gated | needs owner approval (read-only prod) |
| Yoast state + 8.4 plugin compat | 🔒 gated | needs owner approval (read-only prod) |
| Dev cleared of WIP | ❓ owner | confirm nothing on `thefivestardev` needs preserving before R1 |

## Unblocked captures (done / doable now)

### Performance baseline (needs API key, then run)
```bash
set -a; . ./.env; set +a   # loads PAGESPEED_API_KEY
for u in / /five-star-conference/ /careers/ /contact/ /five-star-academy/ /events/; do
  for s in mobile desktop; do
    curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=https://thefivestar.com${u}&strategy=${s}&category=performance&category=seo&category=accessibility&key=${PAGESPEED_API_KEY}" \
      | jq -r --arg u "$u" --arg s "$s" '[$u,$s,
          (.lighthouseResult.categories.performance.score*100|round),
          (.lighthouseResult.audits."largest-contentful-paint".displayValue),
          (.lighthouseResult.audits."cumulative-layout-shift".displayValue),
          (.lighthouseResult.audits."total-blocking-time".displayValue)]|@tsv'
  done
done
```
Populate `sites/thefivestar/performance-baseline.md` mobile/desktop tables.

### WPE environment confirmation (infra read — done)
```bash
set -a; . ./.env; set +a
scripts/wpe-api.sh installs | jq -rc 'select(.name|test("thefivestar"))|[.name,.php,.status]|@tsv'
# thefivestar 8.2 active | thefivestarstg 8.4 active | thefivestardev 8.4 active
```

## GATED — requires explicit owner approval (read-only, on prod)

Per `CLAUDE.md` production gate, even read-only prod commands need per-session approval.
Run over SSH alias `thefivestar` (see `docs/sops/ssh-session-startup.md`).

### 1. Yoast state + 8.4 plugin compatibility
```bash
ssh thefivestar "wp plugin list --fields=name,status,version,update --format=csv" \
  > sites/thefivestar/audits/$(date +%F)-prod-plugins.csv
# Settle the Yoast conflict (docs disagree on whether it's removed) and flag any
# plugin not marked 8.4-compatible.
```

### 2. Redirect table dump (regression oracle)
```bash
# eps-301-redirects stores rules in an option; export to CSV. Confirm exact storage on-box:
ssh thefivestar "wp eval '\$r = get_option(\"eps_redirects\"); echo json_encode(\$r);'" \
  > /tmp/eps-redirects.json
# Then normalise to sites/thefivestar/audits/<date>-redirects.csv (from,to,type).
# Lesson #20: rows match full URI. Lesson #35: IA-change dead URLs are intentional — do not "fix".
```

## Gate R0 checklist

- [ ] Performance baseline captured + committed
- [ ] Redirect inventory CSV committed
- [ ] Yoast disposition confirmed (removed, or scheduled for removal — AIOSEO Pro sole SEO plugin)
- [ ] All active plugins confirmed 8.4-clean
- [ ] `thefivestardev` confirmed clear of WIP to overwrite
- [ ] Deploy scope confirmed wp-content-only ✅

When all checked → R0 gate passes → proceed to R1 (clone) planning.
