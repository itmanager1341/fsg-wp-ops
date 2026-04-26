# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-04-26 (LLSS Elementor LIVE on staging at canonical
              slug; pending image content population + Phase 1.11 prod
              promotion approval)
Last completed: Phase 1.4 LLSS rebuild fully through Step 5 + Step 7.
                All 9 sections rendering at staging canonical slug. Option B
                pattern (Elementor structural containers + HTML widgets for
                content sections) proven: 45% smaller _elementor_data, 75%
                fewer widgets, visual parity with WPBakery design via
                fsi-event-styles.php CSS. Decision logged in decisions.md
                2026-04-26. Migration tracker updated.
Next phase: Image content population (Jonathan uploads to Media Library,
                sends URLs in chat, I update JSON files + push). After
                images visually verified → Jonathan approves Phase 1.11 →
                production promotion via the proven CLI workflow.

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

15. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/llss-elementor-build-spec.md` (look at top "Updated 2026-04-26: Option B pattern" block first)
16. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/llss-wpbakery-content.html` (authoritative copy reference)
17. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-templates/event-page/` (the 9 section JSON files — quick scan)

Then confirm you've read them and summarize:

- The 2026-04-26 Option B decision (Elementor structural containers + HTML
  widgets for content sections) — what it solved, why we pivoted, the
  performance numbers
- Where each of the 9 LLSS sections lives in `elementor-templates/event-page/`
  and which are widget tree (1, 8, 9) vs HTML widget (2-7)
- The image-swap workflow for HTML widget content (placeholder div →
  `<img>` tag inside the JSON's `html` setting)
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

Do not proceed until that summary is confirmed.

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
| Step 6: New SOP `docs/sops/new-event-page-elementor.md` | ⏳ PENDING | Should write before Phase 2/3 use Option B pattern. Documents: clone Option B sections, populate event-specific copy, image dimension reference, push pipeline. |
| Step 7 (Phase 1.11): Production promotion | ⏳ PENDING | Awaiting explicit Jonathan approval. Path documented in earlier handoff entries. |

**Pre-prod content tasks (not in spec):**
- 🟢 **Image content population** (front-loaded above as first-thing-next-session)
- 🟡 **Lighthouse Slow-4G CLS before-number** on the WPBakery `-old` page (Pre-work #4 carry-forward) — needed for Phase 1.7 verification gate; capture any time before Phase 1.11
- 🟡 **Save sections as Elementor Pro library templates** for Phase 2/3 cloning — `wp elementor library import_dir` against the section JSON files. Useful but not blocking.

**Carry-forward (non-blocking):**
- WP auto-update disable for Elementor + Pro on FSI staging + prod (enforces 4.0.2 / 4.0.2 version pin)
- `claude gray` color (slot `dc145d8` `#6B7A8D`) cleanup — purpose unknown
- `_elementor_page_settings_backup_*` meta-key pruning on kit 4004 + page 5106 (keep 2-3 most recent)
- Velocity page 4436 deprecation pass (uses 3 of 7 contested slot IDs but renumber preserves them; not urgent)

### 🟢 First-thing-next-session — image content population

LLSS Elementor staging page has **6 image placeholders** + **2 background
image slots** waiting for real photos. Workflow (Jonathan-driven):

1. **Jonathan uploads images** to Media Library via WP Admin
   (`https://thefivestarstg.wpenginepowered.com/wp-admin/upload.php`)
2. **Jonathan pastes URLs into chat** with this format:

```
Hero bg (1900×600): <url>
Final CTA bg (1900×400): <url>  (can reuse Hero or use a different shot)
Community photo (1100×440): <url>
Photo strip 1 (360×240, panel): <url>
Photo strip 2 (360×240, networking): <url>
Photo strip 3 (360×240, room): <url>
Membership card 1 firm (480×220): <url>
Membership card 2 corporate (480×220): <url>
```

3. **AI updates the 4 affected JSON files**:
   - `01-hero.json` → set `background_image: { url, id }`
   - `02-intro-who-belongs.json` → swap community-photo placeholder div
     for `<img>` tag inside the HTML widget
   - `05-recent-summit-strip.json` → 3 placeholder swaps
   - `06-membership-cards.json` → 2 placeholder swaps
   - `08-final-cta.json` → set `background_image: { url, id }`

4. **AI pushes via standard `wp eval-file` pipeline** + `wp elementor flush_css` + WP Rocket flush

5. **AI captures fresh screenshots at 3 viewports** for visual sign-off

6. **Jonathan visually approves** → ready for Phase 1.11 production promotion

If Jonathan would rather do swaps via the Elementor UI instead of JSON,
the workflow is: open page in Elementor editor → click on the placeholder
div → swap HTML in the code panel. JSON workflow keeps source-of-truth in
git; UI workflow is faster but un-versioned.

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
`sites/thefivestar/elementor-templates/event-page/`:

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
sites/thefivestar/elementor-templates/event-page/
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
