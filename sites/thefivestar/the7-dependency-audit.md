# The7 Dependency Audit — thefivestar.com

**Purpose:** Determine the real cost of a The7 → Hello Elementor theme swap
on thefivestar.com by measuring actual usage of The7-specific features, not
assumed usage from plugin presence.

**Date:** 2026-04-23
**Method:** SSH + WP-CLI read-only queries against production (`thefivestar`)
**Motivating question:** The 2026-04-22 portfolio standardization decision
defers the theme question ("stay on The7 vs swap to Hello Elementor") as a
separate later decision. Before committing to two themes across the portfolio
(Hello Elementor on MortgagePoint, The7 on FSI + AMAA), confirm what The7 is
actually doing on FSI that Hello Elementor wouldn't cover.

---

## Findings by layer

### 1. The7 custom post types — data volume

| CPT | Slug | Published records |
|-----|------|-------------------|
| Portfolio | `dt_portfolio` | 0 |
| Team | `dt_team` | 5 |
| Photo Albums | `dt_gallery` | 1 |
| Testimonials | `dt_testimonials` | 11 |
| Slideshows | `dt_slideshow` | 0 |

**17 total records across 5 CPTs.** Three of the five CPTs are empty.

Site profile had two wrong slugs — `project` was the assumed Portfolio slug
but the correct registered slug is `dt_portfolio`. Slideshows are `dt_slideshow`
(singular), not `dt_slideshows`. Corrected here.

### 2. The7 shortcode consumption in page/post content

Count of published pages + posts whose `post_content` references each
shortcode pattern:

| Shortcode | Consuming pages/posts |
|-----------|-----------------------|
| `dt_team` | 3 |
| `dt_testimonials` | 0 |
| `dt_gallery` | 0 |
| `dt_portfolio` | 0 |
| `dt_slideshow` | 0 |

Only 3 pages render any The7 CPT via shortcode. Testimonials (11 records)
and Team (5 records) exist as data but aren't displayed through standard
shortcodes; they may be rendered via widgets or unused entirely.

### 3. Widgets actively placed in widget areas

From WP Admin → Appearance → Widgets, inventory of widgets actually placed
in active widget areas (not available-but-unplaced):

| Widget | Count | Area |
|--------|-------|------|
| DT-Custom menu style 1 | 3 | Default Footer (Our Services, Services, Learn More About Our Memb...) |
| DT-Contact form | 1 | Services |
| DT-Contact info | 1 | Default Footer |

**5 The7 widget instances active, all simple chrome** — menus, contact form,
contact info. Zero The7 CPT widgets (DT-Team, DT-Testimonials list/slider,
DT-Portfolio projects, DT-Photos, DT-Blog posts) placed anywhere.

All five have direct Elementor Pro equivalents (Nav Menu widget, Form widget
or HubSpot shortcode, Text/Icon widgets).

### 4. Primary navigation

**TFSI menu** (assigned to `primary`, `mobile`, `bottom` locations):

```
Home
Media
Events
  ├── Live
  └── Virtual
Memberships
News & More
  └── Resources
Contact
```

- 7 top-level items, 3 children, max depth 2
- **Zero mega-menu metadata** on any item (no `_dt_mega_menu`, no
  `_the7_mega_menu`, no custom HTML, no mega-menu classes)
- Site profile noted "Legacy Deprecated Mega-Menu Settings: Enabled" in
  The7 Theme Options — confirmed as a toggle without content. It is on,
  but no menu item actually uses it.
- One oddity: duplicate "Media" relationship (top-level Media item + "Virtual"
  child of Events pointing at `/webinars/`). IA cleanup candidate, not a
  migration blocker.

Rebuilds as a standard Elementor Pro Nav Menu widget with zero custom work.

### 5. Homepage — the complication

**Two "Home" pages exist:**

| ID | Slug | Status | Builder | Content |
|----|------|--------|---------|---------|
| 363 | `home` | **publish** (live) | **WPBakery** | 20,290 chars of `post_content`, top is `[vc_row][vc_column][ultimate_heading]...` |
| 4909 | `home-2` | private | Elementor (stub) | 189 chars of `_elementor_data`, created 2025-06-30, last touched 2026-02-13, abandoned |

**Live homepage (363) is WPBakery, not Elementor.** Vestigial Elementor meta
on 363 (`_elementor_data`, `_elementor_pro_version = 3.35.0`) is leftover
from an abandoned rebuild attempt. Not rendering.

**Live homepage is also deeply coupled to The7:**

| Meta key | Value | What it does |
|----------|-------|--------------|
| `_dt_slideshow_revolution_slider` | `home-slider-2026` | Home hero is a Revolution Slider slideshow, driven through The7's slideshow system |
| `_dt_slideshow_mode` | `revolution` | Confirms Revolution Slider as hero renderer |
| `_dt_header_*` (many) | populated | Per-page header overrides via The7's controls (background, opacity, etc.) |
| `_dt_footer_*` | populated | Per-page footer overrides via The7's controls |
| `the7_fancy_title_css` | populated | The7 "fancy title" custom CSS |
| `the7_shortcodes_dynamic_css` | 5 entries | Dynamic CSS from The7 shortcodes within the page |

If The7 leaves, the homepage needs: a new hero (embed Revolution Slider via
Elementor, rebuild as Elementor Pro Slides widget, or use native Elementor
slideshow) + per-page header/footer overrides rebuilt as Elementor Pro Theme
Builder templates with conditional logic.

---

## Net cost assessment

| Layer | Swap cost | Notes |
|-------|-----------|-------|
| CPT data (5 CPTs, 17 records) | Near zero | None actively displayed; trash or no-op |
| The7 shortcodes in content | Low | 3 pages reference `dt_team`; rebuild as Elementor |
| Widgets placed in active areas | Low | 5 items, all chrome; direct Elementor Pro equivalents |
| TFSI navigation | Low | 7-item, 2-level, no mega menu; Nav Menu widget swap |
| **Homepage rebuild** | **Medium** | 20K chars WPBakery + Revolution Slider hero + The7 per-page overrides |
| The7 Theme Options (not audited) | Unknown, likely medium | Global typography, colors, header/footer layout — must be rebuilt in Elementor global kit regardless of theme swap; audit needed |

**Overall read:** the Hello Elementor swap is feasible with no hidden
structural landmines, but it is **not free**. Scope is bounded:

1. One meaningful homepage rebuild (the production home is WPBakery + The7
   slideshow + The7 header/footer overrides)
2. Three pages with `dt_team` to rebuild
3. Header/footer per-page override logic to rebuild as Elementor Pro
   Theme Builder templates
4. Revolution Slider to either re-embed via an Elementor widget or replace
   with a native Elementor slideshow

Rough estimate: 1-2 weeks of focused work when the decision is made, not a
multi-month migration.

---

## What's NOT in this audit

The following were out of scope here and should be checked before committing
to a theme swap:

1. **The7 Theme Options / Customizer configuration.** Global typography,
   color palette, header layout, footer layout, logo, topbar, sidebar
   defaults. These don't migrate when the theme changes; they have to be
   rebuilt in Elementor Pro's global kit regardless. Cheap if minimal,
   medium cost if heavily customized.
2. **The7 Core plugin dependencies.** `dt-the7-core` is in the WPBakery
   update chain and ships some of the CPT registrations + shortcodes.
   Removing The7 fully requires understanding what The7 Core provides that
   the site depends on beyond the CPT registrations audited here.
3. **CSS classes used in page content.** If WPBakery pages have inline
   class names like `accent-border-color`, `accent-title-color`, or other
   The7-themed classes, those styles evaporate with the theme. Grep across
   all `post_content` to quantify.
4. **Per-page The7 overrides beyond the homepage.** The `_dt_*` meta keys
   exist on any page where they were customized. Worth querying how many
   pages have any `_dt_*` meta populated to scope the per-page rebuild.

---

## Recommendation

**Don't decide theme direction yet.** The audit confirms the swap is
bounded-scope, not structural, so nothing about the Phase 1-3 Elementor
migration plan needs to change based on this data. Phases 1-3 (LLSS, Events
hub, Velocity) all proceed on The7 as-is and are unaffected by the theme
question either way.

**Revisit at Phase 4 kickoff** when there's concrete data on how Elementor +
Elementor Pro behave inside The7 during real migration work. If it's clean,
staying on The7 is free. If Elementor and The7 fight over rendering (CSS
specificity conflicts, global kit collisions with The7 Theme Options, etc.),
the swap case gets stronger with real evidence.

**Treat the homepage as its own phase whenever it happens.** It's the
highest-stakes page on the site, it's the most deeply The7-coupled, and it
should not be bundled with event-template authoring work.

**Before Phase 4, complete the two remaining unknowns:** The7 Theme Options
inventory + The7-themed CSS class grep across all `post_content`. Both are
<30-minute audits. Completing them locks in a real confidence number on the
swap cost.

---

## Related documents

- `docs/decisions.md` — 2026-04-22 portfolio standardization decision;
  theme direction flagged as "deferred as separate decision"
- `sites/thefivestar/wpbakery-migration.md` — migration tracker; open
  questions section references the theme-direction question
- `sites/thefivestar/site-profile.md` — The7 version, CPT slugs (corrections
  noted here should be backported)
