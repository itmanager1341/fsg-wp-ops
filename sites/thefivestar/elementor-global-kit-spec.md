# FSI Elementor Pro Global Kit — v1 Spec

Authoritative source for the Elementor Pro Site Settings / Global Kit on
thefivestar.com staging. Every value below is extracted from the current
production-proven `fsi-event-styles.php` v1.1 so visually-nothing changes
when pages migrate from plain-HTML-in-WPBakery to Elementor.

**Status:** Awaiting Phase 1.3 execution (WP Admin → Elementor → Site Settings).
**Source of truth:** this file. Re-export the kit `.zip` to `elementor-global-kit-v1.zip`
in this directory after any change so it's versionable and transferable to
production.

**Decision basis:** 2026-04-22 portfolio standardization + 2026-04-23 design
direction lock (reuse existing visual language for Phase 1-3; redesign is a
separate pass after Phase 3).

---

## 1. Global Colors

WP Admin → Elementor → Site Settings → Global Colors

| Name | Hex | Role |
|------|-----|------|
| Primary | `#1f365c` | Navy — brand primary, hero bg, card accents, primary buttons |
| Secondary | `#c9a040` | Gold — accent, hero CTA, callout background, left-border features |
| Text | `#444444` | Body text |
| Accent | `#666666` | Muted text (event location, card meta) |

**Custom colors (add under Custom Colors, not the 4 standard slots):**

| Name | Hex | Usage |
|------|-----|-------|
| Navy Hover | `#162848` | Primary button hover, navy link hover |
| Gold Hover | `#b8922e` | Gold CTA hover |
| Offwhite | `#f7f7f5` | Muted section background, card inner bg |
| Border | `#e0e0dc` | Card borders, hr-style dividers |
| Light Grey | `#cfd5de` | Hero tagline subtext |
| Gold Text Dark | `#3d2e00` | Text on gold bg (eyebrow, detail) |
| Hero Overlay | `rgba(31, 54, 92, 0.85)` | Hero background image overlay |

---

## 2. Global Fonts

WP Admin → Elementor → Site Settings → Global Fonts

Use The7 theme font (current site default) — do not introduce a new typeface
for Phase 1. Capture whatever The7 is serving today under each role; the kit
records the computed values so future theme swaps preserve typography.

| Role | Size | Weight | Line height | Notes |
|------|------|--------|-------------|-------|
| Primary | 16px | 400 | 1.6 | Body base |
| Secondary | 15px | 400 | 1.55 | Muted section body, section intro |
| Text | 14px | 400 | 1.55 | Card text, event descriptions, small |
| Accent | 13px | 700 | 1 | Button labels, small headings |

**Headings (set via Typography → Headings, not Global Fonts):**

| Tag | Size | Weight | Color | Notes |
|-----|------|--------|-------|-------|
| H1 | Theme default | — | Primary (`#1f365c`) | Page title — do not override unless current H1 diverges |
| H2 | 26px | Theme default | Primary (`#1f365c`) | Section headings; callout gold heading size matches |
| H3 | 20px | Theme default | Primary (`#1f365c`) | Event title, muted section heading |
| H4 | 18px | Theme default | Primary (`#1f365c`) | Card title, membership card title |
| Small | 11px | 700 | Primary (`#1f365c`) | Uppercase eyebrow text; set `text-transform: uppercase` + `letter-spacing: 1.2px` |

**If The7 theme currently serves different weights/families than expected,
capture what it's actually serving — not what we wish it served.** The
visual continuity goal depends on matching current rendered output.

---

## 3. Buttons

WP Admin → Elementor → Site Settings → Buttons

### Primary (navy solid — default action)

| Property | Value |
|----------|-------|
| Typography size | 13px |
| Typography weight | 700 |
| Text color | `#ffffff` |
| Background (normal) | `#1f365c` (Primary) |
| Background (hover) | `#162848` (Navy Hover) |
| Padding | 9px 22px |
| Border radius | 4px |

### Secondary — outline (navy border + white fill)

| Property | Value |
|----------|-------|
| Typography size | 13px |
| Typography weight | 700 |
| Text color | `#1f365c` (Primary) |
| Background (normal) | `#ffffff` |
| Background (hover) | `#f0f4f8` |
| Border | 2px solid `#1f365c` |
| Padding | 9px 22px |
| Border radius | 4px |

### Gold — hero CTA (larger)

Add as a third button style (Elementor → Site Settings → Buttons → Add Preset;
or use a Custom CSS class `.btn-gold` scoped to the global kit).

| Property | Value |
|----------|-------|
| Typography size | 16px |
| Typography weight | 700 |
| Text color | `#1f365c` (Primary) |
| Background (normal) | `#c9a040` (Secondary) |
| Background (hover) | `#b8922e` (Gold Hover) |
| Padding | 14px 36px |
| Border radius | 4px |

---

## 4. Layout

WP Admin → Elementor → Site Settings → Layout

| Setting | Value | Notes |
|---------|-------|-------|
| Content Width | 1100px | Matches `fsi-page-wrap` max-width |
| Widgets Space | 20px | Default gap between widgets |
| Stretched Section Fit To | `body` | Full-width section containment |

**Custom content-width widths for specific contexts** (set per-section, not global):
- Narrow body text: 820px max (intro, muted section body)
- Callout body text: 740px max

---

## 5. Site Settings → Site Identity

No changes. Leave The7 theme control intact during Phase 1-3. Revisit under
the theme-direction decision (separate audit at Phase 4 kickoff).

---

## 6. Image defaults — CLS prevention (critical)

WP Admin → Elementor → Site Settings → Images (and Lightbox)

| Setting | Value | Why |
|---------|-------|-----|
| Default Image Widget loading | `lazy` (below-fold), `eager` (above-fold overrides per widget) | Core Web Vitals |
| Enforce explicit Width + Height on Image widget | **Yes** — training, not a toggle | Prevents CLS |

**There is no single "enforce dimensions" toggle in Elementor.** This is a
build-time discipline. Every Image widget on every page has explicit
`width` and `height` values in pixels (not `auto`, not blank). Background-
image sections have explicit `min-height` in px so the section reserves
vertical space before the image loads.

Acceptance criterion for every page built from this kit: Lighthouse CLS
score < 0.1 under Slow 4G throttle.

---

## 7. Responsive breakpoints

WP Admin → Elementor → Site Settings → Layout → Breakpoints

| Breakpoint | Value | Notes |
|------------|-------|-------|
| Mobile | 480px | Small phone — matches current stylesheet |
| Tablet | 768px | Larger phone / small tablet — matches current stylesheet |
| Desktop | 1100px+ | Full layout |

Match the existing stylesheet breakpoints. Elementor's default tablet (768px)
and mobile (767px) are very close — use 768px for tablet, 480px for mobile,
which is what the current CSS uses.

---

## 8. Export + persist

After all settings above are saved:

1. WP Admin → Elementor → Tools → Import / Export Kit → Export Kit
2. Include: Site Settings (Global Colors, Global Fonts, Buttons, Layout, Images)
3. Exclude: Content (Pages, Posts — those migrate individually per phase)
4. Download the `.zip` and save it as:

   ```
   /Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-global-kit-v1.zip
   ```

5. Commit the zip to the ops repo. This is the transferable artifact for
   production promotion in Phase 1.11 and for AMAA in Phase 7.

---

## 9. Verification checklist (after the kit is built)

Before moving to Phase 1.4 (LLSS page build):

- [ ] All 4 Global Colors set to the hex values above
- [ ] 7 Custom Colors added for the extended palette
- [ ] 3 Button presets (primary / outline / gold) visually match the current
      event page buttons — side-by-side comparison with the WPBakery LLSS page
- [ ] Typography renders identically to the current LLSS page at desktop,
      tablet, and mobile widths
- [ ] Content Width = 1100px
- [ ] Export zip saved to the repo
- [ ] A throwaway test page built with one of each (H1, H2, body paragraph,
      primary button, gold button, section with offwhite bg) verifies the
      kit is alive

Once all boxes check, proceed to `llss-elementor-build-spec.md`.
