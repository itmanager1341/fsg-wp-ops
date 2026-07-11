# Rebuild Handoff — thefivestar.com

Rebuild-specific handoff (distinct from the portfolio-wide `docs/next-chat-handoff.md`,
which still tracks the page-by-page Elementor work on live prod). Update at each session end.

Last updated: 2026-06-17

## Where we are

**Phase: pre-R0 (planning).** Strategy locked as **clone-and-cutover** onto Hello Elementor,
promote-back at cutover. No clone or production operation has run. See `rebuild-plan.md`.

## Done

- **SEO baseline** captured from Semrush → `sites/thefivestar/seo-baseline.md` +
  `audits/2026-06-16-semrush-*.csv`. Profile: brand-dominant, ~343 kw, ~914 visits/mo,
  ~80% homepage; ~12–15 URLs carry real traffic.
- **URL inventory** (277 URLs) → `audits/2026-06-16-url-inventory.csv`.
- **Read-only export tooling**: `scripts/semrush-export.sh` (working), `scripts/gsc-export.sh`
  (working; GSC has no usable history — new property is forward-only).
- **URL-preservation plan** → `sites/thefivestar/url-preservation-plan.md` (Tier 1/2/3 + asset rule).
- **LMS exclusion decision** recorded (`docs/decisions.md` 2026-06-16).
- **Stale-doc safety**: `theme-migration.md` T5 voided; plan imported here.

## Open items before R0 can start

1. **R0 prod read approval** — one read-only `wp plugin list` on prod to settle the Yoast
   question and confirm 8.4 plugin compat.
2. **Clear `thefivestardev`** — confirm nothing on dev needs preserving before the R1 clone
   overwrites it.
3. **Rotate the Semrush API key** — it was pasted in chat; regenerate + update `.env`.
4. **Redirect-plugin consolidation** — two are active (`aioseo-redirects`, `eps-301-redirects`);
   decide canonical before staging cutover redirects.
5. **Confirm LMS retirement** before any media deletion (destructive).

## Next action

Get owner approval for the R0 read-only prod `wp plugin list`, then execute R0 baselines
(the remaining GSC/redirect/perf captures) per `rebuild-plan.md`. Nothing touches prod
without the standing per-stage approval gate.
