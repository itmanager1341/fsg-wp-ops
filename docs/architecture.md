# Architecture

How FSG Media's WordPress portfolio is structured and operated.
For site-specific details see `sites/{site}/site-profile.md`.

---

## High-level stack

```
Cloudflare DNS (external)
  └─▶ WP Engine CDN
        └─▶ WP Engine server cache
              └─▶ WP Rocket (plugin cache)
                    └─▶ WordPress 6.9.4
                          └─▶ MySQL (WPE managed)
```

---

## Code deployment pipeline (Workflow A)

For tracked code only — child theme, custom plugins, mu-plugins.

```
Local machine
  └─▶ git push → GitHub (itmanager1341/thefivestar-wp)
        └─▶ GitHub Actions
              ├─▶ WP Engine Git remote → thefivestarstg  (auto on push to main)
              └─▶ WP Engine Git remote → thefivestar     (manual + approval gate)
```

## Plugin and operational changes (Workflow B)

For plugin installs, updates, deactivations, deletions, cache, DB.
GitHub not involved — plugins live on the WPE server, not in git.

```
SSH → WP-CLI on thefivestarstg (staging — always first)
  └─▶ verify OK
        └─▶ SSH → WP-CLI on thefivestar (production)
```

See `docs/how-changes-are-made.md` for full detail and risk levels.

---

## Repo layout

```
itmanager1341/
├── fsg-wp-ops/          ← this repo: docs, brands, sites, scripts
├── thefivestar-wp/      ← FSI site code (reference implementation)
├── amaaonline-wp/       ← AMAA site code (not yet scaffolded)
└── themortgagepoint-wp/ ← MP site code (not yet scaffolded)
```

Site repos track only custom code:
```
{site}-wp/
├── wp-content/themes/{custom-child}/
├── wp-content/plugins/{custom-fsg-*}/
└── wp-content/mu-plugins/
```
WP core, third-party plugins, and uploads are never tracked.


---

## thefivestar.com — stack detail

| Layer | Detail |
|-------|--------|
| Theme | The7 v14.3.0 (Dream-Theme) — Hello Elementor migration planned; see `sites/thefivestar/theme-migration.md` |
| Page builder | **Elementor + Elementor Pro 4.0.2** (forward); WPBakery maintenance-only |
| SEO | All in One SEO Pro 4.8.6.2 + add-on suite |
| Performance | WP Rocket (needs update from 2.6.1) |
| Ads | Advanced Ads Pro + AMP Ads + GAM + Sticky + Tracking |
| CRM/Marketing | HubSpot All-in-One |
| Analytics | MonsterInsights + Site Kit by Google |
| Activity log | Stream |
| PHP (prod) | 8.2 |
| PHP (stg/dev) | 8.4 |

Elementor 4.0.2 and Elementor Pro 4.0.2 are active (2026-04-22 portfolio standardization decision).
Elementor Global Kit v1 is live on staging; brand color + typography tokens partially promoted to production.
WPBakery remains active for legacy pages; Classic Editor + Classic Widgets stay active until all WPBakery
pages are retired. The7 Theme Settings page-builder mode is left as WPBakery — Elementor pages work
regardless of this setting. Hello Elementor theme migration is planned as a separate phase.

---

## Tool access

| Tool | How we use it |
|------|--------------|
| Filesystem / Desktop Commander MCP | Read/write local repo files |
| GitHub MCP (itmanager1341) | Repo management, Actions status |
| SharePoint MCP | Voice guides at `Marketing/1. Voice Guides/` |
| WordPress MCP (AI Engine plugin) | Per-site live ops — install once per site |
| WP Engine API | Backups, cache purge, domain management |
| Supabase MCP (itmanager1341) | Adjacent projects: mpdash, seed-connect, tmr-design-studio |
| WP CLI over SSH | Plugin updates, DB ops, cache management |

---

## Secrets management

- Local: `.env` (gitignored), loaded by direnv via `.envrc`
- GitHub Actions: repo-level Secrets, never in code
- WPE API creds: Application Passwords in WPE portal → User → API Access
- SSH keys: registered per-user in WPE portal
- WP REST API: Application Passwords on WP Admin user, not main admin password

---

## Decision log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-04 | thefivestar-wp is reference impl | Prove pattern before rolling to AMAA + MP |
| ~~2026-04~~ | ~~WPBakery stays as FSI page builder~~ | Superseded 2026-04-22 — Elementor is forward builder |
| 2026-04-22 | Elementor + Elementor Pro as sole forward builder | WPBakery maintenance-only; migrate as pages are touched |
| 2026-04 | AIOSEO Pro over Yoast | Paid investment; Yoast is redundant and will be removed |
| 2026-04 | PHP 8.4 on FSI stg/dev | Test forward compat before prod upgrade |
