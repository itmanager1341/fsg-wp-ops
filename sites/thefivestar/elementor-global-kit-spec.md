# FSI Elementor Pro Global Kit — v1 Spec (Elementor v4)

Authoritative source for the Elementor Pro Site Settings on thefivestar.com
staging. Every value below is extracted from the production-proven
`fsi-event-styles.php` v1.1 so visually-nothing changes when pages migrate
from plain-HTML-in-WPBakery to Elementor.

**Elementor version targeted: 4.0.x.** This spec has been corrected for v4
— Elementor v4 removed the Theme Style, Typography (heading color/size as
a panel), and Buttons panels that existed in v3.x. Those settings now live
in Custom CSS (for global rules) or per-widget (for button presets saved
as global widgets). Do NOT look for a "Buttons" or "Typography" section
under Site Settings — they are not there.

**Status:** Phase 1.3 COMPLETE (2026-04-23). Kit live on FSI staging,
verified on `/kit-test/`. Kit zip exported and committed to
`elementor-global-kit-v1.zip` (5.4KB, 4 JSON files — contents verified).
**Source of truth:** this file.
**Decision basis:** 2026-04-22 portfolio standardization + 2026-04-23
design-direction lock (reuse existing visual language for Phase 1–3;
redesign is a separate pass after Phase 3).

---

## Elementor v4 Site Settings — what panels exist

From a live Site Settings panel on FSI staging (Elementor 4.0.x):

**Design System:**
- Global Colors ← configure
- Global Fonts ← configure

**Settings:**
- Site Identity — skip (leave to The7 for now)
- Background — skip (per-page, not global)
- Layout ← configure (Content Width + Breakpoints)
- Lightbox — skip (defaults fine)
- Page Transitions — skip (defaults fine)
- Custom CSS ← configure (heading colors + sizes)
- Additional Settings — skip

**What v4 does NOT have that older docs/spec v0 referenced:**
- ❌ Theme Style panel
- ❌ Typography panel (H1–H6 color pickers)
- ❌ Buttons panel (preset styles)

Button styles in v4 are built per-widget and saved as Global Widgets. We do
this during Phase 1.4 (LLSS build), not during global-kit setup.

---

## 1. Global Colors

Path: Site Settings → Design System → Global Colors

**Standard slots (4):**

| Slot | Hex | Role |
|------|-----|------|
| Primary | `#1f365c` | Navy — brand primary, hero bg, card accents, primary buttons |
| Secondary | `#c9a040` | Gold — accent, hero CTA, callout background, left-border features |
| Text | `#444444` | Body text |
| Accent | `#666666` | Muted text (event location, card meta) |

**Custom Colors (add via "+ Add Item" under Custom Colors):**

| Name | Hex | Usage |
|------|-----|-------|
| Navy Hover | `#162848` | Primary button hover, navy link hover |
| Gold Hover | `#b8922e` | Gold CTA hover |
| Offwhite | `#f7f7f5` | Muted section background, card inner bg |
| Border | `#e0e0dc` | Card borders, dividers |
| Light Grey | `#cfd5de` | Hero tagline subtext |
| Gold Text Dark | `#3d2e00` | Text on gold bg (eyebrow, detail) |

Hero overlay (`rgba(31, 54, 92, 0.85)`) is not settable as a Global Color —
it has opacity and Global Colors are opaque-only. Applied as inline
background overlay on hero sections.

---

## 2. Global Fonts

Path: Site Settings → Design System → Global Fonts

Keep The7's current font family (Arial based on the FSI screenshot).
Capture the tokens — Elementor uses these as typography variables that
widgets can bind to.

| Token | Family | Weight | Size | Line height | Notes |
|-------|--------|--------|------|-------------|-------|
| Primary | Arial | 400 | 16px | 1.6 | Body base |
| Secondary | Arial | 400 | 15px | 1.55 | Muted section body, section intro |
| Text | Arial | 400 | 14px | 1.55 | Card text, event descriptions |
| Accent | Arial | 700 | 13px | 1 | Small caps, eyebrow, labels |

**Global Fonts does not include a color field** — that's per-widget (or
applied via the Custom CSS in section 4).

If The7 serves a different family than Arial (verify in DevTools: inspect
an `<h2>` on the live LLSS page, note `computed > font-family`), use
whatever is actually rendering, not Arial by default.

---

## 3. Layout

Path: Site Settings → Settings → Layout

| Setting | Value | Notes |
|---------|-------|-------|
| Content Width | 1100 | Matches `.fsi-page-wrap` max-width |
| Widgets Space | 20 | Default gap between stacked widgets |
| Stretched Section Fit To | `body` | Full-width section containment |

**Breakpoints** (Layout → Breakpoints section):

| Breakpoint | Value | Notes |
|------------|-------|-------|
| Mobile | 480 | Matches `@media (max-width: 480px)` in current CSS |
| Tablet | 768 | Matches `@media (max-width: 768px)` in current CSS |
| Desktop | (derived) | Everything above 768px |

Match the existing stylesheet exactly. Different breakpoint values would
cause Elementor pages to respond at different widths than the current FSI
pages — that breaks visual consistency during the transition.

---

## 4. Custom CSS — heading colors + sizes

Path: Site Settings → Settings → Custom CSS

Elementor v4's CSS linter rejects CSS variables (`var(--e-global-color-*)`)
inside `color:` properties. Use hardcoded hex values. Zero practical cost
since we're not changing the Primary navy color.

Paste:

```css
.elementor-heading-title { color: #1f365c !important; }

h1.elementor-heading-title { font-size: 42px; line-height: 1.2; font-weight: 700; }
h2.elementor-heading-title { font-size: 26px; line-height: 1.3; font-weight: 700; }
h3.elementor-heading-title { font-size: 20px; line-height: 1.35; font-weight: 700; }
h4.elementor-heading-title { font-size: 18px; line-height: 1.4; font-weight: 700; }
```

Save. The linter should go green. If it rejects anything, screenshot and
flag — do not guess at workarounds.

**Why this is scoped to `.elementor-heading-title` and not bare `h1, h2...`:**
The7 targets Elementor's widget classes directly and out-specifies plain
element selectors (verified on `/kit-test/` 2026-04-23). Scoping our rule
to `.elementor-heading-title` does two things: beats The7's specificity
without `!important` on sizes, and leaves The7's non-Elementor headings
elsewhere on the site alone during transition. See
`the7-elementor-specificity-notes.md` for the fuller finding and its
implications for Phase 1.4+.

**Why headings go in Custom CSS, not per-widget:** setting color per-widget
means every Heading widget across every page needs the color set manually
by whoever builds the page. One forgotten widget renders default grey text.
Custom CSS applies globally — zero chance of drift.

---

## 5. Buttons — DEFERRED to Phase 1.4

v4 has no Buttons panel in Site Settings. Buttons become a Phase 1.4 task:
build the 3 styles (navy solid / navy outline / gold large) once on the
LLSS page, right-click each → Save as Global Widget, then reuse from the
global widget library across all future pages.

Target specs (for Phase 1.4 reference, not for Site Settings):

**Primary (navy solid):** 13px / weight 700 / white text / bg `#1f365c` /
hover `#162848` / padding 9px 22px / radius 4px

**Outline:** 13px / weight 700 / navy text / bg white / hover `#f0f4f8` /
2px solid `#1f365c` border / padding 9px 22px / radius 4px

**Gold (hero CTA):** 16px / weight 700 / navy text / bg `#c9a040` / hover
`#b8922e` / padding 14px 36px / radius 4px

---

## 6. Image defaults — CLS prevention (discipline, not a toggle)

Elementor has no global "enforce image dimensions" setting. CLS prevention
is build-time discipline:

- Every Image widget on every page: set Width and Height to explicit px
  values (not `auto`, not blank)
- Every background-image section: set Min Height in px
- Below-fold images: Loading = Lazy (per-widget setting on the Image
  widget's Advanced tab)
- Above-fold images (hero): Loading = Eager

Acceptance: Lighthouse CLS < 0.1 under Slow 4G throttle. Verify during
Phase 1.7 before the LLSS approval gate.

---

## 7. Export + persist

**Export path in Elementor v4.0.2 (verified 2026-04-23):**

`WP Admin → Templates → Kits & Templates → Export`

Older docs reference `Elementor → Tools → Export Kit`. That path is stale
in v4 — the feature moved to the Templates menu. Export produces a `.zip`.

**Include in the export:**
- Site Settings (Global Colors, Global Fonts, Layout, Custom CSS)

**Exclude from the export:**
- Content (pages/posts — those migrate per phase)
- Templates (phase-specific; exported separately once built)

Save the zip as:

```
fsg-wp-ops/sites/thefivestar/elementor-global-kit-v1.zip
```

**Verified kit zip contents (2026-04-23 post-export inspection):** 5.4KB
archive, 4 JSON files:

| File | What's in it |
|------|--------------|
| `site-settings.json` | Global Colors (system + custom), Layout + breakpoints, `custom_css` (the heading CSS block) |
| `custom-fonts.json` | Global Fonts (4 typography tokens) |
| `custom-code.json` | Elementor "Custom Code" entries (separate from Custom CSS — site-wide head/body injection blocks). FSI has 2: Naylor + Apollo tracking pixels. **Note:** if promoting kit to production, these entries will import as well — verify prod already has them, or exclude before import |
| `manifest.json` | Kit metadata, version info |

This is the transferable artifact for Phase 1.11 (production promotion)
and for AMAA in Phase 7 — kit contents are environment-agnostic.

**Import on production (Phase 1.11):** WP Admin → Templates → Kits &
Templates → Import. Review what imports (especially `custom-code.json`)
before confirming.

---

## 8. Verification gate before Phase 1.4

Build a throwaway page at `/kit-test/` with:
- H1 "Test Headline"
- H2 "Section Heading"
- Paragraph of lorem ipsum
- Default Button widget (styled in 1.4, not here)

Verify:

- [ ] H1 + H2 render navy `#1f365c`
- [ ] H2 is 26px; H3 (if tested) is 20px
- [ ] Body is Arial 16px, line height ~1.6
- [ ] Content width ~1100px (inspect in DevTools)
- [ ] Tablet width (768–1100px) behaves correctly
- [ ] Mobile width (<480px) behaves correctly
- [ ] No console errors in DevTools
- [ ] Kit zip exported and committed

Once all boxes check, proceed to Phase 1.4 (LLSS build spec — written next
session).
