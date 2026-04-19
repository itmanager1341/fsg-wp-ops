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
| Page builder mode | **WPBakery** (confirmed in Theme Settings) |
| Mega Menu | Enabled |
| DB auto-update | Enabled |
| Legacy Deprecated Mega-Menu Settings | Enabled (existing nav relies on this) |

**Note:** The7 v14.3.0 is the current version — the WP Admin screenshot showed WordPress 6.9.4
in the footer, which I earlier incorrectly recorded as The7's version. Corrected from live data.

## Active custom post types (via The7)

Portfolio (slug: `project`), Testimonials, Team (slug: `dt_team`),
Photo Albums (slug: `dt_gallery`), Slideshows.

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

## Open issues (from live audit 2026-04-18)

| Priority | Issue |
|----------|-------|
| 🟢 Low | No child theme exists — create `dt-the7-child` only when custom PHP or template overrides are needed (see docs/decisions.md) |
| 🟡 Med | PHP warning in `aioseo-redirects`: `Attempt to read property "hasMinimumVersion" on array` (line 73) — plugin is active |
| 🟡 Med | Yoast SEO installed (inactive) alongside AIOSEO Pro — remove entirely |
| 🟡 Med | Elementor Pro active at v4.0.2 — active since last screenshot; audit which pages use it before removing |
| 🟡 Med | Blocksy Companion Pro inactive — installed for Blocksy theme, not The7; remove |
| 🟡 Med | MonsterInsights inactive — overlaps with Site Kit for GA4; decide which to keep |
| 🟡 Med | Image Optimizer inactive — if not being used, remove or activate |
| 🟡 Med | AIOSEO Local Business active but not applicable to FSI — deactivate |
| 🟡 Med | AIOSEO REST API active but only needed for headless — deactivate |
| 🟢 Low | OptiMonster, Safe SVG, EventON Lite inactive — remove or activate |
| 🟢 Low | matchheight (jQuery equal-height) inactive — likely legacy; remove |
