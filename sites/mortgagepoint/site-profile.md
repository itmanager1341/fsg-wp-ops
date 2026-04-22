# Site Profile: themortgagepoint.com

Last audited: 2026-04-22 (live WP-CLI via SSH — source of truth)
Audit scope: stack, content volume, Elementor structure, ad system, portfolio fit

## Brand & role

MortgagePoint is FSI's media flagship — a mortgage industry news and magazine
publication. It's a content machine: ~100 articles/month, 3,351 total published
posts, 41 magazine issues, a podcast, and a guest-author system.

Editorial model is distinct from thefivestar.com (trade-association hub) and
amaaonline.com (auction industry association + event calendar).

## Install

| Field | Value |
|-------|-------|
| WPE content path | `/nas/content/live/mortgagepoint/` |
| WPE install name | `mortgagepoint` |
| Domain | https://themortgagepoint.com |
| WordPress | 6.9.4 |
| PHP (production) | 8.2.30 |
| DB table prefix | `wp_lkihb5gwg6_` (non-default — must use this in db query) |
| Storage | 6.9 GB uploads; 50% of 787 GB NAS |

**Note:** `siteurl` option stored as `http://themortgagepoint.com` (not https).
Live site redirects to https via server config. Worth normalizing `siteurl`
to https to reduce mixed-content edge cases.

## Theme

| Field | Value |
|-------|-------|
| Active theme | `hello-elementor` 3.4.6 |
| Update available | 3.4.7 |
| Child theme | **None** |
| Inactive themes | `twentytwentyfive` 1.4 |

Hello Elementor is Elementor's intentionally-bare starter theme. All design
lives in Elementor Pro Theme Builder templates + the active Elementor Kit
(ID 257 — global typography, colors, layouts).

## Page builder

| Plugin | Version | Role |
|--------|---------|------|
| Elementor | 4.0.1 | Core builder |
| Elementor Pro | 3.35.1 | Theme Builder + Pro widgets |
| ElementsKit Lite | 3.9.0 | Extra widget library |
| Envato Elements | 2.0.16 | Template library |

**Elementor Pro is on 3.x while Elementor core is on 4.x** — there's a 4.0.3
update available for Pro. Version compatibility matrix should be verified
before updating either (and see `docs/sops/plugin-update.md` — this is
MortgagePoint's equivalent of FSI's WPBakery chain).

**Elementor Pro license:** Expert tier subscription ID 13620718, 25 activations,
billed yearly. License used across MortgagePoint and 19 other sites today.

## Content volume

| Type | Published | Notes |
|------|-----------|-------|
| Posts (articles) | 3,351 | Core editorial output |
| Pages | 102 | 104 are Elementor-built (some may be drafts) |
| Publications (magazine issues) | 41 | Custom post type `publication` |
| Podcast episodes | 31 | Custom post type `podcast` (MP Access Show) |
| People (guest-author) | 85 | Custom post type `mt_pp` — bylines for industry contributors |
| Elementor library templates | 36 published | Theme Builder templates (see below) |

### Publishing cadence (posts only, 2025–2026)

| Month | Posts | | Month | Posts |
|-------|-------|---|-------|-------|
| 2025-01 | 95  | | 2025-09 | 106 |
| 2025-02 | 91  | | 2025-10 | 115 |
| 2025-03 | 95  | | 2025-11 | 90 |
| 2025-04 | 104 | | 2025-12 | 119 |
| 2025-05 | 110 | | 2026-01 | 107 |
| 2025-06 | 106 | | 2026-02 | 106 |
| 2025-07 | 110 | | 2026-03 | 119 |
| 2025-08 | 107 | | 2026-04 | 75 (partial through 04-22) |

Consistent ~100–120/month for 16 months straight. No visible seasonality dips.
Latest post: ID 22514 — "U.S. Home Prices Inched Up 0.1% in March" (2026-04-22).

## Elementor Theme Builder templates

The 36 published templates in `elementor_library` are how MortgagePoint
renders thousands of posts consistently without per-post building. This is
the architectural advantage Elementor Pro has over WPBakery.

Notable templates (`wp post list --post_type=elementor_library`):

| Template | Purpose |
|----------|---------|
| Single Post | Default article layout |
| Single Post (Sponsored) | Sponsored-content variant |
| Single MP Product | Guest-author / people profile layout |
| Archive Blog | Main blog archive |
| Archive Categories | Category archive |
| Archive Author | Author archive |
| Search Results | Site search template |
| Error 404 | 404 page |
| Landing Header / Landing Footer | Alternate header/footer for landing pages |
| Media Kit Header / Media Kit Footer | Media kit microsite chrome |
| Header Desktop Ad | Leaderboard ad placement |
| Loop V2 – Hero Mini - Sponsored | Featured-post loop variant |
| Loop - Latest Post | Standard loop variant |
| Loop V5 – Page H270T | Loop variant |
| TMP - Top CTA / Bottom CTA / Page Title | Reusable CTA blocks |
| Archive Author | Author archive layout |
| Most Recent Podcasts | Podcast listing widget |
| Popup with Form, Exit Intent | Popup system |

Editorial workflow: write article → assign template → publish. Template changes
propagate across all posts of that type automatically.

## Custom post types

| CPT | Public | Count | Source |
|-----|--------|-------|--------|
| `post` | yes | 3,351 | WP core |
| `page` | yes | 102 | WP core |
| `publication` | yes | 41 | Toolset Types (magazine issues) |
| `podcast` | yes | 31 | Toolset Types (MP Access episodes) |
| `mt_pp` | yes | 85 | `guest-author` plugin (people/contributors) |
| `elementor_library` | yes | 36 | Elementor (theme-builder templates) |
| `elementskit_content` | yes | — | ElementsKit |
| `elementskit_template` | yes | — | ElementsKit |
| `advanced_ads` | no | 5 | Advanced Ads (house ads) |
| `advanced_ads_plcmnt` | no | 4 | Advanced Ads (placement records) |
| `view` / `view-template` | no | — | Toolset Views |

## Ad system

| Plugin | Version |
|--------|---------|
| Advanced Ads | 2.0.18 |
| Advanced Ads Pro | 3.0.9 |
| Advanced Ads – Responsive | 2.0.5 |
| Advanced Ads – GAM | 3.0.3 |
| Advanced Ads – Layer | 2.0.3 |
| Advanced Ads – Sticky Ads | 2.0.4 |
| Advanced Ads – Tracking | 3.0.10 |

**Placements (4 published):**

| ID | Name | Type |
|----|------|------|
| 16220 | MP Header 1 | Leaderboard (top of page) |
| 16218 | Middle Content Fourth Paragraph | In-content |
| 16219 | MP Top Banner - Xome | Sponsored banner |
| 16221 | MP Footer Stick | Sticky footer |

**House ads (5 published):**

All currently house-promoting FSI events:
- LLSS26 house ads at 728×90, 300×250, 300×600 (Legal League Servicer Summit)
- GF26 house ads at 728×90, 300×600 (Government Forum)

**Cross-site ad serving is already demonstrated here** — MortgagePoint ads
promote FSI events. The same Advanced Ads + GAM stack is on thefivestar.com,
so the infrastructure for reciprocal or portfolio-wide ad serving already
exists without theme changes.

## Navigation

| Menu | Slug | Items | Locations |
|------|------|-------|-----------|
| Main | `main` | 8 | — (legacy) |
| **Main 2026** | `main-2026` | 18 | Active primary nav |
| Media Kit | `media-kit` | 31 | Media kit microsite |

**Main 2026 structure:**

```
Latest News (/news/)
News (/news/)
  ├── Lending/Originations
  ├── Default Servicing
  ├── Government
  ├── Market Trends
  └── Industry News
Magazine (/current-issue/)
  ├── Current Issue
  └── Archive (/recent-publications/)
MP Access (/mp-access-podcast/)
  ├── MP Access Podcast
  └── MP Daily (/mp-access/)
Media (/mp-access-podcast/)
  ├── MP Access Podcast
  └── Webinars → https://thefivestar.com/webinars/  ← CROSS-SITE
Events → https://thefivestar.com/conferences/  ← CROSS-SITE
About (/about-us/)
```

**The portfolio already links across domains at the nav level.** MortgagePoint
routes users to FSI for events and webinars. This is the existing cross-site
story — not theoretical.

## Homepage

| Field | Value |
|-------|-------|
| `show_on_front` | `page` |
| `page_on_front` | 334 |
| Title | Home |
| Builder | Elementor (`_elementor_edit_mode = builder`) |
| Template type | `wp-page` |

## Environments

| Environment | Install | SSH alias | PHP |
|-------------|---------|-----------|-----|
| Production | `mortgagepoint` | `mortgagepoint` | 8.2.30 |
| Staging | `mortgageptstg` | (not yet aliased) | TBD |

Staging exists on WPE (on Elementor Pro license list) but is not yet in
`~/.ssh/config`. Add before any SSH-based work on MortgagePoint staging.

## Repo status

No site repo exists yet. `../themortgagepoint-wp/` has not been scaffolded.
Per the 2026-04-18 decision, site repos are scaffolded after fivestar proves
the pattern. MortgagePoint is next in line after FSI pipeline is confirmed.

## Must-use plugins (WP Engine managed)

Standard WPE mu-plugins only (force-strong-passwords, wpe-cache-plugin,
wpe-update-source-selector, wpe-wp-sign-on-plugin, wpengine-security-auditor,
wpengine-common). **No custom FSG mu-plugins.** When the AIOSEO warning
suppression plugin (`fsg-suppress-aioseo-warning.php`) is deployed portfolio-wide,
this site needs it too — the warning fires here.

## Open issues / observations

| Priority | Issue | Notes |
|----------|-------|-------|
| 🟡 Med | `siteurl` stored as http, not https | Live site redirects correctly, but option value should be normalized |
| 🟡 Med | Elementor Pro 3.35.1 lags Elementor core 4.0.1 | Update to 4.0.3 available. Test staging first; version compatibility is tight in Elementor stack |
| 🟡 Med | aioseo-redirects PHP warning NOT suppressed here | Same upstream bug as FSI. Deploy `fsg-suppress-aioseo-warning.php` via Workflow A |
| 🟡 Med | Two Elementor add-on libraries (ElementsKit + Envato Elements) | Likely redundant — audit which widgets are actually used |
| 🟢 Low | Legacy Main menu (8 items) still exists alongside Main 2026 | Trash after verifying nothing references it |
| 🟢 Low | MonsterInsights (`google-analytics-for-wordpress`) active alongside Site Kit | Same redundancy that was cleaned up on FSI. Staging test, then remove |
| 🟢 Low | Simple History + Stream both installed | Two activity-log plugins — pick one |
| 🟢 Low | Hello Elementor has update 3.4.7 available | Low risk; schedule with next Elementor chain update |

## Portfolio fit — why this site matters to the thefivestar + amaaonline redesign decision

1. **Proof point for Elementor + Hello Elementor at scale.** MortgagePoint
   runs 3,351 posts, 41 magazine issues, 31 podcast episodes on this stack
   in production. Theme Builder + global kit is handling the design system.
2. **Proof point for Advanced Ads + GAM on Elementor.** FSI's ad infrastructure
   is not tied to The7/WPBakery. The same ad stack runs here without
   modification.
3. **Cross-site content syndication precedent.** Nav already links to FSI.
   If FSI adopts Elementor, cross-site post import becomes schema-compatible
   (same post meta, same block structure) rather than a rebuild per imported
   article.
4. **Guest-author (`mt_pp`) pattern worth replicating.** FSI currently has
   no guest-author CPT. If FSI wants to accept industry contributions
   (part of the "incorporate MP posts into FSI" intent), this is the
   proven pattern.

See `docs/decisions.md` for the full cross-site redesign decision brief.
