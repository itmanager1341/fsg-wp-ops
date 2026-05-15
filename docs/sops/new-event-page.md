# SOP: Creating a New FSI Event Page

Applies to: thefivestar.com event detail pages under `/events/{slug}/`
Last updated: 2026-05-14 — rewritten for Elementor + JSON authoring workflow

---

## Overview

New event pages are built in **Elementor** using the **Option B pattern**: one HTML widget
per content section containing `fsi-page-wrap` class-based markup. Hero and Final CTA sections
use Elementor container widgets (bg-image + overlay). This keeps widget trees minimal (~45%
smaller `_elementor_data` than full Elementor widget trees) while preserving full visual design.

Event pages live under the Events hub (`/events/`, page ID 5089) as WordPress child pages.
The URL structure is `/events/{slug}/` — set via WordPress parent/child page relationships.

**JSON template source:** `sites/thefivestar/elementor-templates/event-pages/`

- LLSS template: `event-pages/legal-league-servicer-summit/` — 9 sections, most complete reference
- Velocity template: `event-pages/velocity/` — 8 sections (Section 5 photo strip skipped)

**Push pipeline:** `docs/sops/elementor-json-authoring.md`

---

## Pre-flight checklist

- [ ] `fsi-event-styles.php` is deployed to the target environment
  - Staging: ✅ always deployed via GitHub Actions on push to main
  - Production: ✅ deployed (F1-F3 foundation wave, 2026-04-30)
- [ ] JSON authoring toolchain ready: `wp eval-file` access via SSH confirmed
- [ ] Event details on hand: name, date(s), location, description, Swoogo registration links

---

## Step 1 — Create the page in WP Admin

1. WP Admin → Pages → Add New
2. Set the title (e.g. "Servicer Summit")
3. Set parent page: **Events** (ID 5089)
4. Set slug: `servicer-summit` (lowercase, hyphenated)
5. Set template: **Elementor Full Width** (not Default Template — The7's default template
   injects header chrome that conflicts with Elementor's full-width layout)
6. Leave as Draft — do not publish yet
7. Save and note the new page ID (visible in the URL: `?post=NNNN`)

URL will resolve as: `https://thefivestar.com/events/servicer-summit/`

---

## Step 2 — Choose and clone the closest JSON template

Pick the template that most closely matches the new event's structure:

- **`event-pages/legal-league-servicer-summit/`** — Full 9-section event with photo strip and next-summit callout. Most complete reference.
- **`event-pages/velocity/`** — Newer format; no photo strip, includes info bar and charter offer section.

Clone the template directory, rename it for the new event, and edit section JSON files
to replace all event-specific copy (name, date, location, Swoogo URLs, image placeholders).

---

## Step 3 — Section structure

Standard 8–9 section layout for an FSI event page:

| # | File | Pattern | Notes |
|---|------|---------|-------|
| 01 | `01-hero.json` | Elementor Container (bg-image + overlay) | Navy overlay, date + tagline + CTA button |
| 01b | `01b-info-bar.json` | HTML widget | Optional info strip (Velocity style) |
| 02 | `02-intro-who-belongs.json` | HTML widget | `.fsi-intro` + `.fsi-grid-3` cards |
| 03 | `03-what-happens.json` | HTML widget | `.fsi-grid-2` feature items |
| 04 | `04-next-summit.json` or `04-charter-offer.json` | HTML widget | `.fsi-callout-gold` block |
| 05 | `05-recent-summit-strip.json` | HTML widget | `.fsi-photo-strip` — skip if no past-event photos |
| 06 | `06-membership-cards.json` | HTML widget | `.fsi-membership-grid` — Five Star Alliance + FORCE cards |
| 07 | `07-event-details.json` | HTML widget | `.fsi-section-muted` recap / details block |
| 08 | `08-final-cta.json` | Elementor Container (bg-image + overlay) | Gold CTA strip |
| 09 | `09-footer-line.json` | HTML widget | Minimal footer line |

**Section skip rules:**

- Section 05 (photo strip): skip for first-format or new events with no past photos
- Section 01b (info bar): Velocity pattern only — omit for LLSS-style events
- Sections 04 and 07 are interchangeable depending on event maturity (callout vs recap)

---

## Step 4 — Edit section JSON and push

For each section:

1. Open the section JSON file in your editor
2. Replace all event-specific placeholders:
   - Event name, date string, venue + city
   - Swoogo register URL (all CTA `href` values)
   - Image `src` URLs (upload to Media Library first — see image-swap workflow below)
   - Copy blocks: intro paragraph, card titles/text, feature items
3. Push via the `wp eval-file` pipeline:

```bash
# Push a single section to staging
ssh thefivestarstg 'wp eval-file /tmp/push-section.php' < scripts/push-section.php
```

See `docs/sops/elementor-json-authoring.md` for the full pipeline, including how to
update `_elementor_data` on the page post and run `flush_css`.

**Hero + Final CTA bg images:** These are Elementor Container background settings.
Update `background_image: { url, id }` in the section JSON, or swap via the
Elementor editor's Style panel after pushing.

**Image-swap workflow for HTML widget placeholders:**

1. Upload to Media Library via WP Admin or `wp media import`
2. Get the URL from Media Library → Copy URL
3. In the section JSON, replace `<div class="fsi-img-placeholder">...</div>` with:
   `<img src="URL" alt="ALT TEXT" width="W" height="H" loading="lazy" />`
4. Push updated JSON via the pipeline

---

## Step 5 — Set SEO metadata

- **AIOSEO Title:** `EVENT NAME – The Five Star`
- **AIOSEO Description:** 1-2 sentences, include event name, date, primary audience

---

## Step 6 — Verify on staging before publishing

1. Publish the draft page (or set to preview-able status)
2. Check: URL resolves correctly (`/events/{slug}/`)
3. Check: Elementor CSS loaded — no raw HTML fallback, no shortcode bleed
4. Check: `fsi-*` classes render correctly (navy/gold/grid layout)
5. Check mobile: resize to < 768px — grids collapse to 1 column
6. Check: CTA buttons link to correct Swoogo registration URLs
7. Check: hero + final CTA background images display (no broken image icons)

---

## Step 7 — Add card to the Events hub page

Once the event page is ready, add an event card to `/events/` (page ID 5089).
Edit `sites/thefivestar/elementor-templates/event-pages/events/02-event-cards.json`
(or `00-hero.json` / `01-hub-intro.json` if the card lives there), add the new card
markup, and push via the standard pipeline.

Use the `.fsi-event-card` pattern:

```html
<div class="fsi-event-card">
  <div class="fsi-event-date">
    <span class="fsi-event-date__month">MON</span>
    <span class="fsi-event-date__day">DD</span>
    <span class="fsi-event-date__year">YYYY</span>
  </div>
  <div class="fsi-event-body">
    <div class="fsi-event-label">PROFESSION / AUDIENCE TYPE</div>
    <h3 class="fsi-event-title">EVENT NAME</h3>
    <p class="fsi-event-location">VENUE | CITY, STATE</p>
    <p class="fsi-event-desc">One-sentence description.</p>
    <div class="fsi-event-actions">
      <a href="LEARN_MORE_URL" class="fsi-btn fsi-btn--outline">Learn More</a>
      <a href="REGISTER_URL" class="fsi-btn fsi-btn--primary">Register Now</a>
    </div>
  </div>
</div>
```

---

## Adding or updating CSS classes

If a new event requires a layout not covered by existing classes:

1. Edit `thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php` locally
2. Add the new class with a comment explaining its purpose
3. Push to main → GitHub Actions auto-deploys to staging
4. Verify on staging
5. Trigger production deploy via GitHub Actions (manual workflow trigger)
6. Update the class reference appendix below

Do not add one-off styles inline on the page. Every style goes in the shared file.

---

## Appendix: fsi-* CSS class reference

All classes below are served by `fsi-event-styles.php` mu-plugin. Use inside Elementor
HTML widgets — do not add `style="..."` inline.

### Layout

- `.fsi-page-wrap` — max-width 1100px, centered, horizontal padding
- `.fsi-intro` — max-width 820px, centered, bottom margin

### Hero banner

- `.fsi-event-hero` — navy background, centered, rounded
- `.fsi-event-hero__date` — gold date line
- `.fsi-event-hero__tagline` — italic muted tagline
- `.fsi-event-hero__cta` — CTA button wrapper
- `.fsi-event-hero--image` — hero with background-image support (overlay built in)

### Section headings

- `.fsi-section-heading` — h2 with grey bottom border

### Grids (responsive — collapse to 1 col on mobile)

- `.fsi-grid-3` — 3-column grid
- `.fsi-grid-2` — 2-column grid

### Cards (top-bordered)

- `.fsi-card-gold` — gold top border, offwhite background
- `.fsi-card-navy` — navy top border, offwhite background
- `.fsi-card__title` — card heading
- `.fsi-card__text` — card body text

### Feature items (left-bordered)

- `.fsi-feature` — gold left border, padding
- Use `h4` and `p` inside

### Buttons

- `.fsi-btn.fsi-btn--gold` — gold fill, navy text — hero CTA
- `.fsi-btn.fsi-btn--primary` — navy fill, white text — secondary CTA
- `.fsi-btn.fsi-btn--outline` — white fill, navy border — tertiary

### Image and callout patterns (v1.1)

- `.fsi-image-block` — full-width image container (1100×440px)
- `.fsi-img-placeholder` — styled placeholder with label/desc until real photo added
- `.fsi-img-placeholder__label`, `.fsi-img-placeholder__desc`
- `.fsi-photo-strip` — 3-up horizontal photo grid with captions
- `.fsi-photo-strip__item`, `.fsi-photo-strip__caption`
- `.fsi-callout-gold` — gold background callout (Next Summit, announcements)
- `.fsi-callout-gold__eyebrow`, `.fsi-callout-gold__heading`, `.fsi-callout-gold__body`
- `.fsi-callout-gold__detail`, `.fsi-callout-gold__link`
- `.fsi-section-muted` — light grey reflective section (Recent Summit, recap content)
- `.fsi-section-muted__heading`, `.fsi-section-muted__body`
- `.fsi-membership-grid` — 2-col grid for membership cards
- `.fsi-membership-card` — card with image top + body + CTA
- `.fsi-membership-card__image`, `.fsi-membership-card__body`
- `.fsi-membership-card__title`, `.fsi-membership-card__text`, `.fsi-membership-card__cta`
- `.fsi-program-full` — full-width program element (e.g. Closing Reception)
- `.fsi-section-intro` — intro paragraph above a grid section

### Event hub cards (for use on /events/ hub page only)

- `.fsi-event-card`, `.fsi-event-date`, `.fsi-event-body`
- `.fsi-event-label`, `.fsi-event-title`, `.fsi-event-location`
- `.fsi-event-desc`, `.fsi-event-actions`
- `.fsi-event-date__month`, `.fsi-event-date__day`, `.fsi-event-date__year`
