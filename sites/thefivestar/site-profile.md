# Site Profile: thefivestar.com

Last audited: 2026-04-23 (Phase 1.3 verified Elementor 4.0.2 + Pro 4.0.2; The7 14.3.0)

## Install

| Field | Value |
|-------|-------|
| WPE content path | `/nas/content/live/thefivestar/` |
| WPE install name | `thefivestar` |
| Domain | https://thefivestar.com |
| WordPress | 6.9.4 |
| PHP (production) | 8.2 |
| PHP (staging / dev) | 8.4 |
| Storage | 1.78 GB |
| Est. daily visits | ~171 |

## Environments

| Environment | Install | URL | PHP |
|-------------|---------|-----|-----|
| Production | `thefivestar` | https://thefivestar.com | 8.2 |
| Staging | `thefivestarstg` | https://thefivestarstg.wpenginepowered.com | 8.4 |
| Dev | `thefivestardev` | https://thefivestardev.wpenginepowered.com | 8.4 |

## Theme + builder stack

| Field | Value |
|-------|-------|
| Theme | The7 by Dream-Theme |
| Version | **14.3.0** (slug: `dt-the7`) — verified 2026-04-23 |
| Elementor | **4.0.2** (active on staging; verify prod separately at Phase 1.11) |
| Elementor Pro | **4.0.2** (active on staging) |
| Page builder mode (theme option) | **WPBakery** in Theme Settings (transitional — Elementor is the forward builder per 2026-04-22 decision; mode setting does not prevent Elementor pages from working) |
| Mega Menu | Enabled |
| DB auto-update | Enabled |
| Legacy Deprecated Mega-Menu Settings | Enabled (existing nav relies on this) |

**Note:** The7 v14.3.0 is the current version — the WP Admin screenshot showed WordPress 6.9.4
in the footer, which I earlier incorrectly recorded as The7's version. Corrected from live data.

**Elementor v4 note:** v4 removed the Theme Style, Typography (H1-H6 panel), and
Buttons panels that existed in v3.x. Global kit configuration is:
Global Colors + Global Fonts + Layout + Custom CSS. Button presets in v4 are
per-widget, saved as Global Widgets. See `elementor-global-kit-spec.md`.

## Active custom post types (via The7)

Portfolio (slug: `dt_portfolio`), Testimonials (slug: `dt_testimonials`),
Team (slug: `dt_team`), Photo Albums (slug: `dt_gallery`),
Slideshows (slug: `dt_slideshow`).

Slugs corrected 2026-04-23 per `the7-dependency-audit.md` — previous entries
had Portfolio as `project` (wrong) and Slideshows unlabeled. 17 records total
across all 5 CPTs; 3 CPTs are empty. None actively displayed via shortcode
or widget — see audit doc for swap-cost implications.

## Child theme

**No child theme exists.** Only `dt-the7` (parent) is installed. Before writing any
theme code, a child theme must be created — edits to the parent are wiped on update.

## SSH access

```bash
ssh thefivestar   # shorthand via ~/.ssh/config
```

## Git remotes (thefivestar-wp repo)

```bash
git remote add wpe-stg git@git.wpengine.com:staging/thefivestarstg.git
git remote add wpe     git@git.wpengine.com:production/thefivestar.git
```

## Open issues

Last reviewed: 2026-04-21

| Priority | Issue | Status |
|----------|-------|--------|
| 🟢 Low | No child theme — create `dt-the7-child` only when custom PHP or template overrides needed | Deferred by decision |
| 🟡 Med | PHP warning in `aioseo-redirects` line 73 — upstream bug, suppressed via mu-plugin | Suppressed ✅ |
| 🟡 Med | Yoast SEO alongside AIOSEO Pro | Deleted ✅ |
| — | Elementor Pro active with 18 pages | **On-standard under 2026-04-22 decision.** Migration tracker: `wpbakery-migration.md` |
| 🟡 Med | Blocksy Companion Pro — wrong theme | Deleted ✅ |
| 🟡 Med | MonsterInsights — overlaps Site Kit | Deleted from staging ⏳ |
| 🟡 Med | Image Optimizer inactive | Deleted from staging ⏳ |
| 🟡 Med | AIOSEO Local Business — not applicable | Deactivated ✅ |
| 🟡 Med | AIOSEO REST API — headless only | Deactivated ✅ |
| 🟢 Low | OptiMonster inactive | Deleted from staging ⏳ |
| 🟢 Low | Safe SVG — duplicate of SVG Support | Deleted ✅ |
| 🟢 Low | EventON Lite inactive | Deleted from staging ⏳ |
| 🟢 Low | matchheight — legacy jQuery | Deleted ✅ |
| 🟢 Done | fsi-event-styles.php LIVE on production | ✅ PROD since 2026-04-30 ~18:08 (after F1 incident + workflow fix in deploy.yml SRC_PATH=wp-content/) |
| 🟡 Med | LLSS Elementor at canonical staging slug (page 5106 since 2026-04-26) | Pending Phase 1.11 production promotion ⏳ + Template A revision (apply Velocity 2026-04-30 pattern: image-only hero + 3-col info bar + 20/20 padding cap) |
| 🟢 Done | Velocity Elementor LIVE on PROD (page 5110 since 2026-04-30 ~19:50 via Wave 1 Step 1 create-new + slug-swap). Old WPBakery 5088 preserved at /events/velocity-old/. Template A REVISION (image-only hero + 3-col info bar + 20/20 padding cap) shipped. Hero image (prod attachment 5099) + Alliance card image (prod attachment 5100) live. | ✅ PROD — `https://thefivestar.com/events/velocity/`. Atomic rollback: `_elementor_data_backup_2026_04_30_193938` |
| 🟢 Done | Events hub Elementor LIVE on PROD (page 5089 since 2026-05-01 via in-place swap; WPE backup `39912795-28d6-495e-8bb0-1cfaa657b3b8` taken pre-swap; atomic rollback: `_elementor_inplace_swap_backup_2026_05_01_044450_*`; child URLs /events/velocity/ + /events/velocity-old/ intact). | ✅ PROD — `https://thefivestar.com/events/` |
| 🟢 Done | RE Pros Elementor LIVE on PROD (page 5115 since 2026-05-01 via create-new + slug-swap; parent 5114 communities hub). 8 sections. Old WPBakery 5087 preserved at `/memberships-old/real-estate-professionals/`. No redirect from `/memberships/real-estate-professionals/` — that URL is intentionally dead; RE Pros is a community, not a membership. | ✅ PROD — `https://thefivestar.com/communities/real-estate-professionals/` |
| 🟢 Done | Memberships hub Elementor LIVE on PROD (page 5113 since 2026-04-30 ~20:30 via Wave 1 Step 2 create-new + slug-swap). Old WPBakery 2597 preserved at /memberships-old/. 4 sections (seven-memberships hero, 6-tile specialty grid, Alliance foundation strip, footer-line). All 7 logos via clean attachments (FORCE 5112 + LL 5111 re-uploaded; others 5103/5105/5107/5108/5109). Followed by Step 3.5 nav repoint (TFSI item 2622 + Footer item 2779 → 5113). | ✅ PROD — `https://thefivestar.com/memberships/`. Atomic rollback: `_elementor_data_backup_2026_04_30_202430` |
| 🟡 Med | Phase 4a Membership pages (FORCE, Legal League firms, AMDC, PPEF, NMSA, MSEA, Five Star Alliance) — none exist on staging; hub now references them via Member Portal external links + Community internal links | Pending Phase 4a — fully greenfield template + 7 page builds |
| 🟢 Done | Communities hub Elementor LIVE on PROD (page 5114 since 2026-04-30 ~21:20 via Wave 1 Step 3 single create-and-populate; `/communities/` did not exist on prod previously). 6 sections, no images, Template C alignment applied. NOT nav-wired per standing rule (page is published but discoverable only via direct URL or from RE Pros once 4b.11 ships). | ✅ PROD — `https://thefivestar.com/communities/`. Rollback: delete prod page 5114, URL becomes 404 again |
| 🟡 Med | Phase 4b Community siblings (Mortgage Finance, Legal, Prop Pres) — children not yet authored | Pending Phase 4b 2nd+ instances |
| 🟢 Done | Site footer "Membership Groups" widget link drift fixed on PROD via Wave 1 Step 3.5 (item 2779 repointed object_id 2597 → 5113). | ✅ Resolved 2026-04-30 evening. Same item on staging may still drift; check + fix when staging is touched. |
| 🟡 Med | WPBakery chain — maintenance-only under 2026-04-22 decision | SOP only needed if critical update ships before chain retires |

## Elementor Global Kit v1

**Live on staging 2026-04-23.** Phase 1.3 complete.

- Spec + token values: `elementor-global-kit-spec.md`
- Kit export artifact: `elementor-global-kit-v1.zip` (5.4KB; 4 JSON files — site-settings, custom-fonts, custom-code, manifest)
- Verification page: `/kit-test/` on staging (retain permanently as regression canary — do not delete)
- Production promotion: Phase 1.11 via Templates → Kits & Templates import

## Elementor Custom Code inventory

Separate from Site Settings → Custom CSS. These blocks inject into page
`<head>` via Elementor's Custom Code feature (not Site Settings; different UI).
Discovered 2026-04-23 in the kit-export `custom-code.json`.

| ID | Title | Location | Priority | Conditions |
|----|-------|----------|----------|------------|
| 4840 | Naylor | `elementor_head` | 1 | `include/general` (all pages) |
| 4527 | Apollo | `elementor_head` | 1 | `include/general` (all pages) |

Both are tracking-pixel injection blocks (sitewide). Flag for audit:
- Confirm both are still-in-use integrations (Naylor = job board? Apollo = CRM?)
- If either is stale, trash via Elementor → Custom Code
- Not blocking Phase 1.4

## The7 + Elementor CSS specificity

Phase 1.3 surfaced that The7 out-specifies plain element selectors. Custom CSS
must be scoped to Elementor widget classes (e.g. `.elementor-widget-heading
.elementor-heading-title`) to take effect. Full findings + forward plan:
`the7-elementor-specificity-notes.md`.

**Implication:** Every Elementor widget type used in Phase 1-5 templates
likely needs matching scoped override rules. Raises total cost of keeping
The7 vs swapping to Hello Elementor — factored into Phase 4 kickoff
theme-direction revisit.
