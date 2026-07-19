# Runbook: R1 — Clone Production → thefivestardev

Phase R1 of `../rebuild-plan.md`. **Status: not executed — planning only.**

Clones production into the `thefivestardev` sandbox so all URLs, content, media, redirects,
AIOSEO config, and post/attachment IDs come across intact. This is the foundation that makes
SEO preservation nearly free. **It overwrites `thefivestardev`** (owner confirmed clear
2026-07-11). It does **not** modify production — prod is the read source only.

> **Approval:** initiating the clone needs owner go-ahead (heavyweight op reading all of prod).
> It writes only to dev, so it is not a production-write under the gate — but confirm before running.

## Preconditions (from R0)

- ✅ Baselines captured (SEO, URL inventory, redirects, plugins, perf) — the regression oracle.
- ✅ `thefivestardev` confirmed clear to overwrite.
- ✅ Deploy scope wp-content-only (Lesson #31) — not relevant to Copy Environment, but keep in mind for later GHA deploys to dev.
- ✅ **Multisite resolved (decision 2026-07-11).** Prod is a live multisite: blog_id 1
  (`thefivestar.com/`) + blog_id 6 (`thefivestar.com/mediakit/`, the advertising media kit —
  28 pages). **Decided: clone the full network as-is in R1, then collapse to single-site + retire
  /mediakit/ on the CLONE** (see `r1b-collapse-singlesite.md`, to author). Prod stays multisite
  until cutover. Subsite recorded in `audits/2026-07-11-mediakit-subsite-inventory.csv`.
  R1 clone itself is unchanged — Copy Environment brings the whole network. Verify topology
  post-clone with:
  ```bash
  ssh -o BatchMode=yes thefivestar "wp site list --format=csv" 2>&1 | head
  ssh -o BatchMode=yes thefivestar "wp eval 'echo is_multisite() ? \"MULTISITE\" : \"single\";'" 2>&1 | head -1
  # If the eval quoting fails on the WPE gateway, use:
  printf 'SELECT blog_id, domain, path FROM wp_0edpxsjfuc_blogs;\n' | ssh -o BatchMode=yes thefivestar "wp db query" 2>&1 | head
  ```
  If **single-site** (no `wp_blogs` table / `is_multisite()` false): the `_6_` tables are
  harmless leftovers — proceed. If **multisite**: STOP and re-plan clone/cutover for multisite
  before continuing.

## Environment facts

| Item | Value |
|------|-------|
| Prod install / env | `thefivestar` (Production), PHP 8.2, domain `thefivestar.com` |
| Sandbox install / env | `thefivestardev` (Development), PHP 8.4, domain `thefivestardev.wpenginepowered.com` |
| Staging (untouched safety net) | `thefivestarstg`, PHP 8.4 |
| DB prefix (main) | `wp_0edpxsjfuc_` |
| Active Elementor kit | 4004 (kit Custom Code IDs 4840 / 4527 = ad/tracking pixels) |
| Key post IDs to verify | 5089, 5110, 5113–5128 (per `site-profile.md`) |

## Steps

### 1. Take a pre-clone checkpoint of dev (safety, optional)
Dev is being overwritten and is confirmed clear, but a WPE checkpoint gives a trivial undo:
- WPE portal → `thefivestardev` → Backups → create backup ("pre-R1-clone").

### 2. WPE Copy Environment: Production → Development
`thefivestar` / `thefivestarstg` / `thefivestardev` are the three environments of one WPE site,
so this is the native **Copy Environment** operation (not a cross-site migration).
- WPE portal → the FSI site → **Copy environment**.
- **Source:** Production. **Destination:** Development.
- Include **database + files** (full copy — brings media, redirects, AIOSEO config, kit).
- WPE runs the domain search-replace `thefivestar.com` → `thefivestardev.wpenginepowered.com`
  on serialized data automatically during the copy.
- Confirm PHP on dev stays **8.4** after copy (Copy Environment moves content, not the env's PHP setting).

### 3. De-index the sandbox IMMEDIATELY (Risk #3 — duplicate content)
Before doing anything else on the clone:
```bash
# WP discourage-search-engines flag on the clone
ssh -o BatchMode=yes thefivestardev "wp option update blog_public 0"
# Verify WPE env-level noindex header on the temp domain
curl -sI https://thefivestardev.wpenginepowered.com/ | grep -i 'x-robots-tag'   # expect: noindex
```
Never link the temp domain from anywhere indexable.

### 4. Disconnect prod-coupled integrations on the clone
So the sandbox can't pollute prod analytics or fire real leads/ads (re-enabled at R7 cutover):
- **Site Kit / GSC**, **HubSpot** (`leadin`), **MonsterInsights / GA4**, **Advanced Ads**,
  and the **Naylor + Apollo pixels** in kit Custom Code (4840 / 4527).
- Deactivate the analytics/lead plugins on dev and/or blank the pixel custom-code blocks.
```bash
ssh -o BatchMode=yes thefivestardev "wp plugin deactivate leadin google-site-kit google-analytics-for-wordpress" 2>&1 | head
```

### 5. Verify domain search-replace (Risk #2 — Elementor stores absolute URLs)
Elementor keeps absolute URLs in serialized `_elementor_data`; confirm WPE rewrote them:
```bash
# Expect ZERO prod-domain hits remaining in Elementor meta on the clone:
printf "SELECT COUNT(*) FROM wp_0edpxsjfuc_postmeta WHERE meta_key='_elementor_data' AND meta_value LIKE '%%thefivestar.com%%';\n" \
  | ssh -o BatchMode=yes thefivestardev "wp db query"
# Redirect tables should also reference the dev domain (or relative paths), not thefivestar.com:
printf 'SELECT url_from, url_to FROM wp_0edpxsjfuc_redirects;\n' | ssh -o BatchMode=yes thefivestardev "wp db query"
```
If prod-domain URLs remain, run a serialized-safe search-replace on the clone:
`wp search-replace 'thefivestar.com' 'thefivestardev.wpenginepowered.com' --precise --recurse-objects --skip-columns=guid` (dev only).

### 6. Verify ID preservation (Risk #8)
Copy Environment copies the DB verbatim, so IDs should match. Confirm the anchors:
```bash
printf 'SELECT ID, post_name, post_status FROM wp_0edpxsjfuc_posts WHERE ID IN (5089,5110,5113,5115,5127,5128);\n' \
  | ssh -o BatchMode=yes thefivestardev "wp db query"
```
Same IDs as `site-profile.md` → JSON-push targets + media refs stay valid; no F2-style remap.

### 7. Parity check (clone == prod, The7 still active)
- HTTP-200 sweep the full R0 URL inventory on the temp domain (cache-busted). Expect parity
  with prod status codes — this is still the The7 site, just cloned.
- Spot-check homepage + the 6 perf-baseline pages render identically.

### 8. Snapshot the good clone
- WPE portal → `thefivestardev` → Backups → "R1-clone-parity-good". This is the known-good
  "full-parity-on-The7" rollback point for the rebuild work in R2–R6.

## Gate R1 checklist

- [ ] Site topology confirmed (single-site — or multisite re-plan done)
- [ ] Copy Environment prod→dev complete; dev on PHP 8.4
- [ ] Clone renders identical to prod on temp domain (The7 active); 200-sweep matches baseline
- [ ] `blog_public=0` + `X-Robots-Tag: noindex` verified on temp domain
- [ ] Prod integrations disconnected on the clone (Site Kit, HubSpot, GA4, ads, pixels)
- [ ] `_elementor_data` + redirect tables free of prod-domain URLs (search-replace verified)
- [ ] Anchor post IDs (5089, 5113–5128) preserved
- [ ] WPE checkpoint "R1-clone-parity-good" taken

When all checked → R1 gate passes → proceed to R2 (WPBakery inventory + disposition).

## Rollback

Nothing on prod changed, so "rollback" only means resetting the sandbox: restore the
pre-R1 dev checkpoint (step 1) or simply re-run Copy Environment. No DNS/SSL/prod impact.

## Risk callouts (from `../rebuild-plan.md` § Risk register)

- **#2 Elementor abs-URL not rewritten** → step 5 grep, don't trust the auto search-replace.
- **#3 Sandbox indexed** → step 3 noindex + verify header; never link the temp domain.
- **#4b Losing dev WIP** → dev confirmed clear (R0); step 1 checkpoint anyway.
- **#8 ID reassignment** → step 6 verify anchors.
