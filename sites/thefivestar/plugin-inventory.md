# Plugin Inventory: thefivestar.com

Last updated: 2026-04-19 — Phase 1 cleanup complete
WordPress 6.9.4 | The7 v14.3.0 | WPBakery mode

---

## WPBakery dependency chain

Update these together, in order. Never update independently.

| Plugin | Slug | Status | Version |
|--------|------|--------|---------|
| WPBakery Page Builder | `js_composer` | active | 8.7.2 |
| Ultimate Addons for WPBakery | `Ultimate_VC_Addons` | active | 3.21.3 |
| Ads for WPBakery (Visual Composer) | `ads-for-visual-composer` | active | 2.0.0 |
| The7 Core (theme companion) | `dt-the7-core` | active | 2.7.12 |

Update order: WPBakery → Ultimate Addons → Ads for WPBakery → The7 Core → The7 theme.

---

## SEO

| Plugin | Slug | Status | Version | Notes |
|--------|------|--------|---------|-------|
| All in One SEO Pro | `all-in-one-seo-pack-pro` | active | 4.9.6.2 | Primary SEO plugin |
| AIOSEO – E-E-A-T | `aioseo-eeat` | inactive | 1.2.10 | Remove if not using author authority features |
| AIOSEO – Image SEO | `aioseo-image-seo` | active | 1.2.4 | |
| AIOSEO – IndexNow | `aioseo-index-now` | active | 1.0.13 | Fast Bing/Yandex indexing ✅ |
| AIOSEO – Link Assistant | `aioseo-link-assistant` | active | 1.1.13 | Internal linking ✅ |
| AIOSEO – Local Business | `aioseo-local-business` | **active** | 1.3.12 | ⚠️ Not applicable to FSI — deactivate (Phase 2) |
| AIOSEO – News Sitemap | `aioseo-news-sitemap` | active | 1.0.21 | |
| AIOSEO – Redirects | `aioseo-redirects` | active | 1.4.14 | ⚠️ PHP warning on line 73 — update pending (Goal 4) |
| AIOSEO – REST API | `aioseo-rest-api` | **active** | 1.0.9 | ⚠️ Only for headless — deactivate (Phase 2) |
| AIOSEO – Video Sitemap | `aioseo-video-sitemap` | active | 1.1.26 | |
| Yoast Duplicate Post | `duplicate-post` | active | 4.6 | Useful for content workflows; keep |
| Broken Link Checker | `broken-link-checker-seo` | inactive | 1.2.10 | Run periodically — fine to keep inactive |
| 301 Redirects | `eps-301-redirects` | active | 2.84 | Redirect management |

**Removed 2026-04-19:** Yoast SEO (`wordpress-seo`) — redundant with AIOSEO Pro.

**PHP warning:** `aioseo-redirects` throws `Attempt to read property "hasMinimumVersion" on array`
at line 73. Plugin is active. Fix pending (Goal 4).

---

## Advertising

| Plugin | Slug | Status | Version |
|--------|------|--------|---------|
| Advanced Ads | `advanced-ads` | active | 2.0.19 |
| Advanced Ads Pro | `advanced-ads-pro` | active | 3.0.10 |
| Advanced Ads – Responsive | `advanced-ads-responsive` | active | 2.0.5 |
| Advanced Ads – Google Ad Manager | `advanced-ads-gam` | active | 3.0.3 |
| Advanced Ads – Sticky Ads | `advanced-ads-sticky-ads` | active | 2.0.5 |
| Advanced Ads – Tracking | `advanced-ads-tracking` | active | 3.0.11 |

Core ad revenue infrastructure. Do not deactivate without revenue impact analysis.

---

## Analytics and marketing

| Plugin | Slug | Status | Version | Notes |
|--------|------|--------|---------|-------|
| Site Kit by Google | `google-site-kit` | active | 1.176.0 | GA4 + Search Console |
| MonsterInsights | `google-analytics-for-wordpress` | **inactive** | 10.1.2 | ⚠️ Overlaps with Site Kit — decide and remove one |
| HubSpot (Leadin) | `leadin` | active | 11.3.45 | Forms, live chat, CRM |
| Stream | `stream` | active-network | 4.1.2 | WP activity log |
| OptiMonster | `optinmonster` | inactive | 2.16.22 | Remove if not actively used |

---

## Performance and media

| Plugin | Slug | Status | Version | Notes |
|--------|------|--------|---------|-------|
| WP Rocket | `wp-rocket` | active | 3.21.1 | Current version ✅ |
| Image Optimizer | `image-optimization` | **inactive** | 1.7.3 | ⚠️ Activate or remove |
| Slider Revolution | `revslider` | active | 6.7.38 | |
| SVG Support | `svg-support` | active | 2.5.14 | |

**Removed 2026-04-19:** Safe SVG (`safe-svg`) — duplicate of SVG Support.

---

## Page building and UI

| Plugin | Slug | Status | Version | Notes |
|--------|------|--------|---------|-------|
| Classic Editor | `classic-editor` | active | 1.6.7 | Required for WPBakery |
| Classic Widgets | `classic-widgets` | active | 0.3 | Required for WPBakery |
| Elementor | `elementor` | active | 4.0.2 | |
| Elementor Pro | `elementor-pro` | **active** | 4.0.2 | Audit pages before removing |
| Shortcodes Ultimate | `shortcodes-ultimate` | active | 7.5.0 | |
| Header Footer Code Manager | `header-footer-code-manager` | active | 1.1.44 | GTM, pixels, custom scripts |

**Removed 2026-04-19:** matchheight (`matchheight`) — legacy jQuery, nothing uses it.
**Removed 2026-04-19:** Blocksy Companion Pro (`blocksy-companion-pro`) — wrong theme companion.

---

## Content and custom fields

| Plugin | Slug | Status | Version | Notes |
|--------|------|--------|---------|-------|
| Toolset Types | `types` | active | 3.6.1 | Custom post types and fields |
| Toolset Views | `wp-views` | active | 3.6.21 | Content display |
| EventON Lite | `eventon-lite` | inactive | 2.5.2 | Activate if events published; else remove |

---

## Security

| Plugin | Slug | Status | Version |
|--------|------|--------|---------|
| Akismet | `akismet` | active | 5.6 |

---

## Must-use plugins (WP Engine managed)

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Force Strong Passwords | `slt-force-strong-passwords` | 1.8.0 | WPE security |
| WPE Cache Plugin | `wpe-cache-plugin` | 1.3.0 | Server cache layer |
| WPE Sign-On | `wpe-wp-sign-on-plugin` | 1.6.1 | WPE SSO |
| WPE Security Auditor | `wpengine-security-auditor` | 1.1.1 | |
| WPE MU Plugin | `mu-plugin` | 6.6.2 | |
| WPE Update Source | `wpe-update-source-selector` | 1.1.5 | |

These are auto-loaded by WP Engine. Do not attempt to deactivate.

---

## Cleanup backlog

| Plugin | Action | Reason |
|--------|--------|--------|
| AIOSEO – Local Business | **Deactivate** | Not applicable to FSI (Phase 2) |
| AIOSEO – REST API | **Deactivate** | Only for headless installs (Phase 2) |
| AIOSEO – Redirects | **Update** | PHP warning line 73 (Goal 4) |
| Elementor Pro | **Audit first** | Active — check which pages use it |
| MonsterInsights | **Decide** | Overlaps Site Kit for GA4 |
| Image Optimizer | **Activate or remove** | Currently inactive |
| OptiMonster | **Activate or remove** | Currently inactive |
| EventON Lite | **Activate or remove** | Depends on events use case |
| AIOSEO – E-E-A-T | **Activate or remove** | Depends on author authority strategy |

**Process:** Analyze → deactivate on staging → confirm site healthy → delete.

---

## WP-CLI notes

- **Production** (`thefivestar`): WP-CLI works via SSH. WordPress core present at `/nas/content/live/thefivestar/`.
- **Staging** (`thefivestarstg`): WP-CLI broken — WordPress core not present at `/sites/thefivestarstg/` (WPE mounts core at runtime on this environment). All plugin ops run on production directly for now. Flag to WPE support if staging WP-CLI is needed.
