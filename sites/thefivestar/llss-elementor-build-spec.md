# LLSS Elementor Build Spec — Phase 1.4

Authoritative section-by-section build plan for the Elementor rebuild of the
Legal League Servicer Summit page. Establishes the "FSI Event Page"
Elementor Pro template that Phases 2–3 (Events hub, Velocity) clone.

**Target environment:** thefivestar.com **staging** (`thefivestarstg`).
No production work in this phase. Production promotion is Phase 1.11 via
explicit approval gate.

**Target stack (verified 2026-04-23):**
Elementor 4.0.2 + Elementor Pro 4.0.2 + The7 14.3.0.

**Decision basis:**
- 2026-04-22 portfolio standardization (Elementor forward)
- 2026-04-23 Phase 1.3 global kit landed
- 2026-04-23 design direction lock (reuse existing FSI visual language for Phase 1–3)
- 2026-04-23 nav-wiring rule (publish ≠ wire)

**Reference pages (existing WPBakery staging content):**
- LLSS: page 5094, slug `legal-league-servicer-summit`, parent 5089 (Events), publish
- Events hub: page 5089, slug `events`, top-level, publish
- Velocity: page 5088

**Kit artifact:** `sites/thefivestar/elementor-global-kit-v1.zip` (5.4KB, 4 JSON).
**Kit spec:** `sites/thefivestar/elementor-global-kit-spec.md`.
**Specificity notes:** `sites/thefivestar/the7-elementor-specificity-notes.md`.
**Migration tracker:** `sites/thefivestar/wpbakery-migration.md`.

---

## Core principles (apply to every section)

**1. v4 Container, not legacy Section.**
Elementor v4 deprecated the Section widget in favor of flex Containers.
Every layout block in this spec is a Container. DOM signature on render:
`.elementor-element.e-con-boxed.e-flex.e-con.e-parent` (boxed mode) or
`.elementor-element.e-con-full.e-flex.e-con.e-parent` (full-width mode).

**2. Global kit bindings, not hardcoded values.**
Every color binds to a Global Color token. Every font binds to a Global Font
token. If a value is hardcoded inside a widget, that's a spec violation —
revert and bind to the kit.

Exceptions: the hero navy overlay `rgba(31, 54, 92, 0.85)` cannot be a
Global Color (opacity) — apply as inline background overlay on that section
only. Document as a known exception.

**3. Image dimensions are non-optional.**
Every Image widget has Width and Height set in pixels (not "auto", not
blank). Every Container with a background image has Min Height in pixels.
Acceptance: Lighthouse CLS < 0.1 under Slow 4G throttle.

**4. Save as template before moving on.**
Each completed section is right-click → Save as Template → named
`FSI Event — [Section Name]`. Don't batch this at the end; save per section
so template library grows as sections complete.

**5. Page-level pre-work mandatory.**
Before switching to Elementor on the new page:
- The7 Page Options → Page Title → **Disable**
- Page Template → check if The7 offers a "Blank" or "Full Width" template
  (see page-template section below; affects hero stretching)

**6. Predicted specificity overrides are predictions, not certainties.**
Phase 1.3 confirmed headings fight The7. Other widgets likely fight too.
For each section, the "predicted overrides" block lists CSS rules I expect
will be needed. During the build, inspect in DevTools; if a prediction is
wrong, drop it and log the real override in `the7-elementor-specificity-notes.md`.

---

## Page-level setup (Step 0 — do this first, once)

### 0.1 — Resolve the hero-width question (The7 wrapper)

Phase 1.3 DevTools output showed The7 wraps Elementor content in
`.wf-container` + `.wf-wrap`. This wrapper has a max-width (likely 1200px
or similar) that clips any Container set to "Full Width" mode in Elementor.

A 1900×600 hero that should bleed to the viewport edge will instead clip
to `.wf-container` max-width unless we escape the wrapper.

**Three options, in order of preference:**

1. **The7 Blank / Full Width page template.** WP Admin → Edit Page → Page
   Attributes → Template. If The7 offers "Blank" or similar, it removes
   `.wf-container`. This is the cleanest fix. Check during page creation.
2. **Stretched Section setting** (Elementor). Site Settings → Layout →
   Stretched Section Fit To: `body`. Already set in kit v1. Whether it
   works depends on #1 — if `.wf-container` is present, stretching will
   hit the wrapper, not the body.
3. **Custom CSS override** (fallback). If #1 and #2 both fail, add to Site
   Settings → Custom CSS, scoped to the new page ID:
   ```css
   .page-id-XXXX .wf-container { max-width: none; padding-left: 0; padding-right: 0; }
   ```

Verify which path works during Hero build (step 1.1). Document the
resolution back into `the7-elementor-specificity-notes.md`.

### 0.2 — Create the new page

```
WP Admin → Pages → Add New
  Title:  Legal League Servicer Summit (Elementor)
  Slug:   legal-league-servicer-summit-elementor    (temporary)
  Parent: Events (5089)
  Status: Draft (promote to publish after section 6 verification)

The7 Page Options sidebar:
  Page Title:      Disable
  Page Template:   Blank / Full Width if available, else Default

Save. Note the assigned page ID.
```

Record the new page ID in the spec so Step 1 onward references it:

**NEW_LLSS_ID = ________ (fill in during Step 0.2)**

### 0.3 — Switch to Elementor and confirm kit is loaded

Editor → Site Settings → Global Colors.
Confirm 4 standard + 6 custom colors from kit spec are present.
If not, Import Kit from `elementor-global-kit-v1.zip` on this page first.

---

## Section 1 — Hero

Full-bleed background image, navy overlay, centered H1, subhead, gold CTA.

### Structure

```
Container (full-width mode) [id: hero]
  └─ Container (boxed mode, max 1100px)
      ├─ Heading widget           → H1
      ├─ Text Editor widget       → subhead paragraph
      └─ Button widget            → gold primary CTA
```

### Settings — outer Container

| Field | Value |
|---|---|
| Width | Full Width |
| Min Height | **600px** (mandatory — CLS prevention) |
| Content Position | Middle |
| Background Type | Classic |
| Background Image | Upload/select hero image (target dimensions **1900×600**) |
| Background Position | Center Center |
| Background Size | Cover |
| Background Attachment | Scroll |
| Background Overlay | Color `rgba(31, 54, 92, 0.85)` — inline, NOT a global color |
| Padding | 80px top / 80px bottom / 40px left / 40px right (desktop) |
| Padding (mobile) | 60px top / 60px bottom / 20px left / 20px right |

### Settings — inner Container

| Field | Value |
|---|---|
| Width | Boxed |
| Max Width | 1100px |
| Content Width | Full (inside) |
| Gap | 20px between items |

### Settings — Heading widget (H1)

| Field | Value |
|---|---|
| Title | `Legal League Servicer Summit` (pull exact from baseline) |
| HTML Tag | H1 |
| Alignment | Center |
| Color | White `#FFFFFF` (NOT primary token — this is white on navy) |
| Typography | Inherits from Custom CSS (42px / 1.2 / 700 per kit) |

### Settings — Text Editor widget (subhead)

| Field | Value |
|---|---|
| Content | Pull from baseline WPBakery page (single paragraph) |
| Alignment | Center |
| Color | Custom Color `Light Grey` = `#cfd5de` |
| Typography | Global → Primary (Arial 400 16px 1.6) |

### Settings — Button widget (gold CTA)

| Field | Value |
|---|---|
| Text | Pull from baseline (likely "Register" or similar) |
| Link | Registration URL from baseline |
| Size | Custom (don't use `sm`/`md`/`lg` presets — they fight The7) |
| Alignment | Center |
| Typography | 16px / 700 |
| Text Color | Global → Primary (`#1f365c` — navy on gold) |
| Background Color | Global → Secondary (`#c9a040` — gold) |
| Hover Background | Custom Color `Gold Hover` = `#b8922e` |
| Padding | 14px top/bottom, 36px left/right |
| Border Radius | 4px |
| Border | None |

### Predicted specificity overrides (Section 1)

Phase 1.3 evidence suggests The7 fights Elementor button and heading
defaults. Predictions for `/kit-test/`-style verification:

```css
/* Hero H1 — override The7 if H1 renders wrong color/size on full-bleed section */
.elementor-element-XXXX h1.elementor-heading-title { color: #FFFFFF !important; }

/* Hero CTA button — override The7 button base styling if needed */
.elementor-element-XXXX .elementor-widget-button .elementor-button {
  background-color: #c9a040 !important;
  color: #1f365c !important;
  font-size: 16px !important;
  padding: 14px 36px !important;
}
.elementor-element-XXXX .elementor-widget-button .elementor-button:hover {
  background-color: #b8922e !important;
}
```

`XXXX` = the hero Container's `data-id` (shown in DevTools). Scoping to the
element ID confines the override to this section only.

**If the widget renders correctly without these overrides, drop them.**

### Responsive behavior

- **Desktop (>768px):** H1 42px, centered, full hero height 600px
- **Tablet (480–768px):** H1 36px, padding reduces, min-height 500px
- **Mobile (<480px):** H1 30px, padding reduces, min-height 400px,
  text wraps fully

Elementor handles breakpoints via device-toolbar per-field overrides.
Kit breakpoints are 480/768 per Phase 1.3. Set per-device values in each
widget.

### Verification (Section 1)

- [ ] Background image loads, navy overlay visible
- [ ] H1 white, centered, 42px desktop
- [ ] Subhead light grey, readable on overlay
- [ ] Gold CTA renders, hover state changes to `#b8922e`
- [ ] Min-height 600px reserved BEFORE image loads (DevTools Network throttle: Slow 4G, reload, observe no text shift)
- [ ] Mobile view: no overflow, CTA tappable (44×44px min target)
- [ ] No console errors
- [ ] DOM: outer container has `e-con-full`, inner has `e-con-boxed`

### Save as template

Right-click Hero container → Save as Template → name: `FSI Event — Hero`.

---

## Section 8 — Final CTA

Full-bleed background, dark overlay, centered headline + button.
(Built second in the mid-phase checkpoint, before sections 2–7.)

### Structure

```
Container (full-width mode) [id: final-cta]
  └─ Container (boxed mode, max 800px — narrower than hero for focus)
      ├─ Heading widget        → H2
      ├─ Text Editor widget    → one-line motivation
      └─ Button widget         → gold primary CTA (same as hero)
```

### Settings — outer Container

| Field | Value |
|---|---|
| Width | Full Width |
| Min Height | **400px** (mandatory) |
| Content Position | Middle |
| Background Type | Classic |
| Background Image | Upload/select CTA bg (target **1900×400**) |
| Background Position | Center Center |
| Background Size | Cover |
| Background Overlay | `rgba(31, 54, 92, 0.85)` — same navy overlay as hero |
| Padding | 60px top / 60px bottom (desktop) |

### Settings — inner Container, Heading, Text, Button

Same patterns as Hero. Differences:
- Heading is H2 (26px), not H1
- Narrower inner container (800px) for tighter feel
- Otherwise identical CTA button styling (gold, 16px, 14/36 padding)

### Predicted overrides

Reuse Hero's button override block scoped to the Final CTA container's
`data-id`. If Hero's override pattern works, this one inherits the pattern.

### Verification

Same checklist as Section 1, adjusted for the smaller dimensions (400 min-
height, H2 not H1).

### Save as template

Right-click → Save as Template → `FSI Event — Final CTA`.

---

## 🛑 MID-PHASE CHECKPOINT

After Section 1 (Hero) and Section 8 (Final CTA) are built and saved as
templates, STOP. Verify before building sections 2–7.

### Mid-phase verification gate

- [ ] Hero renders at full viewport width (no `.wf-container` clipping)
- [ ] Hero min-height 600px, CTA min-height 400px — no layout shift on reload under Slow 4G throttle
- [ ] Advanced Ads placement "Header Placement" (ID 4896) renders above hero if applicable to page type
- [ ] Advanced Ads "Before Content" (4897) renders between header and hero (or confirm placement rules don't target this page type)
- [ ] Lighthouse report under Slow 4G: CLS < 0.1
- [ ] Chrome DevTools Console: no errors, no warnings related to CSS/layout
- [ ] Widget `data-id` attributes captured in specificity-notes for any override rules added
- [ ] Visually matches baseline hero (side-by-side with
  `sites/thefivestar/llss-baseline-2026-04-23/hero-desktop.png`)

### Mid-phase output report

Format Jonathan wants back before proceeding:

```
HERO + FINAL CTA CHECKPOINT — [date]

Page ID: [NEW_LLSS_ID]
Hero data-id: [XXXX]
Final CTA data-id: [YYYY]

The7 wrapper resolution: [Blank template / Stretched Section / Custom CSS override]
Specificity overrides added: [count]
  - [rule 1 purpose]
  - [rule 2 purpose]
  ...

Lighthouse CLS score: [X.XX] (target <0.1)
Console errors: [count]
Advanced Ads placements rendered: [list]

Baseline comparison: [match / delta: description]

RECOMMENDATION: proceed to sections 2–7 / pause and fix [X]
```

### Pass → continue below (Sections 2–7)
### Fail → pause, report, re-plan. Possible causes:
- The7 `.wf-container` can't be escaped cleanly
- Button specificity requires more aggressive overrides than predicted
- Min-height / CLS score above 0.1 (suggests font-loading shift or JS insertion)
- Background overlay rgba not supported as predicted

---

## Section 2 — Intro / Who Belongs

Two-column layout. Left: body copy introducing LLSS. Right: optional side
image (portrait of attendees or LLSS event shot).

### Structure

```
Container (boxed, 1100px) [id: intro]
  ├─ Container (flex-row, 2 columns, 50/50 split on desktop; stacked on mobile)
  │   ├─ Container (left column)
  │   │   ├─ Heading widget    → "Who Belongs Here" H2
  │   │   └─ Text Editor        → 2–3 paragraphs
  │   └─ Container (right column)
  │       └─ Image widget       → 560×400 side image
```

### Settings — outer Container

| Field | Value |
|---|---|
| Width | Boxed (1100px from kit) |
| Padding | 80px top / 80px bottom (desktop); 40/40 tablet; 30/30 mobile |
| Background | None (white default) |

### Settings — 2-column Container

| Field | Value |
|---|---|
| Direction | Row (desktop), Column (mobile — use device toolbar) |
| Gap | 48px (desktop); 32px (tablet); 24px (mobile) |
| Align Items | Center |

### Settings — Heading (H2)

| Field | Value |
|---|---|
| Tag | H2 |
| Alignment | Left |
| Color | Global → Primary (`#1f365c`) |
| Typography | Inherits from Custom CSS (26px / 1.3 / 700) |

### Settings — Text Editor

| Field | Value |
|---|---|
| Content | Pull from baseline |
| Typography | Global → Primary (16px / 1.6) |
| Color | Global → Text (`#444444`) |

### Settings — Image widget

| Field | Value |
|---|---|
| Image | Upload/select |
| **Width** | **560** (mandatory, not auto) |
| **Height** | **400** (mandatory) |
| Image Size | Custom (560×400) |
| Caption | None |
| Link | None |
| Loading | Lazy |

### Predicted overrides

```css
/* Body paragraph color — The7 may style .elementor-widget-text-editor p */
.elementor-widget-text-editor p { color: #444444; }
```

### Verification

- [ ] Columns 50/50 desktop, stack on mobile
- [ ] Image loads at exactly 560×400, no browser scaling distortion
- [ ] Image reserves 400px height before load (Slow 4G test)
- [ ] H2 navy, body dark grey, readable contrast
- [ ] No overflow at tablet breakpoint (768px)

### Save as template

`FSI Event — Intro / Who Belongs`.

---

## Section 3 — What Happens

Feature grid explaining what attendees do at LLSS. 3–4 card layout with
icons + short descriptions. If there are larger "moments" or feature
cards below, they use the 400×300 card images.

### Structure

```
Container (boxed, 1100px) [id: what-happens]
  ├─ Heading widget             → "What Happens at LLSS" H2, centered
  ├─ Container (row, 4 columns desktop / 2 tablet / 1 mobile)
  │   ├─ Icon Box widget × 4    → icon + title + short desc
  │
  └─ Container (row, 3 columns desktop / 1 mobile) [optional second row]
      ├─ Image Box widget × 3   → image + title + description
```

### Settings — outer Container

| Field | Value |
|---|---|
| Width | Boxed |
| Background | Custom Color `Offwhite` = `#f7f7f5` |
| Padding | 80px top/bottom desktop |

### Settings — Icon Box widget

| Field | Value |
|---|---|
| Icon | From Elementor library (or custom SVG) |
| **Icon size** | **64×64** (mandatory — set explicitly, not auto) |
| Title | Short label (H3 or H4) |
| Description | 1–2 sentences |
| Alignment | Center |
| Icon Color | Global → Secondary (gold) |
| Title Color | Global → Primary (navy) |
| Description Color | Global → Text |
| Spacing (icon → title) | 16px |
| Spacing (title → desc) | 8px |

### Settings — Image Box widget (if used in second row)

| Field | Value |
|---|---|
| Image | Upload |
| **Image Width** | **400** |
| **Image Height** | **300** |
| Title | Feature name |
| Description | 1–2 sentences |
| Alignment | Center or left (per baseline) |

### Predicted overrides

```css
/* Icon Box title — The7 likely sizes and colors this */
.elementor-widget-icon-box .elementor-icon-box-title {
  color: #1f365c;
  font-size: 20px;
  font-weight: 700;
}
.elementor-widget-icon-box .elementor-icon-box-description {
  color: #444444;
  font-size: 15px;
  line-height: 1.55;
}

/* Icon size enforcement */
.elementor-widget-icon-box .elementor-icon svg,
.elementor-widget-icon-box .elementor-icon i {
  width: 64px;
  height: 64px;
}
```

### Verification

- [ ] Icons render at exactly 64×64
- [ ] Icon boxes evenly spaced, aligned top
- [ ] Responsive: 4-col → 2-col → 1-col at breakpoints
- [ ] Hover state on icon boxes (if baseline uses hover) matches
- [ ] Image boxes (if used): dimensions 400×300 explicit, no distortion

### Save as template

`FSI Event — What Happens`.

---

## Section 4 — Next Summit (gold callout)

Gold background band announcing the next LLSS date/location. No images.
Single-row, centered eyebrow + H2 + short detail + secondary CTA.

### Structure

```
Container (full-width) [id: next-summit]
  └─ Container (boxed, 800px, centered)
      ├─ Text Editor (or Heading widget)   → eyebrow "NEXT SUMMIT" (small caps, 13px)
      ├─ Heading widget                     → H2 "Month YYYY · City, ST"
      ├─ Text Editor                        → 1-line detail
      └─ Button widget                      → outline variant (navy outline on gold bg)
```

### Settings — outer Container

| Field | Value |
|---|---|
| Width | Full Width |
| Min Height | **240px** (mandatory — no image but still reserve space) |
| Background | Global → Secondary (`#c9a040` — gold) |
| Padding | 60px top/bottom desktop |
| Content Position | Middle / Center |

### Settings — Eyebrow

| Field | Value |
|---|---|
| Tag | `span` or `p` |
| Text | `NEXT SUMMIT` (all caps in source, don't rely on text-transform) |
| Typography | Global → Accent (Arial 700 13px, line-height 1) |
| Color | Custom Color `Gold Text Dark` = `#3d2e00` |
| Letter Spacing | 2px |

### Settings — H2

| Field | Value |
|---|---|
| Color | Custom Color `Gold Text Dark` (`#3d2e00`) — not navy |
| Size | 26px (inherits from kit Custom CSS) |

### Settings — Button (outline variant)

| Field | Value |
|---|---|
| Text | From baseline |
| Background | White `#FFFFFF` |
| Text Color | Global → Primary (navy) |
| Border | 2px solid Global → Primary (navy) |
| Hover Background | `#f0f4f8` |
| Padding | 9px 22px |
| Font Size | 13px / 700 |

### Predicted overrides

On gold bg, heading color needs explicit dark brown to avoid navy
looking muddy against gold. Scope:

```css
.elementor-element-XXXX h2.elementor-heading-title { color: #3d2e00 !important; }
```

### Verification

- [ ] Solid gold bg, no gaps
- [ ] Eyebrow small-caps, dark brown, readable
- [ ] H2 dark brown (not navy), readable on gold
- [ ] Outline button: white fill, navy border, navy text, hover lightens
- [ ] No layout shift (min-height 240 reserves space)

### Save as template

`FSI Event — Next Summit Callout`.

---

## Section 5 — Recent Summit photo strip

Three-photo row. Pulls forward the "community feel" — past attendees,
keynote moments. Each photo gets explicit 360×240 dimensions.

### Structure

```
Container (boxed, 1100px) [id: recent-summit]
  ├─ Heading widget            → H2 "Recent Moments" (or per baseline)
  └─ Container (row, 3 columns)
      ├─ Image widget (360×240)
      ├─ Image widget (360×240)
      └─ Image widget (360×240)
```

**Note:** This is manual 3-column for Phase 1.4. Phase 2 (Events hub) will
evaluate whether to use Elementor Pro Loop widget for auto-population from
a "past events" CPT or media library query. Not in scope here.

### Settings — outer Container

| Field | Value |
|---|---|
| Width | Boxed |
| Padding | 80px top/bottom |
| Background | White |

### Settings — 3-column Container

| Field | Value |
|---|---|
| Direction | Row desktop, Column mobile |
| Gap | 16px |
| Align Items | Stretch |

### Settings — Image widget (each of 3)

| Field | Value |
|---|---|
| Image | Upload (from baseline photo set) |
| **Width** | **360** |
| **Height** | **240** |
| Caption | None (or small caption per baseline) |
| Link | None |
| Loading | Lazy (all 3 — below fold) |

### Predicted overrides

Images tend not to fight The7; minor max-width issue possible. If images
render at less than 360px wide on desktop, add:

```css
.elementor-widget-image img { max-width: 100%; height: auto; }
```

(But this may break the explicit width/height → verify carefully.)

### Verification

- [ ] 3 images in a row on desktop, aspect ratio 3:2 (360×240) preserved
- [ ] On mobile: single column, each image still 360×240 (or proportional)
- [ ] Images reserve 240px height before load (Slow 4G check)
- [ ] No image scaling artifacts

### Save as template

`FSI Event — Recent Summit Strip`.

---

## Section 6 — Membership cards (Join the Community)

Two (or three) cards inviting attendees to join Legal League community
year-round. Each card has image + headline + short pitch + CTA button.

### Structure

```
Container (boxed, 1100px) [id: membership-cards]
  ├─ Heading widget               → "Join the Community" H2, centered
  ├─ Text Editor                  → short intro paragraph
  └─ Container (row, 2 columns — or 3 if baseline has 3 cards)
      ├─ Container (card)
      │   ├─ Image (480×220)
      │   ├─ Heading widget (card title, H3)
      │   ├─ Text Editor (short pitch)
      │   └─ Button widget (primary navy)
      └─ Container (card)
          └─ [repeat]
```

### Settings — outer Container

Padding 80px top/bottom, background white.

### Settings — card Container

| Field | Value |
|---|---|
| Background | White |
| Border | 1px solid Custom Color `Border` = `#e0e0dc` |
| Border Radius | 6px |
| Padding | 24px all sides (inside card, below image) |
| Box Shadow | None (or subtle per baseline) |

### Settings — card Image

| Field | Value |
|---|---|
| **Width** | **480** |
| **Height** | **220** |
| Image Size | Custom (480×220) |
| Loading | Lazy |
| Margin Bottom | 0 (card content container handles spacing) |

### Settings — card H3

Color Global → Primary (navy). Size inherits from kit (20px).

### Settings — card Button (primary navy)

| Field | Value |
|---|---|
| Size | Custom (not `sm`/`md`/`lg` — fights The7) |
| Background | Global → Primary (navy) |
| Text Color | White `#FFFFFF` |
| Hover Background | Custom Color `Navy Hover` = `#162848` |
| Padding | 9px 22px |
| Font Size | 13px / 700 |
| Border Radius | 4px |

### Predicted overrides

```css
/* Card body text */
.elementor-element-XXXX .elementor-widget-text-editor p {
  color: #444444;
  font-size: 15px;
  line-height: 1.55;
}

/* Primary button — navy variant */
.elementor-element-XXXX .elementor-widget-button .elementor-button {
  background-color: #1f365c;
  color: #FFFFFF;
  font-size: 13px;
  font-weight: 700;
  padding: 9px 22px;
  border-radius: 4px;
}
.elementor-element-XXXX .elementor-widget-button .elementor-button:hover {
  background-color: #162848;
}
```

### Verification

- [ ] Cards evenly spaced, equal height
- [ ] Image 480×220 explicit, no distortion
- [ ] Card border visible, 6px radius
- [ ] Navy button with white text; hover darkens
- [ ] Mobile: cards stack, full-width, image still proportional
- [ ] CLS: 220px reserved per card image on load

### Save as template

`FSI Event — Membership Cards`.

---

## Section 7 — Event Details

Practical details — dates, location, schedule-at-a-glance. 2-column
layout: left = bulleted text details, right = optional venue image.

### Structure

```
Container (boxed, 1100px) [id: event-details]
  └─ Container (row, 2 columns 60/40 split)
      ├─ Container (left)
      │   ├─ Heading (H2 "Event Details")
      │   ├─ Text Editor (details bullets or structured copy)
      │   └─ Button (register, primary navy)
      └─ Container (right)
          └─ Image (800×450) venue/location shot
```

### Settings

Same patterns as Section 2 (Intro). Key differences:
- Image dimensions 800×450 (wider, 16:9 aspect)
- 60/40 column split instead of 50/50
- Button is navy primary (not outline)

### Settings — Image widget

| Field | Value |
|---|---|
| **Width** | **800** |
| **Height** | **450** |
| Loading | Lazy |

### Verification

- [ ] 60/40 split on desktop, stacks on mobile
- [ ] Venue image 800×450 explicit
- [ ] Details list: bullet spacing matches baseline
- [ ] Navy register button, matches Section 6 card button pattern

### Save as template

`FSI Event — Event Details`.

---

## Step 2 — Combine saved sections into master template

After all 8 sections are built on the new LLSS page and each is saved as
a template:

```
WP Admin → Templates → Kits & Templates → Add New → Page Template
  Name: FSI Event Page
  Type: Page
```

Inside the new template, insert each saved section in order:
1. Hero
2. Intro / Who Belongs
3. What Happens
4. Next Summit Callout
5. Recent Summit Strip
6. Membership Cards
7. Event Details
8. Final CTA

Save. This "FSI Event Page" template is the source for:
- Phase 3 (Velocity — clone template, populate with Velocity content)
- Future FSI event pages (Phase 6+)
- Any team member creating a new event page post-Phase-1.11

---

## Step 3 — Full-page verification (the gate before production)

After all 8 sections built and master template saved:

### 3.1 — Functional checks

| # | Check | How | Pass |
|---|---|---|---|
| 1 | Advanced Ads render (Header Placement 4896, Before Content 4897) | Visual on page; disable ad blocker if needed | Placeholders or real ads visible |
| 2 | HubSpot forms (if present on LLSS page) | Submit test entry | Entry appears in HubSpot CRM |
| 3 | AIOSEO meta + schema | View-source; look for `og:title`, `og:description`, `@type: Event` schema | Populated |
| 4 | Site Kit pageview | Site Kit dashboard → Realtime | Pageview recorded |
| 5 | Responsive | Chrome device toolbar at 1440 / 768 / 480 | All 3 render correctly |
| 6 | CLS | Lighthouse mobile preset, Slow 4G throttle | Score < 0.1 |
| 7 | PHP errors | `ssh thefivestarstg 'wp option get siteurl'` + visit Site Health | No fatals; aioseo-redirects warning suppressed |
| 8 | Visual layout shift | Hard reload under Slow 4G throttle 3× | No visible jump |

### 3.2 — Save the artifacts

- Lighthouse report PDF:
  `sites/thefivestar/llss-lighthouse-after-2026-04-XX.pdf`
- Baseline screenshots (Jonathan captures separately per pre-work #4):
  `sites/thefivestar/llss-baseline-2026-04-23/{desktop,tablet,mobile}.png`
- Post-build screenshots:
  `sites/thefivestar/llss-elementor-2026-04-XX/{desktop,tablet,mobile}.png`
- Specificity overrides catalogue (updated):
  `sites/thefivestar/the7-elementor-specificity-notes.md`

---

## Step 4 — Rename + swap (staging only)

After 3.1 passes:

```bash
# SSH session already persistent from Phase 1.4 start
# Verify PID still alive; if not, re-run ssh-session-startup SOP

# 1. Rename the old WPBakery LLSS (5094) to preserve it
ssh thefivestarstg \
  'wp post update 5094 \
   --post_name=legal-league-servicer-summit-old \
   --post_title="Legal League Servicer Summit (Old WPBakery)"'

# 2. Rename the new Elementor page to take the canonical slug
ssh thefivestarstg \
  "wp post update ${NEW_LLSS_ID} \
   --post_name=legal-league-servicer-summit"

# 3. Flush caches
ssh thefivestarstg 'wp cache flush'
ssh thefivestarstg 'rm -rf /sites/thefivestarstg/wp-content/cache/wp-rocket/*'

# 4. Verify
ssh thefivestarstg \
  "wp post list --post__in=5094,${NEW_LLSS_ID} \
   --fields=ID,post_name,post_title,post_status --format=table"

# Expected:
#   5094          legal-league-servicer-summit-old  Legal League Servicer Summit (Old WPBakery)  publish
#   NEW_LLSS_ID   legal-league-servicer-summit      Legal League Servicer Summit (Elementor)     publish
```

Old WPBakery version stays on staging for rollback/reference. Do NOT
promote the `-old` version to production. Trash after ~1–2 weeks of
production confidence on the Elementor replacement (Phase 1.11+).

---

## Step 5 — 🛑 STOP. Approval gate.

Report to Jonathan:

```
LLSS ELEMENTOR REBUILD — STAGING VERIFIED

Staging URL: https://thefivestarstg.wpenginepowered.com/events/legal-league-servicer-summit/
New page ID: [NEW_LLSS_ID]
Old WPBakery page ID: 5094 (renamed to -old)

All 8 sections built and saved as templates.
Master template "FSI Event Page" created.

Verification results:
  - Advanced Ads:    [pass/fail]
  - HubSpot forms:   [pass/fail/na]
  - AIOSEO meta:     [pass/fail]
  - Site Kit track:  [pass/fail]
  - Responsive:      [pass/fail]
  - CLS score:       [X.XX]
  - PHP errors:      [count]
  - Layout shift:    [pass/fail]

Specificity overrides added: [count]
The7 wrapper resolution: [method]

Ready for production promotion (Phase 1.11).
Approve? [y/n]
```

**Wait for explicit "yes" in chat.**

---

## Step 6 — New SOP (only after staging verified)

Write `docs/sops/new-event-page-elementor.md`. Required sections:

1. **Scope** — what this SOP covers and replaces
2. **Prerequisites** — global kit v1 imported, FSI Event Page template available, user has Elementor edit access
3. **Procedure**
   - Clone the FSI Event Page template
   - Apply The7 Page Options → Page Title → Disable
   - Populate each of the 8 sections with new event content
   - Image dimension enforcement table (reference this spec)
   - Specificity override catalogue (reference specificity-notes)
4. **Verification** — Slow 4G CLS check, Advanced Ads check, AIOSEO check
5. **Staging-first rule** — every new event page goes through staging
6. **Approval gate** — reminder
7. **Nav-wiring** — publishing ≠ wiring; event pages DO NOT get nav entries without per-entry approval (standing exception: Phase 2 `/events/` pre-approved for `/conferences/` nav swap)
8. **`-old` rename pattern** — only if migrating from existing WPBakery event page

Mark the old SOP (`docs/sops/new-event-page.md`) with a deprecation header:

```markdown
# ⚠️ DEPRECATED

This SOP is superseded by `new-event-page-elementor.md` as of 2026-04-XX.

Retained because it still backs:
- Events hub (/events/, page 5089) until Phase 2 migration
- Velocity (/events/velocity/, page 5088) until Phase 3 migration
- Any WPBakery event pages still on production

Do NOT use this SOP to create NEW event pages. Use the Elementor SOP instead.
```

Don't delete `new-event-page.md`. Keep until Phases 2–3 complete.

---

## Step 7 — Production promotion (Phase 1.11 — NOT in scope for Phase 1.4)

Deferred to Phase 1.11. For reference only:

1. Staging verified per Step 3 above
2. Explicit "yes" in chat from Jonathan
3. Import Global Kit zip on production via Templates → Kits & Templates → Import
4. Import FSI Event Page master template on production
5. Create new page on production, slug `legal-league-servicer-summit`
   (doesn't exist on prod — this is create-new, not replace)
6. Apply The7 Page Options → Page Title → Disable on production page
7. Populate with LLSS content (easiest: export staging page Elementor JSON, import on prod)
8. Run Step 3 verification checklist against the production URL
9. **DO NOT wire into nav.** Per nav-wiring rule, publishing ≠ wiring.
   Page exists at its canonical URL but stays unlinked until separate
   per-entry nav approval. Jonathan drives that decision.
10. WPBakery `-old` page stays staging-only forever (until Phase 1.11
    trash decision)

---

## Out of scope (do NOT do in Phase 1.4)

- Events hub (5089) rebuild → **Phase 2**
- Velocity (5088) rebuild → **Phase 3**
- Nav wiring `/events/` ↔ `/conferences/` → **Phase 2 approval gate** (standing exception is for Phase 2 only)
- Promote 4 plugin deletions to production → Jonathan handles manually
- MP MonsterInsights cleanup → blocked on MP staging SSH alias
- The7 Custom Code blocks (Naylor, Apollo) audit → separate 30-min task, no blocker
- Deprecation of old FSI pages → needs GA4 data, separate pass
- Theme direction (The7 vs Hello Elementor) → revisit at Phase 4 kickoff
- Elementor Pro 3.35 → 4.x on MP → blocked on MP staging SSH alias

---

## Files this Phase 1.4 will produce

| File | Status |
|---|---|
| `sites/thefivestar/llss-elementor-build-spec.md` | this file — review gate |
| `sites/thefivestar/llss-baseline-2026-04-23/` | captured by Jonathan (pre-work #4) |
| `sites/thefivestar/llss-elementor-2026-04-XX/` | captured post-build |
| `sites/thefivestar/llss-lighthouse-after-2026-04-XX.pdf` | from Lighthouse |
| `sites/thefivestar/the7-elementor-specificity-notes.md` | **updated** — real overrides added as discovered |
| `docs/sops/new-event-page-elementor.md` | **new** — written after staging verification |
| `docs/sops/new-event-page.md` | **annotated** with deprecation header |
| `sites/thefivestar/wpbakery-migration.md` | **updated** — LLSS row marks migrated, first-wave status advanced |
| `docs/decisions.md` | **possibly updated** if The7 wrapper resolution surfaces a portfolio-level decision |
| `docs/next-chat-handoff.md` | **updated** at session close |

---

## Review checklist before execution

Before Jonathan approves spec and starts Step 0:

- [ ] Spec sections 1–8 all have widget choices, explicit image dimensions, global kit bindings
- [ ] Predicted specificity overrides are flagged as predictions, not certainties
- [ ] Mid-phase checkpoint is clearly defined (Hero + Final CTA only)
- [ ] The7 `.wf-container` resolution has 3 ordered options
- [ ] v4 Container syntax used consistently (not legacy Section)
- [ ] Production promotion is deferred; spec is staging-only
- [ ] Approval gate language is verbatim from CLAUDE.md
- [ ] `-old` rename pattern is included
- [ ] Nav-wiring rule explicitly honored

If any box is unchecked, revise the spec before starting the build.

---

## Open questions Jonathan should resolve before Step 0

1. **Hero background image source.** WP Admin media library, or new asset? Same question for the other background sections.
2. **Baseline capture timing.** Pre-work #4 screenshots — are you capturing now, or inline during Step 0? Sequencing matters for the mid-phase visual comparison.
3. **Advanced Ads on Elementor event pages.** Confirm Header Placement (4896) and Before Content (4897) placement rules target event pages (i.e., child pages of 5089) — not all pages sitewide. If they don't currently target event pages, this spec's verification checks 1 will fail without being a real problem.
4. **HubSpot form on LLSS.** Does the current WPBakery LLSS have a HubSpot form? If yes, verification check 2 applies. If no, mark N/A and skip.
5. **Mid-phase checkpoint: still the plan?** (Confirmed in prior turn, reconfirming here.)
