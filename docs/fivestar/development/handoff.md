# Rebuild Handoff — thefivestar.com

Rebuild-specific handoff (distinct from the portfolio-wide `docs/next-chat-handoff.md`,
which still tracks the page-by-page Elementor work on live prod). Update at each session end.

Last updated: 2026-07-11

## Where we are

**Phase: R0 COMPLETE — gate passed. Next is R1 (clone).** Strategy is **clone-and-cutover**
onto Hello Elementor, promote-back at cutover. No clone/prod-write has run; only read-only R0
audits. See `rebuild-plan.md` and `runbooks/r0-baselines.md`.

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

## R0 findings (prod audit 2026-07-11)

- **Yoast already removed** — AIOSEO Pro is the sole SEO plugin. That plan concern is closed.
- **Only 4 redirects, messy state** — `eps-301-redirects` active-but-empty; `aioseo-redirects`
  inactive but holds 2 enabled 301s (fire-status unverified); plain `wp_redirects` table has 2
  live rules. Consolidate + verify in R2. Dump: `audits/2026-07-11-redirects.csv`.
- **Perf baseline poor on mobile** (25–56, LCP 9–20s) — the "before". `audits/2026-07-11-performance.csv`.
- **WPBakery still active** (js_composer, Ultimate VC) — removed by the rebuild.
- Plugin snapshot: `audits/2026-07-11-prod-plugins.csv` (53 plugins).

## Carry-forward (not blocking R1)

1. **R2 redirect consolidation** — pick one manager, verify the 2 AIOSEO-table redirects still
   fire, migrate all live rules + Tier 3 LMS redirects in.
2. **Rotate the Semrush API key** — pasted in chat; regenerate + update `.env`.
3. **Confirm LMS retirement** before any media deletion (destructive).
4. **8.4 compat** — spot-check `advanced-ads` + `leadin` (HubSpot) on 8.4 (likely fine; dev/staging already 8.4).

## Multisite resolved (decision 2026-07-11) — R1 unblocked

Prod is a live multisite (blog_id 1 main + blog_id 6 `/mediakit/` advertising media kit, 28
pages). **Decided: clone the full network in R1, then collapse to single-site + retire
`/mediakit/` on the clone** (301 `/mediakit/*` → `/`). Prod stays multisite until cutover.
Details in `docs/decisions.md` 2026-07-11; subsite recorded in
`audits/2026-07-11-mediakit-subsite-inventory.csv`.

## R1 clone — DONE (2026-07-11)

Prod pushed to `thefivestardev` via WPE portal (Production → Push to → Development). Post-clone
steps executed on dev by Claude:
- ✅ Clone verified: multisite intact (blog 1 + blog 6 `/mediakit/`), domain rewritten to
  `thefivestardev.wpengine.com`.
- ✅ ID preservation: 5089/5110/5113/5115/5127/5128 all present.
- ✅ Search-replace clean: 0 prod-domain URLs in `_elementor_data`; siteurl/home rewritten.
- ✅ De-indexed: `blog_public=0` on both blogs.
- ✅ Integrations off: leadin (HubSpot), google-site-kit, advanced-ads suite (incl. GAM).
- ✅ Parity: homepage, Elementor pages, and `/mediakit/*` all HTTP 200 on temp domain.
- ✅ Checkpoint: WPE backup `48b72dd4-1eec-49a4-bead-b3a454f4ea91` ("R1-clone-parity-good").

**2 items still needed to fully close R1:**
1. 🔴 **Jonathan: enable WPE Password protection on Development** (Overview toggle). `blog_public=0`
   only adds a weak meta-robots tag (no `X-Robots-Tag`, site still 200). Password protection is
   the strong guard against the sandbox being crawled (Risk #3).
2. Backup `48b72dd4` finishes (async).

## R2 — page disposition + trash DONE (2026-07-11)

74→73 pages classified (`audits/2026-07-11-wpbakery-disposition.csv`; runbook
`runbooks/r2-inventory-disposition.md`). VERIFY resolved by owner (Join pages 5380/5386,
Confirmation 2937, Who We Are 5086 → keep; News 2542, AM&AA 2916, dup RE Pros 5115, dup
Velocity 4436 → trash). **43 pages trashed on the clone** (reversible). Remaining: **30
published** = 14 MIGRATE (WPBakery→Elementor) + 16 LEAVE (Elementor, re-author in R4).
Front page 363 (Home) is WPBakery → top MIGRATE priority.

**R2 COMPLETE.** LMS retired: 49 course/seminar/certification CPTs force-deleted + their 46
images deleted (safety-checked: none used by kept pages). Redirects: owner opted to **skip**
`/mediakit/` + LMS 301s (zero traffic → let them 404); fixed the one broken active redirect
(`network-groups` → trashed 2597, repointed to Memberships 5113); `reif` external 302 kept; the
2 AIOSEO-table redirects are in an inactive plugin (not firing — fine). No redirect manager
consolidation needed.

## Authoring approach decided (2026-07-11)

Pages are built as **native Elementor widgets generated as JSON from natural-language specs** and
pushed via the existing pipeline (decision in `docs/decisions.md`). Retires the HTML-embed Option B.
**Scope correction:** the 16 "LEAVE" (already-Elementor) pages are HTML-embed, not native →
**REFACTOR**. R4 worklist = **all 30 pages → native**. Prereqs: native-widget schema reference
library (`widget-references/`); `__globals__` only after Hello (R3). Validated by a **spike on
page 13 (Contact)** before the other 29. Runbooks `r3-theme-cutover.md` + `r4-page-rebuild.md` drafted.

## Next — R3: build Hello Elementor chrome, then activate

Hands-on **Elementor authoring** (GUI): Header / Footer / Mega-Menu as Theme Builder templates
while The7 is active, add a fallback singular template, activate Hello, 200-sweep. Claude
preps/verifies via CLI; building happens in the Elementor editor. See `runbooks/r3-theme-cutover.md`.
Then R4 (NL→native-JSON, spike first). **WPE password protection now ON ✅.**

## R1b — DONE (2026-07-11): single-site + /mediakit/ retired

On the clone: `wp site delete 6` (mediakit) → removed all 7 multisite constants from wp-config →
dropped network tables. Verified: `wp site list` = "not a multisite installation"; all key pages
200; `/mediakit/` now 404 (301 deferred to R2); wp-admin reachable (302→login). Runbook:
`runbooks/r1b-collapse-singlesite.md`. Rollback checkpoint `48b72dd4…` still available.

## Next action — R2: WPBakery inventory + disposition (on the clone)

Run `theme-migration.md` Phase T1 (`[vc_row` scan + nav + Elementor flag), cross-ref R0 SEO
baseline, classify every page MIGRATE/TRASH/LEAVE. Then **R2 redirect consolidation**: pick one
manager, verify the existing redirects fire, add `/mediakit/(.*)` → `/` + the LMS Tier-3 301s.

Carry-forward: 🔴 enable WPE Password protection on dev (still pending — sandbox is crawlable);
rotate Semrush key; 8.4 spot-check advanced-ads + leadin.
