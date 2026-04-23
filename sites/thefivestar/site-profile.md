# Site Profile: thefivestar.com

Last audited: 2026-04-18 (live WP-CLI via SSH — source of truth)

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

## Theme

| Field | Value |
|-------|-------|
| Theme | The7 by Dream-Theme |
| Version | **14.3.0** (slug: `dt-the7`) |
| Page builder mode | **WPBakery** in Theme Settings (transitional — Elementor is the forward builder per 2026-04-22 decision; mode setting does not prevent Elementor pages from working) |
| Mega Menu | Enabled |
| DB auto-update | Enabled |
| Legacy Deprecated Mega-Menu Settings | Enabled (existing nav relies on this) |

**Note:** The7 v14.3.0 is the current version — the WP Admin screenshot showed WordPress 6.9.4
in the footer, which I earlier incorrectly recorded as The7's version. Corrected from live data.

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
| 🟡 Med | fsi-event-styles.php not on production | Pending production deploy ⏳ |
| 🟡 Med | Event pages (LLSS, hub rebuild, nav) staging-only | Pending production promotion ⏳ |
| 🟡 Med | WPBakery chain — maintenance-only under 2026-04-22 decision | SOP only needed if critical update ships before chain retires |
