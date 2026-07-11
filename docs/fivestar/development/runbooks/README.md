# Rebuild Runbooks

Step-by-step operational procedures for the thefivestar.com rebuild. Each is authored
just before its phase executes (with real install IDs, checkpoint IDs, and verified
commands), so we don't carry untested steps. The phase definitions and gates live in
`../rebuild-plan.md`; these runbooks are the executable detail.

## Planned runbooks (author per phase)

| Runbook | Covers | Plan phase | Status |
|---------|--------|-----------|--------|
| `r0-baselines.md` | GSC/redirect/perf capture, dev clearance, deploy-scope check | R0 | not started |
| `r1-clone.md` | WPE Copy Environment prod→dev, noindex, integration disconnect, ID/search-replace verify | R1 | not started |
| `r3-theme-cutover.md` | Build Hello chrome, activate, 200-sweep | R3 | not started |
| `r6-regression.md` | Full verification kit (200/redirect/visual/CWV) | R6 | not started |
| `r7-cutover.md` | Promote-back, PHP bump, re-enable integrations, post-cutover 404 sweep | R7 | not started |

## Reuse, don't reinvent

- The **verification kit** (HTTP-200 sweep, redirect sweep, visual regression, computed-style
  assertion, cache purge) is defined once in `../rebuild-plan.md` § Verification — runbooks
  reference it rather than restating.
- The **production approval gate** and ship mechanics live in
  `docs/sops/fsi-production-promotion.md` — the R7 runbook wraps that, it doesn't replace it.
- Cache-purge sequence, JSON-push fallback, and known lessons live in
  `docs/sops/elementor-json-authoring.md`.
