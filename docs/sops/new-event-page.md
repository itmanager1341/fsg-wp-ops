# SOP: Creating a New FSI Event Page

Applies to: thefivestar.com event detail pages under `/events/{slug}/`
Last updated: 2026-04-19

---

## Overview

Event pages live under the Events hub (`/events/`, page ID 5089) as WordPress
child pages. The URL structure is `/events/{slug}/` — set via WordPress
parent/child page relationships, not custom routes.

The shared CSS (`fsi-event-styles.php` mu-plugin) loads on every page. You do
not need to add styles inline or via HFCM. Just use the class names.

**Do not paste raw HTML with inline `style="..."` attributes.** That was the
previous approach and is being replaced. All new pages use class-based markup
referencing the shared stylesheet.

---

## Pre-flight checklist

- [ ] `fsi-event-styles.php` is deployed to the target environment
  - Staging: always deployed via GitHub Actions on push to main
  - Production: check before going live — see deployment note below
- [ ] You have the event details: name, date(s), location, description, Swoogo links

---

## Step 1 — Create the page in WP Admin

1. WP Admin → Pages → Add New
2. Set the title (e.g. "Servicer Summit")
3. Set parent page: **Events** (ID 5089)
4. Set slug: `servicer-summit` (lowercase, hyphenated)
5. Leave as Draft — do not publish yet
6. Switch to **Classic Editor** (WPBakery requires it)
7. Save Draft

URL will resolve as: `https://thefivestar.com/events/servicer-summit/`

---

## Step 2 — Build the layout in WPBakery

Open the WPBakery Backend Editor. Build using Row → Column → element structure.

Use the **Raw HTML** element for any section that needs custom HTML with fsi-* classes.
Use WPBakery's native Text Block for simple body copy.

### Standard event page structure

```
fsi-page-wrap (outer div — wrap all content)
  ├── fsi-event-hero        (navy hero banner with date, tagline, CTA)
  ├── fsi-intro             (intro paragraph, centered, max 820px)
  ├── fsi-section-heading   (h2 with gold bottom border)
  ├── fsi-grid-3            (3-col feature cards — who attends)
  ├── fsi-section-heading   (h2)
  └── fsi-grid-2            (2-col feature items — what happens)
```

### Available CSS classes (from fsi-event-styles.php)

**Layout**
- `.fsi-page-wrap` — max-width 1100px, centered, horizontal padding
- `.fsi-intro` — max-width 820px, centered, bottom margin

**Hero banner**
- `.fsi-event-hero` — navy background, centered, rounded
- `.fsi-event-hero__date` — gold date line
- `.fsi-event-hero__tagline` — italic muted tagline
- `.fsi-event-hero__cta` — CTA button wrapper

**Section headings**
- `.fsi-section-heading` — h2 with grey bottom border

**Grids (responsive — collapse to 1 col on mobile)**
- `.fsi-grid-3` — 3-column grid
- `.fsi-grid-2` — 2-column grid

**Cards (top-bordered)**
- `.fsi-card-gold` — gold top border, offwhite background
- `.fsi-card-navy` — navy top border, offwhite background
- `.fsi-card__title` — card heading
- `.fsi-card__text` — card body text

**Feature items (left-bordered)**
- `.fsi-feature` — gold left border, padding
- Use `h4` and `p` inside

**Buttons**
- `.fsi-btn.fsi-btn--gold` — gold fill, navy text — hero CTA
- `.fsi-btn.fsi-btn--primary` — navy fill, white text — secondary CTA
- `.fsi-btn.fsi-btn--outline` — white fill, navy border — tertiary

**Event hub cards** (for use on /events/ hub page only)
- `.fsi-event-card`, `.fsi-event-date`, `.fsi-event-body`
- `.fsi-event-label`, `.fsi-event-title`, `.fsi-event-location`
- `.fsi-event-desc`, `.fsi-event-actions`
- `.fsi-event-date__month`, `.fsi-event-date__day`, `.fsi-event-date__year`

**v1.1 additions — image and callout patterns**
- `.fsi-event-hero--image` — hero with background-image support (overlay built in)
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

---

## Step 3 — Reference HTML for a new event page

Copy this shell and fill in the event details. Paste into a WPBakery Raw HTML element.

```html
<div class="fsi-page-wrap">

  <div class="fsi-event-hero">
    <p class="fsi-event-hero__date">DATE | VENUE, CITY</p>
    <p class="fsi-event-hero__tagline">ONE-LINE TAGLINE</p>
    <div class="fsi-event-hero__cta">
      <a href="SWOOGO_REGISTER_URL" class="fsi-btn fsi-btn--gold">Register for EVENT NAME</a>
    </div>
  </div>

  <div class="fsi-intro">
    <p>INTRO PARAGRAPH — 2-3 sentences describing the event and audience.</p>
  </div>

  <h2 class="fsi-section-heading">Who Belongs at EVENT NAME</h2>

  <div class="fsi-grid-3">
    <div class="fsi-card-gold">
      <h3 class="fsi-card__title">AUDIENCE 1</h3>
      <p class="fsi-card__text">Description.</p>
    </div>
    <div class="fsi-card-navy">
      <h3 class="fsi-card__title">AUDIENCE 2</h3>
      <p class="fsi-card__text">Description.</p>
    </div>
    <div class="fsi-card-navy">
      <h3 class="fsi-card__title">AUDIENCE 3</h3>
      <p class="fsi-card__text">Description.</p>
    </div>
  </div>

  <h2 class="fsi-section-heading">What Happens at EVENT NAME</h2>

  <div class="fsi-grid-2">
    <div class="fsi-feature">
      <h4>PROGRAM ELEMENT 1</h4>
      <p>Description.</p>
    </div>
    <div class="fsi-feature">
      <h4>PROGRAM ELEMENT 2</h4>
      <p>Description.</p>
    </div>
    <div class="fsi-feature">
      <h4>PROGRAM ELEMENT 3</h4>
      <p>Description.</p>
    </div>
    <div class="fsi-feature">
      <h4>PROGRAM ELEMENT 4</h4>
      <p>Description.</p>
    </div>
  </div>

</div>
```

---

## Step 4 — Set page attributes and SEO

- **Parent:** Events (ID 5089)
- **Template:** Default Template (The7 handles layout)
- **Featured image:** Optional — if set, The7 may display in page header
- **AIOSEO Title:** `EVENT NAME – The Five Star`
- **AIOSEO Description:** 1-2 sentences, include event name, date, audience

---

## Step 5 — Verify on staging before publishing

1. Publish the page (or set to a preview-able status)
2. Check: does the URL resolve correctly? (`/events/{slug}/`)
3. Check: does the header and footer render from The7? (should be automatic)
4. Check: do the fsi-* classes render correctly? (navy/gold/grid)
5. Check mobile: resize browser to < 768px — grids should collapse to 1 column
6. Check: do the register/learn more buttons link correctly?

---

## Step 6 — Add card to the Events hub page

Once the event page is ready, add a card to `/events/` (page ID 5089) in the same
Raw HTML block. Use the `.fsi-event-card` pattern:

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

## Deployment note

The shared stylesheet (`fsi-event-styles.php`) is a mu-plugin deployed via GitHub
Actions (Workflow A). It must be present on the target environment before the page
goes live or the classes will have no effect.

**Current deployment status:**
- Staging: ✅ deployed (v1.1)
- Production: ❌ not yet promoted

Before promoting any event page to production, confirm the mu-plugin is on production:
```bash
ssh thefivestar 'ls /sites/thefivestar/wp-content/mu-plugins/fsi-event-styles.php'
```
If missing, trigger a production deploy from GitHub Actions first.

---

## Adding or updating CSS classes

If a new event requires a layout not covered by existing classes:

1. Edit `thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php` locally
2. Add the new class with a comment explaining its purpose
3. Push to main → GitHub Actions auto-deploys to staging
4. Verify on staging
5. Trigger production deploy via GitHub Actions (manual workflow trigger)
6. Update the class reference in this SOP

Do not add one-off styles inline on the page. Every style goes in the shared file.
