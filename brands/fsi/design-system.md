# FSI Design System — Reference

Last updated: 2026-05-14 — page builder direction updated; typography captured from Elementor Global Kit v1

## Page builder

**Elementor + Elementor Pro 4.0.2** — all new FSI pages are built in Elementor.

- New pages use Elementor Full Width template
- Structural edits use JSON authoring workflow — see `docs/sops/elementor-json-authoring.md`
- WPBakery is **maintenance-only**: existing live pages stay in WPBakery until touched for a content/design update, at which point they migrate to Elementor
- Do not create new pages in WPBakery
- Classic Editor plugin must remain active while WPBakery pages exist
- Decision reference: `docs/decisions.md` 2026-04-22 portfolio standardization

## Theme: The7

- Version: 14.3.0 (Dream-Theme, slug: `dt-the7`)
- WP: 6.9.4
- Mega Menu: enabled (Deprecated Mega-Menu Settings also enabled)
- Custom post types active: Portfolio, Testimonials, Team, Photo Albums, Slideshows
- "Apply The7 Typography to H1–H6 automatically": OFF
  Typography is governed by the Elementor Global Kit (scoped CSS on `.elementor-heading-title`).
- **Hello Elementor migration is planned.** The7 stays as the active theme until header/footer
  templates are built in Elementor Theme Builder and WPBakery page dependencies are resolved.
  See `sites/thefivestar/theme-migration.md`.

## Brand tokens

These are the confirmed, canonical FSI brand values. All custom CSS must use these.
Do not hard-code hex values on individual pages — use the shared stylesheet classes
or Global Kit color slot bindings.

| Token | Hex | Use |
|-------|-----|-----|
| Navy (primary) | `#1f365c` | Backgrounds, borders, primary buttons, headings |
| Gold (accent) | `#c9a040` | CTA buttons, accent borders, highlights |
| Offwhite | `#f7f7f5` | Card backgrounds, subtle fills |
| Muted text | `#666` | Secondary text, location/meta info |
| Border | `#e0e0dc` | Card borders, dividers |
| Light grey | `#cfd5de` | Hero taglines, date year text |
| White | `#fff` | Page background, card fills |
| Dark navy hover | `#162848` | Primary button hover state |
| Dark gold hover | `#b8922e` | Gold button hover state |

## Elementor Global Kit color slots

Brand colors map to named custom-color slots in the Elementor Global Kit.
Use these slot IDs when authoring section JSON — do not use the legacy slot IDs.

| Slot ID | Token | Hex |
|---------|-------|-----|
| `fsi01nh` | Navy Hover | `#162848` |
| `fsi02gh` | Gold Hover | `#b8922e` |
| `fsi03ow` | Offwhite | `#f7f7f5` |
| `fsi04bd` | Border | `#e0e0dc` |
| `fsi05lg` | Light Grey | `#cfd5de` |
| `fsi06gt` | Gold Text Dark | `#b8922e` |
| `fsi07ho` | Hero Overlay | `rgba(31,54,92,0.72)` |

Standard Global Colors (Primary, Secondary, Text, Accent) also available.
**Do not bind new sections to legacy slot IDs** `f64043d`, `fd98090`, `7836aae`, `9bb2763`,
`9e77118`, `2922fdd`, `73bb18d` — those hold Velocity event colors for prod page back-compat.

Full kit spec: `sites/thefivestar/elementor-global-kit-spec.md`

## Typography

Captured from Elementor Global Kit v1 (2026-04-23). Governed by kit — do not override per-widget.

| Token | Family | Weight | Size | Role |
|-------|--------|--------|------|------|
| Primary | Roboto | 400 | 16px | Body base |
| Secondary | Roboto Slab | 400 | 15px | Section intro, muted body |
| Text | Roboto | 400 | 14px | Card text, event descriptions |
| Accent | Roboto | 400 | 13px | Labels, eyebrow, small caps |

Heading sizes are set via kit Custom CSS scoped to `.elementor-heading-title`:

| Heading | Size | Weight | Line height |
|---------|------|--------|-------------|
| H1 | 42px | 700 | 1.2 |
| H2 | 26px | 700 | 1.3 |
| H3 | 20px | 700 | 1.35 |
| H4 | 18px | 700 | 1.4 |

All headings render in Navy (`#1f365c`) via kit CSS. The7 specificity requires `!important`
on the `.elementor-heading-title` color rule — this will be removed after the Hello Elementor migration.

## Shared stylesheet

Custom styles for FSI HTML widget content are loaded via a mu-plugin.

**File:** `wp-content/mu-plugins/fsi-event-styles.php`
**Repo:** `thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php`
**Deployed to:** Staging ✅ | Production ✅ (deployed via F1-F3 foundation wave, 2026-04-30)

This mu-plugin backs the `fsi-*` CSS classes used inside Elementor HTML widgets (Option B pattern).
The Elementor Global Kit handles brand tokens for Elementor-native sections (containers, widgets).
To use these styles in an HTML widget, add class names to the HTML markup — do not add `style="..."` inline.

See SOP: `docs/sops/new-event-page.md` for the event page build workflow.
See `docs/sops/elementor-json-authoring.md` for the JSON authoring pipeline.
