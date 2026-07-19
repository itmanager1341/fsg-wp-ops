# Runbook: R0 — Baselines + Provisioning

Phase R0 of `../rebuild-plan.md`. **Read-only.** Captures the regression oracle before any
rebuild change. No writes to prod or dev. Gate R0 = baselines committed, dev cleared, Yoast
disposition confirmed, deploy scope confirmed wp-content-only.

## Status — R0 COMPLETE (2026-07-11)

| Item | Status | Evidence |
|------|--------|----------|
| SEO baseline | ✅ (Semrush) | `sites/thefivestar/seo-baseline.md`, `audits/2026-06-16-semrush-*.csv` |
| GSC 28d metrics | ⚠️ N/A | GSC history in inaccessible account; new property forward-only |
| Full URL inventory | ✅ | `audits/2026-06-16-url-inventory.csv` (277 URLs) |
| Performance baseline | ✅ | `audits/2026-07-11-performance.csv`; tables in `performance-baseline.md` |
| Dev env exists + PHP 8.4 | ✅ | WPE API: `thefivestardev` active, PHP 8.4 |
| Deploy scope wp-content only | ✅ | `../thefivestar-wp/.github/workflows/deploy.yml` L41/42/65/66 |
| Redirect inventory | ✅ | `audits/2026-07-11-redirects.csv` (4 rules — see Findings) |
| Yoast state + 8.4 plugin compat | ✅ | `audits/2026-07-11-prod-plugins.csv` (53 plugins — see Findings) |
| Dev cleared of WIP | ✅ | owner confirmed `thefivestardev` clear to overwrite (2026-07-11) |

## Findings (R0 audit, prod 2026-07-11)

- **Yoast is already GONE** — not installed on prod. AIOSEO Pro (`all-in-one-seo-pack-pro`
  4.9.10) is the sole SEO plugin. The R0/plan "remove Yoast" concern is closed; docs that
  said Yoast was active (`seo-baseline.md` old stack table) were stale.
- **Redirects total 4, and the state is messy** (see `url-preservation-plan.md` → Redirect
  tooling): `eps-301-redirects` active but empty; `aioseo-redirects` plugin INACTIVE yet holds
  2 enabled 301s (fire-status unverified); plain `wp_redirects` table has 2 live rules. Must be
  consolidated + verified in R2.
- **WPBakery still active** (`js_composer` 8.7.3, `Ultimate_VC_Addons` 3.21.4) — expected; the
  rebuild removes these.
- **Plugins with updates available**: `advanced-ads`, `leadin` (HubSpot), `js_composer`,
  `Ultimate_VC_Addons`. The last two are removed in the rebuild; verify `advanced-ads` + `leadin`
  on 8.4 (staging/dev already run 8.4, so likely fine).
- **Perf baseline is poor on mobile** (perf 25–56, LCP 9–20s) — the "before" the rebuild improves.

**Gate R0: PASSED.** Ready for R1 (clone) planning + approval.

## Reproduce the prod reads (base64/stdin pattern — WPE gateway mangles nested quotes)

WPE's SSH gateway breaks `COUNT(*)`/parens in quoted commands. Pass SQL via **stdin**:
```bash
printf 'SELECT COUNT(*) FROM wp_0edpxsjfuc_aioseo_redirects;\n' \
  | ssh -o BatchMode=yes thefivestar "wp db query"
```
Plugin list works inline: `ssh thefivestar "wp plugin list --format=csv"`.

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
