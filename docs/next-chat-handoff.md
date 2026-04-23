# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-04-23 (evening — Phase 1.3 closed, docs refreshed)
Last completed: Phase 1.3 Elementor Global Kit v1 live on FSI staging;
                kit zip exported + committed; The7+Elementor specificity
                finding documented; MP MonsterInsights audit completed;
                CPT slug backport; IA split for Phase 4 locked;
                nav-wiring rule tightened
Next phase: Phase 1.4 — LLSS Elementor build

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

Then confirm you've read them and summarize:

- Phase 1.3 outcome (what's live on staging; artifact locations)
- The7 + Elementor CSS specificity rule (why it matters for Phase 1.4)
- Phase 1.4 scope + the pre-work before section builds
- The mid-phase checkpoint plan (Hero + Final CTA first, then remaining 6)
- The production approval gate rule (verbatim from CLAUDE.md)
- Nav-wiring rule and the one standing exception
- Phase 4 IA split (two templates: Memberships + Communities)
- Current staging-only changes (what's held, what's ready to promote)

Do not proceed until that summary is confirmed.

---

## Completed this session (2026-04-23)

### Phase 1.3 — Elementor Pro Global Kit v1 LIVE on FSI staging ✅

Executed via WP Admin (Workflow C) on `thefivestarstg.wpenginepowered.com`.

**Verified stack:** Elementor 4.0.2 + Elementor Pro 4.0.2 + The7 14.3.0.

**Settings applied:**
- Global Colors: 4 standard (Primary `#1f365c`, Secondary `#c9a040`, Text
  `#444444`, Accent `#666666`) + 6 custom (Navy Hover, Gold Hover,
  Offwhite, Border, Light Grey, Gold Text Dark)
- Global Fonts: 4 typography tokens matching Arial + size/weight/line-height
  from `fsi-event-styles.php`
- Layout: Content Width 1100px, breakpoints Mobile 480 / Tablet 768
- Custom CSS: heading color + H1–H4 sizes scoped to
  `.elementor-widget-heading .elementor-heading-title`

**Verification:** `/kit-test/` staging page renders H1 42px navy, H2 26px
navy, body Arial 16px, 1100px centered. **Retained as regression canary
— do not delete.**

**Kit export artifact:** `sites/thefivestar/elementor-global-kit-v1.zip`
(5.4KB, committed). Inspection confirmed 4 JSON files: site-settings,
custom-fonts, custom-code, manifest. Custom CSS block verified present.

### v4 Elementor reality captured in docs ✅

Elementor v4 removed the Theme Style, Typography (H1–H6 color panel), and
Buttons panels from Site Settings. Stale references to
`Elementor → Tools → Export Kit` corrected throughout — v4 path is
`Templates → Kits & Templates`. Button presets in v4 are per-widget,
saved as Global Widgets (Phase 1.4 deliverable, not kit config).

Updates landed in: `how-we-update-the-site.md`,
`brands/fsi/CLAUDE.md`, `elementor-global-kit-spec.md`,
`thefivestar/plugin-inventory.md`, `thefivestar/site-profile.md`.

### The7 + Elementor CSS specificity finding ✅

Phase 1.3 surfaced that The7 targets Elementor widget classes directly
(`.elementor-heading-title`) and out-specifies plain element selectors.
Plain `h1, h2, h3 { color: ... }` in Custom CSS does not take effect.
Fix: scope every rule to `.elementor-widget-heading .elementor-heading-title`
(specificity 0,0,2,1).

Written to `sites/thefivestar/the7-elementor-specificity-notes.md`.

**Implications for Phase 1.4+:** expect similar specificity fights on body
text, links, lists, buttons, images. Each Elementor widget type used in
templates likely needs a matching scoped override. This is early Phase 1
evidence feeding the Phase 4 theme-direction revisit (The7 vs Hello
Elementor) — preliminary lean toward Hello Elementor, insufficient to
decide yet.

### MonsterInsights audit on MortgagePoint ✅

**Finding: keep MonsterInsights on MP, disable Site Kit's GA4 snippet.**
Opposite of FSI pattern. MP's MonsterInsights has real configured
features Site Kit doesn't replicate: affiliate link tracking (`/go/`,
`/recommend/`), file download tracking (doc, pdf, ppt, zip, xls, docx,
pptx, xlsx), enhanced link attribution, demographics tracking.

Both tools currently inject the GA4 tag (`G-3ZF6013VSR`) — **double
pageview counting**. Cleanup action: Site Kit → Analytics → disable
snippet output. Full findings in `sites/mortgagepoint/site-profile.md`.

**Blocker:** MP staging SSH alias not yet in `~/.ssh/config`. Must be
added before MP staging work. Then: staging cleanup → explicit approval
gate → production.

### IA split for Phase 4 locked ✅

Phase 4 was "Membership / profession pages" (one template). Now two
visually-distinct templates:

- **`/memberships/`** — existing groups (FORCE, Legal League, AMDC, PPEF,
  NMSA, MSEA) + new Five Star Alliance. Update in place. Template: "FSI
  Membership Page"
- **`/communities/`** — NEW subfolder. Children: Mortgage Finance, Legal,
  RE Pro, Prop Pres. Greenfield. Template: "FSI Community Page" —
  visually distinct from Membership

Logged to `docs/decisions.md` and `brands/fsi/CLAUDE.md`.

### Nav-wiring rule tightened ✅

Standing rule: **all new nav entries require explicit approval.**
Publishing a page is authorized; wiring to nav is not.
Single standing exception: Phase 2 `/events/` replaces `/conferences/`
in the Events top-nav slot. No other nav changes inherit this approval.

Logged to `docs/decisions.md` and `brands/fsi/CLAUDE.md` (as a "do not").

### Other housekeeping ✅

- CPT slug corrections backported to `site-profile.md` (Portfolio is
  `dt_portfolio`, Slideshows is `dt_slideshow`, all 5 CPTs correct)
- LLSS-on-prod check: singular slug `legal-league-servicer-summit` is
  clear; plural `legal-league-servicers-summit` (page 3579) exists but
  is independent cleanup per Jonathan
- Velocity scope clarified: `thefivestar.com/velocity/` is an old 2024
  event lander (unrelated); `thefivestar.com/events/velocity/` is the
  page Phase 3 replaces
- Elementor Custom Code inventory: discovered 2 sitewide injection blocks
  (Naylor, Apollo) in the kit zip. Noted in `site-profile.md` for later
  audit — not blocking

### Elementor Pro license cleanup ✅ (done by Jonathan)

10 seats available on the Expert license post-cleanup. Removed from open
items carried forward.

---

## Files changed this session

- `sites/thefivestar/site-profile.md` — theme/builder stack table,
  kit v1 section, Custom Code inventory, specificity section
- `sites/thefivestar/plugin-inventory.md` — Phase 1.3 status, v4 notes
- `sites/thefivestar/elementor-global-kit-spec.md` — v4-corrected,
  status=COMPLETE, verified export path
- `sites/thefivestar/the7-elementor-specificity-notes.md` — new file
- `sites/thefivestar/elementor-global-kit-v1.zip` — new artifact (5.4KB)
- `sites/mortgagepoint/site-profile.md` — full MonsterInsights audit
  writeup, opposite-of-FSI decision documented
- `docs/how-we-update-the-site.md` — v4 Elementor section rewritten
- `docs/decisions.md` — nav-wiring rule + Phase 4 split entries at top
- `brands/fsi/CLAUDE.md` — nav rule, IA split, Phase 1.3 complete note,
  specificity warning, v4 note
- `docs/next-chat-handoff.md` — this file

---

## Next phase: Phase 1.4 — LLSS Elementor build

### Pre-work (before any section is built)

**Pre-work #1 — SSH session startup**

Per `docs/sops/ssh-session-startup.md`. Start persistent shell, load
ssh-agent with `id_ed25519_itmanager`, verify WP-CLI on staging (run
`wp core download --skip-content` if the container has recycled).

**Pre-work #2 — Specificity audit on `/kit-test/`**

Before writing section specs, add each widget type we'll use in Phase 1-3
templates to `/kit-test/` (or a new `/kit-test-widgets/` scratch page):

- Heading (already on `/kit-test/` — Phase 1.3 confirmed)
- Text Editor
- Button
- Image (with explicit dimensions)
- Icon Box
- Image Box
- Inner Section / Container
- Spacer
- Divider

For each widget, inspect rendered output in Chrome DevTools. For any
property The7 overrides, catalogue the scoped override selector into
`sites/thefivestar/the7-elementor-specificity-notes.md`. Target: 30 min
to catalogue, saves hours of rework during section builds.

**Pre-work #3 — Hide The7 page-title bar on Elementor event pages**

The7 renders a navy page-title bar (slug) above the Elementor content area
by default. For the LLSS Elementor page this creates a double-hero
effect (The7 title + our Elementor hero). Per-page fix:
WP Admin → Edit Page → The7 Page Options sidebar → Page Title → Disable.
Apply to every Elementor event page as it's built.

**Pre-work #4 — Capture LLSS visual baseline**

Before building, take full-page screenshots of the current staging
WPBakery LLSS page at desktop (1440px), tablet (768px), mobile (420px).
Save to `sites/thefivestar/llss-baseline-2026-04-23/`. These are the
side-by-side comparison reference for "does it match visually?" checks.

Also: run Lighthouse against the WPBakery LLSS page under Slow 4G, save
the report. Phase 1.7 verification requires Elementor LLSS CLS < 0.1 —
we need the before-number to know whether we improved or regressed.

### Phase 1.4 runbook

**Step 1 — Write the build spec**

`sites/thefivestar/llss-elementor-build-spec.md`. Section-by-section
instructions for WP Admin (Workflow C). 8 sections from the template:

| # | Section | Image spec | Notes |
|---|---------|------------|-------|
| 1 | Hero | Background 1900×600px min-height | H1 + subhead + gold CTA. Set Page Title Disable on The7 sidebar first |
| 2 | Intro / Who Belongs | Optional side 560×400px | 2-column layout, Inner Section |
| 3 | What Happens | Icons 64×64, cards 400×300 | Feature grid |
| 4 | Next Summit callout | No images (min-height only) | Gold background section |
| 5 | Recent Summit photo strip | 3 images, 360×240 each | Loop or manual 3-column |
| 6 | Membership cards | Card images 480×220 each | 2-column feature cards |
| 7 | Event Details | Optional location 800×450 | Text + image 2-column |
| 8 | Final CTA | Background 1900×400 min-height | Full-width with overlay |

Each section spec includes: widgets used, global color bindings, explicit
dimensions for images (non-optional), CSS override selectors predicted
from pre-work #2, responsive behavior at 480/768 breakpoints.

**Step 2 — Build a new page, do NOT edit 5094**

```
WP Admin → Pages → Add New
Title: "Legal League Servicer Summit (Elementor)"
Slug: legal-league-servicer-summit-elementor  (temp — swapped in step 7)
Parent: Events (5089)
The7 Page Options → Page Title → Disable
```

Switch to Elementor.

**Step 3 — Mid-phase checkpoint (Jonathan-approved)**

Build ONLY the Hero (section 1) + Final CTA (section 8) first. Save page.
Verify:

- Matches visual target (compare against baseline screenshots from
  pre-work #4)
- Lighthouse CLS < 0.1 under Slow 4G
- Advanced Ads render if present in these slots
- No PHP errors in Site Health
- Chrome DevTools: no console errors, no CLS flashes on reload

**If checkpoint passes →** build remaining 6 sections (Intro through
Event Details).

**If checkpoint fails →** surface findings, pause, re-plan before
continuing. Possible outcomes: Elementor widget limitation discovered
(e.g. can't get 1900px hero right), template approach needs rework, or
The7 specificity issues outrun what Custom CSS can handle.

**Step 4 — Save each section as Elementor Pro template**

After all 8 sections built and section-level verified, right-click each
section in the editor → Save as Template. Naming:
`FSI Event — [Section Name]` (e.g., "FSI Event — Hero", "FSI Event —
Recent Summit Strip").

**Step 5 — Combine into master template**

Templates → Add New Template → Page. Name: "FSI Event Page". Import all
8 saved sections in order. This is the template future event pages clone.

**Step 6 — Full page verification (the gate before any production work)**

Run all 8 checks:

| # | Check | How | Pass criterion |
|---|-------|-----|----------------|
| 1 | Advanced Ads render | Visual on page | Slots show placeholders or ads |
| 2 | HubSpot forms | Submit test entry | Appears in HubSpot |
| 3 | AIOSEO meta + schema | View source | `og:title`, `og:description`, article schema populated |
| 4 | Site Kit pageview | Site Kit Realtime | Recorded |
| 5 | Responsive | DevTools device toolbar | Desktop / 768px / 480px all render correctly |
| 6 | CLS | Lighthouse Slow 4G | Score < 0.1 |
| 7 | PHP errors | `wp option get siteurl` + Site Health | No fatals; aioseo-redirects warning suppressed/known |
| 8 | Visual layout shift | Load 3× under Slow 4G | No visible jump |

Save the Lighthouse report to
`sites/thefivestar/llss-lighthouse-after-2026-04-XX.pdf`.

**Step 7 — Write the new SOP**

`docs/sops/new-event-page-elementor.md`. Required sections:
- How to clone the FSI Event Page template
- Per-section image dimension table (mandatory, not optional)
- How to update the Elementor Pro global kit + re-export zip
- The7 Page Options → Page Title → Disable (mandatory step)
- Specificity override register (what scoped CSS to use)
- Staging-first + approval gate reminder
- `-old` rename pattern

Also: mark `docs/sops/new-event-page.md` (the HTML/WPBakery SOP) with a
deprecation header pointing at the new SOP. Don't delete it — it still
backs Velocity and Events hub until Phases 2-3 ship.

**Step 8 — Rename + swap (still staging only)**

After step 6 passes:

```bash
# Rename original WPBakery LLSS
ssh thefivestarstg 'wp post update 5094 \
  --post_name=legal-league-servicer-summit-old \
  --post_title="Legal League Servicer Summit (Old WPBakery)"'

# Rename Elementor version to canonical slug
ssh thefivestarstg 'wp post update <NEW_ID> \
  --post_name=legal-league-servicer-summit'

# Flush cache
ssh thefivestarstg 'wp cache flush'
ssh thefivestarstg 'rm -rf /sites/thefivestarstg/wp-content/cache/wp-rocket/*'
```

**Step 9 — 🛑 STOP. Approval gate.**

Report: staging LLSS verified, Elementor at canonical slug, WPBakery
renamed to `-old`, CLS [score]. Ask: "Approve production?"

**Step 10 — Production (only after explicit "yes" in chat)**

LLSS does not exist on prod at singular slug — this is a create-new op,
not replace-content.

1. Import Global Kit zip on prod: Templates → Kits & Templates → Import
2. Import FSI Event Page template on prod: Templates → Import
3. Create new page on prod, slug `legal-league-servicer-summit`, apply
   template, populate with LLSS content (easiest: export staging page's
   Elementor JSON, import on prod)
4. The7 Page Options → Page Title → Disable
5. Run steps 1-8 verification against production URL
6. **DO NOT wire into nav** — per nav-wiring rule. Page publishes to a
   live URL but stays unlinked until explicit nav-wiring approval
7. WPBakery `-old` version stays staging-only

---

## Parallel work (can happen alongside Phase 1.4)

| Item | Effort | Value | Blocker? |
|------|--------|-------|----------|
| Promote 4 plugin deletions to prod (Jonathan handles manually) | Per-plugin approval gate | Low (hygiene) | None |
| MP MonsterInsights cleanup (disable Site Kit GA4) | 15 min staging + approval gate | Medium (ends double-counting) | MP staging SSH alias not in `~/.ssh/config` |
| MP Elementor Pro 3.35.1 → 4.0.3 upgrade path | 1-2hr on MP staging | Medium (unblocks Phase 7 AMAA reference) | MP staging SSH alias |
| FSI deprecation pass (~200 legacy pages) | 1-2hr once GA4 data in hand | High (trims Phase 6 scope) | Needs GA4 / Site Kit data export |
| Elementor Custom Code audit (Naylor + Apollo) | 30 min | Low | None |

**Recommended pick for this session:** the specificity audit in Pre-work #2
IS parallel-adjacent — catalogues rules for multiple widget types up
front. Most leverage per minute.

---

## Current staging-only changes

Unchanged since 2026-04-22. Do NOT promote WPBakery-era content pages to
production — Phase 1-3 Elementor rebuilds replace them.

| Change | Type | Staging | Production plan |
|--------|------|---------|-----------------|
| MonsterInsights deleted | Plugin | ✅ | Hygiene — Jonathan handles manually |
| Image Optimizer deleted | Plugin | ✅ | Hygiene — Jonathan handles |
| OptiMonster deleted | Plugin | ✅ | Hygiene — Jonathan handles |
| EventON Lite deleted | Plugin | ✅ | Hygiene — Jonathan handles |
| fsi-event-styles.php v1.1 | mu-plugin | ✅ | Hold — retires with WPBakery event pages |
| Events hub (HTML/WPBakery) | Content | ✅ | Hold — Phase 2 Elementor replaces |
| Velocity (HTML/WPBakery) | Content | ✅ | Hold — Phase 3 Elementor replaces |
| LLSS (HTML/WPBakery, 5094) | Content | ✅ | Hold — Phase 1.4 Elementor replaces |
| Nav: Events → /events/ | Menu | ✅ | Hold — Phase 2 approval required |
| Nav: Live → /events/ | Menu | ✅ | Hold — Phase 2 approval required |
| **Elementor Global Kit v1** | Site settings | ✅ | Phase 1.11 promotion via zip import |
| **/kit-test/ regression page** | Content | ✅ | **Keep staging-only permanently** |

---

## Key facts (reference)

**Portfolio standardization (2026-04-22):** Elementor + Elementor Pro
across all 3 WP sites. WPBakery maintenance-only on FSI + AMAA.

**Theme direction:** Deferred. 2026-04-23 dependency audit says bounded-
scope swap to Hello Elementor on FSI. Phase 1.3 specificity finding adds
evidence toward Hello Elementor. Revisit at Phase 4 kickoff with Phase
1-3 experience in hand.

**Environments (FSI):** Prod `thefivestar` PHP 8.2, Staging
`thefivestarstg` PHP 8.4, Dev `thefivestardev` PHP 8.4. WP-CLI works on
all three; staging requires `wp core download --skip-content` if
container recycled.

**Elementor verified versions (2026-04-23 on staging):**
Elementor 4.0.2 + Elementor Pro 4.0.2. The7 14.3.0.

**Production approval gate (verbatim from CLAUDE.md):**
Run on staging → verify → STOP → report → ask "Approve?" → wait for
explicit "yes" in chat → production. No exceptions. Blanket task
approval ≠ production approval.

**Nav-wiring rule:** New pages publish freely; new nav entries require
explicit per-entry approval. Standing exception: Phase 2 `/events/`
replaces `/conferences/` is pre-approved. No other nav changes inherit.

**Elementor Pro license:** Expert tier, 25 seats, subscription 13620718,
10 seats available after cleanup.

**The7 + Elementor CSS specificity rule:** Scope Custom CSS to Elementor
widget classes, not bare elements. See
`sites/thefivestar/the7-elementor-specificity-notes.md`.

**Elementor v4 Site Settings scope:** Global Colors + Global Fonts +
Layout + Custom CSS. No Theme Style, no Typography panel, no Buttons
panel. Kit export path: `Templates → Kits & Templates`.

---

## Open questions carried forward

1. **Theme direction (The7 vs Hello Elementor).** Audit 2026-04-23;
   Phase 1.3 adds early specificity evidence. Revisit at Phase 4 kickoff
   with Phase 1-3 experience.
2. **Visual design for event-page template.** LOCKED — reuse existing
   FSI visual language for Phase 1-3; redesign is a separate pass after
   Phase 3.
3. **MP Elementor Pro 3.x → 4.x upgrade path.** Needs proven path on MP
   staging before MP is cited as reference. Blocked on MP staging SSH
   alias.
4. **FSI deprecation pass.** Needs GA4 / Site Kit data export to identify
   ~200 legacy pages for trash vs migrate.
5. **MP staging SSH alias in `~/.ssh/config`.** Pending. Blocks all MP
   staging work.
6. **Elementor Custom Code blocks (Naylor, Apollo).** Discovered in kit
   zip 2026-04-23. Verify both integrations are current before the next
   kit re-export — if stale, delete via Elementor → Custom Code on
   staging first.
7. **Plural-slug LLSS cleanup on production.** Page 3579
   (`legal-league-servicers-summit`) is independent of Phase 1.4. Trash
   after Phase 1.11 ships; no redirect required per Jonathan (no
   meaningful traffic to fivestar.com).

---

## First question to ask Jonathan next session

Before executing pre-work: "Proceed with Phase 1.4 as outlined here, or
adjust scope?" The mid-phase checkpoint (Hero + Final CTA only, before
the remaining 6 sections) was approved this session but worth reconfirming
given the amount of document churn since.

If Jonathan confirms: start with Pre-work #1 (SSH session) → #2
(specificity widget audit) → #4 (visual baseline). Skip #3 until actual
page creation in Step 2.
