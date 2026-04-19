# FSI Design System — Reference

> Populate exact values from The7 → Theme Options after the next site audit.
> Until then, use this as a checklist of what to capture.

## Page builder

**WPBakery Page Builder** — all FSI page layouts use WPBakery shortcodes.

- Backend Editor is the primary editing interface
- Do not mix Gutenberg blocks into WPBakery pages
- Classic Editor plugin must stay active
- The7 Theme Settings → Optimize for: **WPBakery** (confirmed)

## Theme: The7

- Version: 6.9.4 (Dream-Theme)
- Mega Menu: enabled (Deprecated Mega-Menu Settings also enabled)
- Custom post types active: Portfolio, Testimonials, Team, Photo Albums, Slideshows
- "Apply The7 Typography to H1–H6 automatically": OFF
  Typography is set per-element in WPBakery.

## Colors

_Capture from The7 → Theme Options → Colors during next audit._

| Role | Hex | Notes |
|------|-----|-------|
| Primary | TBD | Main brand / CTA buttons |
| Secondary | TBD | Accents |
| Body text | TBD | |
| Link | TBD | |
| Header background | TBD | |
| Footer background | TBD | |

## Typography

_Capture from The7 → Theme Options → Typography._

| Element | Font | Weight | Size |
|---------|------|--------|------|
| Body | TBD | TBD | TBD |
| H1 | TBD | TBD | TBD |
| H2 | TBD | TBD | TBD |
| Navigation | TBD | TBD | TBD |

## Image standards

| Context | Dimensions | Format | Max size |
|---------|-----------|--------|----------|
| Featured image | 1200×630 | JPG | 200 KB |
| Hero / slider | 1920×800 | JPG | 400 KB |
| Inline article | 800×450 | JPG | 150 KB |
| Team headshot | 400×400 | JPG | 80 KB |
| Logo / icon | — | SVG or PNG | 50 KB |

## WPBakery elements in use

- The7 Elements (The7-specific widgets)
- Ultimate Addons for WPBakery (extended element library)
- Slider Revolution (hero sliders)
- Shortcodes Ultimate (supplemental shortcodes)

## Notes for AI-generated layouts

- Stay within WPBakery backend editor patterns
- Do not generate Elementor or Gutenberg markup for FSI pages
- Mega Menu edits go through WP Admin → Appearance → Menus
- If generating CSS: check for child theme before adding to parent
