# PRD + Implementation Plan: Rebuild thefivestar.com on Hello Elementor (clone-and-cutover)

> **Provenance:** Authored in the 2026-06-16 planning session; imported into the repo
> 2026-06-17 as the canonical rebuild plan. (Original title said "Fresh … Staging Install" —
> corrected here: the build strategy is **clone**, not fresh install. See Decision 1.)
>
> **Updates since drafting (2026-06-17):**
> - SEO baseline captured from **Semrush** (GSC history is in an inaccessible account; the new
>   `sc-domain:thefivestar.com` property is forward-only). See `sites/thefivestar/seo-baseline.md`
>   + `scripts/semrush-export.sh`. R0's GSC-based baseline steps are partially satisfied by Semrush.
> - **Academy LMS post types excluded** from the rebuild (decision 2026-06-16 in `docs/decisions.md`):
>   ~75 `/blog/course|seminar|certification/*` static pages → set inactive, media deleted, 301'd.
> - **URL / redirect / asset handling** now detailed in `sites/thefivestar/url-preservation-plan.md`.
> - `theme-migration.md` **T5 voided** (Risk #10 closed) — no in-place prod theme swap.

## Context

thefivestar.com (The Five Star Institute, FSI brand) runs on WP Engine with **The7 theme** plus a mix of **legacy WPBakery pages** and **7 already-migrated Elementor pages** (Events hub, Velocity, Memberships hub, Communities hub, RE Professionals, FSI Offers, Alliance). ~171 visits/day.

The core problem: **The7 fights Elementor on CSS specificity**, forcing `!important` heading rules and hardcoded hex colors instead of `__globals__` brand-token bindings on every section. The documented fix is migrating to **Hello Elementor** (already proven at themortgagepoint.com), but an in-place theme swap is blocked because removing The7 strips header/footer chrome from any remaining WPBakery page.

Rather than continue the slow incremental in-place migration (the existing `theme-migration.md` T1–T5 plan), this project stands up a **fresh, dedicated WP Engine install** that is a faithful clone of production, re-themes it to Hello Elementor "done right," achieves full URL parity with legacy cleanup, then promotes the finished result back into production. **SEO preservation is the #1 priority** — every live URL must keep returning the same status.

### Decisions locked (confirmed with owner)
1. **Build strategy: clone production**, then re-theme (preserves all URLs/content/redirects/media — lowest SEO risk).
2. **Theme: Hello Elementor + Elementor Pro Theme Builder** (header/footer/mega-menu rebuilt as Elementor templates). Replaces The7; unlocks `__globals__` bindings.
3. **Environment: the existing `thefivestardev`** (`thefivestardev.wpenginepowered.com`, already PHP 8.4) is the rebuild sandbox — no new install slot. Prod + staging remain as the untouched safety net; dev's current contents are overwritten by the clone.
4. **Scope: full parity + clean legacy** — every live URL renders correctly on Hello Elementor; remaining WPBakery pages are migrated (if trafficked/in-nav) or trashed (dead).

### Cutover (confirmed): **promote-back, not domain cutover**
Copy the finished rebuild from `thefivestardev` *back into the existing `thefivestar` prod install* via WPE Copy Environment (or backup-restore into the install — see Open Q4). This keeps the domain, SSL cert, install ID, SSH alias, deploy target, and redirect table prefix unchanged (zero DNS/SSL change, minutes-long rollback via WPE restore, lowest crawl disruption). Dev is only the build surface and resets to normal use afterward.

### PHP version (confirmed): **build on 8.4, bump prod 8.2 → 8.4 at cutover**
Staging + dev already run 8.4 and render the current site fine (verified via WPE API), so the stack is already proven on 8.4; prod 8.2 reaches EOL Dec 2026. Build the sandbox on 8.4 and toggle prod to 8.4 at cutover (per-install WPE setting, reversible). Add a plugin 8.4-compat verification to R0/R6.

---

## Template design principles (the new approach — the heart of this rebuild)

The current Elementor pages use an "Option B" workaround: each content section is a single **HTML widget embedding `fsi-page-wrap` markup** styled by the `fsi-event-styles.php` mu-plugin. That pattern exists **only to trick The7 into rendering cleanly** (avoiding its CSS-specificity fights and the `__globals__` breakage). It is NOT user-editable — a content editor opening the page sees a raw HTML blob, not editable widgets.

**On Hello Elementor this workaround is unnecessary and must be retired for standard templates.** The new standard templates must be:

- **Native Elementor widgets** (Heading, Text, Button, Image, Icon Box, containers/flexbox) — editable in the Elementor UI by non-technical users, not raw HTML embeds.
- **Styled via the Global Kit** using `__globals__` brand-token bindings (which now work once The7 is gone), not inline hex or mu-plugin CSS.
- **Saved as reusable Elementor Templates** (Library / Theme Builder), one per family (Event / Membership / Community / Resource), so an editor clones the template, fills in copy, and publishes — "the correct way to use the template in Elementor."

**Consequences for the plan:**
- The existing `elementor-templates/**` JSON section files are **The7-era reference/source-of-copy**, NOT the deploy artifact. R4 is *re-author as native widget templates*, not *re-push existing JSON*.
- `fsi-event-styles.php` is retired for standard templates (may remain only for any legacy page not yet rebuilt). Styling moves into the kit + widget settings.
- The authoring model shifts from "JSON meta-write via WP-CLI" toward "build/edit reusable templates in the Elementor UI," with exported template JSON version-controlled for reproducibility. The strict JSON-push SOP becomes a fallback, not the primary path.

---

## Phase plan

Each phase ends in a **gate**. The existing T1–T5 phase *content* in `sites/thefivestar/theme-migration.md` still applies — it just executes inside the sandbox install instead of in-place.

### R0 — Baselines + provisioning (no rebuild changes)
The regression oracle must be captured **before** anything changes.
- **SEO baseline**: populate `sites/thefivestar/seo-baseline.md` from GSC (last 28d + prior 28d clicks/impressions/CTR/position); export **top-200 pages** + **top-200 queries** CSV to `sites/thefivestar/audits/`; record Coverage indexed-URL count + CWV state.
- **Performance baseline**: populate `sites/thefivestar/performance-baseline.md` (PageSpeed mobile+desktop, homepage + top-5 pages).
- **Full URL inventory** → `sites/thefivestar/audits/YYYY-MM-DD-url-inventory.csv` (AIOSEO `/sitemap.xml` + WP-CLI post/page/CPT enum).
- **Redirect inventory** → dump the `eps-301-redirects` table to CSV (Lesson #20: rows match full URI; Lesson #35: IA-change URLs are intentionally dead — do not "fix").
- **Confirm `thefivestardev` is clear to use** as the sandbox (already PHP 8.4). Capture/snapshot any current dev contents worth keeping before R1 overwrites it.
- **Verify Yoast state + 8.4 plugin compat** (read-only prod `wp plugin list` — needs owner approval): confirm whether Yoast is truly removed (docs conflict) and that all active plugins are 8.4-clean. Remove Yoast entirely if present — AIOSEO Pro is the sole SEO plugin (single canonical/meta/sitemap source).
- **Confirm deploy safety**: dev is already a `thefivestar-wp` deploy target; confirm `SRC_PATH: wp-content/` + `REMOTE_PATH: wp-content/` (Lesson #31 — prevents the WP-core-deletion incident).
- **Gate R0**: baselines committed; dev cleared for use; Yoast disposition confirmed; deploy scope confirmed wp-content-only.

### R1 — Clone production → thefivestardev
- **WPE Copy Environment** prod → `thefivestardev` (DB + files + media + redirects + AIOSEO config + active kit 4004 in one operation). Overwrites dev's current contents. This is why clone beats greenfield — every URL, redirect, canonical, post-ID, and attachment-ID comes across intact.
- **De-index the sandbox immediately**: `blog_public = 0` + confirm WPE env `noindex`; verify `X-Robots-Tag: noindex` via `curl -sI` on the temp domain. Protects the real domain's GSC property.
- **Disconnect prod-coupled integrations on the clone**: Site Kit/GSC, HubSpot, Naylor + Apollo pixels (kit Custom Code 4840/4527), GA4/MonsterInsights — so rebuild work doesn't pollute prod analytics or fire duplicate leads. Re-enable at cutover.
- **Verify search-replace**: grep `_elementor_data` and the `*_redirects` table for the prod domain — Elementor stores absolute URLs in serialized meta; confirm WPE rewrote them to the temp domain.
- **Verify ID preservation**: confirm post-IDs (5089, 5113–5128, etc. per `site-profile.md`) and attachment-IDs survived the clone. If preserved, JSON-push targets are unchanged and no image re-upload/ID-remap is needed.
- **Snapshot** the clone (WPE checkpoint = known-good "full-parity-on-The7" rollback).
- **Gate R1**: clone renders identical to prod on temp domain (The7 still active); URLs rewritten; sandbox noindex; integrations disconnected; checkpoint taken.

### R2 — T1 inventory + WPBakery disposition (on the clone)
- Run `theme-migration.md` Phase T1 query (`[vc_row` shortcode scan + nav membership + Elementor flag). Cross-reference against the R0 GSC top-200.
- Classify every page: **MIGRATE** (in-nav OR has GSC traffic OR inbound links) / **TRASH** (>2yr, not in nav, ~zero impressions, no inbound links — starting set in `wpbakery-migration.md`: 4973, 4834, 4828, 4909, 4829, 4757, 4912, 3471, 4965) / **LEAVE-AS-IS** (already Elementor).
- **The7 CPT audit** (Portfolio/Testimonials/Team/Photo Albums/Slideshows): 17 records, none displayed via shortcode/widget per prior audit — confirm on clone, then leave as harmless dead DB rows.
- **Mega Menu disposition**: recommend rebuilding natively in Elementor Pro (removes The7 + legacy-deprecated-mega-menu dependency entirely) rather than testing the fragile standalone plugin under Hello.
- Update `wpbakery-migration.md` disposition table = the scope contract for R4.
- **Gate R2**: every live URL classified; trash list approved; CPT + Mega Menu disposition decided.

### R3 — Build Hello Elementor + Pro chrome (on the clone)
- Build **Header / Footer / Mega-Menu as Theme Builder templates while The7 is still active** (templates don't take over until Hello is the active theme), then flip the theme in one step so the site never renders chrome-less.
- Header (condition: Entire Site) — logo, nav, mega-menu matching The7 visually against R0 screenshots.
- Footer (condition: Entire Site) — links, "Membership Groups" widget (watch known link-drift in `site-profile.md`), copyright, social.
- **Fallback singular Page template** (Theme Builder) so any not-yet-migrated WPBakery page still gets chrome under Hello — `theme-migration.md` resolution option 2 as a safety net.
- **Activate Hello**, then full HTTP-200 sweep of the entire R0 URL inventory on the temp domain.
- **Gate R3**: Hello active; chrome matches baseline; 200-sweep passes; PHP log clean (on 8.2).

### R4 — Build native reusable templates + migrate/trash pages (on the clone)
This is the core of the "new approach" — see Template design principles above.
- **Author one native, user-editable reusable Elementor template per family** (Event / Membership / Community / Resource) using native widgets + `__globals__` kit bindings, saved to the Elementor Library (and Theme Builder where a CPT loop applies). These templates are the deliverable an editor clones to make new pages. The existing `elementor-templates/**` JSON is the **source of copy/structure reference**, not the deploy artifact.
- **Rebuild the 7 live Elementor pages** (Events hub, Velocity, Memberships hub, Communities hub, RE Professionals, FSI Offers, Alliance) from their family templates as native widgets, replacing the HTML-embed Option B bodies. Clone preserves post + attachment IDs, so URLs and media references are intact (no F2-style image-ID remap).
- **Migrate** the remaining MIGRATE-list WPBakery pages into native templates.
- **Trash** the approved deprecation list (reversible — clone trash + disposable clone).
- **Finish the pending pipeline** on native templates: LLSS, 6 remaining Membership pages, 3 Community siblings.
- **Retire `fsi-event-styles.php`** for standard templates once no rebuilt page depends on it (keep only if a not-yet-rebuilt legacy page still needs it).
- **Gate R4**: zero active WPBakery pages (re-run T1, expect empty); standard pages are native editable widgets (spot-open in Elementor UI to confirm no raw-HTML-blob sections remain); WPBakery plugin chain deactivated; full 200-sweep + visual regression passes.

### R5 — Global Kit cleanup (on the clone, The7 gone) — `theme-migration.md` T3
Only possible now (Lesson #12: The7 was what broke `__globals__`).
- Remove `!important` from heading-color rules in kit Custom CSS.
- Convert section JSON hardcoded hex → `__globals__` bindings (slots `fsi01nh`–`fsi07ho`); verify buttons + overlays now honor globals.
- Re-export kit to `sites/thefivestar/elementor-kit/*.json` via **direct meta-write** (never `wp elementor kit import` — Lessons #3–#6).
- Verify `/kit-test/` canary + full visual parity.
- **Gate R5**: kit cleaned; globals verified live; canary green; no `!important` heading rules remain.

### R6 — Full regression on the clone (this IS the staging gate)
The clone at its temp domain now plays "staging." Run the full verification kit (§ Verification): 200-sweep of entire inventory, redirect sweep (bare URL, no query string), visual regression @ 1440/768/420 vs R0, PHP log clean on 8.2, forms, sitemap, robots (still noindex), CWV/PageSpeed vs R0 baseline.
- **Gate R6**: clone is full-parity, clean, measured equal-or-better than prod. This report is what goes to the cutover approval.

### R7 — Production cutover (promote-back) — 🔴 High, standing approval gate
Follows the verbatim approval gate in `CLAUDE.md` / `docs/sops/fsi-production-promotion.md`. Gate R6 is **never** permission to proceed.
1. WPE checkpoint of live `thefivestar` (rollback target); record ID in `decisions.md` (Lesson #34: backup API needs `notification_emails`).
2. **Content freeze** on prod from this point (so the clone doesn't drift from what overwrites it). If editors changed prod during R2–R6, diff `post_modified` prod vs clone and reconcile deltas — see Risk #1.
3. Low-traffic maintenance window.
4. State operation + risk: **🔴 High — full DB + files overwrite of production.**
5. **Bump prod install to PHP 8.4**, then **WPE Copy Environment: `thefivestardev` → `thefivestar`** (WPE runs `thefivestardev.wpenginepowered.com` → `thefivestar.com` search-replace inbound).
6. Re-enable prod integrations stubbed in R1 (Site Kit/GSC, HubSpot, pixels, analytics); re-enable indexing (`blog_public = 1`, remove sandbox noindex).
7. Full cache purge (Lesson #16 sequence: Elementor `clear_cache` + `wp cache flush` + wp-rocket + `WpeCommon::purge_varnish_cache_all()` + `purge_memcached()`).
8. **STOP. Verify on prod** (§ Verification post-cutover). Report results.
9. **STOP. Ask Jonathan in chat for explicit acceptance or rollback.**
10. Rollback if rejected: WPE restore step-1 checkpoint (minutes, no DNS).

---

## SEO preservation checklist
**Before cutover (R0):** GSC 28d+prior metrics; top-200 pages+queries CSV; Coverage indexed count; PageSpeed baseline; full URL inventory CSV; redirect-table dump; pre-cutover screenshots (1440/768/420).
**On clone before cutover (R6):** sandbox noindex verified; every URL matches baseline status; every redirect fires (bare URL); `/sitemap.xml` generates with same URL set minus intended trash; Yoast confirmed gone (AIOSEO only); internal-link crawl finds no dangling links to trashed pages.
**After cutover:** canonicals resolve to `thefivestar.com`; `robots.txt` + `blog_public=1`; `/sitemap.xml` resolves + submit to GSC; **404 sweep of full inventory = release blocker** (any new 404 → add redirect or restore); trashed dead pages 404 as intended (IA-change URLs stay 404 by design, Lesson #35); GSC Coverage watch 7–14 days.

---

## Risk register (top items)
| # | Risk | Sev | Mitigation |
|---|---|---|---|
| 1 | Content drift: editors change prod during build window; promote-back overwrites it | 🔴 | Content freeze (R7.2); else diff `post_modified` + reapply deltas |
| 2 | Elementor abs-URL not search-replaced in `_elementor_data` after clone | 🔴 | Post-copy grep meta + redirects table; verify don't trust |
| 3 | Sandbox indexed → duplicate-content harm to real domain | 🔴 | R1 noindex + verify `X-Robots-Tag`; never link temp domain |
| 4 | rsync `--delete` deletes WP core on dev | 🔴 | Confirm `SRC_PATH=wp-content/` before first deploy (Lesson #31) |
| 4b | Losing in-flight dev work when clone overwrites dev | 🟢 | Snapshot/relocate any wanted dev contents at R0 before R1 |
| 5 | Mega Menu doesn't survive theme swap | 🟡 | Rebuild natively in Elementor Pro (R2); test in R3 |
| 6 | `__globals__` still fails after Hello | 🟡 | Verify on `/kit-test/` in R5; fallback keep hardcoded hex |
| 7 | A plugin breaks on the 8.4 bump | 🟢 | Stack already runs 8.4 on staging/dev; verify plugin compat at R0; prod PHP toggle is reversible at cutover |
| 8 | Post/attachment-ID reassignment breaks JSON-push targets + image refs | 🟡 | Verify ID preservation right after R1; rebuild ID map if needed |
| 9 | Trashed page had real traffic/inbound links | 🟡 | Cross-ref trash list vs GSC top-200; default MIGRATE on doubt |
| 10 | Stale T5 in `theme-migration.md` executed in-place by future session | 🟢 | Update doc to clone-and-cutover model |

---

## Verification (reusable kit, applied at every gate)
- **HTTP-200 sweep**: loop R0 inventory with `curl -sI`, cache-busted (`?cb=...`) for pages, bare URL for redirect rows; diff vs baseline.
- **Redirect sweep**: bare-URL curl each redirect row; expect recorded 301→target.
- **Visual regression**: Playwright full-page screenshots @ 1440/768/420 vs R0 baselines in `sites/thefivestar/visual-baselines/`.
- **Computed-style assertion**: Playwright `getComputedStyle` on headings/buttons/containers vs kit spec (esp. after R5 globals conversion).
- **PHP error log**: WPE Logs clean (on 8.2).
- **Cache**: Lesson #16 purge, then cache-busted verify then bare-URL verify.

Post-cutover adds: canonical/robots/sitemap checks + the 404 sweep (release blocker) + GSC sitemap submit and 7–14 day Coverage watch.

---

## Critical files
- `sites/thefivestar/theme-migration.md` — existing T1–T5 content (flag stale T5 in-place note)
- `sites/thefivestar/wpbakery-migration.md` — disposition tracker (scope contract)
- `sites/thefivestar/site-profile.md` — page-ID map, environments, open issues
- `docs/sops/fsi-production-promotion.md` — approval gate + ship runbook
- `docs/sops/elementor-json-authoring.md` — Option B JSON push pipeline + lessons
- `docs/sops/deployment.md` — GHA→WPE, rollback via WPE restore
- `sites/thefivestar/seo-baseline.md`, `performance-baseline.md` — populate in R0
- `sites/thefivestar/elementor-kit/*.json`, `elementor-global-kit-spec.md` — kit cleanup target (R5)
- `sites/thefivestar/elementor-templates/**` — section JSON re-pushed in R4

---

## Decisions resolved this session
1. **Cutover**: promote-back (sandbox → existing prod install). ✅
2. **Content freeze**: **deferred** — revisit as we approach R7 cutover; budget a `post_modified` delta-reconciliation step if a freeze proves impractical.
3. **PHP**: build on 8.4, bump prod to 8.4 at cutover. ✅
4. **WPE access**: confirmed via Hosting API (installs + IDs visible). The exact cross-install **Copy Environment** button is verified at R1; backup-restore into the install is the equivalent fallback.
5. **Yoast**: remove entirely; AIOSEO Pro is the sole SEO plugin (single canonical/meta/sitemap source). Confirm live state at R0 via read-only prod check (needs approval).
6. **Templates**: standard templates are native, user-editable Elementor widgets + kit globals — the HTML-embed/The7 workaround is retired. ✅

7. **Environment**: rebuild on the existing `thefivestardev` (no new install slot); prod + staging stay as the safety net. ✅

## Still to confirm at execution
- **R0 prod read approval** — one read-only `wp plugin list` on prod to settle the Yoast conflict and 8.4 plugin compat.
- **Clear `thefivestardev` for use** — confirm nothing on dev needs preserving before the R1 clone overwrites it.
