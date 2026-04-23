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
- Do not wire new pages into navigation (top nav, mobile nav, footer) without
  explicit per-entry approval in chat. Publishing a new page is authorized;
  exposing it via nav is not. Standing rule, not per-phase. Single pre-approved
  exception: Phase 2 Events hub migration may replace the existing `/conferences/`
  top-nav entry with `/events/`. No other nav changes inherit this approval.
- Do not update WPBakery, Ultimate Addons, The7 Elements, or The7 theme independently
  — update as a group on staging (see `docs/sops/plugin-update.md`).
  Lower priority under the standardization decision but still required if the
  chain is touched.
- Do not remove Advanced Ads plugins without a revenue impact analysis.
- Do not deactivate HubSpot plugin without confirming no active form dependencies.
- Do not delete Elementor or Elementor Pro.
- Do not activate Gutenberg as the editor for WPBakery pages that haven't been
  migrated yet — they render raw shortcodes.

## IA structure for Phase 4 (locked 2026-04-23)

Phase 4 authors TWO templates, not one. Memberships and Communities are
distinct IA structures and visually distinct templates.

- **`/memberships/`** — existing member groups (FORCE, Legal League, AMDC,
  PPEF, NMSA, MSEA) plus new Five Star Alliance Membership. Update in place.
  Template: "FSI Membership Page."
- **`/communities/`** — NEW subfolder. Children: Mortgage Finance, Legal, RE
  Pro, Prop Pres (profession-based audience cuts). Greenfield authoring.
  Template: "FSI Community Page" — visually distinct from Membership per
  Jonathan's direction.

`/memberships/` keeps its existing URL structure and parent nav entry;
`/communities/` requires fresh nav approval before wiring.

## Transition state notes

- **Phase 1.3 complete (2026-04-23):** Elementor Pro Global Kit v1 is live
  on FSI staging. Kit spec: `sites/thefivestar/elementor-global-kit-spec.md`.
  Kit export artifact: `sites/thefivestar/elementor-global-kit-v1.zip`.
  Regression canary page: `/kit-test/` on staging — do not delete.
- **The7 CSS specificity fights Elementor.** Any Custom CSS targeting plain
  HTML elements (`h1, p, a`, etc.) will be overridden by The7. Scope CSS to
  Elementor widget classes (`.elementor-widget-heading .elementor-heading-title`,
  etc.). See `sites/thefivestar/the7-elementor-specificity-notes.md` for
  the full finding. Every new widget type used in templates likely needs
  matching scoped override rules.
- **Elementor v4 note:** v4.0.2 on staging. v4 removed Theme Style,
  Typography, and Buttons panels. Kit configuration = Global Colors + Global
  Fonts + Layout + Custom CSS. Button presets are per-widget saved as Global
  Widgets (Phase 1.4 deliverable). Kit export path is `Templates → Kits &
  Templates`, not the older `Elementor → Tools → Export Kit`.
- Classic Editor and Classic Widgets remain active while WPBakery pages exist.
  They can retire only after all pages are Elementor-native.
- The7 Theme Settings page-builder mode: leave as-is for now. Elementor pages
  work inside The7 regardless of this setting. Touching it risks breaking
  existing WPBakery pages during transition.
- `fsi-event-styles.php` mu-plugin stays deployed. During transition it backs
  plain-HTML event pages. After Phase 1.4 LLSS ships, the Elementor Pro global
  kit owns brand tokens; the mu-plugin retains only CSS the kit can't express
  (may retire entirely by end of Phase 3).
