# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-04-23 (Phase 1.3 complete — Elementor global kit live on staging)
Last completed: MonsterInsights audit on MortgagePoint; CPT slug backport;
                Phase 1.3 execution (Elementor Pro Global Kit v1 on FSI staging);
                The7+Elementor CSS specificity finding captured;
                IA update captured (Phase 4 splits into Memberships + Communities templates);
                Nav-wiring rule tightened (all new nav entries require explicit approval)

---

## PROMPT TO PASTE INTO NEXT CHAT

---

Continuing FSG Media WP ops. Before responding, read these files in order:

1. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/CLAUDE.md`
2. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/brands/fsi/CLAUDE.md`
3. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/how-we-update-the-site.md`
4. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/decisions.md`
5. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/site-profile.md`
6. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/plugin-inventory.md`
7. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/wpbakery-migration.md`
8. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/the7-dependency-audit.md`
9. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-global-kit-spec.md`
10. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/the7-elementor-specificity-notes.md`
11. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/mortgagepoint/site-profile.md`
12. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/amaaonline/site-profile.md`
13. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/ssh-session-startup.md`

Then confirm and summarize:

- Phase 1.3 outcome (kit live, CSS specificity finding, kit zip location)
- Remaining Phase 1 subtasks (1.4 build LLSS → 1.11 prod promotion)
- Phase 4 template split (Memberships + Communities distinct templates)
- Nav-wiring rule (all new nav entries require explicit approval)
- MortgagePoint MonsterInsights audit finding (keep MI, disable Site Kit GA4)

Do not proceed until that summary is confirmed.

---

## Completed this session (2026-04-23 afternoon)

### Phase 1.3 — Elementor Pro Global Kit v1 on FSI staging ✅

Executed via WP Admin (Workflow C) on `thefivestarstg.wpenginepowered.com`.

Settings applied:
- **Global Colors** — 4 standard (Primary `#1f365c`, Secondary `#c9a040`,
  Text `#444444`, Accent `#666666`) + 6 custom (Navy Hover, Gold Hover,
  Offwhite, Border, Light Grey, Gold Text Dark)
- **Global Fonts** — 4 tokens (Primary/Secondary/Text/Accent) matching
  existing Arial + size/weight/line-height from `fsi-event-styles.php`
- **Layout** — Content Width 1100px; breakpoints Mobile 480, Tablet 768
- **Custom CSS** — heading color + H1-H4 sizes scoped to
  `.elementor-widget-heading .elementor-heading-title`

Verification: `/kit-test/` staging page built with H1, H2, body, button.
H1 renders 42px navy, H2 renders 26px navy, body Arial 16px, layout
1100px-centered. **Kit-test page is retained as regression canary** — do
not delete.

Kit zip target location (awaiting Jonathan's export):
`fsg-wp-ops/sites/thefivestar/elementor-global-kit-v1.zip`

### The7 + Elementor CSS specificity finding ✅ (documented)

Phase 1.3 surfaced that The7 targets Elementor widget classes directly
(`.elementor-heading-title`) and out-specifies plain element selectors.
Plain `h1, h2, h3 { color: ... }` in Custom CSS doesn't take effect.
Fix: scope every rule to `.elementor-widget-heading .elementor-heading-title`
(specificity 0,0,2,1).

Written to `sites/thefivestar/the7-elementor-specificity-notes.md`.

**Implications:** expect similar specificity fights on body text, links,
lists, buttons, and image styling. Each Elementor widget type used in
templates likely needs a matching scoped override. This raises the
"keep The7 vs swap to Hello Elementor" cost estimate meaningfully and
should be revisited at Phase 4 kickoff with Phase 1 evidence in hand.

Flagged as future work: comprehensive specificity audit — build a page
with every widget type we'll use in templates, catalogue which properties
The7 overrides. ~30 min. Saves rework during Phase 1.4-1.6.

### MonsterInsights audit on MortgagePoint ✅

**Finding: keep MonsterInsights on MP, disable Site Kit's GA4 snippet.**

Opposite of FSI pattern. MP's MonsterInsights has real configured features
that Site Kit doesn't replicate:
- Affiliate link tracking (`/go/`, `/recommend/`)
- File download tracking (doc, pdf, ppt, zip, xls, docx, pptx, xlsx)
- Enhanced link attribution
- Demographics tracking

Both tools currently inject the GA4 tag (`G-3ZF6013VSR`) — **double
pageview counting**. Cleanup needed: Site Kit → Analytics → disable
snippet output. Keep Site Kit for Search Console + AdSense + PageSpeed
Insights dashboard modules only.

Action still pending; recommended 5-min change during the next MP session.

### CPT slug corrections backported ✅

`sites/thefivestar/site-profile.md` updated — Portfolio is `dt_portfolio`
(was `project`), Slideshows is `dt_slideshow` (was unlabeled), all 5 CPTs
now show correct slugs and are cross-referenced to the dependency audit.

### Phase 4 IA split locked (from Jonathan this session) ✅

Phase 4 was originally "Membership / profession pages" — one template.
Jonathan clarified these are two distinct IA structures with visually
different templates:

- **`/memberships/` hub** — existing member groups (FORCE, Legal League,
  AMDC, PPEF, NMSA, MSEA) + new Five Star Alliance Membership. Update in
  place. Template: "FSI Membership Page".
- **`/communities/` hub** — NEW subfolder. Children: Mortgage Finance,
  Legal, RE Pro, Prop Pres. Greenfield authoring. Template: "FSI Community
  Page" (visually distinct from Membership).

Phase 4 now authors **two** templates, not one. Phase 5 (Who We Are /
institutional) may be a third or a variant of one of these two.

### Nav-wiring rule tightened ✅

Global rule for all new pages: **new pages can publish; new nav links
stay staging-only until explicit approval.** Single pre-approved
exception: the Phase 2 swap where `/events/` replaces `/conferences/` in
the Events top-nav slot (`/conferences/` is what's currently wired).

Any future nav addition — including `/communities/` when Phase 4 ships —
requires fresh explicit approval. No inference, no assumption.

### LLSS slug decision locked ✅

Phase 1 uses the singular slug `legal-league-servicer-summit`. The plural
`legal-league-servicers-summit` page (3579) on production is independent
cleanup, not blocking. No redirect needed — per Jonathan, no meaningful
traffic to fivestar.com means we're not optimizing for link equity on
legacy URLs; at most add redirects on deprecated pages later.

### Velocity scope clarified ✅

- `thefivestar.com/velocity/` — old 2024 single-event lander. Unrelated
  to Phase 3.
- `thefivestar.com/events/velocity/` — the page Phase 3 replaces. Existing
  page gets its content replaced by the new Elementor version.

---

## Next session priority: Phase 1.4 — LLSS Elementor build

### Prerequisites (must be true before starting)

1. Jonathan exports Elementor kit zip to `sites/thefivestar/elementor-global-kit-v1.zip`
2. `/kit-test/` staging page retained (regression canary)
3. Next session reads `sites/thefivestar/the7-elementor-specificity-notes.md`
   before writing any CSS or building any widget

### Subtasks

**Step 1 — Write the LLSS build spec**

`sites/thefivestar/llss-elementor-build-spec.md`. Section-by-section
instructions for WP Admin (Workflow C). 8 sections from the template:

| # | Section | Key spec |
|---|---------|----------|
| 1 | Hero | Background image 1900×600px min-height; H1 + subhead + gold CTA |
| 2 | Intro / Who Belongs | Optional side image 560×400px |
| 3 | What Happens | Feature grid, icons 64×64, card images 400×300 |
| 4 | Next Summit callout | Gold background, no images, min-height reserves space |
| 5 | Recent Summit photo strip | 3 images, 360×240 each |
| 6 | Membership cards | Card images 480×220 each |
| 7 | Event Details | Optional location image 800×450 |
| 8 | Final CTA | Background image 1900×400 min-height |

Each section spec includes: widgets used, global color bindings, explicit
dimensions for images, CSS overrides likely needed (based on specificity
findings), responsive behavior at 480/768 breakpoints.

**Step 2 — Mid-phase checkpoint (Jonathan-approved in prior session)**

Build ONLY Hero + Final CTA first. Save throwaway page. Verify:
- Matches visual target from WPBakery LLSS reference
- Lighthouse CLS < 0.1 under Slow 4G
- Advanced Ads render in expected slots if present
- No PHP errors

If checkpoint passes → build remaining 6 sections.
If checkpoint fails → surface findings, re-plan before continuing.

**Step 3 — Specificity audit widget-type inventory**

Before writing section specs, run a focused audit on `/kit-test/` or a
new scratch page: add each widget type used in Phase 1-3 templates,
note which properties The7 overrides. Catalogue into
`the7-elementor-specificity-notes.md`. Saves iteration time in Step 1-2.

Widgets to test: Heading (done), Text Editor, Button, Image, Icon Box,
Image Box, Inner Section/Container, Spacer, Divider.

**Step 4 — Hide The7 page-title bar on Elementor event pages**

The7 Page Options (per-page, in WP Admin Page editor sidebar) → Page
Title → Disable. Applied to LLSS, Velocity, Events hub as they're built.
Prevents double-hero effect.

**Step 5 — Subsequent steps per Phase 1 runbook**

1.5 Save each section as Elementor Pro template →
1.6 Combine into "FSI Event Page" master template →
1.7 Full 8-check verification gate →
1.8 Write `docs/sops/new-event-page-elementor.md` →
1.9 Rename + swap on staging →
1.10 🛑 Approval gate →
1.11 Production promotion (create-new; LLSS doesn't exist on prod).

---

## Parallel work (can happen alongside Phase 1.4)

### MortgagePoint — disable Site Kit GA4 snippet (15 min, 🟡 Med)

Staging first (need MP staging SSH alias added to `~/.ssh/config`; not
yet done). Then explicit approval gate → production. Resolves double-
pageview issue.

### FSI — plugin deletions to production (🟢 Low, Jonathan handles manually)

Jonathan to execute: MonsterInsights, Image Optimizer, OptiMonster,
EventON Lite. All currently deleted on staging; promote when convenient.

### Elementor Pro license cleanup

**Done per Jonathan this session** — 10 seats available on the license.
Removed from open items.

### MortgagePoint — Elementor Pro 3.35.1 → 4.0.3 upgrade path (🟡 Med)

Needs MP staging SSH alias first. Then staging upgrade → verify →
explicit approval gate → production. Unblocks Phase 7 (AMAA) reference.

### FSI deprecation pass (🟡 Med)

Identify ~200 legacy FSI pages that should be trashed rather than
migrated. Needs GA4 / Site Kit data. Reduces Phase 6 scope significantly.

---

## Current staging-only changes

Unchanged from 2026-04-22 stance — do NOT promote WPBakery-era content
pages to production.

| Change | Type | Staging | Production plan |
|--------|------|---------|-----------------|
| MonsterInsights deleted | Plugin | ✅ | Hygiene — Jonathan handles when convenient |
| Image Optimizer deleted | Plugin | ✅ | Hygiene — Jonathan handles |
| OptiMonster deleted | Plugin | ✅ | Hygiene — Jonathan handles |
| EventON Lite deleted | Plugin | ✅ | Hygiene — Jonathan handles |
| fsi-event-styles.php v1.1 | mu-plugin | ✅ | Hold — retires with WPBakery event pages |
| Events hub (HTML/WPBakery) | Content | ✅ | Hold — Phase 2 Elementor replaces |
| Velocity (HTML/WPBakery) | Content | ✅ | Hold — Phase 3 Elementor replaces |
| LLSS (HTML/WPBakery) | Content | ✅ | Hold — Phase 1 Elementor replaces |
| Nav: Events → /events/ | Menu | ✅ | Hold — Phase 2 approval required |
| Nav: Live → /events/ | Menu | ✅ | Hold — Phase 2 approval required |
| Elementor Global Kit v1 | Site settings | ✅ | Phase 1.11 promotion via kit zip import |
| /kit-test/ regression page | Content | ✅ | Keep staging-only permanently |

---

## Key facts (unchanged from prior sessions)

**Portfolio standardization (2026-04-22):** Elementor + Elementor Pro
across all 3 WP sites. WPBakery maintenance-only on FSI + AMAA.

**Theme direction:** Deferred. 2026-04-23 audit says bounded-scope swap
to Hello Elementor on FSI. Revisit at Phase 4 kickoff. **Early Phase 1
evidence (specificity findings) pushes the scale toward Hello Elementor**
— worth weighing at Phase 4 with more data.

**Environments (FSI):** Prod `thefivestar` PHP 8.2, Staging
`thefivestarstg` PHP 8.4, Dev `thefivestardev` PHP 8.4. WP-CLI works on
all three; staging requires `wp core download --skip-content` if
container recycled.

**Production approval gate:** Staging verified ✅ → STOP → report → ask
"Approve?" → wait for explicit "yes" in chat → production. No exceptions.

**Nav-wiring rule:** New pages publish freely on staging; new nav
entries require explicit approval before production wiring. Exception:
Phase 2 `/events/` replaces `/conferences/` is pre-approved.

**Elementor Pro Expert license:** 25 seats, 10 available after cleanup.

---

## Open questions carried forward

1. **Theme direction** — The7 vs Hello Elementor. Audit-completed
   2026-04-23. Revisit at Phase 4 kickoff with Phase 1-3 specificity
   evidence in hand. Preliminary Phase 1 evidence leans toward Hello
   Elementor but insufficient to decide.
2. **Visual design for event-page template** — LOCKED as "reuse existing
   visual language for Phase 1-3; redesign is a separate pass after
   Phase 3."
3. **Elementor Pro 3.35.1 → 4.0.3 on MortgagePoint** — needs proven path
   on MP staging before MP is cited as reference.
4. **FSI deprecation pass** — needs GA4 / Site Kit data.
5. **MP staging SSH alias** — not yet in `~/.ssh/config`. Add before any
   MP staging work.
