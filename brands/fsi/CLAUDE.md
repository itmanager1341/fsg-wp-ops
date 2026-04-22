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

- **Elementor + Elementor Pro is the forward page builder.** All new pages are
  built in Elementor. Existing WPBakery pages migrate to Elementor as they are
  touched. See `docs/decisions.md` 2026-04-22 portfolio standardization decision.
- **WPBakery is in maintenance-only mode.** Still active because ~all existing
  live pages are built in it, but no new pages are created in WPBakery and no
  feature work is done on WPBakery sections. Retires when all active pages are
  Elementor-native.
- **Theme is The7.** Elementor Pro runs inside The7. A swap to Hello Elementor
  is a separate, later decision — not blocked on the builder standardization.
- **First Elementor work:** rebuild the Events hub (5089), Velocity (5088), and
  Legal League Servicer Summit (5094) pages in Elementor to establish the event
  page template. These are currently plain-HTML-in-WPBakery pages using the
  shared `fsi-event-styles.php` mu-plugin; they're the ideal first migration
  because content is fresh and CSS tokens are already documented.
- **Ad revenue is core infrastructure.** Advanced Ads Pro + GAM integration
  powers display advertising. Do not deactivate without understanding the impact.
  Advanced Ads works on Elementor (proven on MortgagePoint).
- **HubSpot is live.** Forms, live chat, and contact management are active.
  Any form changes need to be tested — broken forms = lost leads.
- **The Five Star Conference** is FSI's flagship event. Conference-related
  content and pages are high priority and high visibility.
- The MortgagePoint (`themortgagepoint.com`) is FSI's media brand — separate
  WPE install, separate site repo, separate brand voice. **Cross-site content
  syndication (importing MP posts into FSI) is a near-term intent**, enabled
  by both sites being on Elementor.

## Do not

- Do not create new pages in WPBakery. New pages = Elementor only.
- Do not update WPBakery, Ultimate Addons, The7 Elements, or The7 theme independently
  — update as a group on staging (see `docs/sops/plugin-update.md`).
  Lower priority under the standardization decision but still required if the
  chain is touched.
- Do not remove Advanced Ads plugins without a revenue impact analysis.
- Do not deactivate HubSpot plugin without confirming no active form dependencies.
- Do not delete Elementor or Elementor Pro.
- Do not activate Gutenberg as the editor for WPBakery pages that haven't been
  migrated yet — they render raw shortcodes.

## Transition state notes

- Classic Editor and Classic Widgets remain active while WPBakery pages exist.
  They can retire only after all pages are Elementor-native.
- The7 Theme Settings page-builder mode: leave as-is for now. Elementor pages
  work inside The7 regardless of this setting. Touching it risks breaking
  existing WPBakery pages during transition.
- `fsi-event-styles.php` mu-plugin stays deployed. During transition it backs
  plain-HTML event pages. After migration, its role shrinks — most tokens move
  into the Elementor Pro global kit; the mu-plugin retains only CSS the kit
  can't express.
