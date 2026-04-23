# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-04-23 (The7 dependency audit completed)
Last completed: The7 dependency audit on thefivestar.com production —
                CPTs, shortcodes, widgets, nav, and homepage scoped for
                eventual Hello Elementor swap cost. Findings memorialized
                in `sites/thefivestar/the7-dependency-audit.md`.
                Prior session (2026-04-22 evening): Portfolio-wide
                Elementor standardization decision + implementation order
                (LLSS → events portal → Velocity → membership/profession).

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
9. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/mortgagepoint/site-profile.md`
10. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/amaaonline/site-profile.md`
11. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/ssh-session-startup.md`

Then confirm you've read them and summarize:

- The 2026-04-22 portfolio standardization decision (what builder, what it
  supersedes, what the first migration wave is)
- Current state of thefivestar.com, amaaonline.com, themortgagepoint.com
  (theme, builder, content volume at a glance)
- The three deployment workflows (A/B/C) and when each applies
- The production approval gate rule (verbatim from CLAUDE.md)
- Current staging-only changes not yet promoted to production

Do not proceed until that summary is confirmed.

---

## Completed this session (2026-04-23)

### The7 dependency audit on thefivestar.com production ✅

Motivating question: Portfolio standardization decision (2026-04-22) defers
the theme direction ("keep The7 vs swap to Hello Elementor") as separate
later decision. Need real data on swap cost before committing to two themes
across the portfolio.

Method: SSH + WP-CLI read-only queries against production (`thefivestar`).

Findings (full detail in `sites/thefivestar/the7-dependency-audit.md`):

- **CPT data:** 17 records across 5 The7 CPTs; 3 CPTs empty; none actively
  displayed via shortcode or widget. Near-zero swap cost for this layer.
- **Shortcode consumption:** Only 3 pages reference `dt_team`; zero reference
  the other 4 The7 CPTs. Low swap cost.
- **Widgets in active areas:** 5 The7 widget instances, all simple chrome
  (3 DT-Custom menus, 1 DT-Contact form, 1 DT-Contact info). Zero The7 CPT
  widgets placed. Direct Elementor Pro equivalents exist. Low swap cost.
- **TFSI primary nav:** 7 top-level items, 3 children, max depth 2, zero
  mega-menu metadata despite the setting being enabled. Rebuilds as a
  standard Elementor Pro Nav Menu widget. Low swap cost.
- **Homepage (page 363, slug `home`):** Live WPBakery (20,290 chars of
  shortcodes), with Revolution Slider hero driven through The7's slideshow
  system and per-page The7 header/footer overrides. **Medium swap cost** —
  one meaningful rebuild.
- **Second Home page (4909, slug `home-2`, private):** Empty Elementor
  stub, 189 chars, abandoned since Feb 2026.

### Site profile slug corrections identified (not yet backported)

The7 CPT slugs in `sites/thefivestar/site-profile.md` have two errors:
- "Portfolio (slug: `project`)" — correct slug is `dt_portfolio`
- "Slideshows" — correct slug is `dt_slideshow` (singular)

Backport to site-profile.md in next session. The dependency audit doc has
the correct slugs.

### Decisions doc updated ✅

`docs/decisions.md` 2026-04-22 entry, "Open items pending Jonathan's input"
section, theme-direction item updated with a pointer to the audit doc and
a summary of findings. Decision itself stays open — audit recommends
revisiting at Phase 4 kickoff, not now.

### Files written this session

- `sites/thefivestar/the7-dependency-audit.md` (new, 218 lines)
- `docs/decisions.md` (edited — theme-direction open item)
- `docs/next-chat-handoff.md` (this file — metadata + new session block +
  Open questions update)

---

## Completed previous session (2026-04-22)

### MortgagePoint audit ✅

- Full stack audit via SSH + WP-CLI read-only queries
- Hello Elementor 3.4.6 + Elementor 4.0.1 + Elementor Pro 3.35.1
- Content: 3,351 posts, 102 pages, 41 publications, 31 podcasts, 85 people (guest-author)
- 36 Elementor Pro theme-builder templates
- 4 ad placements + 5 house ads (all cross-promoting FSI events)
- Publishing cadence ~100/month consistent since 2025
- Notable: DB prefix is `wp_lkihb5gwg6_` (non-default)
- Written to `sites/mortgagepoint/site-profile.md` (267 lines)
- Plugin inventory at `sites/mortgagepoint/plugin-inventory.md` (151 lines)

### AMAA audit ✅

- Theme: The7 14.3.1, same family as FSI
- Hybrid state: WPBakery + Elementor Pro both active (22 pages + 23 posts on Elementor)
- Content: 688 posts, 115 pages, 545 events, 178 deals, 127 tombstones, 24 podcasts
- `wild-apricot-login` for SSO (being deprecated by FSG, not a constraint)
- Full Toolset stack (Types, Views, Access, CRED, Layouts)
- 85-item main menu — IA cleanup candidate
- Written to `sites/amaaonline/site-profile.md` (247 lines)
- Plugin inventory at `sites/amaaonline/plugin-inventory.md` (181 lines)

### Portfolio standardization decision ✅

**Decision:** Elementor + Elementor Pro is the sole page builder across
thefivestar.com, amaaonline.com, and themortgagepoint.com. All new pages
built in Elementor. WPBakery in maintenance-only mode; retires as migration
completes. Written to `docs/decisions.md` 2026-04-22 entry.

**Supersedes:** 2026-04-19 "WPBakery only going forward" decision.
Original entries preserved with supersede annotations.

### Docs updated to reflect new direction ✅

Six files updated/created:

1. `docs/decisions.md` — new 2026-04-22 entry at top; 2026-04-19 and earlier
   2026-04-18 WPBakery decisions marked superseded (original text preserved)
2. `brands/fsi/CLAUDE.md` — rewrote "WPBakery is the page builder" guidance
   to reflect Elementor-forward direction; noted Classic Editor/Widgets are
   retained only while WPBakery pages exist
3. `docs/how-we-update-the-site.md` — Workflow C page-builder section rewritten;
   WPBakery chain section reframed as maintenance-only; Elementor chain section
   added; event page SOP marked transitional
4. `sites/thefivestar/wpbakery-migration.md` — new tracker for WPBakery → Elementor
   direction (replaces the superseded elementor-migration.md which was renamed
   to `.superseded-2026-04-22`)
5. `sites/thefivestar/site-profile.md` — open-issues table updated: Elementor
   "phased out" → "on-standard"; WPBakery chain update 🔴 → 🟡 maintenance-only
6. `sites/thefivestar/plugin-inventory.md` — WPBakery chain relabeled
   maintenance-only; new Elementor chain section; Elementor plugins relabeled
   from "Legacy" to "Forward builder"

### Files written this session

- `sites/mortgagepoint/site-profile.md` (new)
- `sites/mortgagepoint/plugin-inventory.md` (new)
- `sites/amaaonline/site-profile.md` (new, then amended for Wild Apricot / EventON framing)
- `sites/amaaonline/plugin-inventory.md` (new, then amended)
- `sites/thefivestar/wpbakery-migration.md` (new — replaces elementor-migration.md)

---

## Current staging-only changes

Revised stance 2026-04-22 evening: **do NOT promote the WPBakery-era content
pages to production.** We're in active development. Those pages are being
replaced by Elementor versions in Phase 1-3 below. Promoting them to
production only to replace them again is wasted work.

| Change | Type | Staging | Production plan |
|--------|------|---------|----------------|
| MonsterInsights deleted | Plugin | ✅ deleted | Hygiene — can promote anytime, not urgent |
| Image Optimizer deleted | Plugin | ✅ deleted | Hygiene — can promote anytime, not urgent |
| OptiMonster deleted | Plugin | ✅ deleted | Hygiene — can promote anytime, not urgent |
| EventON Lite deleted | Plugin | ✅ deleted | Hygiene — can promote anytime, not urgent |
| fsi-event-styles.php (v1.1) | mu-plugin (code) | ✅ deployed | **Hold** — only backs staging HTML pages; retire with those pages |
| Events hub rebuilt (HTML/WPBakery) | Content | ✅ live | **Hold** — will be replaced by Phase 2 Elementor version |
| Velocity page content (HTML/WPBakery) | Content | ✅ synced | **Hold** — will be replaced by Phase 3 Elementor version |
| LLSS page (HTML/WPBakery) | Content | ✅ live | **Hold** — will be replaced by Phase 1 Elementor version |
| Nav: Events → /events/ | Menu | ✅ updated | **Hold** — wait until Elementor /events/ is live on production |
| Nav: Live → /events/ | Menu | ✅ updated | **Hold** — same |

**Why this changed from last session's plan:**
- Development, not urgency-driven — no user is waiting for /events/
- Every HTML/WPBakery page listed will be replaced by an Elementor version
  in Phases 1-3
- Nav changes point to Elementor URLs that don't exist on production yet
- Plugin cleanups are independent of all this and can go anytime

**Preservation pattern:** When an Elementor version is verified on staging,
the original HTML/WPBakery staging page is **renamed** rather than deleted —
slug becomes `{original-slug}-old` and title gets "(Old WPBakery)" appended.
Keeps the content findable for rollback or reference. Trash after ~1-2 weeks
of production confidence on the Elementor replacement.

---

## Next session priority order (confirmed 2026-04-22)

**Top priority: convert already-built FSI pages to Elementor, then extend.**

### Phase 1 — LLSS Elementor rebuild (establish the template) 🟡

Start here. LLSS is the template source — every other event page conforms
to this pattern after.

URL: https://thefivestarstg.wpenginepowered.com/events/legal-league-servicer-summit/
Page ID: 5094

**Global rule for all Elementor work — image sizing / CLS prevention:**
Every image in every template has explicit `width` and `height` attributes
so the browser reserves space before the image loads. This prevents layout
shift (CLS) and eliminates the page-jump UX issue. Applies to: hero images,
photo strip images, card images, logos, icons, any `<img>` or Elementor
Image widget. Target dimensions are documented per section below. Elementor
Image widget must have Width and Height set (not "auto"); if using Background
Image sections, the section itself must have Min Height set in px so it
reserves space.

Subtasks:

1. **Global kit setup (staging)**
   - Populate Elementor Pro global kit with FSI brand tokens
     (Navy `#1f365c`, Gold `#c9a040`, Offwhite `#f7f7f5`)
   - Typography scale (H1/H2/H3, body, small) matching current FSI pages
   - Button presets (primary navy, secondary gold, tertiary outline)
   - Section padding presets
   - Global image defaults: enforce explicit width/height in any image
     widgets, set "Loading: Lazy" on below-fold images

2. **Build LLSS Elementor version (staging, new page — do NOT edit the
   existing WPBakery LLSS page)**
   - Create a new staging page, slug `legal-league-servicer-summit-elementor`
     (temporary slug — will swap slugs in step 7)
   - Build using Elementor against the reference LLSS WPBakery content
   - Parent: Events hub (ID 5089)

3. **Save each section as a reusable Elementor Pro template**
   All image dimensions listed are required on the image widget/section:
   - **Hero** — background image 1900×600px min-height, headline, subhead, CTA
   - **Intro / Who Belongs** — text + optional side image 560×400px
   - **What Happens** — feature grid, icons 64×64px, card images 400×300px
   - **Next Summit gold callout** — no images required; explicit min-height
   - **Recent Summit photo strip** — 3 images, 360×240px each
   - **Join the Community membership cards** — card images 480×220px each
   - **Event Details** — text + optional location image 800×450px
   - **Final CTA** — background image 1900×400px min-height

4. **Combine saved sections into one "FSI Event Page" Elementor Pro template**
   Users cloning this template get all sections pre-wired with correct
   dimensions and global kit styling.

5. **Verification on staging**
   - Advanced Ads render in expected slots
   - HubSpot forms submit (if any on page)
   - AIOSEO meta and schema populate
   - Site Kit tracks pageview
   - Responsive behavior: desktop / tablet / mobile
   - **CLS check:** Lighthouse / PageSpeed report — CLS score < 0.1
   - No PHP errors in site health
   - Load the page multiple times with slow network throttle (Chrome DevTools
     "Slow 4G") — confirm no visible layout shift

6. **Write the new SOP**
   `docs/sops/new-event-page-elementor.md` replacing plain-HTML SOP. Include:
   - How to clone the FSI Event Page template
   - Per-section image dimension requirements (mandatory, not optional)
   - How to update the Elementor Pro global kit
   - Staging-first + approval gate rules
   - `-old` rename pattern for migrating pages

7. **Rename + swap (still on staging)**
   - Rename original WPBakery LLSS: slug `legal-league-servicer-summit-old`,
     title append "(Old WPBakery)"
   - Rename Elementor version: slug `legal-league-servicer-summit`
     (takes the canonical slot)
   - Verify Elementor LLSS is at the original URL

8. **Production promotion (🔴 explicit approval per CLAUDE.md gate)**
   - Create the Elementor LLSS page on production (new page, not replacing
     anything — LLSS doesn't exist on prod yet)
   - Verify on production
   - Do NOT promote the WPBakery -old versions to production; they only
     exist on staging for safekeeping

### Phase 2 — Events portal (Events hub) 🟡

URL: https://thefivestarstg.wpenginepowered.com/events/
Page ID: 5089

Uses the global kit established in Phase 1. Event cards reuse Phase 1
hero/CTA sections where applicable. Consider an Elementor Pro Loop widget
driven by the Events parent/child page structure so new event pages
auto-appear in the hub.

Subtasks (condensed):
1. Build Elementor version on staging — new page, slug `events-elementor` (temp)
2. All images: explicit width/height — event card thumbnails 600×400px,
   any background 1900×400px min-height
3. Verify (same checks as Phase 1 step 5)
4. Rename originals: existing Events hub slug → `events-old`, title append
   "(Old WPBakery)"
5. Rename Elementor version → slug `events`
6. Promote to production with approval gate

### Phase 3 — Velocity 🟡

URL: https://thefivestarstg.wpenginepowered.com/events/velocity/
Page ID: 5088

Apply the FSI Event Page template from Phase 1. Should fit cleanly; any
structural variations become optional template sections, not divergent
patterns.

Subtasks (condensed):
1. Clone FSI Event Page template into new staging page, slug `velocity-elementor`
2. Populate with Velocity content; all images meet dimension spec from Phase 1
3. Verify
4. Rename pattern: existing `velocity` → `velocity-old`; new version → `velocity`
5. Promote with approval gate

### Phase 4 — Membership / profession pages 🟡

URL: https://thefivestarstg.wpenginepowered.com/memberships/real-estate-professionals/

Next candidate after event pages. Requires a new "FSI Membership Page"
Elementor Pro template (same reusable-section approach as Phase 1, different
sections): member benefits, eligibility, application CTA, member
testimonials, pricing tiers where applicable.

**Before starting Phase 4:** audit this page via WP-CLI (page ID, current
builder, content structure, image inventory).

Subtasks follow same pattern as Phase 1: staging build → image-sized sections
→ save template → verify (Lighthouse CLS check) → `-old` rename pattern →
approval gate → production.

### Phase 5 — Who We Are / institutional pages 🟡

URL: https://thefivestarstg.wpenginepowered.com/who-we-are/

Hub/institutional page type. May require a third template ("FSI Institutional
Page") or may be a variant of the membership template. Decide after auditing
current structure.

**Before starting Phase 5:** audit this page via WP-CLI.

Subtasks follow same pattern as Phase 1: staging build → image-sized sections
→ save template → verify → `-old` rename pattern → approval gate → production.

### Phase 6 — Remaining FSI event + membership + profession pages

Once three templates exist (Event, Membership, Institutional) and the global
kit is mature, remaining FSI page migrations are template-driven, not
template-authoring. Pace accelerates.

### Phase 7 — AMAA migration (deferred)

Per 2026-04-22 decision: AMAA follows once FSI pattern is proven through
Phases 1-6. AMAA-specific additions: deal/tombstone CPT loop templates,
EventON → ReMembers AMS integration handoff, Wild Apricot SSO retirement.

---

## Parallel work (can happen alongside Phase 1-3)

### Plugin deletions to production (🟢 Low, hygiene)

The 4 plugin deletions currently staging-only (MonsterInsights, Image Optimizer,
OptiMonster, EventON Lite) are unrelated to the builder decision and can be
promoted to production whenever convenient. All were inactive on production;
deletion is cleanup, not feature work. Not urgent.

### Audit MonsterInsights usage on MortgagePoint (🟡 Medium)

Before assuming MP should match FSI's "delete MonsterInsights" pattern, check
whether MP actually uses MonsterInsights features that Site Kit doesn't
provide — scroll depth tracking, outbound link tracking, author/category
performance reports, forms tracking. If configured and used, keeping
MonsterInsights on MP is legitimate; in that case, disable Site Kit's GA4
module on MP (keep Site Kit only for Search Console) to prevent duplicate
pageview counting. If not configured → delete like FSI did.

This is a 5-minute audit of `wp option get monsterinsights_settings` on MP
plus a visual check of the MonsterInsights dashboard configuration.

### Elementor Pro license cleanup (🟢 Low, can happen anytime)

Prune defunct activations from the 20-of-25 assigned. Candidates from
Jonathan's list: `themsea.com`, `themplaunch.com`, `themp.flywheelsites.com`,
`thefsiad.flywheelsites.com`, `localhost:10004`,
`thefivestar.wpenginepowered.com/mediakit`, potentially `fivestarforce.com`,
`propertypresforum.com`, `legalleague100.com`, `mortgagediversitycouncil.com`,
`thefivestarmedia.com`. Verify each before removing. Goal: clean to ~6-9
active seats (thefivestar + amaaonline + mortgagepoint + their staging/dev).

### FSI deprecation pass (🟡 Medium, can happen anytime)

Identify the ~200 legacy FSI pages that should be trashed rather than
migrated. Needs GA4 / Site Kit data for traffic-based filtering. Reduces
Phase 6 scope significantly.

### Elementor Pro update on MortgagePoint (🟡 Medium, before MP becomes reference)

MP is on Elementor Pro 3.35.1; the ecosystem is on 4.0.3. Needs proven
update path on a staging/dev environment before MP is cited as the reference
pattern for FSI template decisions.

### WPBakery chain update (now 🟡, was 🔴)

Downgraded under 2026-04-22 decision. Only needed if critical security
update ships before the chain retires through FSI migration. Still: write
`docs/sops/wpbakery-chain-update.md` first if it becomes unavoidable.

---

## Key facts

**Portfolio standardization decision (2026-04-22):**
- Forward builder: Elementor + Elementor Pro across all 3 WP sites
- WPBakery on FSI + AMAA: maintenance-only, retires as migration completes
- Theme direction: The7 stays on FSI and AMAA for now (Hello Elementor swap
  is a separate later decision). MortgagePoint stays on Hello Elementor.
- Elementor Pro license: Expert tier, 25 seats, subscription 13620718

**Environments (FSI):**
- Production: `thefivestar` / PHP 8.2 / WP-CLI works ✅
- Staging: `thefivestarstg` / PHP 8.4 / WP-CLI works ✅
- Dev: `thefivestardev` / PHP 8.4 / WP-CLI works ✅

**WP core on staging SSH container:** Disappears when WPE recycles the
container. Fix: `wp core download --skip-content`. Doesn't affect the live
site. Run at start of every SSH session.

**Deploy key:** `id_ed25519_itmanager` (SSH Gateway / WP-CLI)
**GitHub Actions key:** `wpengine_ed25519` → secret `WPE_SSHG_KEY_PRIVATE`

**Event pages (staging):**
- Events hub: page ID 5089, `/events/`
- Velocity: page ID 5088, `/events/velocity/`
- Legal League Servicer Summit: page ID 5094, `/events/legal-league-servicer-summit/`

**fsi-event-styles.php:** v1.1 on staging. NOT on production.
Repo: `thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php`.
Role: transitional — Elementor Pro global kit will own brand tokens after
Phase 1.

**WPBakery content pages during transition:** Do NOT use `vc_raw_html`
encoding for pages we control. Push plain HTML via `wp eval-file -`.
(Still applies to the remaining WPBakery-era staging work; after Phase 1,
Elementor replaces this pattern.)

**Production approval gate (from CLAUDE.md):**
Run on staging → verify → STOP → report → ask "Approve?" → wait → then production.
No exceptions. Blanket task approval ≠ production approval.

**Staging content loss — root cause identified:**
Not a WPE platform issue. Claude sessions starting fresh have historically
pulled production → staging to "baseline" a page, silently overwriting staging-only
work. Fix: staging is authoritative for unreleased work. Read staging state
before any write. Track page-level staging-only state in this handoff file.

**Local WP setup:** Pending separate deliverable. Will enable faster code
iteration and eliminate "SSH container recycled" delays for development work.

---

## Open questions carried forward

1. Theme direction — keep The7 on FSI and AMAA, or swap to Hello Elementor?
   Scoping audit completed 2026-04-23: `sites/thefivestar/the7-dependency-audit.md`.
   Summary: swap is bounded-scope (low cost on CPTs / shortcodes / widgets /
   nav; medium cost on homepage rebuild). Not a blocker for Phase 1-3.
   Audit recommendation: revisit at Phase 4 kickoff with real migration
   experience to inform the call.
2. Design direction for the Phase 1 Elementor event-page template — reuse
   existing FSI visual language or introduce redesign concurrent with builder
   migration? (Recommend: reuse existing tokens to de-risk Phase 1; visual
   redesign is a separate pass)
3. Elementor Pro 3.x → 4.x upgrade path on MortgagePoint — needs proven path
   before MP is promoted as reference
4. FSI deprecation pass — which pages truly dead? Needs GA4 / Site Kit data
