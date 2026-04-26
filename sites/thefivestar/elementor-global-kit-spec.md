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
**Source of truth:** `sites/thefivestar/elementor-kit/*.json` (mirror of the
kit zip contents). This spec doc describes the *intent* and the rationale;
the JSON files are the executable truth. When they disagree, the JSON wins
and this doc gets updated.
**Decision basis:** 2026-04-22 portfolio standardization + 2026-04-23
design-direction lock (reuse existing visual language for Phase 1–3;
redesign is a separate pass after Phase 3) + 2026-04-25 AI-first Elementor
authoring (`docs/decisions.md`).

**2026-04-25 reality reconciliation** (after first round-trip via WP-CLI):

| Spec said | Reality on staging | Resolution |
|-----------|--------------------|------------|
| Body fonts: Arial 16/15/14/13 | Roboto / Roboto Slab 16/15/14/13 | Spec wrong; kit uses Roboto. Updated below. |
| 6 custom colors (Navy Hover, Gold Hover, Offwhite, Border, Light Grey, Gold Text Dark) | 10 custom colors (above 6 + Hero Overlay `#1F365CD9`, Velocity CP Light Yellow `#F2F1AE`, Velocity CP Blue `#00A0E6`, claude gray `#6B7A8D`) | 4 extra colors documented below; Hero Overlay invalidates spec note that v4 doesn't support alpha. |
| Mobile breakpoint 480 | `viewport_mobile` stored as null in `_elementor_page_settings` | v4 stores breakpoints differently than v3; need follow-up audit. Tablet (`viewport_md=768`) and desktop (`viewport_lg=1025`) confirmed. |

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

**Custom Colors — 17 slots (live on staging 2026-04-25 after renumber):**

The kit was renumbered 2026-04-25 to preserve prod page back-compatibility.
See `docs/decisions.md` 2026-04-25 entry "Restore prod custom-color slot
IDs". Full audit in `docs/sops/elementor-json-authoring.md` section
"Color slot ID convention".

**Pre-existing prod slots (DO NOT bind new pages to these — preserved for
prod page back-compat only):**

| Slot ID | Name | Hex | Notes |
|---------|------|-----|-------|
| `f64043d` | Velocity Blue | `#0086DB` | Used by Exit Intent popup (4497), Five Star Access (4993) |
| `fd98090` | Velocity Lighter Blue | `#EEAC04` | Currently 0 prod refs (vestigial slot) |
| `7836aae` | Velocity Yellow | `#EEAC04` | Used by Five Star Access (4993) |
| `9bb2763` | Velocity Red | `#D12726` | Used by Exit Intent popup (4497) |
| `9e77118` | Velocity White | `#FFFFFF` | Used by Exit Intent, Education, Five Star Access, Velocity |
| `2922fdd` | Velocity CP Red | `#D02422` | Used by Velocity (4436) |
| `73bb18d` | Velocity CP Orange | `#F09A1E` | Used by Velocity (4436) |
| `bd029dc` | Velocity CP Light Yellow | `#F2F1AE` | Velocity event accent |
| `60190b2` | Velocity CP Blue | `#00A0E6` | Velocity event accent |
| `dc145d8` | claude gray | `#6B7A8D` | (purpose unknown — flag for cleanup pass) |

**FSI brand-kit slots (bind new event/membership/community pages to these):**

| Slot ID | Name | Hex | Usage |
|---------|------|-----|-------|
| `fsi01nh` | Navy Hover | `#162848` | Primary button hover, navy link hover |
| `fsi02gh` | Gold Hover | `#B8922E` | Gold CTA hover |
| `fsi03ow` | Offwhite | `#F7F7F5` | Muted section background, card inner bg |
| `fsi04bd` | Border | `#E0E0DC` | Card borders, dividers |
| `fsi05lg` | Light Grey | `#CFD5DE` | Hero tagline subtext |
| `fsi06gt` | Gold Text Dark | `#3D2E00` | Text on gold bg (eyebrow, detail) |
| `fsi07ho` | Hero Overlay | `#1F365CD9` | Hero overlay (8-digit hex `RRGGBBAA`) |

**Note on Hero Overlay:** the original spec assumed v4 Global Colors
couldn't hold alpha. Reality is v4 accepts 8-digit hex (`RRGGBBAA`).
`#1F365CD9` is `rgba(31, 54, 92, 0.85)`. Slot `fsi07ho` is bindable.

**Slot ID convention going forward:** `fsi[NN][initials]` for FSI brand
additions. Next free is `fsi08xx`. Pre-existing 7-char IDs are preserved
for back-compat — never overwrite their title/hex without first running
the pre-flight slot-usage query (see SOP).

---

## 2. Global Fonts

Path: Site Settings → Design System → Global Fonts

**Live on staging 2026-04-25:**

| Token | Family | Size | Notes |
|-------|--------|------|-------|
| Primary | Roboto | 16px | Body base |
| Secondary | Roboto Slab | 15px | Section intro / muted body |
| Text | Roboto | 14px | Card text, event descriptions |
| Accent | Roboto | 13px | Small caps, eyebrow, labels |

**Verified via Playwright `getComputedStyle` on `/kit-test/` 2026-04-25:**
body paragraph renders `Roboto, sans-serif`, 14px (matches Text token).
Heading widgets render `Roboto, sans-serif` (matches Primary family).

**Original spec said Arial.** That assumption was wrong. The7 doesn't
override Elementor's font-family token (it overrides size/color/weight via
its widget-class selectors — see specificity notes). Roboto is what's
actually live.

**Global Fonts does not include a color field** — that's per-widget (or
applied via the Custom CSS in section 4).

---

## 3. Layout

Path: Site Settings → Settings → Layout

| Setting | Value | Notes |
|---------|-------|-------|
| Content Width | 1100 | Matches `.fsi-page-wrap` max-width |
| Widgets Space | 20 | Default gap between stacked widgets |
| Stretched Section Fit To | `body` | Full-width section containment |

**Breakpoints** — verified on staging 2026-04-25:

| Breakpoint | Storage key | Value | Notes |
|------------|-------------|-------|-------|
| Tablet | `viewport_md` | 768 | ✅ matches spec |
| Desktop | `viewport_lg` | 1025 | (live-only — not in original spec) |
| Mobile | `viewport_mobile` | `null` | ⚠️ stored as null; v4 may use a different storage path. **Open audit item** before relying on a 480px mobile breakpoint in section CSS. |

The original spec target was Mobile 480 / Tablet 768. Tablet matches.
Desktop and mobile storage need a v4-specific re-audit — spec value alone
cannot be trusted until we verify how v4 actually delivers the mobile
breakpoint to the rendered CSS.

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
