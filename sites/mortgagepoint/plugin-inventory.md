# Plugin Inventory: themortgagepoint.com

Last updated: 2026-04-22 (from live WP-CLI audit)
WordPress 6.9.4 | hello-elementor 3.4.6 | Elementor 4.0.1 / Pro 3.35.1

All plugins listed as active unless noted. No deletions or changes made —
this is a snapshot for informing the portfolio redesign decision.

---

## Elementor ecosystem

| Plugin | Slug | Version | Update | Notes |
|--------|------|---------|--------|-------|
| Elementor | `elementor` | 4.0.1 | 4.0.3 | Core builder |
| Elementor Pro | `elementor-pro` | 3.35.1 | 4.0.3 | **Major version lag** — test staging before update |
| ElementsKit Lite | `elementskit-lite` | 3.9.0 | 3.9.2 | Third-party widget library |
| Envato Elements | `envato-elements` | 2.0.16 | — | Template library |
| Site Mailer | `site-mailer` | 1.4.3 | 1.4.4 | Elementor's SMTP plugin |

**Update order (Elementor chain):** Elementor core → Elementor Pro →
ElementsKit → Envato Elements. Do on staging first. No SOP exists yet for
the Elementor chain; write one before first update. Treat as moderate-to-high
risk because of the 3.x→4.x Pro jump.

---

## Advertising (core revenue infrastructure)

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Advanced Ads | `advanced-ads` | 2.0.18 | Update available (2.0.20) |
| Advanced Ads Pro | `advanced-ads-pro` | 3.0.9 | |
| Advanced Ads – Responsive | `advanced-ads-responsive` | 2.0.5 | |
| Advanced Ads – GAM | `advanced-ads-gam` | 3.0.3 | Google Ad Manager integration |
| Advanced Ads – Layer | `advanced-ads-layer` | 2.0.3 | **MP-only** — popover/interstitials (not on FSI) |
| Advanced Ads – Sticky Ads | `advanced-ads-sticky-ads` | 2.0.4 | |
| Advanced Ads – Tracking | `advanced-ads-tracking` | 3.0.10 | |

Nearly identical to FSI ad stack. The Layer add-on is the one difference —
it's what enables MP's exit-intent and popup system (also see
`Popup with Form` / `Exit Intent` Elementor library templates).

---

## SEO

| Plugin | Slug | Version | Status | Notes |
|--------|------|---------|--------|-------|
| All in One SEO Pro | `all-in-one-seo-pack-pro` | 4.9.6 | active | Update to 4.9.6.2 available (same as FSI) |
| AIOSEO – Image SEO | `aioseo-image-seo` | 1.2.4 | active | |
| AIOSEO – News Sitemap | `aioseo-news-sitemap` | 1.0.21 | active | |

**Notable absences vs FSI:** No AIOSEO Redirects, Link Assistant, IndexNow,
E-E-A-T, Video Sitemap, Local Business, or REST API modules on MP. Either
intentionally lighter or a cleanup opportunity depending on what MP actually
needs.

**No Yoast.** Only AIOSEO. Cleaner than FSI was.

**`aioseo-redirects` is NOT installed** — the PHP warning nonetheless fires
here (during wp-cli at least). Worth investigating — may be an AIOSEO Pro
core bug, not an add-on bug. This changes the FSI suppression mu-plugin
assumption slightly.

Redirects managed via `eps-301-redirects` on FSI; MortgagePoint doesn't appear
to have a redirect plugin active. TBD whether redirects are handled via WPE
portal or elsewhere.

---

## Analytics and marketing

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Site Kit by Google | `google-site-kit` | 1.176.0 | GA4 + Search Console |
| MonsterInsights | `google-analytics-for-wordpress` | 10.1.2 | **Redundant with Site Kit** — same cleanup as FSI staging |
| HubSpot (Leadin) | `leadin` | 11.3.45 | Forms, live chat, CRM |

---

## Activity logs

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Stream | `stream` | 4.1.2 | WP activity log (same as FSI) |
| Simple History | `simple-history` | 5.25.0 | **Redundant with Stream** — pick one |

---

## Page building and UI

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Shortcodes Ultimate | `shortcodes-ultimate` | 7.5.0 | Same as FSI and AMAA |
| Header Footer Code Manager | `header-footer-code-manager` | 1.1.44 | GTM, pixels |

**No Classic Editor or Classic Widgets** — Hello Elementor + Elementor Pro
own the entire UI. Gutenberg is active for post authoring where Elementor
isn't used.

---

## Content and custom fields

| Plugin | Slug | Version | Notes |
|--------|------|---------|-------|
| Toolset Types | `types` | 3.6.1 | Custom post types (publication, podcast) |
| Toolset Views | `wp-views` | 3.6.21 | Content display |
| Guest Author | `guest-author` | 2.61 | Creates the `mt_pp` people CPT for bylines |
| Metronet Profile Picture | `metronet-profile-picture` | 2.6.3 | Gravatar alternative |
| WP DataTables | `wpdatatables` | 6.5.0.3 | Update 6.5.0.5 available |
| Calameo | `wp-calameo` | 2.1.8 | Publication viewer (magazine embed) |
| WP Consent API | `wp-consent-api` | 2.0.1 | GDPR/consent |
| Image Optimization | `image-optimization` | 1.7.3 | Update 1.7.4 available |
| Code Snippets | `code-snippets` | 3.9.5 | Used instead of functions.php |
| Better Search Replace | `better-search-replace` | 1.4.10 | Migration tool (typically deactivated; active here) |
| Disable Comments | `disable-comments` | 2.7.0 | |

---

## Must-use plugins (WP Engine managed)

| Plugin | Slug |
|--------|------|
| Force Strong Passwords | `slt-force-strong-passwords` |
| WPE Cache Plugin | `wpe-cache-plugin` |
| WPE Sign-On | `wpe-wp-sign-on-plugin` |
| WPE Security Auditor | `wpengine-security-auditor` |
| WPE MU Plugin | `mu-plugin` (`wpengine-common`) |
| WPE Update Source | `wpe-update-source-selector` |

**No custom FSG mu-plugins installed** — when `fsg-suppress-aioseo-warning.php`
or the future `fsi-event-styles.php` equivalent are ready for portfolio rollout,
this site will need them deployed via its own GitHub Actions pipeline (not yet
scaffolded).

---

## Cleanup candidates (not done this session — informational)

| Priority | Plugin | Reason |
|----------|--------|--------|
| 🟡 | MonsterInsights | Redundant with Site Kit (same cleanup done on FSI) |
| 🟡 | Simple History | Redundant with Stream |
| 🟡 | Better Search Replace | Migration tool left active |
| 🟢 | ElementsKit Lite or Envato Elements | Likely only one is actively used; audit widget usage |
| 🟢 | Code Snippets | Evaluate if contents could move to child theme once repo is scaffolded |

No changes recommended before the portfolio redesign decision is made.
Cleanup is a post-decision activity.
