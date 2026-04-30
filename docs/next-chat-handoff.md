# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-04-30 EVENING (Foundation work F1-F3 ALL DONE on
              prod. Wave 1 Phase .11 promotions are now unblocked.

              ⚠️ INCIDENT + RECOVERY: F1 first attempt deleted WP
              core from prod (rsync --delete reached install root
              because SRC_PATH defaulted to repo root). Recovered in
              ~3 min via `wp core download --skip-content --force`.
              Workflow fixed in thefivestar-wp commit e9db426
              (SRC_PATH=wp-content/, REMOTE_PATH=wp-content/, plus
              path corrections in .deployignore). F1 retry succeeded
              cleanly. F3 then promoted staging kit to prod (4
              of 5 sample pages had ZERO byte HTML diff vs pre-state;
              the 1 with diff was the deprecation candidate Velocity
              4436 page, expected). See decisions.md 2026-04-30 entry
              for full incident detail.

              ALSO ON STAGING (cycle continues): Phase 3 Velocity
              TEMPLATE A REVISION applied 2026-04-30 PM. Three
              template-level changes supersede the 2026-04-26 Option B
              Conversion Hero pattern: (1) image-only hero (no overlay,
              no overlay text, sr-only H1 only); (2) 3-col
              WHEN/REGISTER/WHERE info bar in offwhite below the hero;
              (3) 20/20 padding cap on every body section (40px
              combined gaps everywhere). Velocity hero image populated
              (staging attachment 5143, prod attachment 5099). Five
              Star Alliance card image populated (staging 5144, prod
              5100). Section 2 intro now anchored by H2 "Two days. One
              community."
              SAME REVISION MUST PROPAGATE TO LLSS before Phase 1.11
              prod promotion so prod ships consistent FSI Event Page
              pattern.
              ALL THREE FSI HUBS Elementor-native: Events ✅ Memberships ✅
              (redesigned, hero copy revised) Communities ✅ (Template C
              alignment applied). NOW READY FOR PRODUCTION PROMOTION
              SEQUENCING — see "Production promotion plan" block below.
              CLEANUP FLAGGED:
              - LLSS Template A revision (apply Velocity 2026-04-30
                pattern to LLSS before Phase 1.11)
              - 3 image slots remaining on Velocity (Section 2
                community photo + FORCE card re-register +
                Section 8 Final CTA bg)
              - Footer "Membership Groups" widget link drift to
                /memberships-old/
              - Pre-existing em-dash violations in 3 specialty card
                subtitles + 5 image alt-text strings + 3 CSS comments
                in fsi-event-styles.php)
Last completed: Foundation F3 (kit promotion) shipped on prod
                2026-04-30 18:43. Backup at meta key
                `_elementor_page_settings_backup_2026_04_30_184340` on
                kit 4004. Kit now has 17 custom_colors (10 legacy
                preserved + 7 fsi*), system_colors at FSI brand,
                custom_css with heading scoping. F1 (mu-plugin) was
                done at 18:08 after the incident-and-fix cycle. F2
                (11 media uploads) done by Jonathan via WP Admin.
                F4 (Elementor version drift): accepted (4.0.3 prod /
                4.0.2 staging — schema-compatible).
Next phase: Wave 1 Phase .11 production promotions. Foundation work
                complete. Per Jonathan's reordering: Velocity 3.11 →
                Memberships 4a-hub.11 → Communities 4b-hub.11 → Events
                2.11 → RE Pros 4b.11. LLSS Template A revision + Phase
                1.11 LLSS in Wave 2 (later session).
                Wave 1 Step 1 (Velocity 3.11) is the next gate: requires
                attachment ID remap (staging IDs → prod IDs) before
                pushing the section payload to prod page-create. Runbook
                at docs/sops/fsi-production-promotion.md "Wave 1, Step 1"
                section has the full plan + executable commands.
                IMPORTANT pre-Wave-1-Step-2 cleanup: 2 Memberships hub
                logo assets (FORCE_COLOR + LL_COLOR) on prod have
                `-scaled-1` filename suffixes from upload name conflict.
                Section JSONs reference the un-suffixed paths (will
                404). Resolve before Wave 1 Step 2: either re-upload
                without conflict OR URL-rewrite at deploy time.
                Background tracks: Phase 4a individual Membership pages
                (7 greenfield, FORCE first), Phase 4b community siblings
                (3 greenfield), em-dash cleanup, footer widget link fix.

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
14. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/elementor-json-authoring.md`
14a. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/fsi-production-promotion.md` (the prod-promotion runbook — read in full before any Phase .11 work)

15. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/llss-elementor-build-spec.md` (look at top "Updated 2026-04-26: Option B pattern" block first)
16. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/llss-wpbakery-content.html` (authoritative copy reference)
17. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-templates/event-pages/legal-league-servicer-summit/` (the 9 section JSON files — quick scan)

Then confirm you've read them and summarize:

- The 2026-04-26 Option B decision (Elementor structural containers + HTML
  widgets for content sections) — what it solved, why we pivoted, the
  performance numbers
- Where each of the 9 LLSS sections lives in `elementor-templates/event-pages/legal-league-servicer-summit/`
  and which are widget tree (1, 8, 9) vs HTML widget (2-7)
- The image-swap workflow for HTML widget content (placeholder div →
  `<img>` tag inside the JSON's `html` setting)
- **The next-step plan: Phase 3 Velocity build** using the Option B
  template proven for LLSS (page 5088 → new Elementor page → Option B
  HTML widget pattern → slug swap). Directory naming question to ask
  Jonathan first.
- LLSS image shotlist (8 slots) — what Jonathan needs to gather and
  paste URLs for in parallel
- Verification artifacts: `visual-baselines/llss-elementor-optionB-2026-04-26-{1440,768,420}.png`
  + the WPBakery side-by-side baselines
- The 2026-04-25 AI-first Elementor authoring decision (C1/C2 split, version pin)
- The 2026-04-26 v4 + The7 button/overlay binding gotcha + workaround (hardcode
  hex on buttons + overlays only)
- Custom-color slot ID renumber (legacy IDs preserved for prod page back-compat,
  brand colors live at `fsi*` IDs)
- Production approval gate rule (verbatim from `CLAUDE.md`)
- Nav-wiring rule and the one standing exception
- Phase 4 IA split (two templates: Memberships + Communities, both at root)
- Current staging state (canonical LLSS = Elementor 5106, `-old` = WPBakery 5094)
- What's pending before Phase 1.11 (image content + Lighthouse before-number)
- **The 2026-04-28 PM Memberships hub redesign** (literal-foundation
  hierarchy: Alliance moved BELOW the 6-tile specialty grid as a
  foundation strip; v4 umbrella band and v5 featured tile both rejected
  before landing on the foundation strip) — see decisions.md.
- **The 2026-04-29 AM Memberships hub hero copy revision**: H1 "The
  seven memberships that move this industry forward." + sub naming
  all 7 memberships inline. Saved em-dash rule to user-memory.
- **The 2026-04-29 PM Communities hub Template C alignment**: hero serif
  overrides dropped (inherits The7 default Open Sans Condensed UPPERCASE);
  FSC convergence section bg navy → offwhite (single-navy-band rule).
- **The 2026-04-30 PM Velocity Template A revision** (the big template-
  level change): image-only hero with no overlay + 3-col info bar
  (WHEN | REGISTER | WHERE) below hero + 20/20 padding cap on every body
  section. Same revision MUST propagate to LLSS before Phase 1.11. See
  decisions.md top entry. SOP lessons #25-30 capture the workflow
  details (compose-from-disk discipline, file naming, propagation plan,
  sr-only H1 pattern, padding cap, cumulative-gap audit).
- **The current production promotion plan** in next-chat-handoff.md
  ("Production promotion plan" block) AND the detailed runbook at
  `docs/sops/fsi-production-promotion.md` (executable step-by-step,
  including F1-F4 foundation work, Wave 1 phase .11 operations with
  exact commands + pre-flight + verification + rollback for each).
  Wave 1 order (per Jonathan 2026-04-30): Velocity 3.11 → Memberships
  4a-hub.11 → Communities 4b-hub.11 → Events 2.11 → RE Pros 4b.11.
  LLSS Template A revision + Phase 1.11 LLSS pushed to Wave 2 (later
  session). Memberships hub uses create-new + slug-swap pattern (renames
  prod 2597 to memberships-old) per Jonathan's direction.
- **Prod pre-flight findings (2026-04-30):** 11 media assets ALL
  MISSING on prod, fsi-event-styles.php mu-plugin NOT PRESENT on prod,
  prod kit (4004) is 5+ months stale vs staging, Elementor versions
  drift slight (prod 4.0.3/4.0.2 vs staging 4.0.2/4.0.2 — accept).
  Resolved prod page IDs match staging IDs for the most part (Events
  5089, Velocity 5088, Memberships 2597, RE Pros 5087); /communities/
  doesn't exist on prod yet. See `docs/sops/fsi-production-promotion.md`
  pre-flight section for the full table.

Then read the Memberships hub JSON files to understand the current state:
- `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-templates/membership-pages/_hub/01-alliance-hero.json` (filename retained but content is now "seven memberships" hero, not Alliance-focused)
- `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-templates/membership-pages/_hub/03-specialty-grid.json` (6 tiles, no Alliance)
- `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-templates/membership-pages/_hub/04-alliance-foundation.json` (the new foundation strip)
- `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-templates/membership-pages/_hub/05-footer-line.json`

And the Communities hub JSON files for the next focus:
- `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-templates/community-pages/_hub/` (6 sections — hero / grid intro / 2x2 communities grid / FSC convergence / Memberships CTA / footer-line)

**Next-step plan:**

1. **Complete Memberships hub.** Live on staging at
   `https://thefivestarstg.wpenginepowered.com/memberships/`. Ask Jonathan
   to do a visual review pass; address any remaining polish items;
   then propose Phase 4a-hub.11 production promotion (separate approval
   gate). Produce reversible production push plan first.
2. **Move on to Communities hub.** Live on staging at
   `https://thefivestarstg.wpenginepowered.com/communities/`. Ask
   Jonathan: does the 2026-04-28 Memberships hub literal-foundation
   pattern (Alliance below the grid as "underneath every specialty
   above") suggest a parallel revision for Communities, or is its
   current 6-section layout (hero / grid intro / 2x2 community grid /
   FSC convergence / Memberships CTA / footer-line) correct as-is?
   The pattern transferable from Memberships hub: **spatial layout as
   communication** — when an org relationship is "X underneath Y," put
   X physically below Y. Communities hub doesn't currently have an
   obvious "X underneath Y" relationship to express, so the answer
   may be "current layout stands." Confirm with Jonathan, then either
   iterate or move directly to Phase 4b-hub.11 production promotion.

Do not proceed until that summary is confirmed.

---

## Production promotion plan (current as of 2026-04-30 PM)

**The non-negotiable rule (verbatim from `CLAUDE.md`):** Never run any
operation on production without explicit per-stage approval from
Jonathan. Blanket session approval ≠ production approval. Approval to
run on staging ≠ production approval. Steps 5+6 of the gate (ask in
chat, wait for explicit "yes") have no exceptions.

### Pre-flight before any prod push (every Phase .11)

1. **Verify the kit is on prod.** `wp post get <kit_id> --field=post_modified`
   on prod vs staging. If prod kit is stale, promote kit FIRST.
2. **Verify mu-plugin `fsi-event-styles.php` is on prod.** The deployed
   pages use its CSS classes. Without it, sections render unstyled.
   Promote via Workflow A (`thefivestar-wp` repo → GitHub Actions).
3. **Verify all referenced media assets exist on prod** as proper
   attachment records (file on disk + `wp_posts` row + responsive
   variants). Use `wp post list --post_type=attachment --s=<slug>`
   on prod for each asset referenced in section JSONs. Re-upload via
   Media > Add New if missing.
4. **Verify all 7 logos in prod media library** (Alliance, FORCE,
   Legal League, NMSA, MSEA, PPEF, AMDC) for Memberships hub promotion.
5. **Capture pre-state baseline** at 1440/768/420 of the prod URL being
   replaced (rollback reference).

### Suggested promotion order (each gate independent)

| # | Phase | Page(s) | Pattern | Pre-reqs |
|---|-------|---------|---------|----------|
| 0 | LLSS Template A revision | LLSS staging (page 5106) | Apply Velocity 2026-04-30 changes (image-only hero + 3-col info bar + 20/20 padding). Pre-Phase-1.11 work. | LLSS hero image, LLSS info-bar copy decisions |
| 1 | **1.11 LLSS** | prod LLSS (create-new) | Create-new + slug-swap. Same pipeline as staging. 8 image slots populated first. | Kit on prod, mu-plugin on prod, all images registered, Template A revision applied to staging-5106 |
| 2 | **3.11 Velocity** | prod Velocity (create-new) | Create-new + slug-swap. Same pipeline. 3 image slots populated first (Section 2 community + FORCE re-register + Section 8 final CTA bg). | Kit on prod, mu-plugin on prod, all images registered, LLSS already shipped (consistency) |
| 3 | **4a-hub.11 Memberships hub** | prod Memberships (in-place swap on existing parent OR create-new) | Decide based on prod parent's child pages: if any children exist, in-place swap (Lesson #24); else create-new + slug-swap. | All 7 logos on prod, em-dash cleanup, kit on prod |
| 4 | **4b-hub.11 Communities hub** | prod Communities (create new parent + content) OR in-place swap if parent exists | Likely create-new since `/communities/` likely doesn't exist on prod. Then in-place swap on the new parent for the hub Elementor data. | RE Pros 4b.11 should ship in same window so /communities/ tree is coherent |
| 5 | **2.11 Events hub** | prod /events/ (in-place swap) | In-place swap on prod page 5089 (or whatever prod ID is). Backup post_content + _elementor_data + edit_mode to timestamped meta keys. Verify all 4 child URLs HTTP 200 post-swap. | LLSS + Velocity already shipped (children will be Elementor-native by then) |
| 6 | **4b.11 RE Pros** | prod RE Pros (relocate from /memberships/ to /communities/) | Create `/communities/` parent on prod, create RE Pros Elementor at canonical, slug + parent swap of existing prod RE Pros (if exists), 301 redirect via eps-301-redirects. | /communities/ parent created |

### Per-promotion runbook template

For each Phase .11:

1. State operation + risk level (most are 🟡 Medium; in-place swaps on
   pages with children are 🔴 High)
2. Run pre-flight checks above
3. Execute on prod via the same `wp eval-file -` + `update_post_meta`
   pipeline used on staging
4. Backup prior state to `_elementor_data_backup_*` (or
   `_elementor_inplace_swap_backup_*` for in-place swaps) timestamped
   meta keys
5. Cache flush sequence (Lesson #16): Elementor `flush_css` +
   `wp cache flush` + `rm -rf wp-rocket/*` + `WpeCommon::purge_varnish_cache_all()`
   + `WpeCommon::purge_memcached()`
6. Verify on prod: cache-busted curl + bare URL + child URL preservation
   (for in-place swaps) + Playwright screenshot at 1440
7. Report results back to Jonathan
8. Trash `-old` rollback pages on prod ~1-2 weeks post-promotion if no
   regressions surface

### Open question on prod parent IDs

Most prod pages don't have IDs that match staging (staging used
new-page IDs like 5106, 5107, 5138 created during the migration; prod
either has no equivalent or has different historical IDs). Pre-flight
SQL on prod:

```bash
ssh thefivestar 'wp post list --post_type=page \
  --fields=ID,post_title,post_status,post_name \
  --posts_per_page=200 --format=csv'
```

Resolves prod IDs for: events hub, memberships hub, communities hub
(if exists), RE Pros (if exists), LLSS (if exists), Velocity (if
exists). Drives whether each Phase .11 is create-new or in-place swap.

---

## Completed this session (2026-04-30 PM) — Phase 3 Velocity Template A revision + image content

### Changes deployed to page 5107 (`/events/velocity/`)

**Three template-level changes (decisions.md 2026-04-30 PM entry):**

1. **Image-only hero.** Save-the-Date sub-card removed entirely (date+location, tagline, in-hero Register CTA all gone). Navy overlay removed (was 0.85, then 0.5, now none). Visible H1 removed; sr-only H1 retained for SEO. Section 1 padding 0/0.
2. **3-col info bar (Section 1b NEW).** Below the hero, offwhite `#F7F7F5` strip with WHEN | REGISTER | WHERE cells. Center column houses gold Register CTA. New file `01b-info-bar.json`. Inline `<style>` block for grid + mobile stacking.
3. **20/20 padding cap.** Every body section standardized to 20px top + 20px bottom. Combined inter-section gaps = 40px everywhere (except hero → info bar = 20px, intentional).

**Image content populated:**

| Slot | Asset | ID | Status |
|------|-------|-----|--------|
| Hero bg | Velocity_Conference_2026_Hero_1900-x-600.jpg | 5143 | ✅ properly registered |
| FS Alliance card | FSAlliance_Logo_480-x-220.jpg | 5144 | ✅ properly registered |

**Section 2 H2 added:** "Two days. One community." anchors the intro section. Uses the existing `.fsi-section-heading` class (no eyebrow, matches "Who Belongs at Velocity" / "What Happens at Velocity" pattern downstream).

### SOP lessons added (elementor-json-authoring.md #25-30)

| # | Lesson |
|---|--------|
| 25 | Compose-from-disk is canonical; compose-from-DB-and-patch is a deviation. Always glob section files from disk + diff against deployed before push. |
| 26 | New-section file naming + glob update (e.g., `01b-` for inserted section + glob change to `[0-9]*.json`). |
| 27 | Template-level changes need explicit propagation plans (Velocity Template A revision must reach LLSS before Phase 1.11). |
| 28 | Image-only hero with sr-only H1 (SEO + a11y intact, no visual overlay text). |
| 29 | 20/20 padding cap rule for FSI event pages (40px combined gaps). |
| 30 | Cumulative-gap audit before claiming "consistent rhythm" (per-section padding alone is misleading). |

### Documentation updated this session

| File | Change |
|------|--------|
| `docs/decisions.md` | NEW top entries: 2026-04-30 PM Velocity Template A revision; 2026-04-30 image content + Media Library workflow; 2026-04-29 PM Communities hub Template C alignment; 2026-04-29 AM Memberships hub hero copy revision |
| `docs/sops/elementor-json-authoring.md` | Lessons #25-30 added |
| `sites/thefivestar/site-profile.md` | Velocity row updated (Template A revision); LLSS row tagged with pending revision; Communities hub row updated (Template C alignment) |
| `sites/thefivestar/elementor-templates/event-pages/velocity/01-hero.json` | Save-the-Date sub-card removed; padding 100/100 → 0/0; overlay removed; sr-only H1 added |
| `sites/thefivestar/elementor-templates/event-pages/velocity/01b-info-bar.json` | NEW (renamed from `01b-register-cta.json`); 3-col WHEN/REGISTER/WHERE info bar |
| `sites/thefivestar/elementor-templates/event-pages/velocity/02-intro-who-belongs.json` | Padding 60/60 → 20/20; H2 "Two days. One community." added |
| `sites/thefivestar/elementor-templates/event-pages/velocity/03-what-happens.json` | Padding 60/60 → 20/20 |
| `sites/thefivestar/elementor-templates/event-pages/velocity/06-membership-cards.json` | Padding 60/60 → 20/20; Alliance card image populated (5144); FORCE LogoForce1.jpg orphan-asset status flagged |
| `sites/thefivestar/elementor-templates/event-pages/velocity/07-event-details.json` | Padding 20/60 (asymmetric) → 20/20 |
| `sites/thefivestar/elementor-templates/event-pages/velocity/08-final-cta.json` | Padding 80/80 → 20/20 |

### 🛑 Awaiting decision: which path next session?

Two options for next session, in priority order:

1. **LLSS Template A revision (pre-Phase-1.11 work).** Apply the Velocity 2026-04-30 pattern to LLSS (page 5106): strip Save-the-Date sub-card from hero, drop overlay, add sr-only H1, add new `01b-info-bar.json` with WHEN | REGISTER | WHERE columns and LLSS-specific URL/copy, standardize all sections to 20/20 padding cap, add intro section H2. ~45-60 min. Unblocks Phase 1.11 LLSS production promotion.
2. **Phase 1.11 LLSS production promotion (gate).** Produce reversible-plan + pre-flight checklist for prod push. Requires (1) above to be complete, plus 8 LLSS image slots populated, plus Jonathan approval. Production promotion gate is independent per the rule.

Recommended order: option 1 first (template parity), option 2 follows.

---

## Completed prior session (2026-04-28 PM) — Memberships hub redesign (literal-foundation hierarchy)

### Phase 4a-hub redesign ✅ — Alliance moved from hero to foundation strip below specialty grid

The Memberships hub built 2026-04-27 (Alliance featured as hero +
6-card 2x3 specialty grid below) was redesigned in place on page 5138.
The previous layout had Alliance "above" the specialties, which read
as "Alliance is the headline membership" — not the intended "Alliance
is the universal foundation under all of them." The redesign uses
spatial layout as the carrier of organizational hierarchy: 6 specialties
sit on top as standing structures, Alliance sits underneath as the
foundation strip.

**Iteration sequence (3 attempts before final):**

| Time | Layout | Outcome |
|------|--------|---------|
| 5:15p (v4) | Alliance umbrella band between hero and specialty grid | Rejected — two stacked navy bands; Alliance still read as "above" specialties |
| 5:42p (v5) | Alliance integrated as 3-col-spanning featured tile inside specialty grid | Rejected — Alliance dominated the grid visually; conflated "specialty" with "foundational" |
| **6:03p (final)** | Alliance as dedicated foundation strip BELOW the 6-tile grid + "underneath every specialty above" copy | Adopted — spatial layout communicates the relationship without explanation |

**Final structure on page 5138 (4 sections, ~14.5 KB `_elementor_data`):**

| # | Section | Bg | Notes |
|---|---------|-----|-------|
| 01 | Hero | Navy | "PROFESSIONAL MEMBERSHIPS" eyebrow / "The seven memberships that organize this work" H1 / practitioner-focused description naming Alliance as "universal foundation underneath them all" |
| 02/03 | Specialty grid | Offwhite | 6 tiles in 3-column CSS grid (FORCE / Legal League / NMSA / MSEA / PPEF / AMDC). NO Alliance tile. |
| 04 | Alliance foundation strip | Offwhite | Gold "The Foundation" eyebrow / Alliance logo / "underneath every specialty above" copy / contact CTA. White card on offwhite + gold top accent (matches specialty tiles for cohesion; placement establishes foundation relationship). |
| 05 | Footer-line | White | Standard pattern |

**Color rhythm:** Navy → Offwhite → Offwhite → White. Single navy
band (hero only) — addresses the prior "navy dominance" critique that
drove v4/v5.

**Removed in this session:**

- Old Section 02 navy Alliance umbrella band (the v4 attempt)
- Alliance featured tile from specialty grid (the v5 attempt)
- Old Section 04 "Not sure where you fit?" CTA (mockup-era; conflated funnel steps)
- Redundant secondary "Memberships" heading

**Copy fix:** PPEF description corrected from "standards body" to
"membership organization" (factual error inherited from the mockup).

**Section JSON file updates (in place on `membership-pages/_hub/`):**

| File | Status |
|------|--------|
| `01-alliance-hero.json` | Updated 17:51 — filename retained but content is now "seven memberships" hero, not Alliance-focused |
| `03-specialty-grid.json` | Updated 17:52 — 6 tiles, no Alliance |
| `04-alliance-foundation.json` | NEW 17:55 — Alliance foundation strip |
| `05-footer-line.json` | Unchanged |
| `02-communities-intro.json` | REMOVED |
| `04-not-sure-cta.json` (or equivalent) | REMOVED |

**Deployment:** Composed 4 section files into single Elementor data,
backed up prior content with timestamp to `_elementor_data_backup_*`
meta, pushed via `wp eval-file` pipeline, full cache flush
(Elementor + Varnish + memcached + WP core + WP Rocket). All 10
verification criteria passed including: new "seven memberships"
hero heading, Alliance foundation strip with "The Foundation"
eyebrow + "underneath every specialty above" messaging, all 6
specialty tiles present, removal of old "Memberships" heading +
old "Not sure" CTA, single navy band.

### Documentation updated this session

| File | Change |
|------|--------|
| `docs/decisions.md` | NEW top entry "2026-04-28 PM — Phase 4a-hub redesign: Memberships hub literal-foundation hierarchy" |
| `sites/thefivestar/site-profile.md` | Memberships hub row updated (4 sections; "seven memberships" hero; Alliance foundation strip below grid; PPEF fix; single navy band) |
| `sites/thefivestar/wpbakery-migration.md` | Memberships staging-state block rewritten for new 4-section hierarchy |
| `docs/next-chat-handoff.md` | Header dates + completed/next-phase summary; this session block added; prompt summary bullets and immediate-next-steps plan updated |
| `sites/thefivestar/elementor-templates/membership-pages/_hub/04-alliance-foundation.json` | NEW Alliance foundation strip JSON (3,228 B) |
| `sites/thefivestar/elementor-templates/membership-pages/_hub/01-alliance-hero.json` | Updated content (hero rewrite) |
| `sites/thefivestar/elementor-templates/membership-pages/_hub/03-specialty-grid.json` | Updated content (Alliance tile removal) |

### 🛑 Awaiting decision: which path next session?

Per Jonathan's directive at end of session — immediate steps are
(1) complete Memberships hub, then (2) move on to Communities hub.

1. **Complete Memberships hub.** Live on staging since 2026-04-28 18:03.
   Visual review by Jonathan; address any remaining polish; then
   propose Phase 4a-hub.11 production promotion (reversible plan
   first, separate approval).
2. **Move on to Communities hub.** Live on staging since 2026-04-28
   (revised after Jonathan's flow correction). Ask whether the
   literal-foundation pattern from Memberships transfers. Communities
   hub doesn't have an obvious "X underneath Y" relationship to
   express, so current 6-section layout may already stand. Confirm,
   then either iterate or move to Phase 4b-hub.11 production promotion.
3. Background tracks (any session): Phase 4a individual Membership
   pages (7 greenfield, FORCE first), Phase 4b community siblings
   (3 greenfield), LLSS + Velocity image population, footer
   "Membership Groups" widget link cleanup.

---

## Completed prior session (2026-04-27 PM) — Phase 4b RE Professionals + IA correction

### Phase 4b first-instance build ✅ — FSI Community Page template established

The existing RE Pros mockup (page 5087) was Elementor-rebuilt and relocated from
`/memberships/real-estate-professionals/` to the canonical
`/communities/real-estate-professionals/` URL. This was the first build of the
**FSI Community Page template** (third of three FSI templates — alongside FSI
Event Page proven by LLSS+Velocity, and FSI Membership Page still pending Phase 4a).

**Key operations:**

| Step | Result |
|------|--------|
| Create `/communities/` parent | Page 5108 (root-level, status publish, _dt_header_title=disabled, stub content) |
| Capture WPBakery RE Pros baseline | 1440/768/420 saved at `visual-baselines/re-pro-wpbakery-2026-04-27-{vp}.png` |
| Author 8 section JSON files | `community-pages/real-estate-professionals/` with `repro-*` element IDs |
| Path A vs Path B | **Path A chosen** (inline styles, Velocity precedent) — class extraction deferred until 2nd community page |
| Create new Elementor page | Page 5109 under /communities/ parent |
| Compose + push | 20,019 B `_elementor_data`, 8 sections, 16 `.elementor-element` count (lighter than LLSS/Velocity — no widget-tree hero) |
| Visual verify | 1440/768/420 saved at `visual-baselines/re-pro-elementor-2026-04-27-{vp}.png`; structural audit 8/8 sections + H1 navy + callouts present |
| Slug + parent swap | 5087 → `/communities/real-estate-professionals-old/` "(Old WPBakery)"; 5109 → `/communities/real-estate-professionals/` canonical |
| 301 redirect | `eps-301-redirects` plugin: `memberships/real-estate-professionals` → post 5109; verified via bare-URL curl (HTTP 301 → 200) |
| Velocity cross-link updates | 3 places (`04-charter-offer.json`, `06-membership-cards.json`, `09-footer-line.json`) updated from `/memberships/...` to `/communities/...`; recomposed + pushed Velocity page 5107; rendered HTML verified |

**FSI Community Page template — characteristics distinct from Event Page:**

| Section | Approach |
|---------|----------|
| 01 Header (centered text + gold border-bottom, NO bg image) | HTML widget |
| 02 Intro (max-width 820px) | HTML widget |
| 03 Your Path — 3 pricing tier cards (Free/Alliance $495/FORCE $1,495) | HTML widget — **center of gravity, dominant visual** |
| 04 Founding Institutional Partner (gold left-border on cream) | HTML widget — eligibility-gated free tier |
| 05 Charter Member Rate (gold-fill callout, Velocity-2026 only) | HTML widget |
| 06 Events for RE Professionals (2-card grid: Velocity + FSC) | HTML widget |
| 07 Governance (Offwhite callout, Advisory Council model) | HTML widget — Community-distinctive |
| 08 Footer-line | HTML widget |

**Quantitative outcomes (vs prior templates):**

| Metric | LLSS (Event) | Velocity (Event) | RE Pros (Community) |
|--------|--------------|-------------------|---------------------|
| Sections | 9 | 8 | 8 |
| `_elementor_data` size | 22,032 B | 18,178 B | 20,019 B |
| Total widgets | 15 | 13 | 8 |
| Total `.elementor-element` count | 27 | 24 | 16 |
| Widget-tree sections | 3 (1, 8, 9) | 3 (1, 8, 9) | 0 (all HTML widget) |

**EPS-301 redirect plugin gotcha (logged as SOP Lesson #20):** The plugin
matches the FULL request URI including query string. A cache-buster like
`?cb=12345` BREAKS the match (returns 404). Real users hitting bare URLs
get the proper 301. When testing post-insert, use bare URL curl, not
query-string-augmented URL.

### Documentation updates this session (PM)

| File | Change |
|------|--------|
| `docs/decisions.md` | NEW top entries: Phase 4b RE Pros at canonical staging slug; IA clarification (3 hierarchies, 3 templates) |
| `brands/fsi/CLAUDE.md` | "IA structure" section restructured to 3-hierarchy table; Memberships-vs-Communities distinction |
| `sites/thefivestar/wpbakery-migration.md` | Migration tracker reframed as 3 hierarchies; Communities section populated with RE Pros details |
| `sites/thefivestar/site-profile.md` | Open issues row updated for Phase 4b completion + Phase 4a/4b siblings |
| `docs/sops/elementor-json-authoring.md` | Lessons #20-21 added (eps-301 query string gotcha, slug-prefix convention) |
| `sites/thefivestar/elementor-templates/community-pages/real-estate-professionals/` | NEW: 8 section JSON files |
| `sites/thefivestar/real-estate-professionals-wpbakery-content.html` | NEW: WPBakery source-of-truth copy reference |
| `sites/thefivestar/visual-baselines/` | NEW: 6 baselines (re-pro-wpbakery + re-pro-elementor at 1440/768/420) |
| `sites/thefivestar/elementor-templates/event-pages/velocity/{04-charter-offer,06-membership-cards,09-footer-line}.json` | URL updates: `/memberships/...` → `/communities/...` |

### 🛑 Awaiting decision: which path next session?

Phase 4b first-instance proven. Three options:

1. **Phase 4a — FSI Membership Page template (greenfield).** Author the
   Membership template by building one of FORCE / Legal League / AMDC / PPEF
   / NMSA / MSEA / Five Star Alliance. Visually distinct from Community
   template (already-shipped RE Pros is the contrast benchmark). FORCE is
   the natural first-instance — credentialed + 15-year-established + the
   most-referenced membership in existing Velocity + RE Pros copy. ~120-180
   min including Membership template design pass.
2. **Phase 4b 2nd instance — Mortgage Finance / Legal / Prop Pres community
   pages.** Concretizes the recurring CSS patterns and triggers Path B
   class extraction (`fsi-shared-styles.php` rename + tier-card classes).
   ~60-90 min per page once the pattern is set.
3. **Image content for LLSS + Velocity, in parallel.** Unblocks Phase 1.11
   + Phase 3.11 production promotion gates. ~30 min per event once URLs
   are pasted in chat.
4. **Production promotion** of any of: LLSS (Phase 1.11), Velocity (Phase
   3.11), RE Pros (Phase 4b.11). Each is independent and requires explicit
   Jonathan approval.

**Recommended sequencing:** option 1 (Phase 4a kickoff with FORCE) — gets
the third template proven, completes the IA picture, and naturally
triggers the Path B CSS-class extraction since FORCE is the
most-referenced membership and the cleanest first-instance.

---

## Completed this session (2026-04-27 AM) — Phase 3 Velocity

### Phase 3 Velocity Elementor build ✅ — second event page proves the Option B template clones cleanly

LLSS established the FSI Event Page template via Option B (Elementor
structural containers + HTML widgets containing `fsi-page-wrap` markup).
This session, Velocity (page 5088) was rebuilt as a clone of that
template. Pattern works.

**Velocity build summary:**

| Step | Result |
|------|--------|
| Pull WPBakery source | `velocity-wpbakery-content.html` saved (8,631 B inline-styled HTML) |
| WPBakery baselines | 1440 / 768 / 420 captured at `visual-baselines/velocity-wpbakery-2026-04-27-{vp}.png` |
| Section JSON authoring | 8 files in `elementor-templates/event-pages/velocity/` (01,02,03,04,06,07,08,09) — Section 05 photo strip skipped |
| Element ID convention | `velocity-*` prefix (e.g., `velocity-hero-section`) — collision-safe if exported as saved templates |
| Page creation on staging | `wp post create` page 5107 slug `velocity-elementor`, parent 5089, `_dt_header_title='disabled'`, all Elementor v4.0.2 meta keys |
| Compose + push pipeline | Same as LLSS — Python compose script strips authoring-only keys, base64-pushed via `wp eval-file -`, `update_post_meta(_elementor_data, wp_slash($json))`, backup at `_elementor_data_backup_*` meta key, Elementor `files_manager->clear_cache()` |
| Cache flush | `wp cache flush`, `rm -rf wp-rocket/*`, `WpeCommon::purge_varnish_cache_all()`, `WpeCommon::purge_memcached()` |
| Visual verify | 1440 / 768 / 420 Elementor baselines saved at `visual-baselines/velocity-elementor-2026-04-27-{vp}.png` |
| Structural audit | 12/12 pass via Playwright `getComputedStyle` |
| Slug swap | 5088 → `velocity-old` "(Old WPBakery)", 5107 → `velocity` canonical, verified post-cache-purge with cache-bust query string |

**Section-by-section mapping (LLSS → Velocity):**

| File | Approach | Velocity-specific deviation |
|------|----------|------------------------------|
| 01-hero.json | Widget tree (bg image + overlay + Save-the-Date sub-card) | Swapped LLSS subhead (was "Hosted during Government Forum Week"); Velocity has no equivalent secondary descriptor; 3-element card (event-line, tagline, CTA) |
| 02-intro-who-belongs.json | HTML widget | FORCE Members card uses `.fsi-card-gold` (community core); Agents/Brokers/Investors + Asset Managers use `.fsi-card-navy` |
| 03-what-happens.json | HTML widget | 6 features (LLSS had 4); no `.fsi-program-full` Closing Reception strip |
| 04-charter-offer.json | HTML widget (renamed from 04-next-summit) | `.fsi-callout-gold` reused for Charter Member Offer ($300/yr first-100, $495/yr standard) |
| 05- (skipped) | — | First-format event; no past Velocity photo strip yet. Add post-event if desired. |
| 06-membership-cards.json | HTML widget | Five Star Alliance (new, launching at Velocity) + FORCE (15-year credentialed program) |
| 07-event-details.json | HTML widget | When (May 20-21, 2026) / Where (The Westin, New Orleans) / Questions (force@thefivestar.com) |
| 08-final-cta.json | Widget tree | "Join Us in New Orleans" instead of "Join Us in Washington" |
| 09-footer-line.json | Widget tree | RE Pro Membership / force@ / phone instead of Legal League contact |

**Quantitative outcomes:**

| Metric | LLSS Option B | Velocity Option B | Δ |
|--------|---------------|-------------------|---|
| `_elementor_data` size | 22,032 B | 18,178 B | -17% |
| Total Elementor widgets | 15 | 13 | -2 |
| Total `.elementor-element` count in DOM | 27 | 24 | -3 (= skipped Section 5) |
| Total file count | 9 | 8 | |

**Audit results (12/12 PASS):**

| # | Criterion | Result |
|---|-----------|--------|
| 1 | All 8 sections present in DOM | ✅ |
| 2 | The7 page-title bar suppressed | ✅ (`_dt_header_title='disabled'`) |
| 3 | Hero H1 "Velocity" white Roboto 42px wt 700 | ✅ |
| 4 | Hero CTA bg `#C9A040` gold / text `#1F365C` navy / href to swoogo | ✅ |
| 5 | Final H2 "Join Us in New Orleans" white 26px | ✅ |
| 6 | `.fsi-card-gold` Offwhite + 4px gold top border | ✅ rgb(247,247,245) + rgb(201,160,64) 4px |
| 7 | `.fsi-callout-gold` gold bg `rgb(201,160,64)` | ✅ |
| 8 | Who Belongs: 3 cards (1 gold-top + 2 navy-top) | ✅ |
| 9 | What Happens: 6 features in 2-col grid | ✅ |
| 10 | Photo strip items: 0 (Section 5 intentionally skipped) | ✅ |
| 11 | Membership cards: 2 (Five Star Alliance + FORCE) | ✅ |
| 12 | DOM count: 24 elementor-elements | ✅ |

**Cache propagation gotcha (logged for future migrations):** First
post-swap visit via Playwright returned a stale Varnish-cached version
without the new Elementor markup. `wp cache flush` + `rm -rf wp-rocket/*`
+ `Elementor flush_css` are NOT enough — WPE Varnish has its own layer.
The fix: also call `WpeCommon::purge_varnish_cache_all()` +
`WpeCommon::purge_memcached()`. Adding to SOP as lesson #16.

**HubSpot Leadin observation:** swoogo `/register_now` and `/agenda` /
`/venue` links get tracking params auto-appended at render
(`?__hstc=...&__hssc=...&__hsfp=...`). Same behavior as the WPBakery
version on production; not introduced by Elementor.

### Phase 3 Velocity image content TODOs

Five image slots blocking Phase 3.11 production promotion. Workflow same
as LLSS: Jonathan uploads to Media Library → pastes URLs → AI updates
the affected JSON files + pushes via the standard pipeline + flushes +
captures fresh screenshots.

| # | Slot | Section | Dimensions | Subject |
|---|------|---------|------------|---------|
| 1 | Hero bg | 1 | 1900x600 | New Orleans / past Velocity event / FSI RE community moment |
| 2 | Community photo | 2 | 1100x440 | FORCE members in conversation, networking moment |
| 3 | Five Star Alliance card | 6 | 480x220 | RE professionals at work / community moment |
| 4 | FORCE card | 6 | 480x220 | FORCE-certified credential moment / Connect session |
| 5 | Final CTA bg | 8 | 1900x400 | Same as Hero or alternate New Orleans / event shot |

### Documentation updated this session

| File | Change |
|------|--------|
| `docs/decisions.md` | NEW top entry "2026-04-27 — Phase 3 Velocity Elementor at canonical staging slug" |
| `sites/thefivestar/wpbakery-migration.md` | Migration status updated to "First wave (LLSS + Velocity) MIGRATED ON STAGING"; first-wave table entry added for 5088/5107 |
| `sites/thefivestar/site-profile.md` | Open issues table: Velocity Phase 3.11 row added; Events hub note narrowed (Velocity removed) |
| `docs/next-chat-handoff.md` | Header dates + completed/next-phase summary; this session block added |
| `sites/thefivestar/elementor-templates/event-pages/velocity/` | NEW: 8 section JSON files (01,02,03,04,06,07,08,09) |
| `sites/thefivestar/velocity-wpbakery-content.html` | NEW: WPBakery source-of-truth copy reference (8,631 B) |
| `sites/thefivestar/visual-baselines/` | NEW: 6 baselines — `velocity-wpbakery-2026-04-27-{1440,768,420}.png` and `velocity-elementor-2026-04-27-{1440,768,420}.png` |

### 🛑 Awaiting decision: which path next session?

Per IA clarification (2026-04-27 decisions.md entry), the next phase is
**Phase 4b — Community Page template via Real Estate Professionals
relocation**. The existing RE Pros page is the design reference; it
moves from `/memberships/` to `/communities/`.

Several options are unblocked, in priority order:

1. **Phase 4b Community Page template — RE Pros first instance.**
   Relocate page 5087 from `/memberships/real-estate-professionals/` to
   `/communities/real-estate-professionals/` (canonical), Elementor
   rebuild via Option B pattern, establish the FSI Community Page
   template. Includes creating `/communities/` parent. ~90-120 min.
   See "Phase 4b build plan" block below.
2. **Image content for both LLSS + Velocity, in parallel.** Jonathan
   uploads to Media Library, pastes URLs, AI updates JSON + pushes.
   Unblocks Phase 1.11 + Phase 3.11 production promotion gates. ~30 min
   per event once URLs are in chat.
3. **Phase 2 Events hub (page 5089) Elementor migration.** Same Option B
   template, but different content shape — events hub is a card grid,
   not a single-event page. Likely requires Elementor Loop Builder or a
   saved-section per child event.
4. **SOP write-up: `docs/sops/new-event-page-elementor.md`.** Now that
   two events are built (LLSS + Velocity), the abstracted pattern is
   visible and ready to document.

**Recommended sequencing:** option 1 first (Phase 4b unblocks the third
template proof and produces the visual reference for cross-template
distinction with Phase 4a), option 2 in parallel as Jonathan gathers
images, option 3 + 4 follow.

### Phase 4b build plan: Real Estate Professionals (Community template)

**Goal:** establish the FSI Community Page template by Elementor-rebuilding
the existing RE Pros mockup at its canonical URL.

**Source content (15,859 B, inline-styled WPBakery):**
- Existing page 5087 at `/memberships/real-estate-professionals/`
- Saved to repo: `sites/thefivestar/real-estate-professionals-wpbakery-content.html`

**Existing structure (8 logical sections):**

1. Header block: H1 "Real Estate Professionals" + tagline + gold border
2. Intro: 2-paragraph "why this market needs its own infrastructure"
3. Your Path: 3 tier cards (Free / Five Star Alliance $495 / FORCE $1,495)
4. Founding Institutional Partner: gold left-border callout
5. Charter Member Rate: gold-fill callout (Velocity 2026, $300/yr first 100)
6. Events for RE Professionals: 2-card grid (Velocity 2026 + FSC 2026)
7. Governance: Offwhite callout
8. Footer-line

**Template differences from Event Page:**
- **Pricing tier cards** are the dominant visual element (Section 3) — events have nothing analogous
- **Two callouts** (Sections 4 + 5) instead of one — Founding Institutional Partner is eligibility-gated free, Charter Member Offer is paid time-limited
- **Hero treatment is centered-text-with-gold-border** (no bg image), distinct from event-page full-bleed bg image hero — KEEP this distinction so Community pages read differently from Events at-a-glance

**IA / URL operations (in order):**

1. Create `/communities/` parent on staging (root-level page, slug `communities`, status publish, title "Communities"). Nav-wiring requires separate approval (per standing rule).
2. Capture WPBakery RE Pros baseline at 1440/768/420 against page 5087 → `visual-baselines/re-pro-wpbakery-2026-04-27-{vp}.png`.
3. Author 8 section JSON files in `sites/thefivestar/elementor-templates/community-pages/real-estate-professionals/`. Element ID prefix: `repro-*` (per Lesson #18).
4. Decide CSS dependency path BEFORE authoring (see "Decisions to lock" below):
   - **Path A** — keep tier-card styling inline in HTML widget (Velocity precedent)
   - **Path B** — promote to shared CSS classes in `fsi-event-styles.php` → rename to `fsi-shared-styles.php`, deploy via Workflow A. Path B prerequisite ~30 min before any authoring begins.
5. `wp post create` new Elementor page: parent = `/communities/` (whatever ID we get), slug `real-estate-professionals-elementor`, all v4.0.2 meta + `_dt_header_title='disabled'`.
6. Compose + push via Python script + `wp eval-file` pipeline (proven on LLSS + Velocity).
7. Cache flush: `wp cache flush` + `rm -rf wp-rocket/*` + Elementor `flush_css` + **`WpeCommon::purge_varnish_cache_all()` + `WpeCommon::purge_memcached()`** (Lesson #16).
8. Visual verify at 1440/768/420 + Playwright `getComputedStyle` audit (12-criterion structural pass).
9. Slug + parent swap when verified:
   - New Elementor page → slug `real-estate-professionals`, parent = `/communities/` ID, title "Real Estate Professionals" (canonical at `/communities/real-estate-professionals/`)
   - Existing 5087 → slug `real-estate-professionals-old`, parent stays at 2597 `/memberships/` (or move to communities), title "Real Estate Professionals (Old WPBakery)"
   - Add 301 redirect from `/memberships/real-estate-professionals/` to `/communities/real-estate-professionals/` via `eps-301-redirects` plugin (preserves any external inbound links + the Velocity page references)
10. Cache-busted verify on canonical + `-old` URLs.
11. **Update Velocity links** (3 places) from `/memberships/real-estate-professionals/` to `/communities/real-estate-professionals/`:
    - `velocity/04-charter-offer.json` (1 link in Charter Offer body)
    - `velocity/06-membership-cards.json` (1 link in Five Star Alliance card CTA)
    - `velocity/09-footer-line.json` (1 link in footer-line)
    - Push updates to Velocity page 5107 + flush.
12. **Stop at Phase 4b.11 production approval gate** (separate from Phase 1.11 LLSS, Phase 3.11 Velocity).

**Decisions to lock before kicking off:**

1. **Path A (inline styles per Velocity precedent) or Path B (promote to shared CSS classes)?**
   Strong recommendation **Path B** — Phase 4b adds 4 community pages eventually (RE Pros, Mortgage Finance, Legal, Prop Pres), Phase 4a adds 7 membership pages. Tier-card / pricing-grid / callout patterns will recur. CSS-class reuse pays back fast. Renames `fsi-event-styles.php` → `fsi-shared-styles.php` to signal broader scope.
2. **`-old` page disposition:** keep at `/memberships/real-estate-professionals-old/` for ~1-2 weeks post-prod (LLSS pattern), or move to `/communities/real-estate-professionals-old/` for parent consistency? Recommend the latter (move with the page; redirect handles old URL).
3. **301 redirect:** confirm we use `eps-301-redirects` plugin (already active per plugin-inventory) for the `/memberships/real-estate-professionals/` → `/communities/real-estate-professionals/` redirect, not nginx-level WPE config.
4. **`/communities/` parent page:** what content does it host? Listing of child community pages? Bare hub page? Or just a structural URL anchor with no on-page content? Defer the `/communities/` hub itself to a later Phase 4b iteration; for now create as a stub (status publish, minimal content, `_dt_header_title='disabled'` for clean look).
5. **Phase 4a Membership template design:** does NOT need to be locked before Phase 4b begins. Phase 4b ships first, then Phase 4a starts with a clear visual contrast benchmark (Community Page rendered) so the Membership Page can be deliberately distinct.

**Image TODOs (Phase 4b.11 prerequisites):**

The existing RE Pros mockup has zero images — it's all text + colored cards. No image slots to populate before production promotion. Hero is centered-text-with-gold-border (no bg image). This is a deliberately image-light page; matches the Membership template's likely scope too.

---

## Completed prior session (2026-04-26)

### Phase 1.4 LLSS Elementor build ✅

Per the 2026-04-26 entries below, LLSS was rebuilt across 9 sections
using the Option B pattern (Elementor structural containers + HTML
widgets containing `fsi-page-wrap` markup). All sections rendered;
slug-swapped at canonical `/events/legal-league-servicer-summit/`
(page 5106). WPBakery preserved at `-old` (page 5094). Image content
gathering pending. Phase 1.11 production promotion pending Jonathan
approval.

---

## Completed this session (2026-04-25)

### AI-first Elementor authoring proven end-to-end ✅

The Phase 1.3 UI-built kit was re-authored as JSON in version control and
round-tripped through the WP-CLI push pipeline back onto FSI staging,
proving the full source-of-truth → deployable-zip → push → import →
flush → render-verify cycle works.

**Decision logged:** `docs/decisions.md` 2026-04-25 entry.
**SOP:** `docs/sops/elementor-json-authoring.md`.
**Workflow C split** in `docs/how-we-update-the-site.md`:
- **C1 (default):** JSON authoring + WP-CLI push for kits, sections, page content
- **C2 (escape hatch):** WP Admin UI for theme-builder conditions, popups,
  dynamic-tag wiring, widget schema discovery, and non-Elementor content
  (WPBakery edits, blog posts, nav menus)

### Verified `wp elementor` WP-CLI surface (FSI staging Elementor 4.0.2) ✅

| Command | Use |
|---------|-----|
| `wp elementor kit import <zip> [--include=site-settings,templates,content] --user=<id>` | Import kit zip (admin user mandatory) |
| `wp elementor kit export <path>` | Programmatic kit export |
| `wp elementor kit revert` | **Atomic rollback** of last kit import |
| `wp elementor library import <file>` | Single template import |
| `wp elementor library import_dir <path>` | Bulk template/section import |
| `wp elementor flush_css` | Regenerate per-page CSS cache (mandatory after every push) |
| `wp elementor replace_urls <old> <new>` | Staging→prod URL rewrite |

### Push pipe — verified working ✅

WPE SSH Gateway blocks SCP and shell redirects; `/tmp/` is container-scoped
(non-persistent across SSH sessions). Working pattern:

1. base64-encode binary locally
2. Pipe a PHP script via `wp eval-file -` that decodes + writes to
   `wp_upload_dir()['basedir']/cli-imports/`
3. MD5-verify integrity (proven: 5484 bytes, md5 `4dc548afbeabb9121ed726cf6afdbbff`
   round-tripped exactly)
4. Run `wp elementor kit import ... --user=816`
5. `wp elementor flush_css`
6. Visual + computed-style verify via Playwright
7. Cleanup: delete `/cli-imports/` zip + empty dir

### Repo source-of-truth structure (live) ✅

```
sites/thefivestar/
  elementor-kit/                    # Site Settings JSON source-of-truth
    site-settings.json              (6485 bytes — Global Colors, Layout, Custom CSS)
    custom-fonts.json               (6594 bytes — typography tokens + 6 font uploads)
    custom-code.json                (307 bytes — Naylor + Apollo head injections)
    manifest.json                   (13913 bytes — kit metadata, plugin list, experiments)
  elementor-global-kit-v1.zip       # Built artifact (re-zip the JSON above)
  elementor-templates/
    widget-references/
      kit-test-page-5099.json       # v4.0.2 widget schema oracle: heading×2,
                                    # text-editor, button, image×2, spacer, divider
  visual-baselines/
    kit-test-post-roundtrip-2026-04-25.png   # Verified-good kit render
```

### 3 spec/reality drifts surfaced + corrected ✅

The kit on staging didn't match the kit spec doc. Now corrected in
`elementor-global-kit-spec.md`:

1. **Body fonts: Arial → Roboto.** Staging is Roboto / Roboto Slab. Spec
   said Arial. Updated. (The7 doesn't override font-family — it overrides
   color/size/weight via widget-class selectors.)
2. **6 custom colors → 10 custom colors.** Staging has 4 extras:
   Hero Overlay `#1F365CD9` (8-digit hex with alpha — invalidates the
   spec's "v4 doesn't support transparency" note), Velocity CP Light Yellow
   `#F2F1AE`, Velocity CP Blue `#00A0E6`, claude gray `#6B7A8D` (purpose
   unknown — flag for cleanup pass).
3. **Mobile breakpoint stored as `viewport_mobile: null`.** Tablet
   (`viewport_md: 768`) and desktop (`viewport_lg: 1025`) confirmed. Mobile
   needs a v4-specific re-audit before relying on a 480px breakpoint in
   section CSS — flagged as **open audit item**.

### Round-trip render verification ✅

Playwright `getComputedStyle` on staging `/kit-test/` after the kit
re-import + `flush_css`:

- H1 "Test Headline": `rgb(31, 54, 92)` Roboto **42px** weight 700 line-height **50.4px** ✅
- H2 "Section Heading": `rgb(31, 54, 92)` Roboto **26px** weight 700 line-height **33.8px** ✅
- Body paragraph: `rgb(68, 68, 68)` Roboto 14px ✅
- Container: v4 Flexbox `e-con` ✅
- Custom CSS scoped to `.elementor-widget-heading .elementor-heading-title`
  is winning over The7 — specificity rule confirmed at the kit level

Full-page screenshot baseline:
`sites/thefivestar/visual-baselines/kit-test-post-roundtrip-2026-04-25.png`.

### Version pin locked ✅

Elementor 4.0.2 + Elementor Pro 4.0.2 on FSI. Per the 2026-04-25 decision,
WP auto-update for both is to be disabled; upgrades are deliberate and
require re-export of kit + widget-references to verify schema didn't drift.

### Prod-color-conflict discovered + renumber remediation applied ✅

**Discovery:** During Phase 1.3 setup (Sasa, 2026-04-23), 7 of the 10
pre-existing custom-color slot IDs on the staging kit got *replaced in
place* with brand colors. **Prod kit 4004 was last modified 2025-11-04 —
5 months stale relative to staging.** A direct query of prod
`_elementor_data` found 4 active prod pages still bind to those 7
contested slot IDs:

| Page | Status | Slots | Risk if Phase 1.11 promoted as-is |
|------|--------|-------|------------------------------------|
| 4497 Exit Intent (popup) | Active marketing | 3 slots, 5 refs | HIGH — popup button breaks |
| 4560 Education | Active core page | 1 slot, 5 refs | MEDIUM — backgrounds white→grey |
| 4993 Five Star Access | Active core page | 3 slots, 4 refs | HIGH — links near-invisible |
| 4436 Velocity (old 2024) | Deprecation candidate | 3 slots, 17 refs | VERY HIGH — full identity flip |

**Remediation:** Restore the 7 contested slot IDs (`f64043d`, `fd98090`,
`7836aae`, `9bb2763`, `9e77118`, `2922fdd`, `73bb18d`) on staging to
their prod Velocity values; add the 7 brand colors at NEW `fsi*` slot
IDs (`fsi01nh` through `fsi07ho`). Net 17 custom-color slots. Prod
pages render unchanged after Phase 1.11; new event pages bind to `fsi*`.

**Applied via direct meta-write** to staging kit 4004's
`_elementor_page_settings` (with backup at
`_elementor_page_settings_backup_<timestamp>` post meta). Verified:
kit 4004 has clean 17-color list with no duplicate IDs; `/kit-test/`
renders identically (computed-style + screenshot match prior baseline).

**Source of truth updated:** `sites/thefivestar/elementor-kit/site-settings.json`
+ `elementor-global-kit-v1.zip` (rebuilt from JSON).

### `wp elementor kit import` confirmed broken for kit-content edits ⚠️

While testing the renumber via `kit import`, two distinct failure modes
surfaced:

1. **`--include=site-settings` is a silent no-op.** Returns "Success" but
   creates an import session with `runners: []` (zero runners). Active kit
   bytewise unchanged. The "Success" message is misleading.
2. **No `--include` (full import) APPENDS instead of REPLACES.** Custom
   colors get duplicate `_id` entries (slot `f64043d` listed twice with
   different titles/hex). Elementor's runtime resolution becomes undefined.
   Also creates duplicate `elementor_snippet` posts (Naylor 4840 → trashed,
   5103 → created); also creates a new kit post (5102) and switches
   `elementor_active_kit` away from 4004.

**Replaced in SOP** with direct meta-write to `_elementor_page_settings`
+ `Elementor\Plugin::$instance->files_manager->clear_cache()`. Always
backed up to a timestamped meta key first for instant rollback.

**`wp elementor kit revert` works** as advertised for atomic rollback after
`kit import` (verified 2026-04-25). Caveat: does NOT untrash trashed
`elementor_snippet` posts — manual `wp post update <id> --post_status=publish`
needed.

### Implementation plan audit (Phase 1.4 vs LLSS build spec) — 2026-04-26

| Build-spec step | Status | Note |
|-----------------|--------|------|
| Step 0: Page setup | ✅ DONE | Page 5106 created via CLI; `_dt_header_title='disabled'` set; all Elementor meta in place |
| Section 1 Hero | ✅ DONE | Widget tree + Save-the-Date sub-card |
| Section 8 Final CTA | ✅ DONE | Widget tree |
| 🛑 Mid-phase checkpoint | ✅ DONE | 12/12 audit pass; Jonathan approved continuation |
| Sections 2-7 | ✅ DONE (Option B) | HTML widgets containing `fsi-page-wrap` markup; visual parity with WPBakery design |
| Section 9 Footer-line | ✅ DONE | Added (not in original spec) — small inline contact-info strip below Final CTA |
| Step 2: Combine into master template | ⏳ PARTIAL | All 9 sections live in page `_elementor_data`; saved-template export to `wp elementor library import_dir` not yet done |
| Step 3: Full-page verification | ✅ DONE | 10/10 Option B audit pass; computed-style spot checks; screenshots at 3 viewports |
| Step 4: Rename + swap | ✅ DONE | 5094 → `-old`, 5106 → canonical (2026-04-26) |
| Step 5: 🛑 Approval gate | ✅ DONE | Jonathan approved Step 7 (2026-04-26) |
| Step 6: New SOP `docs/sops/new-event-page-elementor.md` | ⏳ PENDING | Best written DURING Phase 3 Velocity build — the Velocity build IS the second use of the Option B template, so the SOP captures the abstracted pattern from LLSS+Velocity together. |
| Step 7 (Phase 1.11): Production promotion | ⏳ PENDING | Awaiting (a) LLSS image content placement, (b) explicit Jonathan approval. Path documented in earlier handoff entries. |
| **Phase 3: Velocity event page build** | ⏳ NEXT | Page 5088 → new Elementor page → Option B template clone from LLSS. Front-loaded as first-thing-next-session. |

**Pre-prod content tasks (not in spec):**
- 🟢 **Image content population** (front-loaded above as first-thing-next-session)
- 🟡 **Lighthouse Slow-4G CLS before-number** on the WPBakery `-old` page (Pre-work #4 carry-forward) — needed for Phase 1.7 verification gate; capture any time before Phase 1.11
- 🟡 **Save sections as Elementor Pro library templates** for Phase 2/3 cloning — `wp elementor library import_dir` against the section JSON files. Useful but not blocking.

**Carry-forward (non-blocking):**
- WP auto-update disable for Elementor + Pro on FSI staging + prod (enforces 4.0.2 / 4.0.2 version pin)
- `claude gray` color (slot `dc145d8` `#6B7A8D`) cleanup — purpose unknown
- `_elementor_page_settings_backup_*` meta-key pruning on kit 4004 + page 5106 (keep 2-3 most recent)
- Velocity page 4436 deprecation pass (uses 3 of 7 contested slot IDs but renumber preserves them; not urgent)

### 🟢 First-thing-next-session — Phase 3: Velocity event page build (Option B template)

**Why this is next:** LLSS Phase 1.4 is structurally complete (waiting on
image content from Jonathan). Velocity is the next event page in the
migration queue per the 2026-04-22 portfolio standardization plan. Same
Option B template applies — fast cloning vs. starting from scratch.

**Source page on staging:** **page 5088**, slug `velocity` under parent
Events 5089. Plain HTML inside WPBakery using the same `fsi-page-wrap` /
`fsi-event-styles.php` class system as LLSS.

**Reference outputs from LLSS** (the canonical Option B template):
- `sites/thefivestar/elementor-templates/event-pages/legal-league-servicer-summit/01-hero.json`
  through `09-footer-line.json`
- `sites/thefivestar/llss-wpbakery-content.html` (source-of-truth copy)
- `sites/thefivestar/llss-elementor-build-spec.md` (per-section guidance)
- `sites/thefivestar/visual-baselines/llss-elementor-optionB-2026-04-26-{1440,768,420}.png`

**Conventions already settled — do NOT re-litigate:**

- **URL slug:** `/events/<event-slug>/`. Velocity will live at `/events/velocity/`,
  the same way LLSS lives at `/events/legal-league-servicer-summit/`.
- **Repo directory:** `sites/thefivestar/elementor-templates/event-pages/<event-slug>/`.
  Each event = one subdirectory, directory name matches URL slug 1:1.
  `event-pages/velocity/` is already created (empty) for the next session
  to populate.
- **Section JSON file naming:** `01-hero.json` through `09-footer-line.json`
  (or fewer if Velocity's content doesn't need all 9). Numeric prefix
  sets composition order in `_elementor_data`.
- **Section approach:** Sections 1, 8, 9 = Elementor widget tree.
  Sections 2-7 = single HTML widget per section containing the existing
  `fsi-page-wrap` markup chunk.

**Build sequence for next session:**

1. **Pull Velocity source content from staging:**
   ```bash
   echo '<?php echo get_post(5088)->post_content;' | ssh thefivestarstg 'wp eval-file - 2>/dev/null' \
     > /Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/velocity-wpbakery-content.html
   ```
   Mirrors what we did for LLSS (`llss-wpbakery-content.html`). Saves the
   authoritative copy reference.

2. **Capture WPBakery Velocity baselines** for side-by-side comparison
   (Playwright at 1440 / 768 / 420 against
   `https://thefivestarstg.wpenginepowered.com/events/velocity/`). Save to
   `visual-baselines/velocity-wpbakery-2026-04-XX-{viewport}.png`.

3. **Map Velocity's content to the 9-section structure.** Most sections
   should fit directly. If Velocity has different sections than LLSS
   (e.g., a "Sponsors" section, or no "Recent Event" recap because it's a
   first-time event), adapt — Option B accommodates any structure as
   long as the source HTML uses `fsi-event-styles.php` classes.

4. **Author section JSON files in `event-pages/velocity/`** by copying
   the LLSS files from `event-pages/legal-league-servicer-summit/`:
   - Sections 1, 8, 9 (Hero, Final CTA, Footer-line) = widget tree
     (copy LLSS files, swap copy + image slots)
   - Sections 2-7 (Content) = HTML widget per section (copy LLSS
     wrapper structure, swap the `html` setting with Velocity's
     equivalent markup chunk)
   - Use deterministic IDs prefixed with `velocity-` instead of LLSS
     prefixes to avoid collisions if these end up exported as templates

5. **Create new Elementor page on staging via CLI** — same script pattern
   as LLSS Step 0:
   ```bash
   wp post create --post_type=page --post_status=publish \
     --post_parent=5089 --post_title="Velocity (Elementor)" \
     --post_name=velocity-elementor --post_author=816
   ```
   Then `update_post_meta` for `_elementor_edit_mode`,
   `_elementor_template_type`, `_elementor_version`, `_elementor_pro_version`,
   `_dt_header_title='disabled'`, and `_elementor_data='[]'` (initial empty).

6. **Compose + push the section JSON** via the proven `wp eval-file`
   pipeline. Same `update_post_meta(_elementor_data, wp_slash($json))`
   + `Elementor\Plugin::$instance->files_manager->clear_cache()` +
   `wp cache flush` + `rm -rf wp-rocket/*` flow.

7. **Visual verify** at 1440 / 768 / 420 vs the WPBakery Velocity baselines.
   Run the same Playwright `getComputedStyle` audit pattern (cards,
   callouts, grids, buttons) — but Option B + same CSS classes makes this
   guaranteed-by-construction. Should pass on first push.

8. **Slug swap** when verified: 5088 → `velocity-old` (title "Velocity
   (Old WPBakery)"), new page → `velocity` canonical slug. Same approach
   as LLSS Step 7.

9. **Approval gate before production promotion** — separate Phase 3.11
   gate, after LLSS Phase 1.11.

**Estimated build time:** ~60-90 min depending on Velocity's content
complexity. Most of it is mechanical translation now that the Option B
template + push pipeline are proven.

**Caveats / what to watch:**
- If Velocity uses CSS classes NOT in `fsi-event-styles.php` (e.g.,
  Velocity-specific styling), those classes won't apply on the Elementor
  page. Solve by either: (a) adding the missing classes to the kit Custom
  CSS, OR (b) keeping the classes in `fsi-event-styles.php` if they're
  shared across events
- The Velocity gold callout for "Next Event" will use `.fsi-callout-gold`
  same as LLSS — colors handled by the existing CSS

---

### 🟡 Parallel work: LLSS image content (when Jonathan has gathered images)

**Status:** Phase 1.4 LLSS is structurally complete on staging at
canonical slug. **Image content is the only remaining gap before
Phase 1.11 production promotion approval.**

**Shotlist for Jonathan to gather:**

| # | Slot | Section | Dimensions | Subject matter | Notes |
|---|------|---------|------------|----------------|-------|
| 1 | Hero background | 1 | **1900×600** | Conference room wide shot OR panel in progress | Should evoke "annual gathering" — wide angle, attendees ideally visible. Becomes the moodsetter for the page. |
| 2 | Community photo | 2 | **1100×440** | Attorneys in conversation, networking moment, OR full room during a session | Horizontal landscape. Sits between intro paragraphs and "Who Belongs" cards. WPBakery comment: "handshakes, hallway conversation, or full room during session" |
| 3 | Photo strip — Panel | 5 | **360×240** | Dallas 2026 panel on stage | Wide ratio. Caption: "Industry Leadership Panel, Dallas 2026" |
| 4 | Photo strip — Networking | 5 | **360×240** | Dallas 2026 networking or reception moment | Caption: "Closing Reception, Dallas 2026" |
| 5 | Photo strip — Room | 5 | **360×240** | Dallas 2026 wide room shot or group | Caption: "Legal League Servicer Summit, Dallas 2026" |
| 6 | Firm Membership card | 6 | **480×220** | Attorneys in conversation OR Legal League community moment | Pairs with "Legal League Firm Membership" copy |
| 7 | Corporate Membership card | 6 | **480×220** | Service provider or vendor engagement moment | Pairs with "Corporate Membership" copy |
| 8 | Final CTA background | 8 | **1900×400** | Same as Hero OR Washington DC themed (National Press Club exterior, capitol skyline, attendees in DC, etc.) | Ties to "Join Us in Washington" headline. If only one shot is available, reuse Hero. |

**File format suggestions:** JPG for photos (smaller file size). 80% JPEG
quality is fine. Save filenames descriptively (`llss-hero-conference-room.jpg`,
`llss-dallas-2026-panel.jpg`, etc.) — they end up in the Media Library and
make future audits easier.

**Workflow when images are ready:**

1. Jonathan uploads to Media Library via WP Admin
   (`https://thefivestarstg.wpenginepowered.com/wp-admin/upload.php`)
2. Jonathan pastes URLs into chat — for each image, the Media Library's
   "Copy URL to clipboard" button gives the absolute URL
3. AI updates the 5 affected JSON files (`01-hero.json`, `02-intro-who-belongs.json`,
   `05-recent-summit-strip.json`, `06-membership-cards.json`, `08-final-cta.json`)
4. AI pushes via the standard pipeline + flushes
5. AI captures fresh screenshots at 3 viewports for visual sign-off
6. Jonathan visually approves → Phase 1.11 production promotion gate

### Phase 1.4 Step 7 slug swap COMPLETE on staging ✅ (2026-04-26)

After Jonathan approved Option A (proceed with Step 7), executed via single
`wp eval-file` script:

| Action | Result |
|--------|--------|
| `wp_update_post(5094, slug='legal-league-servicer-summit-old', title='Legal League Servicer Summit (Old WPBakery)')` | OK |
| `wp_update_post(5106, slug='legal-league-servicer-summit', title='Legal League Servicer Summit')` | OK |
| `flush_rewrite_rules(false)` | done |
| `Elementor\Plugin::$instance->files_manager->clear_cache()` | done |
| `wp_cache_flush()` | done |
| `rm -rf wp-rocket/*` | done |

**Verified via Playwright:**

- **Canonical URL** `https://thefivestarstg.wpenginepowered.com/events/legal-league-servicer-summit/`
  - Title: "Legal League Servicer Summit"
  - Wrapper class: `.elementor-5106` (Elementor page) ✅
  - All Option-B sections present (`hero-section`, `intro-html` HTML widget,
    `.fsi-card-gold` Offwhite card with 4px gold top border, etc.)
- **`-old` URL** `https://thefivestarstg.wpenginepowered.com/events/legal-league-servicer-summit-old/`
  - Title: "Legal League Servicer Summit (Old WPBakery)"
  - Has `.fsi-page-wrap` (WPBakery markup) ✅
  - Does NOT have `.elementor-5094` (correct — page 5094 isn't an Elementor page)

**Production unchanged.** Phase 1.11 production promotion is the next gate
and requires explicit Jonathan approval per the production-approval rule
in `CLAUDE.md`.

### Phase 1.4 Option B retrofit — visual parity achieved via HTML widgets ✅ (2026-04-26)

**Strategic correction:** The polish-pass version (widget-tree everything)
visually rendered the cards as solid-fill blocks (gold + navy with white
text), which was a wrong read of the source CSS. The actual `.fsi-card-gold`
and `.fsi-card-navy` classes in `fsi-event-styles.php` render as **Offwhite
cards with colored top-border accents** — much cleaner, more contemporary.
Recreating that nuance via Elementor widget settings was reinventing CSS
that already existed.

**Decision:** Pivot to Option B — Elementor outer Container (for structural
layout) + ONE HTML widget per content section (containing the existing
`fsi-page-wrap` markup verbatim). CSS comes from `fsi-event-styles.php`.
Hero + Final CTA + Footer-line stay as widget trees because Elementor's
Container handles bg-image + overlay + structural details elegantly there.

**Section-by-section result:**

| Section | Approach | Why |
|---------|----------|-----|
| 1 Hero | Widget tree (kept) | Bg image + overlay + Save-the-Date sub-card — Elementor handles best |
| 2 Intro / Who Belongs | HTML widget | `.fsi-intro` + `.fsi-image-block` + `.fsi-grid-3` cards |
| 3 What Happens | HTML widget | `.fsi-section-heading` + `.fsi-grid-2` features + `.fsi-program-full` strip |
| 4 Next Summit | HTML widget | `.fsi-callout-gold` is a single styled block |
| 5 Recent Summit Strip | HTML widget | `.fsi-section-muted` + `.fsi-photo-strip` |
| 6 Membership Cards | HTML widget | `.fsi-membership-grid` + 2 `.fsi-membership-card` |
| 7 Event Details | HTML widget | 3-up `.fsi-grid-3` with inline-styled cards |
| 8 Final CTA | Widget tree (kept) | Bg image + overlay + button |
| 9 Footer-line | Widget tree (kept) | Tiny — not worth refactoring |

**Quantitative outcomes:**

| Metric | Polish pass (widget tree) | Option B (HTML widgets) | Change |
|--------|---------------------------|-------------------------|--------|
| `_elementor_data` size | 39,958 bytes | 22,032 bytes | **-45%** |
| Total Elementor widgets | 59 | 15 | **-75%** |
| Total Flexbox containers | 35 | 12 | **-66%** |
| `.elementor-element` count in DOM | ~100+ | 27 | **-73%** |
| Per-page CSS file size | ~9 KB | ~3-4 KB est. | smaller |

**Audit criteria — 10/10 PASS:**

| # | Criterion | Result |
|---|-----------|--------|
| 1 | All 9 sections present in DOM | ✅ |
| 2 | Hero/Final/Footer-line still widget-tree | ✅ Hero H1 + Final H2 present |
| 3 | Sections 2-7 each contain ONE HTML widget | ✅ |
| 4 | **Who Belongs cards: Offwhite bg `rgb(247, 247, 245)` + 4px gold top border on first / 4px navy top border on others** | ✅ Visual parity with source design |
| 5 | Body text readable (`.fsi-card__text` 14px, `.fsi-intro p` 18px) | ✅ |
| 6 | `.fsi-callout-gold` Section 4 has gold bg `rgb(201, 160, 64)` from CSS | ✅ |
| 7 | `.fsi-photo-strip` has 3 items | ✅ |
| 8 | `.fsi-membership-card` has 2 cards | ✅ |
| 9 | Event Details 3-up has 3 cards | ✅ |
| 13 | DOM count: 27 elementor-elements (was 100+) | ✅ |

**Visual baselines captured (Option B):**
- `visual-baselines/llss-elementor-optionB-2026-04-26-1440.png` (570 KB)
- `visual-baselines/llss-elementor-optionB-2026-04-26-768.png` (567 KB)
- `visual-baselines/llss-elementor-optionB-2026-04-26-420.png` (523 KB)

**SOP updated** with lesson #15: use HTML widgets when the existing CSS
already encodes the visual design; widget trees only when they earn their
keep (bg image + overlay + structural logic).

### Phase 1.4 polish pass — visual parity with WPBakery baseline ✅ (2026-04-26)

After the structural-correctness audit passed but Jonathan flagged the page
as "nowhere close" to the WPBakery LLSS visual, the user picked Option A:
visual parity is the bar before Step 7 slug swap. Polish-pass changes:

| Fix | Where | Effect |
|-----|-------|--------|
| Body text 17px / line-height 1.6 | Kit `custom_css` rule scoped to `.elementor-widget-text-editor p, li` | All paragraph content now readable (was 14px from kit Text token) |
| Hero Save-the-Date callout sub-container | New nested container `hero-save-the-date-card` wrapping event-line/subhead/tagline/CTA, rgba(0,0,0,0.28) bg, 6px radius | Matches WPBakery `fsi-event-hero__date` boxed structure |
| Hero overlay opacity fix | `background_overlay_color: "#1F365C"` + explicit `background_overlay_opacity: 0.85` | Was rendering at effective 0.425 (alpha hex × default --overlay-opacity:0.5) |
| Hero padding 80 → 100 (60 → 70 mobile) | Section 1 outer padding | More breathing room |
| Section padding bumped across 2-7 | 80 → 90/100, 60 → 70 mobile | Matches WPBakery's pacing |
| Community photo placeholder | New inner container in Section 2 between intro paragraphs and Who Belongs cards, 1100x440 box w/ "Community Photo" label | Renders the structural element WPBakery has even without uploaded photo |
| Final CTA overlay fix | Same as Hero overlay fix | Renders at intended 0.85 opacity |
| Footer-line strip | New `09-footer-line.json` section, small contact info under Final CTA with top border | Matches WPBakery footer-line markup |

**File changes (9 sections total now):**

| File | Size before | Size after |
|------|------------|-----------|
| 01-hero.json | 5889 B | 7433 B (added Save-the-Date wrapper) |
| 02-intro-who-belongs.json | 7955 B | 9520 B (added community photo block) |
| 03-what-happens.json | 9396 B | 9398 B (padding tweaks) |
| 04-next-summit.json | 5618 B | 5618 B (padding tweaks) |
| 05-recent-summit-strip.json | 7353 B | 7355 B (padding tweaks) |
| 06-membership-cards.json | 10585 B | 10587 B (padding tweaks) |
| 07-event-details.json | 6754 B | 6754 B (padding tweaks) |
| 08-final-cta.json | 4647 B | 4733 B (overlay opacity fix) |
| **09-footer-line.json (NEW)** | — | 1674 B |
| **Total `_elementor_data`** | 36,696 B | **39,958 B** |

Kit `site-settings.json` `custom_css` block: 514 B → 991 B (added body
text rule). Kit pushed via direct meta-write (not import) per the
established workflow.

**Verified via Playwright `getComputedStyle`:**
- All body text widgets: 17px / line-height 27.2px / correct color
- Hero Save-the-Date card: rgba(0,0,0,0.28) bg, 6px radius, 1100px width, 32px padding via `e-con-inner` (v4 boxed-container split: outer takes left/right, inner takes top/bottom — that's how Elementor v4 stores boxed-container padding)
- Hero overlay (`::before` pseudo): rgb(31, 54, 92) at opacity 0.85
- Community photo block: 440px min-height, #E0E0DC border-color bg
- Footer-line section: present with full contact-info text

**Visual baselines captured (polish pass):**
- `visual-baselines/llss-elementor-polish1-2026-04-26-1440.png` (736 KB)
- `visual-baselines/llss-elementor-polish1-2026-04-26-768.png` (750 KB)
- `visual-baselines/llss-elementor-polish1-2026-04-26-420.png` (667 KB)

WPBakery baselines for side-by-side: same `visual-baselines/` dir,
`llss-wpbakery-2026-04-26-{viewport}.png`.

### Phase 1.4 ALL 8 SECTIONS LIVE on staging — full-page verified ✅ (2026-04-26)

After mid-checkpoint passed, Sections 2-7 were authored as JSON files:

| File | id | Size | Description |
|------|-----|------|-------------|
| 01-hero.json | hero-section | 5889 B | Full-bleed hero with H1, event line, tagline, gold CTA |
| 02-intro-who-belongs.json | intro-outer | 7955 B | Intro paragraphs + 3-card "Who Belongs" grid (gold + 2 navy cards) |
| 03-what-happens.json | what-happens-outer | 9396 B | Offwhite section, H2 + intro + 4-feature 2x2 grid + Closing Reception strip |
| 04-next-summit.json | next-summit-outer | 5618 B | Gold callout: eyebrow + H2 + 2 body paragraphs + detail + outline button + Govt Forum link |
| 05-recent-summit-strip.json | recent-summit-outer | 7353 B | Dallas 2026 recap + 3-photo strip (placeholder images, captions) |
| 06-membership-cards.json | membership-outer | 10585 B | Intro + 2 large membership cards (Firm + Corporate) with images, copy, buttons |
| 07-event-details.json | event-details-outer | 6754 B | When / Where / Questions 3-up cards on Offwhite |
| 08-final-cta.json | final-section | 4647 B | Final CTA, gold "Get Summit Updates" button |

Total: 36,696 bytes of `_elementor_data` JSON, pushed to staging page 5106
via direct `update_post_meta` + `Elementor\Plugin::$instance->files_manager->clear_cache()`
(NOT `wp elementor library import_dir`).

**Server-side smoke check (curl + grep):** all 8 section IDs found in
rendered HTML; HTTP 200; 145 KB rendered page.

**Playwright structural audit (1440 desktop):**
- 8/8 sections found in DOM
- 10/10 widget structural checks pass:
  - Hero H1 white Roboto 42px wt 700 ✅
  - Hero CTA bg gold #C9A040 / text navy #1F365C ✅
  - Intro card-a bg gold (`__globals__: secondary` resolved on container) ✅
  - Intro card-b bg navy (`__globals__: primary`) ✅
  - Intro card-c bg navy ✅
  - What Happens section Offwhite #F7F7F5 (`__globals__: fsi03ow`) ✅
  - Next Summit gold callout bg ✅
  - Membership firm card has button ✅
  - Event Details "When" card Offwhite ✅
  - Final CTA full-width / 400px min-height ✅
- 59 widgets total / 35 containers — clean

**Color resolution sanity:**
- Headings (Hero H1, intro card H3s, Next Summit H2, Final H2): all render exactly per kit Custom CSS scoping — white where set, dark brown where set on gold callout, navy default elsewhere
- Text editors with `text_color: "#FFFFFF"` on dark cards: confirmed `rgb(255,255,255)`
- Buttons: hardcoded hex values rendering correctly (per the v4 + The7 workaround)
- Container backgrounds via `__globals__`: all resolve correctly (the workaround only affects buttons + overlays, not container bg)

**Visual baselines captured at 3 viewports:**
- `sites/thefivestar/visual-baselines/llss-elementor-fullpage-2026-04-26-1440.png` (519 KB)
- `sites/thefivestar/visual-baselines/llss-elementor-fullpage-2026-04-26-768.png` (472 KB)
- `sites/thefivestar/visual-baselines/llss-elementor-fullpage-2026-04-26-420.png` (423 KB)

Side-by-side comparison reference (WPBakery baselines from earlier):
- `llss-wpbakery-2026-04-26-{viewport}.png`

**Reusable patterns proven for Phases 2–3:**

1. Section as JSON file in `elementor-templates/{template-type}/{slug}.json`
2. Outer container: `content_width: full|boxed`, deterministic `id`, padding (desktop + mobile variants)
3. Inner container for boxed/centered content within full-width sections
4. Multi-column grids via flex_direction=row + flex_grow:1 + flex_basis:0 on each child container
5. Responsive: flex_direction_mobile=column for stacking
6. Card backgrounds: `__globals__: { background_color: "globals/colors?id=primary|secondary|fsi03ow" }` — works
7. Heading colors: `title_color: "#FFFFFF"` direct hex — works (kit Custom CSS scopes are heading-specific, won't fight)
8. Text-editor colors: `text_color: "#FFFFFF"` direct hex — works
9. Buttons: hardcode all four color fields (`button_text_color`, `background_color`, `hover_color`, `button_background_hover_color`) — REQUIRED workaround
10. Container overlays: hardcode `background_overlay_color` — REQUIRED workaround

Phase 2 (Events hub) and Phase 3 (Velocity) clone this pattern with
section-specific JSON files. The 8 LLSS sections become the FSI Event
Page master template via `wp elementor library import_dir` (later step).

### Phase 1.4 Step 3 + Step 4 mid-checkpoint PASSED ✅ (2026-04-26)

**Page created:** Staging LLSS Elementor page **ID 5106**, slug
`legal-league-servicer-summit-elementor`, parent 5089 (Events). All
required Elementor meta keys + `_dt_header_title='disabled'` set via
`wp post create` + `update_post_meta` — no UI clicks. URL:
`https://thefivestarstg.wpenginepowered.com/events/legal-league-servicer-summit-elementor/`

**Push pipeline working end-to-end:**
1. Compose `_elementor_data` from `01-hero.json` + `08-final-cta.json`
   (strip authoring-only keys `_authoring_notes/_TODO/_NOTE/_comment/_meta`,
   preserve `__globals__` + all real Elementor underscore keys)
2. JSON-encode + base64 + push via `wp eval-file -` running
   `update_post_meta($page_id, '_elementor_data', wp_slash($json))`
3. Backup pre-push state to timestamped meta key
4. `Elementor\Plugin::$instance->files_manager->clear_cache()`
5. `wp cache flush` + `rm -rf wp-rocket/*`

**Mid-checkpoint criteria — 12/12 PASS** (iteration 2, after fix):

| # | Criterion | Result |
|---|-----------|--------|
| 1 | Page loads HTTP 200 | ✅ |
| 2 | The7 page-title bar SUPPRESSED | ✅ (`_dt_header_title='disabled'` works) |
| 3 | Hero outer full-width 1440px / min-height 600px | ✅ |
| 4 | Hero H1 "Legal League Servicer Summit" white Roboto 42px wt 700 centered | ✅ (kit Custom CSS scoping wins) |
| 5 | Hero CTA bg `#C9A040` gold / text `#1F365C` navy | ✅ (after iteration 2 fix) |
| 7 | Hero `::before` overlay `rgba(31, 54, 92, 0.85)` rendering | ✅ (after iteration 2 fix) |
| 8 | Final CTA full-width / min-height 400px | ✅ |
| 9 | Final CTA H2 "Join Us in Washington" white Roboto 26px wt 700 | ✅ |
| 10 | Final CTA button bg gold / text navy | ✅ |
| 11 | Both sections present in DOM | ✅ |
| 13 | Console errors clean (2 errors at navigate are unrelated WP/The7) | ✅ |
| 15 | All `__globals__` bindings on heading/text widgets resolved | ✅ |

(criterion #6 hover state and #12 responsive viewport — deferred to full-page verify; #14 PHP fatals — verified clean separately.)

**Iteration 1 → Iteration 2: the v4 + The7 button/overlay binding gotcha**

Iteration 1 (with `__globals__` bindings on buttons + overlays) failed
criteria 5/7/10. Investigation:
- `__globals__` keys correctly preserved in stored `_elementor_data`
- Per-page CSS file Elementor generates contains
  `background-color: var(--e-global-color-secondary)` declarations
- CSS variables ARE defined: kit CSS file declares all 17 colors
  including `fsi*` slots
- Variables resolve on the button element: `getPropertyValue('--e-global-color-secondary')`
  returns `#C9A040`
- BUT: browser's parsed `cssRules` for the per-element button rule have
  NO `background-color` declaration. The file-on-disk has it, but the
  browser dropped it during parse.

**Root cause:** Elementor's per-page CSS for buttons + overlays writes
both `background-color: var(--color)` AND `background-image: var(--color)`.
The `background-image` value is invalid (variable resolves to a color,
not URL/gradient). The browser drops both declarations together during
parse, leaving The7's lower-specificity `.elementor-button { background:
var(--the7-btn-bg) }` rule to win by default.

**Fix:** hardcode hex values directly in JSON `settings` for `button_text_color`,
`background_color`, `button_background_hover_color`, `background_overlay_color`.
Other widgets (heading title, text editor `text_color`) honor `__globals__`
correctly because their per-page CSS doesn't have the invalid companion.

Full cascade analysis logged in
`sites/thefivestar/the7-elementor-specificity-notes.md` (new section
"v4 + The7 button/overlay global-binding finding"). SOP updated with
this as lesson #12.

**Strip-meta function fix (lesson #13 in SOP):** initial compose script
stripped every underscore-prefixed key, deleting `__globals__` silently.
Corrected to strip ONLY the exact authoring-only set
`{_authoring_notes, _TODO, _comment, _meta, _NOTE}`.

### Phase 1.4 Step 1 build spec updated for JSON authoring ✅ (2026-04-26)

`sites/thefivestar/llss-elementor-build-spec.md` reworked:
- Added "How this spec maps to JSON authoring (Workflow C1)" overlay near
  the top — the slot ID binding table, file layout, JSON shape conventions
- Section 1 Hero: bound color references to `fsi*` slot IDs
  (`fsi05lg` Light Grey for subhead, `fsi02gh` Gold Hover for button hover,
  `fsi07ho` Hero Overlay — invalidating prior "NOT a global color" note)
- Section 3 What Happens: rewrote to use Image (64×64 icon) + Heading +
  Text Editor in container — no Icon Box widget. Predicted overrides
  block now confirms zero new scoped CSS needed
- Section 4 Next Summit: bound `fsi06gt` Gold Text Dark, fixed Arial → Roboto
- Section 6 Membership cards: bound `fsi04bd` Border, `fsi01nh` Navy Hover
- Step 7 Production Promotion: rewritten as CLI direct meta-write flow
  (NOT `wp elementor kit import` — broken for kit-content edits per the
  2026-04-25 finding); includes `wp elementor replace_urls` for
  staging→prod URL rewrite

### Phase 1.4 Step 2 mid-checkpoint pair authored ✅ (2026-04-26)

Two of eight section JSON files in
`sites/thefivestar/elementor-templates/event-pages/legal-league-servicer-summit/`:

- **`01-hero.json`** (5507 bytes) — outer container with full-width +
  600px min-height + bg image placeholder + `fsi07ho` overlay binding;
  inner boxed 1100px column container; H1 "Legal League Servicer Summit",
  3 text widgets (event line / subhead / tagline), gold CTA "Join Legal
  League" → /memberships/financial-services-attorneys/. All brand colors
  bind to `fsi*` or system slot IDs via `__globals__`.
- **`08-final-cta.json`** (4754 bytes) — same structure as Hero but
  smaller (400px min-height); H2 "Join Us in Washington" + tagline + gold
  CTA "Get Summit Updates".

Image URLs are placeholders (`url: ""` with `_TODO` notes). Real images
need upload to Media Library before mid-checkpoint visual verify can pass
the "matches WPBakery baseline" criterion. Image placeholders themselves
won't fail the structural verify (sizing/CLS/overlay/typography) — those
can be checked with empty bg.

**Source-of-truth copy reference saved:**
`sites/thefivestar/llss-wpbakery-content.html` — the original WPBakery
page 5094 content, with structure-mapping comments at top showing how
each WPBakery block maps to one of the 8 section JSON files.

**Authoring conventions established:**
- Element IDs use deterministic readable prefixes (`hero-section`,
  `hero-h1`, `hero-cta`, `final-section`, `final-h2`, etc.)
- `_authoring_notes` array as first key (Elementor ignores; useful for
  reviewers)
- Per-field `_TODO` markers for placeholder URLs/images
- Global color bindings use `__globals__: { <prop>: "globals/colors?id=<slot>" }`
  with the corresponding flat property left empty `""`
- Brand color slots: ONLY `fsi*` IDs (never the legacy 7-char IDs)
- System color slots: `primary`, `secondary`, `text`, `accent` (stable)

### Phase 1.4 Pre-work #3 complete: The7 page-title disable meta identified ✅ (2026-04-26)

Meta key `_dt_header_title` accepts `enabled` (default — renders navy bar),
`disabled` (suppresses bar — what we want for LLSS Elementor), `slideshow`
(Revolution Slider home), `fancy` (The7 fancy header). LLSS page-create
during Phase 1.4 step 3 will include
`update_post_meta($page_id, '_dt_header_title', 'disabled');` — no UI step.

### Phase 1.4 Pre-work #4 mostly complete: WPBakery LLSS visual baseline ✅ (2026-04-26)

WPBakery LLSS (page 5094, slug `legal-league-servicer-summit`) captured at
1440 / 768 / 420 viewports as
`sites/thefivestar/visual-baselines/llss-wpbakery-2026-04-26-{viewport}.png`.
Side-by-side reference for Phase 1.4 mid-checkpoint and full-page verify.

🟡 **Still pending:** Lighthouse Slow-4G CLS before-number on WPBakery LLSS.
Phase 1.7 needs the before-number to verify Elementor CLS < 0.1 is an
improvement. Can be captured any time before Phase 1.7 since the WPBakery
page is untouched until then. Easiest path: Chrome DevTools Lighthouse
panel (manual, ~3 min) or `lighthouse-cli` over the staging URL.

### Phase 1.4 Pre-work #2 complete: widget schema oracle bootstrapped ✅ (2026-04-26)

`/kit-test/` page 5099 now contains exclusively Elementor-native widgets
(verified via Playwright `getComputedStyle` + recursive data walk). Schema
oracle saved at `sites/thefivestar/elementor-templates/widget-references/`:

- `kit-test-page-5099.json` — full page export, 8 widget instances across
  7 widget types
- `image-box.json` — Elementor `image-box` widget reference (with
  330×220 explicit dims, H3 title, description)
- `inner-section.json` — v4 nested-container 2-column layout reference

**Widgets covered:** heading, text-editor, button, image, spacer, divider,
image-box, nested container.

**Specificity audit (logged in `the7-elementor-specificity-notes.md`):**
- All Elementor widgets render with kit Roboto/Roboto Slab fonts
- All headings get scoped color/size/weight from kit `custom_css`
- `image-box` titles render at Elementor default 16px/weight 400
  (intentional card-style; no override needed)
- Nested containers render correctly as v4 Flexbox `e-con` with proper
  column splits at 1100px content width

**Icon Box skipped by decision** — The7's Icon Box widgets are mislabeled
in the panel (one was registered as "Icon Box Pro" but is actually a
The7 image-box internally). Standard Elementor icon-box couldn't be
located through the UI. Phase 1.4 "What Happens" section will use
Image (64×64 icon) + Heading + Text Editor inside a container instead —
same visual outcome, theme-agnostic.

**One UI residue stripped via direct meta-write:** A The7 icon-box widget
was nested inside the Inner Section's left column from earlier bootstrap
rounds. Removed surgically via `update_post_meta(_elementor_data)`;
backup saved at `_elementor_data_backup_2026_04_26` post meta.

**Visual baseline:**
`sites/thefivestar/visual-baselines/kit-test-post-bootstrap-2026-04-26.png`.

### Phase 4 IA confirmed: both `/memberships/` and `/communities/` at root ✅

Verified against `brands/fsi/CLAUDE.md` and `docs/decisions.md` 2026-04-23
entries. `/communities/` is a top-level subfolder parallel to
`/memberships/`. Both are root-level paths with their own children.

---

## Completed prior session (2026-04-23)

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

## Files changed this session (2026-04-25)

- `docs/decisions.md` — TWO new top entries: AI-first Elementor authoring
  (with import-system addendum) + Restore prod custom-color slot IDs
- `docs/sops/elementor-json-authoring.md` — **NEW SOP** for Workflow C1;
  rewritten same day to replace the broken `kit import --include=site-settings`
  recommendation with direct `_elementor_page_settings` meta-write pattern;
  added pre-flight slot-usage query; added color-slot-ID convention
- `docs/how-we-update-the-site.md` — Workflow C split into C1/C2
- `sites/thefivestar/elementor-global-kit-spec.md` — reality reconciliation
  table; Roboto fonts (was Arial); 17 custom colors with `fsi*` brand-slot
  convention
- `sites/thefivestar/elementor-kit/site-settings.json` — **NEW**, rewritten
  with renumbered 17 custom_colors (10 prod-preserved + 7 `fsi*` brand)
- `sites/thefivestar/elementor-kit/custom-fonts.json` — **NEW** (decomposed)
- `sites/thefivestar/elementor-kit/custom-code.json` — **NEW** (decomposed)
- `sites/thefivestar/elementor-kit/manifest.json` — **NEW** (decomposed)
- `sites/thefivestar/elementor-global-kit-v1.zip` — **REBUILT** from updated JSON
  (now 6174 bytes, was 5484; md5 `25a4210712ccd82dd72fc22a4e2e1e98`)
- `sites/thefivestar/elementor-templates/widget-references/kit-test-page-5099.json` — **NEW**
- `sites/thefivestar/visual-baselines/kit-test-post-roundtrip-2026-04-25.png` — **NEW**
- `docs/next-chat-handoff.md` — this file

### Files changed prior session (2026-04-23)

- `sites/thefivestar/site-profile.md` — theme/builder stack table,
  kit v1 section, Custom Code inventory, specificity section
- `sites/thefivestar/plugin-inventory.md` — Phase 1.3 status, v4 notes
- `sites/thefivestar/elementor-global-kit-spec.md` — v4-corrected
- `sites/thefivestar/the7-elementor-specificity-notes.md` — new file
- `sites/thefivestar/elementor-global-kit-v1.zip` — new artifact (5.4KB)
- `sites/mortgagepoint/site-profile.md` — MonsterInsights audit
- `docs/how-we-update-the-site.md` — v4 Elementor section rewritten
- `docs/decisions.md` — nav-wiring rule + Phase 4 split entries
- `brands/fsi/CLAUDE.md` — nav rule, IA split, Phase 1.3 note, specificity, v4

---

## Next phase: Phase 1.4 — LLSS Elementor build (JSON-authored)

**Workflow basis:** All authoring is C1 (JSON in repo + WP-CLI push) per
`docs/sops/elementor-json-authoring.md`. The only allowed UI step is
**bootstrap** (Pre-work #2 below) — building one reference instance per
new widget type to capture its v4.0.2 settings schema. After that, all
authoring is JSON-in-repo.

### Pre-work (before any section is built)

**Pre-work #1 — SSH session startup**

Per `docs/sops/ssh-session-startup.md`. Persistent shell, ssh-agent with
`id_ed25519_itmanager`, verify Elementor versions still pinned at 4.0.2 /
4.0.2 (`wp plugin get elementor --field=version`). If versions drifted
since 2026-04-25: stop, investigate, do not proceed until version pin
question is resolved.

**Pre-work #2 — Bootstrap widget schema oracle ✅ COMPLETE 2026-04-26**

Schema oracle in `sites/thefivestar/elementor-templates/widget-references/`
covers: heading, text-editor, button, image, spacer, divider, image-box,
nested container. **Icon Box was skipped by decision** — Phase 1.4 builds
feature-grid icons via Image+Heading+Text in containers (theme-agnostic,
no widget dependency). Specificity audit findings logged in
`sites/thefivestar/the7-elementor-specificity-notes.md` — no new scoped
CSS rules needed (image-box default 16px card title is appropriate).

**Pre-work #3 — The7 page-title disable ✅ COMPLETE 2026-04-26**

Meta key identified: `_dt_header_title`. Accepts these values on FSI:

| Value | Behavior | Pages using it |
|-------|----------|----------------|
| `'enabled'` | Renders The7 navy page-title bar (default) | 172 |
| `'disabled'` | Suppresses the title bar — **what we want** | 20 |
| `'slideshow'` | Replaces title bar with Revolution Slider hero | 6 (Home pages) |
| `'fancy'` | Uses The7 "fancy header" mode | 3 (event lander pages) |

Empty string falls through to `'enabled'`. To disable on a new Elementor
page during page-create:

```php
update_post_meta($page_id, '_dt_header_title', 'disabled');
```

No UI step needed.

**Pre-work #4 — LLSS visual baseline ✅ MOSTLY COMPLETE 2026-04-26**

Full-page Playwright screenshots of WPBakery LLSS page 5094 captured at:
- `sites/thefivestar/visual-baselines/llss-wpbakery-2026-04-26-1440.png` (desktop)
- `sites/thefivestar/visual-baselines/llss-wpbakery-2026-04-26-768.png` (tablet)
- `sites/thefivestar/visual-baselines/llss-wpbakery-2026-04-26-420.png` (mobile)

These are the side-by-side comparison reference for Phase 1.4 mid-checkpoint
and full-page verification.

**🟡 Still pending (not blocking Phase 1.4 kickoff): Lighthouse Slow-4G CLS
before-number on the WPBakery LLSS page.** Phase 1.7 verification requires
Elementor LLSS CLS < 0.1 — we need the before-number to know whether we
improved or regressed. Run via Playwright + lighthouse-cli OR Chrome
DevTools Lighthouse panel. Save report to `visual-baselines/llss-wpbakery-lighthouse-2026-04-XX.json`
or `.html`. Can be run any time before Phase 1.7 since the WPBakery LLSS
page is unchanged through Phase 1.6.

### Phase 1.4 runbook (JSON workflow)

**Step 1 — Write the build spec**

`sites/thefivestar/llss-elementor-build-spec.md`. Section-by-section
intent. 8 sections:

| # | Section | Image spec | Notes |
|---|---------|------------|-------|
| 1 | Hero | Background 1900×600px min-height | H1 + subhead + gold CTA |
| 2 | Intro / Who Belongs | Optional side 560×400px | 2-column, Inner Section |
| 3 | What Happens | Icons 64×64, cards 400×300 | Feature grid |
| 4 | Next Summit callout | No images (min-height only) | Gold background section |
| 5 | Recent Summit photo strip | 3 images, 360×240 each | Loop or manual 3-column |
| 6 | Membership cards | Card images 480×220 each | 2-column feature cards |
| 7 | Event Details | Optional location 800×450 | Text + image 2-column |
| 8 | Final CTA | Background 1900×400 min-height | Full-width with overlay |

Each section spec includes: widget types used (referencing
`widget-references/` shapes), global color bindings (by name from kit),
explicit image dimensions (non-optional, CLS prevention), CSS overrides
predicted from pre-work #2, responsive behavior at 480/768.

**Step 2 — Author each section as JSON in repo**

For each of 8 sections, write a JSON file:

```
sites/thefivestar/elementor-templates/event-pages/legal-league-servicer-summit/
  01-hero.json
  02-intro-who-belongs.json
  03-what-happens.json
  04-next-summit.json
  05-recent-summit-strip.json
  06-membership-cards.json
  07-event-details.json
  08-final-cta.json
```

Each file is one Elementor Pro library template export (single section,
exportable as a `library` template). Build by composing widget shapes
from `widget-references/`. Use deterministic element IDs
(e.g., `hero-h1-title`, not random hashes) for readable diffs.

**Step 3 — Create the LLSS staging page (no UI)**

```bash
# Create empty page on staging — slug is temporary
ssh thefivestarstg 'wp post create \
  --post_type=page \
  --post_status=publish \
  --post_parent=5089 \
  --post_title="Legal League Servicer Summit (Elementor)" \
  --post_name=legal-league-servicer-summit-elementor'
# Note the returned page ID
```

Then write the The7 page-title-disable meta + Elementor mode meta keys
(per pre-work #3) via `wp post meta update`.

**Step 4 — Mid-phase checkpoint: push Hero + Final CTA only**

Push only `01-hero.json` and `08-final-cta.json` to staging. Compose them
into the new page's `_elementor_data`. Run `flush_css`. Verify:

- Playwright screenshot at 1440 / 768 / 420 vs. baseline (pre-work #4)
- Playwright `getComputedStyle` on hero H1, body text, gold CTA — match spec
- Lighthouse CLS < 0.1 under Slow 4G
- Advanced Ads render if Hero/Final CTA include any ad slots
- `wp option get siteurl` no PHP fatals on the page render
- Chrome DevTools console clean (no errors / no CLS flash on reload)

**If checkpoint passes →** push remaining 6 sections (Intro through Event Details).

**If checkpoint fails →** surface findings, pause, re-plan before continuing.
Possible outcomes: widget limitation, template approach rework, or The7
specificity outrunning Custom CSS. The fail mode is bounded — `wp post meta`
can rewrite or clear `_elementor_data` instantly; no UI-induced state to
back out.

**Step 5 — Push remaining 6 sections, full-page verify**

Compose all 8 sections into the page's `_elementor_data`, push, `flush_css`.

Optionally also push each section as its own saved Elementor Pro library
template via `wp elementor library import_dir` for reuse on Velocity (Phase
3) and Events hub (Phase 2). The page-content `_elementor_data` and the
library templates are independent storage; both can coexist.

Run all 8 verification checks:

| # | Check | How | Pass criterion |
|---|-------|-----|----------------|
| 1 | Advanced Ads render | Playwright screenshot inspection | Slots show placeholders or ads |
| 2 | HubSpot forms | Programmatic submit + check HubSpot via MCP | Test entry appears in HubSpot |
| 3 | AIOSEO meta + schema | Playwright `evaluate()` reading `<head>` | `og:title`, `og:description`, article schema populated |
| 4 | Site Kit pageview | Wait + check Site Kit Realtime | Recorded |
| 5 | Responsive | Playwright at 1440 / 768 / 420 | All render correctly |
| 6 | CLS | Lighthouse via Playwright (Slow 4G) | Score < 0.1 |
| 7 | PHP errors | `wp option get siteurl` + Site Health | No fatals |
| 8 | Visual layout shift | Load 3× under Slow 4G via Playwright | No visible jump |

Save the Lighthouse report to
`sites/thefivestar/visual-baselines/llss-lighthouse-elementor-2026-04-XX.json`.

**Step 6 — Write the new SOP**

`docs/sops/new-event-page-elementor.md` — Required sections:

- How to compose a new event page from `event-page/*.json` section sources
- Per-section image dimension table (mandatory)
- How to update the Elementor Pro global kit JSON + rebuild zip + re-import
- The7 page-title disable meta keys + values (no UI)
- Specificity override register (which scoped CSS rules to apply per widget)
- Staging-first + approval gate reminder
- `-old` rename pattern

Also: mark `docs/sops/new-event-page.md` (HTML/WPBakery SOP) with a
deprecation header pointing at the new SOP. Don't delete — it still backs
Velocity and Events hub until Phases 2-3 ship.

**Step 7 — Rename + swap (still staging only, all CLI)**

After Step 5 passes:

```bash
# Rename WPBakery LLSS to -old
ssh thefivestarstg 'wp post update 5094 \
  --post_name=legal-league-servicer-summit-old \
  --post_title="Legal League Servicer Summit (Old WPBakery)"'

# Rename Elementor version to canonical slug
ssh thefivestarstg 'wp post update <NEW_ID> \
  --post_name=legal-league-servicer-summit'

# Flush WP Rocket + WP cache
ssh thefivestarstg 'wp cache flush && rm -rf /sites/thefivestarstg/wp-content/cache/wp-rocket/*'

# Re-verify URL resolves and renders correctly
```

**Step 8 — 🛑 STOP. Approval gate.**

Report: staging LLSS verified, Elementor at canonical slug, WPBakery
renamed to `-old`, CLS [score], computed-style values match spec, all 8
verification checks pass. Ask: "Approve production?"

**Step 9 — Production (only after explicit "yes" in chat)**

LLSS does not exist on prod at the singular slug — this is a create-new
op, not replace-content. All steps via CLI.

1. Push current `elementor-global-kit-v1.zip` to prod uploads
2. `wp elementor kit import ... --include=site-settings,custom-code,custom-fonts --user=<prod_admin_id>` on prod
   (broader than staging because prod doesn't yet have these — confirm
   what's already there first via export + diff)
3. `wp elementor flush_css` on prod
4. Push `event-page/*.json` to prod uploads, `wp elementor library import_dir`
5. Create the LLSS page on prod via `wp post create`, write
   `_elementor_data` from composed sections, write The7 page-title-disable
   meta, `wp elementor flush_css`
6. `wp elementor replace_urls https://thefivestarstg.wpenginepowered.com https://thefivestar.com`
   to clean any embedded staging URLs
7. Run all 8 verification checks against `https://thefivestar.com/events/legal-league-servicer-summit/`
8. **DO NOT wire into nav** — per nav-wiring rule. Page publishes to a
   live URL but stays unlinked until explicit nav-wiring approval.
9. WPBakery `-old` version stays staging-only.

---

## Parallel work (can happen alongside Phase 1.4)

| Item | Effort | Value | Blocker? |
|------|--------|-------|----------|
| Promote 4 plugin deletions to prod (Jonathan handles manually) | Per-plugin approval gate | Low (hygiene) | None |
| MP MonsterInsights cleanup (disable Site Kit GA4) | 15 min staging + approval gate | Medium (ends double-counting) | MP staging SSH alias not in `~/.ssh/config` |
| MP Elementor Pro 3.35.1 → 4.0.3 upgrade path | 1-2hr on MP staging | Medium (unblocks Phase 7 AMAA reference) | MP staging SSH alias |
| FSI deprecation pass (~200 legacy pages) | 1-2hr once GA4 data in hand | High (trims Phase 6 scope) | Needs GA4 / Site Kit data export |
| Elementor Custom Code audit (Naylor + Apollo) | 30 min | Low | None |

**Recommended pick for next session:** Pre-work #2 (bootstrap widget schema
oracle for Icon Box, Image Box, Inner Section + run specificity audit on the
expanded `/kit-test/`). It's the single highest-leverage step — unlocks
Phase 1.4 section authoring entirely, and produces specificity-override
rules that go into the kit's `custom_css` block (re-import once, applies
forever).

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
