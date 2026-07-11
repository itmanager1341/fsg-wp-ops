# Site Profile: thefivestar.com

Last audited: 2026-05-18 (full prod state audit: page IDs, Elementor versions, all migrated pages confirmed HTTP 200; FSI Offers page added). Prior Phase 1.3 audit baseline: 2026-04-23.

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

## Production page ID map

Source of truth for per-environment WordPress post IDs across staging + production.
Section JSON content lives in `elementor-templates/`; page IDs live here.
Update this section whenever a page is created, slug-swapped, or trashed on either environment.

Last updated: 2026-05-16.

### Currently shipped (Elementor, live)

| URL | Prod ID | Staging ID | Template type | Notes |
|---|---|---|---|---|
| `/events/` | 5089 | 5089 | event-pages/_hub | Shipped 2026-05-01 (Wave 1 Step 4 in-place swap); preserves child URLs |
| `/events/velocity/` | 5110 | 5107 | event-pages/velocity | Shipped 2026-04-30 (Wave 1 Step 1 create-new + slug-swap) |
| `/events/velocity-old/` | 5088 | 5088 | WPBakery (rollback) | Preserved from pre-swap |
| `/memberships/` | 5113 | 5138 | membership-pages/_hub | Shipped 2026-04-30 (Wave 1 Step 2 create-new + slug-swap) |
| `/memberships-old/` | 2597 | 2597 | WPBakery (rollback) | Preserved from pre-swap |
| `/communities/` | 5114 | 5141 | community-pages/_hub | Shipped 2026-04-30 (Wave 1 Step 3 single create-and-populate) |
| `/communities/real-estate-professionals/` | 5115 | 5109 | community-pages/real-estate-professionals | Shipped 2026-05-01 (Wave 1 Step 5 create-new + slug-swap); content updated 2026-05-16 (cross-link to /resources/offers/ + hero margin fix + em-dash removal) |
| `/memberships-old/real-estate-professionals/` | 5087 | 5087 | WPBakery (rollback) | Orphaned under 2597 by Wave 1 Step 2 memberships slug-swap; intentional 404 at old `/memberships/real-estate-professionals/` URL |
| `/resources/offers/` | 5127 | 5145 | resource-pages/offers | Shipped 2026-05-16 (new page create); content fix 2026-05-21 (Hosted Page removed from Free tier) |
| `/memberships/alliance/` | 5128 | 5146 | membership-pages/alliance | Shipped 2026-05-18 (new page create); Phase 4a first instance; FSI Membership Page template |

### Parent pages (anchors only)

| URL | Prod ID | Notes |
|---|---|---|
| `/resources/` | 9 | Long-standing root-level page; anchor for child resources |
| `/conferences/` | 2683 | Legacy LLSS / Government Forum / SFR Summit parent (still WPBakery) |

### Not yet shipped to prod

| Repo path | Staging ID | Status |
|---|---|---|
| `event-pages/legal-league-servicer-summit/` (LLSS) | 5106 | Phase 1.11 pending; Template A revision pending (apply Velocity 2026-04-30 pattern) |
| Phase 4a Membership pages (6 remaining: FORCE, Legal League, NMSA, MSEA, PPEF, AMDC) | — | Pending Phase 4a (Alliance shipped 2026-05-18) |
| Phase 4b Community siblings (Mortgage Finance, Legal, Prop Pres) | — | Pending Phase 4b 2nd+ instances |

### Active Elementor kit

| Environment | Kit page ID | Elementor version |
|---|---|---|
| Production | 4004 | 4.0.3 |
| Staging | 4004 | 4.0.2 |

### Page-ID conventions

- **Atomic rollback** keys: `_elementor_data_backup_<YYYY_MM_DD_HH_MM_SS>` on the post in question. Set automatically by the compose-and-push pipeline before any `update_post_meta` write.
- **In-place swap** rollback keys: `_elementor_inplace_swap_backup_<YYYY_MM_DD_HH_MM_SS>_*` (post_content, elementor_data, edit_mode). Used by Wave 1 Step 4 Events hub pattern.
- **WPE checkpoint** taken before each prod-touching ship. IDs recorded in decisions.md.
- **post_modified caveat:** `update_post_meta` does NOT change `post_modified`. To find a page's last meta-write timestamp, check `_elementor_data_backup_*` meta keys (most recent backup timestamp = previous-write timestamp; prior-to-most-recent = the write before that).

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
| 🟢 Done | RE Pros Elementor LIVE on PROD (page 5115 since 2026-05-01 via create-new + slug-swap; parent 5114 communities hub). 8 sections. Old WPBakery 5087 preserved at `/memberships-old/real-estate-professionals/`. No redirect from `/memberships/real-estate-professionals/` — that URL is intentionally dead; RE Pros is a community, not a membership. **Content updated 2026-05-16**: added inline "Learn more →" cross-link to /resources/offers/ in Alliance tier sub-card, fixed hero margin (max-width:1100px; margin:0 auto; padding:64px 20px), removed two em-dashes from FORCE tier description. Backup `_elementor_data_backup_2026_05_16_16_01_59`. | ✅ PROD — `https://thefivestar.com/communities/real-estate-professionals/` |
| 🟢 Done | Memberships hub Elementor LIVE on PROD (page 5113 since 2026-04-30 ~20:30 via Wave 1 Step 2 create-new + slug-swap). Old WPBakery 2597 preserved at /memberships-old/. 4 sections (seven-memberships hero, 6-tile specialty grid, Alliance foundation strip, footer-line). All 7 logos via clean attachments (FORCE 5112 + LL 5111 re-uploaded; others 5103/5105/5107/5108/5109). Followed by Step 3.5 nav repoint (TFSI item 2622 + Footer item 2779 → 5113). | ✅ PROD — `https://thefivestar.com/memberships/`. Atomic rollback: `_elementor_data_backup_2026_04_30_202430` |
| 🟢 Done | Five Star Alliance membership page LIVE on PROD (page 5128 since 2026-05-18 via single create + push). 9 sections. First instance of FSI Membership Page template. White centered hero (distinct from Community template navy hero). Charter Member callout (time-sensitive: Velocity 2026, May 20-21). Not nav-wired per standing rule. Rollback: `wp post delete 5128 --force`. | ✅ PROD — `https://thefivestar.com/memberships/alliance/` |
| 🟡 Med | Phase 4a Membership pages — 6 remaining (FORCE, Legal League firms, AMDC, PPEF, NMSA, MSEA) | Pending Phase 4a — Alliance template proven; 6 builds remain |
| 🟢 Done | Communities hub Elementor LIVE on PROD (page 5114 since 2026-04-30 ~21:20 via Wave 1 Step 3 single create-and-populate; `/communities/` did not exist on prod previously). 6 sections, no images, Template C alignment applied. NOT nav-wired per standing rule (page is published but discoverable only via direct URL or from RE Pros once 4b.11 ships). | ✅ PROD — `https://thefivestar.com/communities/`. Rollback: delete prod page 5114, URL becomes 404 again |
| 🟢 Done | FSI Offers page Elementor LIVE on PROD (page 5127 since 2026-05-16 via single create + push). 8 sections under new `resource-pages/offers/` template-type directory. 2-tier ladder (Free + Alliance). Hero names audience ("built for real estate professionals"). Linked from RE Pros community Alliance tier sub-card via "Learn more →" cross-link. Resource Page template — first instance. | ✅ PROD — `https://thefivestar.com/resources/offers/`. Rollback: `wp post delete 5127 --force` |
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
