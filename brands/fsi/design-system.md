# FSI Design System — Reference

Last updated: 2026-04-19 — brand tokens confirmed from fsi-event-styles.php

## Page builder

**WPBakery Page Builder** — all FSI page layouts use WPBakery shortcodes.

- Backend Editor is the primary editing interface
- Do not mix Gutenberg blocks into WPBakery pages
- Classic Editor plugin must stay active
- The7 Theme Settings → Optimize for: **WPBakery** (confirmed)
- Elementor is installed but being phased out — do not use for new pages

## Theme: The7

- Version: 14.3.0 (Dream-Theme, slug: `dt-the7`)
- WP: 6.9.4
- Mega Menu: enabled (Deprecated Mega-Menu Settings also enabled)
- Custom post types active: Portfolio, Testimonials, Team, Photo Albums, Slideshows
- "Apply The7 Typography to H1–H6 automatically": OFF
  Typography is set per-element in WPBakery.

## Brand tokens

These are the confirmed, canonical FSI brand values. All custom CSS must use these.
Do not hard-code hex values on individual pages — use the shared stylesheet classes.

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

## Typography

_Capture from The7 → Theme Options → Typography during next admin session._

| Element | Font | Weight | Size |
|---------|------|--------|------|
| Body | TBD | TBD | TBD |
| H1 | TBD | TBD | TBD |
| H2 | TBD | TBD | TBD |
| Navigation | TBD | TBD | TBD |

## Shared stylesheet

Custom styles for FSI pages are loaded via a mu-plugin, not inline CSS.

**File:** `wp-content/mu-plugins/fsi-event-styles.php`
**Repo:** `thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php`
**Deployed to:** Staging ✅ | Production ❌ (pending — not yet promoted)

To use these styles, add class names to HTML elements. Do not add `style="..."` inline.
See SOP: `docs/sops/new-event-page.md` for the full page-building workflow.
