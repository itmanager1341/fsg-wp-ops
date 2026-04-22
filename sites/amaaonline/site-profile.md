# Site Profile: amaaonline.com

Last audited: 2026-04-22 (live WP-CLI via SSH — source of truth)
Audit scope: stack, content volume, page-builder split, portfolio fit

## Brand & role

AMAA is the American Marketing & Auction Association (trade association).
The site is a **hybrid** — part member hub, part content publisher, part
auction-industry workflow system (deal tracking, tombstones, event calendar).

Unlike MortgagePoint, AMAA does not have a separate media site — its news
and content publishing lives on amaaonline.com itself (688 published posts
plus 24 podcast episodes).

Unlike thefivestar.com, AMAA doesn't point out to channel brands — it's
self-contained and member-facing.

## Install

| Field | Value |
|-------|-------|
| WPE content path | `/nas/content/live/amaaonline/` |
| WPE install name | `amaaonline` |
| Domain | https://amaaonline.com |
| WordPress | 6.9.4 |
| PHP (production) | 8.2.30 |
| DB table prefix | `wp_` (default) |
| Storage | 2.6 GB uploads |

## Theme

| Field | Value |
|-------|-------|
| Active theme | `dt-the7` 14.3.1 |
| Child theme | **None** |
| Inactive themes | `twentytwentyfive` 1.4 |

**Same theme family as thefivestar.com** (The7 14.3.0 on FSI, 14.3.1 on AMAA).
No child theme — any custom PHP/template work requires one be created first.

## Page builder — hybrid state (critical finding)

AMAA is running **both WPBakery and Elementor Pro active simultaneously**:

| Plugin | Version | Notes |
|--------|---------|-------|
| WPBakery Page Builder (`js_composer`) | 8.7.2 | Same version as FSI |
| Ultimate Addons for WPBakery (`Ultimate_VC_Addons`) | 3.21.4 | Slightly ahead of FSI (3.21.3) |
| Ads for WPBakery (`ads-for-visual-composer`) | 2.0.0 | Same as FSI |
| The7 Core (`dt-the7-core`) | 2.7.12 | Same as FSI |
| Elementor | 4.0.3 | Current |
| Elementor Pro | 4.0.3 | Current (ahead of MP which is on 3.35.1) |
| ElementsKit Lite | 3.9.2 | Same ecosystem as MP |
| Envato Elements | 2.0.16 | |
| Essential Addons for Elementor Lite (`essential-addons-for-elementor-lite`) | 6.6.2 | Third-party Elementor add-on (not on FSI or MP) |

**Page-builder split:**

| Type | Total published | Elementor-built | Not Elementor |
|------|-----------------|-----------------|---------------|
| Pages | 115 | 22 | 93 (WPBakery or Classic/other) |
| Posts | 688 | 23 | 665 |

Elementor covers ~19% of pages and ~3% of posts. The Theme Builder approach
isn't being used the way MortgagePoint uses it — AMAA's site is structurally
dominated by WPBakery + The7. Elementor appears to be deployed for specific
pages, not as the site framework.

**Homepage (page ID 363):** NOT Elementor (no `_elementor_edit_mode` meta).
Almost certainly WPBakery + The7, like FSI's homepage.

**Both builders load sitewide** because both plugins are active. Same performance
cost problem FSI has (documented in the 2026-04-19 Elementor phase-out decision),
but doubled — AMAA carries both CSS/JS payloads on every page regardless of
what built that page.

## Content volume

| Type | Published | Notes |
|------|-----------|-------|
| Posts | 688 | Active news/blog publishing |
| Pages | 115 | Hub + landing + member pages |
| Events (`ajde_events`) | 545 | EventON calendar — huge archive of past events |
| Deals (`deal`) | 178 | Custom post type — auction deal records |
| Tombstones (`tombstone`) | 127 | Auction industry memorial/announcement CPT (completed transactions) |
| Podcasts (`podcast`) | 24 | AMAA-produced podcast episodes |
| Video Library (`video-library`) | 2 | Barely populated |
| Elementor library templates | 10 | Far fewer than MP's 36 — Theme Builder underused |

### Storage comparison across portfolio

| Site | Posts published | Uploads |
|------|-----------------|---------|
| thefivestar.com | (low — hub site) | 1.78 GB |
| **amaaonline.com** | **688** | **2.6 GB** |
| themortgagepoint.com | 3,351 | 6.9 GB |

AMAA is a legitimate content publisher in its own right — 688 posts is
not a trivial volume.

## Custom post types (public)

| CPT | Count | Source plugin |
|-----|-------|--------------|
| `post` | 688 | WP core |
| `page` | 115 | WP core |
| `ajde_events` | 545 | EventON |
| `deal` | 178 | Toolset Types (auction-specific) |
| `tombstone` | 127 | Toolset Types (auction-specific) |
| `podcast` | 24 | Toolset Types |
| `dt_testimonials` | — | The7 Core |
| `dt_gallery` | — | The7 Core |
| `video-library` | 2 | Unknown plugin — investigate |
| `elementor_library` | 10 | Elementor |
| `e-landing-page` | — | Elementor Pro |
| `elementskit_content/template/widget` | — | ElementsKit |

The `deal` and `tombstone` CPTs are the auction-industry-specific workflow
that makes AMAA structurally different from FSI. Any redesign must preserve
their display templates and Toolset Views.

## Navigation

| Menu | Slug | Items | Locations |
|------|------|-------|-----------|
| **AMAA** | `amaa` | 85 | `primary`, `mobile` |
| Member Dashboard | `member-dashboard` | 12 | — |
| Quick Links | `quick-links` | 6 | `top` |

**85-item main menu is a red flag.** Either it's a deep mega-menu with many
child items, or it's overgrown and due for an IA cleanup. Worth inventorying.

## Plugin stack vs FSI and MortgagePoint

### Plugins AMAA has that FSI doesn't

| Plugin | Slug | Purpose |
|--------|------|---------|
| Bellows Pro | `bellows-pro` | Responsive menu plugin |
| EventON (full) | `eventON` 4.5 | Events calendar — 545 events live |
| Quick Page/Post Redirect | `quick-pagepost-redirect-plugin` | Redirects (duplicates `eps-301-redirects`) |
| Wild Apricot Login | `wild-apricot-login` 1.0.16 | **SSO integration — member DB is in Wild Apricot** |
| Visualizer | `visualizer` 4.0.1 | Data viz / charts |
| Types Access | `types-access` | Toolset access control |
| Cred Frontend Editor | `cred-frontend-editor` | Toolset frontend editing |
| Layouts | `layouts` | Toolset layouts |
| Essential Addons for Elementor | `essential-addons-for-elementor-lite` | Elementor widget library |
| ElementsKit Lite, Envato Elements | (Elementor add-ons) | Widget libraries |
| Elementor + Elementor Pro | (see above) | Second page builder alongside WPBakery |
| Guest Author | `guest-author` 2.61 | Same `mt_pp` people CPT pattern as MortgagePoint — but AMAA already has it |
| Disable Comments | `disable-comments` | Comment suppression |

**Wild Apricot SSO is being deprecated.** FSG Media is deprecating Wild
Apricot SSO for all memberships across the portfolio (planned migration to
the replacement AMS). `wild-apricot-login` plugin will be removed when that
migration completes. Not a constraint on Elementor migration.

### Plugins FSI has that AMAA doesn't

| Plugin | Why AMAA might not need it |
|--------|---------------------------|
| MonsterInsights | AMAA uses Site Kit only (cleaner than FSI) |
| OptiMonster | — |
| EventON Lite | AMAA has full EventON |
| Yoast SEO (legacy) | Already clean |
| Toolset basic Types only | AMAA has fuller Toolset stack (Access, CRED, Layouts) |

### Plugins AMAA still has that FSI cleaned up

| Plugin | Status on AMAA | FSI status |
|--------|---------------|------------|
| AIOSEO – Local Business | active | deactivated 2026-04-19 |
| AIOSEO – REST API | active | deactivated 2026-04-19 |

Both are candidates for the same cleanup FSI did.

## Homepage

| Field | Value |
|-------|-------|
| `show_on_front` | `page` |
| `page_on_front` | 363 (title: "Home") |
| Builder | **NOT Elementor** — most likely WPBakery + The7 |

## Environments

| Environment | Install | SSH alias | PHP |
|-------------|---------|-----------|-----|
| Production | `amaaonline` | `amaaonline` | 8.2.30 |
| Staging | `amaastag` | (not yet aliased) | TBD |

Staging exists on WPE (on Elementor Pro license list: `amaastag.wpenginepowered.com`).
Not yet aliased in `~/.ssh/config`. Add before SSH work on AMAA staging.

## Repo status

No site repo exists. `../amaaonline-wp/` has not been scaffolded.
Per 2026-04-18 decision, scaffolding waits for FSI pattern proof.

## Must-use plugins (WP Engine managed)

Standard WPE mu-plugins only. **No custom FSG mu-plugins.**
`fsg-suppress-aioseo-warning.php` is needed here — the warning fires
on every CLI command (confirmed: "Attempt to read property 'hasMinimumVersion'
on array in /nas/content/live/amaaonline/wp-content/plugins/aioseo-redirects/aioseo-redirects.php on line 73").

## Open issues

| Priority | Issue | Notes |
|----------|-------|-------|
| 🟡 Med | **Two active page builders** (WPBakery + Elementor Pro) | **Resolves per 2026-04-22 standardization decision:** Elementor is the forward builder. The existing 22 pages + 23 posts on Elementor are on-standard; WPBakery migrates as pages are touched. Sequenced after FSI migration. |
| 🟡 Med | 85-item main menu | Likely overgrown — audit IA |
| 🟡 Med | `aioseo-redirects` PHP warning NOT suppressed | Deploy `fsg-suppress-aioseo-warning.php` via Workflow A |
| 🟡 Med | Two redirect plugins active (`eps-301-redirects` + `quick-pagepost-redirect-plugin`) | Pick one; consolidate |
| 🟡 Med | AIOSEO Local Business + REST API active | Same cleanup FSI did — deactivate |
| 🟡 Med | WPBakery chain update coming | Same risk as FSI; consolidated SOP needed |
| 🟡 Med | Essential Addons for Elementor Lite + ElementsKit Lite + Envato Elements all active | Likely redundant; audit widget usage |
| 🟢 Low | EventON at v4.5 — check latest | |
| 🟢 Low | Wild Apricot Login at v1.0.16 — verify plugin is still maintained | Check last-updated date; if stale, find alternative before portfolio migration |

## Portfolio fit — key points for the redesign decision

1. **AMAA is closer to FSI than to MortgagePoint.** Same theme (The7), WPBakery
   as the dominant builder, hub/association role — not a pure content-publisher
   like MortgagePoint.

2. **But AMAA also publishes content** — 688 posts and 24 podcasts. Any
   redesign should support real editorial workflows, not just marketing pages.

3. **Elementor is already active here, partially used.** Unlike FSI (where
   Elementor is phase-out), AMAA has Elementor Pro on the current 4.0.3
   version and already running 22 pages + 23 posts on it. A "standardize on
   Elementor" decision at AMAA is less of a lift than at FSI — the plugin
   exists, the license covers it, some content already uses it.

4. **Auction-specific workflows matter.** `deal` and `tombstone` CPTs plus
   Toolset Views are how AMAA renders auction industry data. Any theme
   migration preserves or rebuilds these patterns.

5. **Wild Apricot SSO is being deprecated** (separate project). Not a
   constraint on Elementor migration.

6. **EventON is being replaced.** FSG Media is implementing a ReMembers AMS
   event integration that will replace EventON. 545 existing events are a
   data migration consideration for that project — not a constraint on the
   Elementor page-builder migration. EventON remains functional during the
   transition.

See `docs/decisions.md` for the portfolio redesign decision brief.
