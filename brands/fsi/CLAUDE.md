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
- **Do not bind new Elementor sections/widgets to legacy custom-color slot IDs**
  `f64043d`, `fd98090`, `7836aae`, `9bb2763`, `9e77118`, `2922fdd`, `73bb18d`.
  Those slots are reserved for prod page back-compat (they hold Velocity
  event colors on prod). Bind brand colors to `fsi01nh` (Navy Hover),
  `fsi02gh` (Gold Hover), `fsi03ow` (Offwhite), `fsi04bd` (Border),
  `fsi05lg` (Light Grey), `fsi06gt` (Gold Text Dark), `fsi07ho` (Hero
  Overlay). See `sites/thefivestar/elementor-global-kit-spec.md`.
- **Do not use `wp elementor kit import` for routine kit-content edits.**
  In Elementor 4.0.2 it silently no-ops with `--include=site-settings` and
  appends instead of replaces without `--include`. Use direct
  `update_post_meta(_elementor_page_settings)` per
  `docs/sops/elementor-json-authoring.md`. `kit import` is reserved for
  greenfield imports only (first-time on fresh sites, cross-site promotion).
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

- **Phase 1.3 complete (2026-04-23, version-controlled 2026-04-25):**
  Elementor Pro Global Kit v1 is live on FSI staging. Kit JSON
  source-of-truth at `sites/thefivestar/elementor-kit/*.json`. Kit zip
  artifact at `sites/thefivestar/elementor-global-kit-v1.zip`. Regression
  canary page: `/kit-test/` on staging — do not delete.
- **AI-first JSON authoring (Workflow C1, 2026-04-25):** All Elementor
  kit edits, sections, page content, and templates are authored as JSON
  in this repo and pushed via WP-CLI. UI is reserved for one-time widget
  schema discovery + cases the CLI surface doesn't cover (Theme Builder
  conditions, popups, dynamic tags). SOP: `docs/sops/elementor-json-authoring.md`.
- **Custom-color slot ID renumber (2026-04-25):** Kit has 17 custom colors
  total. Legacy slots (`f64043d`, etc.) hold Velocity event colors and are
  preserved for prod page back-compat. Brand colors (Navy Hover, Gold
  Hover, Offwhite, Border, Light Grey, Gold Text Dark, Hero Overlay) live
  at `fsi01nh` through `fsi07ho`. See `Do not` section above and
  `sites/thefivestar/elementor-global-kit-spec.md`.
- **Widget schema oracle (2026-04-26):** Phase 1.4 Pre-work #2 complete.
  `sites/thefivestar/elementor-templates/widget-references/` holds
  v4.0.2 schema references for the widgets Phase 1-3 sections will use:
  heading, text-editor, button, image, spacer, divider, image-box,
  nested container. **Standard Elementor `icon-box` was NOT bootstrapped**
  — The7's panel labels make it impossible to spot without trial-and-error.
  Phase 1.4 builds feature-grid "icons" via Image (64×64) + Heading + Text
  inside a container instead. Same visual outcome, theme-agnostic.
- **Option B pattern for FSI event pages (2026-04-26):** Use ONE Elementor
  HTML widget per content section, containing the existing `fsi-page-wrap`
  CSS-class markup (`.fsi-card-gold`, `.fsi-grid-3`, `.fsi-callout-gold`,
  `.fsi-membership-card`, `.fsi-photo-strip`, etc.). `fsi-event-styles.php`
  mu-plugin handles the visual design. Keep widget trees only for sections
  with bg-image + overlay (Hero, Final CTA). Net result: visual parity
  with WPBakery design, 45% smaller `_elementor_data`, 75% fewer widgets.
  See `docs/decisions.md` 2026-04-26 entry. **Apply this pattern to Phase 2
  (Events hub) and Phase 3 (Velocity) authoring.**
- **Image-swap workflow for HTML widget placements (2026-04-26):**
  1. Upload to Media Library via WP Admin (or `wp media import` CLI)
  2. Get the URL from Media Library "Copy URL"
  3. Edit the section's JSON file in repo: replace
     `<div class="fsi-img-placeholder">...</div>` with
     `<img src="..." alt="..." width="..." height="..." loading="lazy" />`
  4. Push via standard `wp eval-file` pipeline + Elementor `flush_css`
  Hero + Final CTA bg images are easier — they're Elementor Container
  background settings, swap via the Elementor editor's Style panel OR
  update `background_image: { url, id }` in the JSON.
- **Elementor versions pinned 4.0.2 / 4.0.2 on FSI** (per 2026-04-25
  decision). Disable WP auto-update for `elementor` and `elementor-pro`.
  Upgrades are deliberate and require re-export of kit + widget references
  to verify schema didn't drift.
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
- **Prod kit drift (2026-04-25 finding):** prod kit 4004 was last modified
  2025-11-04 (5 months stale relative to staging). Always check
  `wp post get <kit_id> --field=post_modified` on prod before promoting any
  kit change. Prod and staging kits drift independently.
- Classic Editor and Classic Widgets remain active while WPBakery pages exist.
  They can retire only after all pages are Elementor-native.
- The7 Theme Settings page-builder mode: leave as-is for now. Elementor pages
  work inside The7 regardless of this setting. Touching it risks breaking
  existing WPBakery pages during transition.
- `fsi-event-styles.php` mu-plugin stays deployed. During transition it backs
  plain-HTML event pages. After Phase 1.4 LLSS ships, the Elementor Pro global
  kit owns brand tokens; the mu-plugin retains only CSS the kit can't express
  (may retire entirely by end of Phase 3).
