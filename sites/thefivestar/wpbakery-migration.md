# WPBakery → Elementor Migration Tracker: thefivestar.com

Decision basis: `docs/decisions.md` 2026-04-22 portfolio standardization
(Elementor + Elementor Pro is the forward builder; WPBakery retires as
migration completes).

**This file replaces the previous `elementor-migration.md`**, which tracked
the opposite direction (Elementor phase-out) and is now retired. The 2026-04-19
"WPBakery only going forward" decision has been superseded.

**Migration is organized around three parent-child hierarchies**, each
backed by its own Elementor template. See `docs/decisions.md`
2026-04-27 IA clarification.

| Hierarchy | Parent | Template | First-wave status |
|-----------|--------|----------|---------------------|
| Events | `/events/` (5089) | FSI Event Page (Option B, proven) | LLSS + Velocity migrated on staging ✅ |
| Memberships | `/memberships/` (2597) | FSI Membership Page (greenfield) | Phase 4a — no pages exist yet |
| Communities | `/communities/` (NEW) | FSI Community Page (greenfield + relocate RE Pros mockup) | Phase 4b — RE Pros relocates from `/memberships/` |

**Production promotion gates pending:**

- Phase 1.11: LLSS → production (awaiting Jonathan approval + image content)
- Phase 3.11: Velocity → production (awaiting Jonathan approval + image content)
- Phase 4b.11: RE Pros (Community) → production (after Phase 4b builds)
- Phase 4a.11: Each Membership page → production (after Phase 4a builds)

**Events — staging state:**

- **/events/ hub** Elementor live at canonical staging slug (since
  2026-04-27 PM via in-place swap on page 5089):
  - `https://thefivestarstg.wpenginepowered.com/events/`
    → Elementor page 5089 (in-place swap; same post ID kept; original
    WPBakery `post_content` backed up to `_elementor_inplace_swap_backup_*` meta)
  - 2 sections, 6,292 B `_elementor_data` (lightest of any migrated FSI page)
  - Preserves "EVENTS" navy page-title bar (`_dt_header_title='enabled'`)
- **LLSS** live at canonical staging slug (since 2026-04-26):
  - `https://thefivestarstg.wpenginepowered.com/events/legal-league-servicer-summit/`
    → Elementor page 5106
  - `https://thefivestarstg.wpenginepowered.com/events/legal-league-servicer-summit-old/`
    → original WPBakery page 5094 (preserved for fallback)
- **Velocity** live at canonical staging slug (since 2026-04-27):
  - `https://thefivestarstg.wpenginepowered.com/events/velocity/`
    → Elementor page 5107
  - `https://thefivestarstg.wpenginepowered.com/events/velocity-old/`
    → original WPBakery page 5088 (preserved for fallback)

**Memberships — staging state:**

- `/memberships/` hub Elementor live at canonical staging slug
  (initial 2026-04-27 PM; redesigned 2026-04-28 PM via in-place update
  on same page 5138):
  - `https://thefivestarstg.wpenginepowered.com/memberships/`
    → Elementor page 5138 (4 sections, ~14.5 KB `_elementor_data`)
  - `https://thefivestarstg.wpenginepowered.com/memberships-old/`
    → original WPBakery page 2597 (renamed; preserved for fallback)
- **Final hierarchy (post 2026-04-28 redesign):** literal visual stack —
  6 specialty memberships sit on top as standing structures, Alliance
  sits underneath as the universal foundation. Spatial layout
  communicates organizational hierarchy without explanation.
  - 01 Hero (navy): "PROFESSIONAL MEMBERSHIPS" eyebrow / "The seven
    memberships that organize this work" H1 / practitioner-focused
    description naming Alliance as "universal foundation underneath
    them all"
  - 02/03 Specialty grid (offwhite): 6 tiles in 3-column CSS grid
    (FORCE / Legal League / NMSA / MSEA / PPEF / AMDC). Each tile:
    logo, title, community subtitle, description, two buttons
    (Community ← / → Member Portal). NO Alliance tile.
  - 04 Alliance foundation strip (offwhite): gold "The Foundation"
    eyebrow / Alliance logo / copy explicitly referencing being
    "underneath every specialty above" / contact CTA. White card on
    offwhite palette + gold top accent (matches specialty tiles for
    visual cohesion while spatial placement establishes the
    foundation relationship).
  - 05 Footer-line
- **Removed in 2026-04-28 redesign:** old Section 02 navy Alliance
  umbrella band; old Alliance featured tile from grid; old "Not sure
  where you fit?" CTA; redundant secondary "Memberships" heading.
  Reduces to single navy band (hero only). PPEF description corrected
  from "standards body" to "membership organization."
- 7 logos uploaded as media assets (Alliance + 6 specialty COLOR
  variants); all rendering correctly
- **No formal Membership child pages exist on staging.** FORCE, Legal
  League (firms), AMDC, PPEF, NMSA, MSEA, Five Star Alliance all need
  to be authored greenfield as part of Phase 4a (individual pages,
  distinct from this hub).
- Page 5087 (`real-estate-professionals`) was previously mis-located
  here. Relocated to `/communities/` 2026-04-27 (Phase 4b).

**Communities — staging state:**

- `/communities/` hub Elementor live at canonical staging slug (since
  2026-04-28 via in-place swap on page 5108):
  - `https://thefivestarstg.wpenginepowered.com/communities/`
    → Elementor page 5108 (in-place swap; same post ID kept; original
    stub `post_content` backed up to `_elementor_inplace_swap_backup_*` meta)
  - **6 sections, 16,282 B `_elementor_data`** (post-revision — AMDC + MortgagePoint dropped)
  - 2x2 community grid (Mortgage Finance / Financial Services Law /
    Real Estate / Property Preservation) — **community-level copy, no
    membership logos, no subtitles** (architectural separation from
    `/memberships/` hub per Jonathan's flow correction)
  - FSC convergence section (4 community badges, AMDC removed)
  - Inline Memberships CTA pulls Step 2 readers toward Step 3 Alliance via `/memberships/`
  - Callouts use FSI palette (offwhite + gold accent) per Jonathan's
    color-conformance directive — NOT the mockup's yellow
  - Nav-wiring deferred per standing rule.
- **RE Professionals** Elementor live at canonical staging slug (since
  2026-04-27):
  - `https://thefivestarstg.wpenginepowered.com/communities/real-estate-professionals/`
    → Elementor page 5109 (8 sections, 20,019 B `_elementor_data`)
  - `https://thefivestarstg.wpenginepowered.com/communities/real-estate-professionals-old/`
    → original WPBakery page 5087 (relocated from `/memberships/` parent
    + renamed; preserved for fallback)
  - 301 redirect via `eps-301-redirects` plugin from
    `/memberships/real-estate-professionals/` → 5109 (verified firing)
- Other community children (Mortgage Finance, Legal, Prop Pres) — not
  yet authored. Phase 4b's 2nd-instance build is the trigger to extract
  shared CSS classes from the inline-styled RE Pros sections.

Elementor page count on FSI: ~20 (~18 pre-existing + LLSS + Velocity).
WPBakery page count on FSI: the bulk of active pages plus ~200 legacy pages
many of which will be deprecated rather than migrated.

**Architectural pattern proven 2026-04-26:** Option B (Elementor structural
containers + HTML widgets containing existing `fsi-page-wrap` markup).
Hero + Final CTA stay as Elementor widget trees (bg image + overlay benefit
from Elementor primitives); content sections become single HTML widgets
that leverage `fsi-event-styles.php` CSS for visual fidelity. See
`docs/decisions.md` 2026-04-26 entry. This is the cloneable pattern for
Phase 2 (Events hub) and Phase 3 (Velocity).

---

## Principle: migrate as you touch, not mass rebuild

Every live page on thefivestar.com is eventually Elementor-native, but we
do not force-migrate pages that don't need editorial or structural changes.
Migration happens when:

1. A page is due for content or design updates — migrate to Elementor during
   the update rather than editing WPBakery in-place
2. A page is a template opportunity — see First Wave below
3. A page is already Elementor — no action; it's on-standard already

Pages scheduled for deprecation are not migrated. They're trashed.

---

## Principle: preserve originals via `-old` rename, not deletion

When a page migrates to Elementor, the original WPBakery/HTML version is
**renamed**, not deleted:

- Slug: append `-old` → `legal-league-servicer-summit-old`, `velocity-old`, etc.
- Title: append ` (Old WPBakery)` → "Legal League Servicer Summit (Old WPBakery)"
- Status stays `publish` on staging so the content remains findable
- Only happens AFTER the Elementor version is verified on staging
- Old WPBakery pages are NOT promoted to production; they only exist on
  staging for rollback/reference
- Trash after ~1-2 weeks of production confidence on the Elementor replacement

This keeps content findable, makes the migration's before/after obvious in
WP Admin, and gives a rollback path if the Elementor version has issues we
missed.

---

## Principle: explicit image dimensions on every image (CLS prevention)

Every image in every Elementor template has explicit `width` and `height`
attributes. This prevents Cumulative Layout Shift (CLS) — the page-jump
behavior that happens when images load and push content around.

**Rules:**

- Elementor Image widget: set Width and Height explicitly (not "auto")
- Background image sections: set Min Height in px so the section reserves
  space before the image loads
- Lazy loading: enabled by default for below-fold images
- Target dimensions are specified per section in the FSI Event Page template
  and in subsequent template specs (Membership, Institutional)
- Lighthouse / PageSpeed CLS score < 0.1 is the acceptance criterion for
  every migrated page
- Chrome DevTools slow-network test: throttle to Slow 4G, load page, observe
  no visible layout shift

**Why this matters more than in WPBakery-era:** the current WPBakery pages
use `fsi-event-styles.php` which has some fixed dimensions baked into
classes. Elementor's widget-driven approach loses that discipline unless
we're deliberate about it. Build it into the template spec from Phase 1 so
every downstream page inherits correct behavior.

---

## First migration wave — FSI event page template

These three pages are rebuilt in Elementor first to establish the event-page
template pattern. Once proven, the template is saved as an Elementor Pro
section/template and becomes the source for all future event pages.

| ID | Slug | Current state | Target state |
|----|------|---------------|--------------|
| 5089 | `/events/` | Plain HTML inside WPBakery + `fsi-event-styles.php` classes | Elementor hub layout with event cards (Loop widget or saved section) — Phase 2 |
| 5088 | `velocity-old` (renamed 2026-04-27) | Inline-styled HTML inside WPBakery | **MIGRATED to Elementor page 5107 at canonical slug `/events/velocity/`** (staging only — prod promotion pending Phase 3.11) |
| 5107 | `/events/velocity/` | **Elementor — Option B pattern (8 sections JSON in repo)** | Production promotion via Phase 3.11 |
| 5094 | `legal-league-servicer-summit-old` (renamed 2026-04-26) | Plain HTML inside WPBakery, fully built per `docs/sops/new-event-page.md` | **MIGRATED to Elementor page 5106 at canonical slug `/events/legal-league-servicer-summit/`** (staging only — prod promotion pending Phase 1.11) |
| 5106 | `/events/legal-league-servicer-summit/` | **Elementor — Option B pattern (9 sections JSON in repo)** | Production promotion via Phase 1.11 |

**Why these three:** content is fresh, CSS tokens already documented,
structure is clear (hero, intro, Who Belongs, What Happens, Next Summit,
Recent Summit photo strip, Join the Community, Event Details, Final CTA).
Ideal material for establishing a reusable Elementor Pro template.

**Deliverables from the first wave:**

- Elementor Pro global kit populated with FSI brand tokens
  (Navy `#1f365c`, Gold `#c9a040`, Offwhite `#f7f7f5`) + typography scale +
  button/heading/section presets
- Elementor Pro template library entries for each event-page section with
  **explicit image dimensions baked into every image widget and min-heights
  on every background-image section** (see CLS principle above)
- One saved "FSI Event Page" template combining the sections
- New SOP `docs/sops/new-event-page-elementor.md` replacing
  `docs/sops/new-event-page.md` — must include image dimension table as a
  mandatory section
- `-old` rename applied to WPBakery LLSS after Elementor version verified
  (both pages exist on staging; only Elementor version goes to production)

**Image dimension spec for FSI Event Page template:**

| Section | Element | Dimensions | Notes |
|---------|---------|------------|-------|
| Hero | Background image | 1900×600px min-height | Section min-height in px |
| Intro/Who Belongs | Optional side image | 560×400px | Lazy load below fold |
| What Happens | Feature icons | 64×64px | 4-up or 3-up grid |
| What Happens | Card images | 400×300px | — |
| Next Summit callout | (no images) | min-height required | Reserve space |
| Recent Summit strip | 3 photos | 360×240px each | Row min-height |
| Membership cards | Card images | 480×220px each | 3-up card layout |
| Event Details | Optional location image | 800×450px | — |
| Final CTA | Background image | 1900×400px min-height | Section min-height |

---

## Second wave — live WPBakery pages touched in the normal course of work

Deferred. Each page migrates when it's edited for real reasons. No forced
schedule. Per-page tracker to be maintained as migrations complete.

| ID | Title | Current builder | Migrated | Notes |
|----|-------|-----------------|----------|-------|
| (tracker populated as migrations happen) |

---

## Deprecation list — trash rather than migrate

Per Jonathan's note, a significant portion of the ~200 FSI pages are legacy
and should be trashed, not migrated. Needs a dedicated deprecation pass with
access to GA4 / Site Kit for low-traffic identification. Candidates from the
superseded Elementor migration tracker that are probably trash anyway:

| ID | Title | Why likely trash |
|----|-------|------------------|
| 4973 | Elementor #4973 | Unnamed draft |
| 4834 | Elementor Page #4834 | Unnamed draft |
| 4828 | Elementor #4828 | Unnamed draft |
| 4909 | Home (private) | Private, not public |
| 4829 | FSC&Me 2024 | 2024 event, superseded |
| 4757 | FSC2024 Asset | 2024 event assets, superseded |
| 4912 | FSC2025 Assets | 2025 event assets, post-event |
| 3471 | contact update | Legacy utility page |
| 4965 | Real Estate Investment Forum Deal Room (duplicate of 4970) | Probable duplicate |

None of these block the first wave.

---

## Elementor pages already on FSI (per 2026-04-19 audit)

18 pages have `_elementor_edit_mode = builder` today. Under the superseded
decision, these were flagged for rebuild in WPBakery. Under the current
decision, **they are on-standard** — no action needed except:

- The deprecation candidates above (trash them)
- The core section pages (Member Benefits, Education, Seminars, Courses,
  Certifications, Five Star Access) — review for redesign but they're
  already Elementor, which means they benefit from the new global kit
  once it exists

Re-audit these pages after the first wave so the Elementor kit + template
library applies consistently.

---

## Success criteria

Portfolio standardization on FSI is complete when:

1. All active (non-deprecated) pages have `_elementor_edit_mode = builder`
2. Zero active pages use WPBakery shortcodes in `post_content`
3. WPBakery + Ultimate Addons + Ads for WPBakery chain is deactivated on
   staging and production
4. Classic Editor and Classic Widgets are deactivated
5. `fsi-event-styles.php` mu-plugin is retired OR scoped to the few
   patterns the Elementor kit can't express

---

## Open questions before starting

1. Target theme during migration — stay on The7 (recommended for now) or
   swap to Hello Elementor? Theme swap is a separate, later decision.
2. Elementor Pro version on FSI — confirm current version is 4.0.x (audit
   showed 4.0.2 earlier). Align with MortgagePoint when MP updates to 4.x
   from its current 3.35.1.
3. Design direction for the event-page template — reuse existing FSI visual
   language (tokens already documented) or introduce redesign at the same
   time as the builder migration? Recommend: reuse existing for the first
   wave to de-risk; visual redesign is a separate pass.
