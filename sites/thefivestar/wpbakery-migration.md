# WPBakery → Elementor Migration Tracker: thefivestar.com

Decision basis: `docs/decisions.md` 2026-04-22 portfolio standardization
(Elementor + Elementor Pro is the forward builder; WPBakery retires as
migration completes).

**This file replaces the previous `elementor-migration.md`**, which tracked
the opposite direction (Elementor phase-out) and is now retired. The 2026-04-19
"WPBakery only going forward" decision has been superseded.

**Migration status:** 🟡 First wave (event pages) — not started.
Elementor page count on FSI: ~18 (pre-standardization decision — those are
now "already ahead" of the curve, though some are scheduled for deprecation).
WPBakery page count on FSI: the bulk of active pages plus ~200 legacy pages
many of which will be deprecated rather than migrated.

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
| 5089 | `/events/` | Plain HTML inside WPBakery + `fsi-event-styles.php` classes | Elementor hub layout with event cards (Loop widget or saved section) |
| 5088 | `/events/velocity/` | Plain HTML inside WPBakery (content synced from production) | Elementor event page from the template |
| 5094 | `/events/legal-league-servicer-summit/` | Plain HTML inside WPBakery, fully built per `docs/sops/new-event-page.md` | Elementor event page from the template |

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
