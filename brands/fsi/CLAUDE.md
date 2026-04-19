# Brand Context: FSI — The Five Star Institute

> Read this before any work on thefivestar.com or FSI content.
> Part of `fsg-wp-ops/brands/fsi/`.

## Identity

| Field | Value |
|-------|-------|
| Brand name | The Five Star Institute |
| Short name | FSI / Five Star |
| Site | thefivestar.com |
| WPE install | `thefivestar` |
| Industry | Mortgage / real estate finance education and events |
| Primary audience | Mortgage servicers, originators, lenders, compliance professionals |
| Content types | Conferences, certifications, continuing education, webinars, editorial |

## Site repo

`../thefivestar-wp/` — see that repo's `CLAUDE.md` for code-level context.

## Voice and design

- Voice summary: `brands/fsi/voice-guide.md`
- Full voice guide: SharePoint → `Marketing/1. Voice Guides/FSI Library/`
  Use SharePoint MCP to read. Do not copy into this repo.
- Design system: `brands/fsi/design-system.md`

## What to know before any FSI task

- **WPBakery is the page builder.** Elementor Pro is installed but deactivated.
  Do not create Elementor content for FSI pages — it won't match the site.
- **Ad revenue is core infrastructure.** Advanced Ads Pro + GAM integration
  powers display advertising. Do not deactivate without understanding the impact.
- **HubSpot is live.** Forms, live chat, and contact management are active.
  Any form changes need to be tested — broken forms = lost leads.
- **The Five Star Conference** is FSI's flagship event. Conference-related
  content and pages are high priority and high visibility.
- The MortgagePoint (`themortgagepoint.com`) is FSI's media brand — separate
  WPE install, separate site repo, separate brand voice.

## Do not

- Do not activate Elementor Theme Style in The7 settings (breaks WPBakery mode)
- Do not update WPBakery, Ultimate Addons, The7 Elements, or The7 theme independently
  — update as a group on staging (see `docs/sops/plugin-update.md`)
- Do not remove Advanced Ads plugins without a revenue impact analysis
- Do not deactivate HubSpot plugin without confirming no active form dependencies
