# Plugin Inventory: amaaonline.com

Last updated: 2026-04-22 (from live WP-CLI audit)
WordPress 6.9.4 | The7 14.3.1 | Hybrid WPBakery + Elementor Pro

All plugins listed are active. No deletions or changes made — this is a
snapshot for informing the portfolio redesign decision.

---

## Two active page builders — resolves under 2026-04-22 decision

AMAA runs **both** WPBakery and Elementor Pro active simultaneously. Both
load CSS/JS sitewide. Per the 2026-04-22 portfolio standardization decision,
**Elementor is the forward builder**. The existing 22 pages + 23 posts on
Elementor are on-standard. WPBakery migrates to Elementor as pages are
touched; chain retires when active WPBakery page count reaches zero.

Sequenced after FSI migration proves the pattern.

See `docs/decisions.md` 2026-04-22 entry.

---

## WPBakery stack

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| WPBakery Page Builder | `js_composer` | 8.7.2 | Same as FSI |
| Ultimate Addons for WPBakery | `Ultimate_VC_Addons` | 3.21.4 | Slightly ahead of FSI (3.21.3) |
| Ads for WPBakery | `ads-for-visual-composer` | 2.0.0 | Same as FSI |
| The7 Core | `dt-the7-core` | 2.7.12 | Same as FSI |

## Elementor stack

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Elementor | `elementor` | 4.0.3 | Ahead of MP (4.0.1) |
| Elementor Pro | `elementor-pro` | 4.0.3 | Ahead of MP (3.35.1) |
| ElementsKit Lite | `elementskit-lite` | 3.9.2 | Matches MP's update state |
| Envato Elements | `envato-elements` | 2.0.16 | Same as MP |
| Essential Addons for Elementor | `essential-addons-for-elementor-lite` | 6.6.2 | **AMAA-only** — not on FSI or MP |

Three Elementor widget libraries (ElementsKit Lite, Envato Elements, Essential
Addons) are all active at once. Probable redundancy — audit which widgets
are actually referenced before picking one.

---

## Advertising

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Advanced Ads | `advanced-ads` | 2.0.20 | Current |
| Advanced Ads Pro | `advanced-ads-pro` | 3.0.11 | Slightly ahead of FSI (3.0.10) |
| Advanced Ads – Responsive | `advanced-ads-responsive` | 2.0.5 | |
| Advanced Ads – Sticky Ads | `advanced-ads-sticky-ads` | 2.0.5 | |
| Advanced Ads – Tracking | `advanced-ads-tracking` | 3.0.11 | |

**Notable:** AMAA does NOT have Advanced Ads – GAM (Google Ad Manager)
or Advanced Ads – Layer. Ad inventory here is lighter than MortgagePoint's.
Revenue-critical ads likely served direct rather than programmatic.

---

## SEO

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| All in One SEO Pro | `all-in-one-seo-pack-pro` | 4.9.6.2 | Current |
| AIOSEO – Image SEO | `aioseo-image-seo` | 1.2.4 | |
| AIOSEO – IndexNow | `aioseo-index-now` | 1.0.13 | |
| AIOSEO – Link Assistant | `aioseo-link-assistant` | 1.1.13 | |
| AIOSEO – Local Business | `aioseo-local-business` | 1.3.12 | **Active — same cleanup candidate FSI deactivated** |
| AIOSEO – News Sitemap | `aioseo-news-sitemap` | 1.0.21 | |
| AIOSEO – Redirects | `aioseo-redirects` | 1.4.14 | **PHP warning firing** — suppression mu-plugin needed |
| AIOSEO – REST API | `aioseo-rest-api` | 1.0.9 | **Active — same cleanup candidate FSI deactivated** |
| AIOSEO – Video Sitemap | `aioseo-video-sitemap` | 1.1.26 | |
| 301 Redirects | `eps-301-redirects` | 2.84 | |
| Quick Page/Post Redirect | `quick-pagepost-redirect-plugin` | 5.2.4 | **Redundant with eps-301-redirects — consolidate** |

---

## Events

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| EventON | `eventON` | 4.5 | Full (not Lite). 545 published events. **Being replaced** by ReMembers AMS event integration |

---

## Analytics and marketing

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Site Kit by Google | `google-site-kit` | 1.177.0 | |
| HubSpot (Leadin) | `leadin` | 11.3.45 | Same as FSI and MP |

**No MonsterInsights.** AMAA is cleaner here than FSI and MP both.

---

## Membership / auction-industry workflow

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Wild Apricot Login | `wild-apricot-login` | 1.0.16 | **Being deprecated** — SSO migration planned; plugin will be removed |
| Types Access | `types-access` | 2.9.4.2 | Role/cap-based content access via Toolset |
| Cred Frontend Editor | `cred-frontend-editor` | 2.6.23 | Toolset frontend forms |
| Layouts | `layouts` | 2.6.17 | Toolset layouts |
| Toolset Types | `types` | 3.6.1 | CPTs (same as FSI/MP) |
| Toolset Views | `wp-views` | 3.6.21 | |

AMAA's Toolset footprint is **four plugins deeper** than FSI
(`types-access`, `cred-frontend-editor`, `layouts`). This reflects AMAA's
more sophisticated content workflow (deal/tombstone CPTs, frontend editing,
role-based access for members). Any theme migration touches Toolset Views
that render these CPTs.

---

## Content helpers

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Guest Author | `guest-author` | 2.61 | Same `mt_pp` people CPT pattern as MortgagePoint |
| Visualizer | `visualizer` | 4.0.1 | Data viz / charts |
| Disable Comments | `disable-comments` | 2.7.0 | |
| Duplicate Post | `duplicate-post` | 4.6 | Same as FSI |
| Shortcodes Ultimate | `shortcodes-ultimate` | 7.5.0 | Same as FSI, MP |
| Header Footer Code Manager | `header-footer-code-manager` | 1.1.44 | Same as FSI, MP |
| Bellows Pro | `bellows-pro` | 1.4.3 | Responsive menu (AMAA-only) |

---

## Performance / media

| Plugin | Slug | Version |
|--------|------|---------|
| Slider Revolution | `revslider` | 6.7.38 |
| SVG Support | `svg-support` | 2.5.14 |

**No WP Rocket on AMAA.** FSI and (presumably) MortgagePoint have WP Rocket;
AMAA doesn't. Either using WPE cache alone, or page-level caching is slower
than it could be. Worth confirming and adding if absent.

---

## Classic Editor stack (WPBakery dependency)

| Plugin | Slug | Version |
|--------|------|---------|
| Classic Editor | `classic-editor` | 1.6.7 |
| Classic Widgets | `classic-widgets` | 0.3 |

Both required for WPBakery. Whether they stay depends on the portfolio
builder decision.

---

## Must-use plugins (WP Engine managed)

Standard WPE set (force-strong-passwords, wpe-cache-plugin, wpe-wp-sign-on-plugin,
wpengine-security-auditor, wpe-update-source-selector, wpengine-common).

**No custom FSG mu-plugins.** `fsg-suppress-aioseo-warning.php` and any
shared CSS plugin will need deployment here via a future `amaaonline-wp`
GitHub Actions pipeline.

---

## Cleanup candidates (pre-decision)

| Priority | Plugin | Reason |
|----------|--------|--------|
| 🔴 | Resolve page-builder split | Full portfolio decision — see `docs/decisions.md` |
| 🟡 | AIOSEO Local Business (deactivate) | Same action FSI took |
| 🟡 | AIOSEO REST API (deactivate) | Same action FSI took |
| 🟡 | `quick-pagepost-redirect-plugin` | Redundant with `eps-301-redirects` |
| 🟡 | Audit three Elementor widget libraries | Pick one of ElementsKit / Envato / Essential Addons |
| 🟢 | Add WP Rocket | Performance baseline vs FSI/MP |
| 🟢 | Verify Wild Apricot Login plugin maintenance status | Critical integration, stale plugin = risk |

No cleanup performed this session. Informational only.
