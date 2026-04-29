# Decision Log

Architectural and operational decisions for the FSG Media WordPress portfolio.
Format: date, decision, rationale, alternatives considered, consequences.

New decisions go at the top.

---

## 2026-04-28 PM — Phase 4a-hub redesign: Memberships hub literal-foundation hierarchy (Alliance below specialty grid)

**Decision:** Memberships hub (page 5138) restructured in place to use
spatial layout as the carrier of organizational hierarchy. Six specialty
memberships sit on top as standing structures; Alliance sits underneath
as the universal foundation. The previous 1+3+3 layout (Alliance-as-hero
+ 6-card specialty grid) put Alliance above the specialties, which read
as "Alliance is the headline membership" instead of the intended "Alliance
is the universal foundation under all of them."

Two intermediate iterations were tried and rejected before landing on the
foundation-strip layout:

| Iteration | Layout | Rejected because |
|-----------|--------|------------------|
| v4 (5:15p) | Alliance umbrella band between hero and specialty grid | Created two navy bands stacked; Alliance still read as "above" specialties |
| v5 (5:42p) | Alliance integrated as 3-col-spanning featured tile inside specialty grid | Alliance dominated the grid visually; conflated "specialty" with "foundational" |
| **Final (6:03p)** | Alliance as dedicated foundation strip BELOW the 6-tile grid | Spatial layout communicates "underneath every specialty above" without explanation |

**Final structure (4 sections, ~14.5 KB `_elementor_data`):**

| # | Section | Bg | Notes |
|---|---------|-----|-------|
| 01 | Hero | Navy | "PROFESSIONAL MEMBERSHIPS" eyebrow / "The seven memberships that organize this work" H1 / practitioner-focused description naming Alliance as "universal foundation underneath them all" |
| 02/03 | Specialty grid | Offwhite | 6 tiles in 3-column CSS grid: FORCE / Legal League / NMSA / MSEA / PPEF / AMDC. Each tile: logo + title + community subtitle + description + two buttons (Community ← / → Member Portal). **NO Alliance tile.** |
| 04 | Alliance foundation strip | Offwhite | Gold "The Foundation" eyebrow / Alliance logo / copy explicitly referencing being "underneath every specialty above" / contact CTA. White card on offwhite palette + gold top accent (matches specialty tiles for visual cohesion while spatial placement establishes the foundation relationship) |
| 05 | Footer-line | White | Standard pattern |

**Color rhythm:** Navy → Offwhite → Offwhite → White. Single navy band
(hero only) — addresses the prior "navy dominance" critique that drove
the v4/v5 iterations.

**Removed from prior layout:**
- Old Section 02 navy Alliance umbrella band (the v4 attempt)
- Alliance featured tile from specialty grid (the v5 attempt)
- Old Section 04 "Not sure where you fit?" CTA (mockup-era; conflated funnel steps)
- Redundant secondary "Memberships" heading

**Copy fix:** PPEF description corrected from "standards body" to
"membership organization" (was a factual error inherited from the
mockup).

**Section JSON files (in-place updates on `membership-pages/_hub/`):**

| File | Status |
|------|--------|
| `01-alliance-hero.json` | Updated 2026-04-28 17:51 (filename retained but content is now "seven memberships" hero, not Alliance-focused) |
| `03-specialty-grid.json` | Updated 2026-04-28 17:52 (6 tiles, no Alliance) |
| `04-alliance-foundation.json` | NEW 2026-04-28 17:55 (Alliance foundation strip) |
| `05-footer-line.json` | Unchanged from 2026-04-27 |
| `02-communities-intro.json` | REMOVED |
| `04-not-sure-cta.json` (or equivalent) | REMOVED |

**Deployment:** Elementor v4.0.2 data composed from 4 section files,
prior content backed up to `_elementor_data_backup_*` meta key,
pushed via `wp eval-file` pipeline, full cache flush (Elementor +
Varnish + memcached + WP core + WP Rocket). All 10 verification
criteria passed including new hero copy, Alliance foundation
positioning + "underneath every specialty above" messaging,
all 6 specialty tiles present, removal of redundant "Memberships"
heading and old "Not sure" CTA, single navy band.

**Phase 4a-hub.11 production promotion gate** — still pending Jonathan
approval. Independent of all other Phase .11 gates. Production ops:
- Verify all 7 logos in prod media library before push
- Push 4-section `_elementor_data` via direct meta-write
- Slug + parent swap of prod Memberships page

**Why this matters as a pattern (transferable to other hubs):**
spatial layout as communication device — when an organizational
relationship is "X sits underneath all of Y" or "X is the foundation
for Y," put X physically below Y in the layout instead of explaining
the relationship in copy. Reader grasps it immediately without reading.

---

## 2026-04-28 — Phase 4b-hub: Communities hub Elementor in-place swap on page 5108 (revised after Jonathan's flow correction)

**Decision:** Communities hub Elementor-rebuilt **in place** at canonical
`/communities/` slug. Second in-place swap in the FSI migration (after
Phase 2 Events hub). Required because page 5108 already has a child
(`/communities/real-estate-professionals/` page 5109 from Phase 4b RE
Pros build) — renaming 5108 would break the canonical RE Pros URL.

**Initial build had AMDC band + MortgagePoint strip + membership logos
on cards. After Jonathan's UI/UX critique + flow correction, the page
was rebuilt with a tighter scope:**

- AMDC dropped — it's a membership organization, lives on `/memberships/` hub
- Membership logos + subtitles dropped from cards — communities are broader than memberships
- Card body copy reframed to community-level (practitioners + lifecycle role), not membership-level
- MortgagePoint strip dropped — not about communities; lives on its own URL + site footer
- Soft Memberships CTA added at bottom — pulls Step 2 readers (community identification)
  toward Step 3 (Five Star Alliance) via /memberships/ hub

**Audience flow underlying the redesign:**

```
Step 1: Free MortgagePoint subscriber       (industry-curious anyone)
Step 2: Identify as a community             ← /communities/ hub serves HERE
Step 3: Join Five Star Alliance             (universal foundation membership)
Step 4: Join a specialty Membership         (FORCE / NMSA / MSEA / Legal League / PPEF)
```

The hub's only job is Step 2. Step 3+4 pitching belongs on community
detail pages and Memberships hub. Anything that conflates the steps is
funnel skip.

**Final section structure (6 sections, 16,282 B `_elementor_data`):**

| # | Section | Bg | Notes |
|---|---------|-----|-------|
| 01 | Hero | Navy | "PROFESSIONAL COMMUNITIES" eyebrow / Roboto Slab serif H1 "The four professions that keep housing moving." (with "housing" italic gold) / tagline |
| 02 | Grid intro | Offwhite | "THE COMMUNITIES" eyebrow / "Four professions, one association." H2 / "Each community is distinct. Each is indispensable. The handoffs between them are where FSI's work happens." |
| 03 | 2×2 community grid | Offwhite | 4 cards (Mortgage Finance / Financial Services Law / Real Estate / Property Preservation). Each card: H3 + 1-paragraph community-level body + cream/gold callout ("Where..." parallel structure) + anchor event chips (no month suffix) + Learn More CTA. **NO logos. NO membership subtitles.** Min-height aligned via flex-column + per-row min-heights + margin-top:auto on CTA. |
| 04 | FSC convergence | Navy | "FIVE STAR CONFERENCE" eyebrow / serif H2 "All four communities. One room. *Once a year.*" / date / 4 community badges (AMDC removed) / Register CTA |
| 05 | Memberships CTA | White | Inline pill: "Want to shape your industry? Explore our Memberships to lend your voice to change that matters." → /memberships/ |
| 06 | Footer-line | White | Standard contact strip |

**Color rhythm (post AMDC drop):** Navy → Offwhite → Offwhite → Navy → White → White. 3 surfaces cycling, no consecutive navy bands.

**Card alignment via min-heights:**

| Row | Constraint |
|-----|-----------|
| Body paragraph | min-height:130px |
| Cream/gold callout | min-height:84px |
| Event chips row | min-height:42px |
| CTA | margin-top:auto |

**CTA routing:**

| Card | Target | Status |
|---|---|---|
| Mortgage Finance Learn More | `/communities/` parent stub | Phase 4b sibling will resolve |
| Financial Services Law Learn More | `/communities/` parent stub | Phase 4b sibling will resolve |
| Real Estate Learn More | `/communities/real-estate-professionals/` | ✅ live |
| Property Preservation Learn More | `/communities/` parent stub | Phase 4b sibling will resolve |

**Anchor event chip routing (no month suffix per Jonathan):**

| Chip | Target |
|---|---|
| LLSS | `/events/legal-league-servicer-summit/` ✅ |
| Velocity | `/events/velocity/` ✅ |
| Government Forum | external `fivestargovernmentforum.com/2026` ✅ |
| Five Star Conference | external `fivestarconference.com/2026` ✅ |

**In-place swap technique** (per SOP Lesson #24): direct meta-write to
5108 with backup at `_elementor_inplace_swap_backup_2026_04_28_165343_*`
meta keys.

**Verification (server-side curl):**
- `.elementor.elementor-5108` wrapper ✅
- All 6 sections ✅
- 4 card titles correct ✅
- 0 membership logos in card content ✅
- 0 AMDC mentions in section content (1 in sitewide footer widget — chrome) ✅
- 0 MortgagePoint mentions in section content ✅
- /memberships/ link present (Section 5 CTA) ✅
- Both child URLs preserved (RE Pros + RE Pros old) ✅

**Cleanup item flagged (sitewide, not blocking):** site footer's
"Membership Groups" widget link → `/memberships-old/` (post-Phase-4a-hub
slug-swap drift). Should update to `/memberships/` on staging + prod.

**Phase 4b-hub.11 production promotion gate** — pending Jonathan
approval. Independent of all other prod gates.

**All four FSI hubs Elementor-native on staging:**

| Template | Page | Status |
|---|---|---|
| FSI Event Page (LLSS, Velocity) | 5106, 5107 | ✅ |
| FSI Community Page (RE Pros) | 5109 | ✅ |
| FSI Events Hub | 5089 (in-place) | ✅ |
| FSI Memberships Hub | 5138 | ✅ |
| FSI Communities Hub | 5108 (in-place) | ✅ |

The structural template work is done. Remaining: individual Phase 4a
Membership pages (FORCE / Legal League / etc. — 7 greenfield) +
Phase 4b community siblings (Mortgage Finance / Legal / Prop Pres — 3
greenfield) + production promotion gates for all staged pages.

---

## 2026-04-27 — Phase 2: Events hub Elementor in-place swap on page 5089

**Decision:** Events hub (page 5089) Elementor-rebuilt **in place** at
canonical `/events/` slug. **First in-place swap** in the FSI Elementor
migration (LLSS / Velocity / RE Pros / Memberships hub all used
create-new + slug-swap pattern). Reason: page 5089 has 4 children
(LLSS, Velocity, and their `-old` WPBakery variants). Renaming 5089's
slug to `-old` would have broken all child URLs (e.g.,
`/events/velocity/` → `/events-old/velocity/`), undoing the canonical
URLs we shipped in Phases 1.4 + 3.

**In-place swap technique:**

1. Compose new Elementor `_elementor_data` JSON (5,292 bytes / 2 sections)
2. Backup 5089's current state to `_elementor_inplace_swap_backup_*` meta keys:
   - `_*_post_content` (the WPBakery shortcodes — 4,841 bytes)
   - `_*_elementor_data` (was empty)
   - `_*_elementor_edit_mode` (was empty)
3. Apply Elementor mode meta: `_elementor_edit_mode='builder'`,
   `_elementor_template_type='wp-page'`, `_elementor_version='4.0.2'`,
   `_elementor_pro_version='4.0.2'`
4. Write new `_elementor_data` via `update_post_meta` + `wp_slash`
5. Clear `post_content` to empty string (Elementor takes precedence
   over `post_content` once `_elementor_edit_mode='builder'` is set,
   but clearing is cleaner for fallback safety)
6. Standard cache flush sequence (Lesson #16): Elementor `flush_css` +
   `wp cache flush` + `rm -rf wp-rocket/*` + `WpeCommon::purge_varnish_cache_all()` +
   `WpeCommon::purge_memcached()`
7. Trash the unused provisional page 5139 (created during the
   compose/verify phase before the in-place swap technique was
   identified as the right approach)

**Verification:**

- `/events/` serves wrapper class `.elementor-5089` ✅
- `.fsi-hub-intro` + 4 `.fsi-event-card` blocks present ✅
- 4 child URLs unchanged: `/events/legal-league-servicer-summit/`,
  `/events/velocity/`, plus the two `-old` variants — all return HTTP 200 ✅
- `_dt_header_title='enabled'` preserved → "EVENTS" navy page-title bar
  still renders (matches existing WPBakery design)

**FSI Events Hub template — characteristics:**

- 2 sections (lightest of any migrated FSI page so far)
- Total `_elementor_data`: 6,292 bytes (vs Memberships hub 18,451 / RE Pros 20,019 / LLSS 22,032 / Velocity 18,178)
- Total `.elementor-element` count: 6 (4 fewer than Memberships hub)
- All sections HTML widgets — preserves existing `.fsi-event-card` /
  `.fsi-event-date` / `.fsi-event-label` design verbatim per Option B
- `_dt_header_title='enabled'` (other migrated pages used `disabled` but
  the Events hub looks better with the navy "EVENTS" page-title bar)
- No bg images, no logos, no widget trees — pure Option B HTML widgets

**SOP Lesson #24 added:** "In-place swap" pattern for hub pages with
children. When the page being migrated is a parent with child pages,
use direct meta-write to the existing post ID rather than the
create-new + slug-swap pattern. Always backup `post_content` +
`_elementor_data` to timestamped meta keys first. Verify all child
permalinks resolve post-swap.

**Cross-link audit (8 buttons across 4 cards):**

| Card | Learn More | Register / Join |
|------|-----------|-----------------|
| LLSS | `/events/legal-league-servicer-summit/` ✅ live Elementor | `/memberships/financial-services-attorneys/` ⚠️ 404 today (Phase 4a will resolve) |
| Government Forum | external `fivestargovernmentforum.com/2026` ✅ | external swoogo URL ✅ |
| Velocity | `/events/velocity/` ✅ live Elementor | external swoogo URL ✅ |
| Five Star Conference | external `fivestarconference.com/2026` ✅ | external swoogo URL ✅ |

Only one stale internal link (LLSS Join Legal League). Preserved as-is
for migration faithfulness; Phase 4a will resolve when individual
Membership pages are built.

**Phase 2.11 production promotion gate** — pending Jonathan approval.
Independent of Phase 1.11 LLSS, Phase 3.11 Velocity, Phase 4b.11 RE
Pros, Phase 4a-hub.11 Memberships. Production ops:
- In-place swap on prod /events/ page (whatever ID it is — likely
  matches staging 5089)
- Same technique: backup + meta-write + clear post_content + flush
- Verify all child URLs unchanged on prod (LLSS, Velocity, etc.)

**Three FSI hubs migration status (all hub-shape pages):**

- Events hub `/events/` ✅ (Phase 2, this entry)
- Memberships hub `/memberships/` ✅ (Phase 4a-hub, prior entry)
- Communities hub `/communities/` — stub created Phase 4b; needs
  authored content when more community children exist

---

## 2026-04-27 — Phase 4a-hub: Memberships hub Elementor at canonical staging slug

**Decision:** Memberships hub (page 2597) Elementor-rebuilt and live at
canonical staging slug `/memberships/`. New page 5138 establishes the
**FSI Membership Hub template** — third hub-shape page after Phase 2
Events hub (pending) and Phase 4b Communities hub (stub at 5108).
Distinct from the still-pending FSI Membership Page template (Phase 4a
individual pages for FORCE / Legal League / etc.).

**Operations executed:**

1. Captured WPBakery hub baseline (page 2597) at 1440/768/420 →
   `visual-baselines/memberships-hub-wpbakery-2026-04-27-{vp}.png`.
2. Authored 5 section JSON files in
   `sites/thefivestar/elementor-templates/membership-pages/_hub/`
   following Jonathan's 10 locked design decisions on the mockup.
   Element ID prefix `mhub-*`.
3. Created Elementor page 5138, parent 0, all v4.0.2 meta + `_dt_header_title='disabled'`.
4. Composed + pushed via `wp eval-file` pipeline. Total
   `_elementor_data`: 18,451 bytes / 5 sections / 11 `.elementor-element` count.
5. Slug swap: 2597 → `memberships-old` "(Old WPBakery)"; 5138 →
   `memberships` canonical.

**FSI Membership Hub template — characteristics:**

- 5 sections (lighter than detail pages: 9 LLSS / 8 Velocity / 8 RE Pros)
- 1+3+3 layout: featured Alliance hero (navy full-bleed) + 2x3 specialty grid
- All sections HTML widgets (no widget-tree heroes — hub-page convention)
- Roboto Slab serif treatment on H1/H2/card H3s — distinguishes hub-typography
  from detail-pages' Open Sans Condensed default
- `text-transform:none` explicitly applied to override The7 default
  uppercase on H1/H2 (lesson #22 below)

**Section structure:**

| # | Section | Bg | Notes |
|---|---------|-----|-------|
| 01 | Alliance hero | Navy full-bleed | Membership Foundation eyebrow / Alliance logo (5136) / Five Star Alliance H1 / gold rule / tagline / 4-up benefits (Events / Media / Education / Community — FSI Offers swapped per decision #1) / 2 CTAs (Join → mailto, What's Included → /communities/real-estate-professionals/#alliance-tier) |
| 02 | Communities intro | Offwhite | Professional Communities eyebrow / "Go deeper in your community" H2 |
| 03 | Specialty grid 2x3 | Offwhite | 6 cards (FORCE / Legal League / NMSA / MSEA / PPEF / AMDC) — each: logo box, title, community subtitle, description, two buttons (Community ← / → Member Portal). AMDC = single button (cross-community). NO pricing or status badges per decision #3. |
| 04 | "Not sure where you fit?" CTA | White | Inline (not sticky) — Alliance pitch + GET STARTED → mailto |
| 05 | Footer-line | White | Standard pattern |

**Key locked design decisions (per Jonathan 2026-04-27):**

1. Swap FSI Offers → Community in Alliance benefits
2. Keep Roboto Slab serif H1 — visual experiment
3. NO pricing, NO status badges (cleaner: implicit "apply" framing). Drop "seven principal companies" from PPEF
4. Adopt mockup community subtitles per card
5. Two buttons on every card (Community + Member Portal), routing non-RE-Pros community links to `/communities/` stub for now
6. AMDC single button (cross-community)
7. Adopt mockup copy verbatim (with PPEF edit)
8. Inline "Not sure where you fit?" CTA, not sticky
9. New FORCE COLOR logo uploaded (5137)
10. JOIN → `mailto:membership@thefivestar.com`

**Logo asset assignments:**

| Card | Asset ID | URL (medium variant) |
|------|----------|---------------------|
| Alliance (hero) | 5136 | /wp-content/uploads/2026/04/FS_Alliance_Logo_v2-300x116.png |
| FORCE | 5137 | /wp-content/uploads/2026/04/FSI-Brand-logo_FORCE_COLOR-300x78.png |
| Legal League | 5131 | /wp-content/uploads/2026/04/FSI-Brand-logo_LL_COLOR-300x78.png |
| NMSA | 5127 | /wp-content/uploads/2026/04/FSI-Brand-logo_NMSA_COLOR-300x83.png |
| MSEA | 5133 | /wp-content/uploads/2026/04/FSI-Brand-logo_MSEA_COLOR-300x83.png |
| PPEF | 5129 | /wp-content/uploads/2026/04/FSI-Brand-logo_PPEF_COLOR-300x83.png |
| AMDC | 5126 | /wp-content/uploads/2026/04/FSI-Brand-logo_AMDC_COLOR-300x83.png |

All logos load and render correctly (`naturalWidth/naturalHeight` matches
URL-specified dimensions; `complete=true` post-scroll on every image).

**The7 heading-uppercase override (SOP Lesson #22):** Initial push
rendered all H1/H2/H3 as ALL CAPS because The7's CSS applies
`text-transform: uppercase` globally to headings. Roboto Slab + the
correct font-family loaded fine, but the visual was broken (mockup
intent was title-case "Five Star Alliance"). Fix: add explicit
`text-transform:none` to every heading inline style. Affects any future
HTML-widget-authored heading on FSI staging — the mu-plugin's heading
overrides also need an audit but for now the per-section fix works.

**Phase 4a-hub.11 production promotion gate** — pending Jonathan
approval. Independent of Phase 1.11 LLSS, Phase 3.11 Velocity, Phase
4b.11 RE Pros. Production ops:
- `wp post create` page on prod with same Elementor v4.0.2 meta
- Push 5-section `_elementor_data` via direct meta-write
- All 7 logos already in prod media library? — verify before push
- Slug + parent swap of prod Memberships page (whatever ID it is)

**Path forward for the 6 specialty Memberships pages:**

When Phase 4a (individual Membership pages) kicks off, each card's
"Member Portal" right button will likely stay external (member sites
own the portal experience). The "Community" left button currently
routes 4 of 5 to `/communities/` stub — those will route to per-community
pages (Legal, Mortgage Finance, Prop Pres) once Phase 4b builds them.
FORCE → RE Pros community already lives.

---

## 2026-04-27 — Phase 4b: Real Estate Professionals Elementor at canonical staging slug + `/communities/` parent created

**Decision:** Phase 4b first-instance build complete on staging. The
existing RE Pros mockup (page 5087) was Elementor-rebuilt and relocated
from `/memberships/` to `/communities/`, establishing the FSI Community
Page template + the `/communities/` URL hierarchy.

**Operations executed:**

1. Created `/communities/` parent (page 5108) — root-level, status
   publish, `_dt_header_title='disabled'`, minimal stub content. Ready
   for Phase 4b sibling community pages (Mortgage Finance, Legal,
   Prop Pres). Nav-wiring deferred per standing rule.
2. Authored 8 section JSON files in
   `sites/thefivestar/elementor-templates/community-pages/real-estate-professionals/`.
   Element ID prefix `repro-*`. Path A (inline styles preserved per
   Velocity precedent) — class extraction deferred to Phase 4b's 2nd
   community page or Phase 4a kickoff.
3. Created new Elementor page 5109 under `/communities/` parent.
4. Composed + pushed via the proven Python compose + `wp eval-file`
   pipeline. Total `_elementor_data`: 20,019 bytes / 8 sections / 16
   `.elementor-element` count (lighter than LLSS/Velocity because no
   widget-tree hero — all sections are HTML widgets).
5. Slug + parent swap:
   - Existing 5087 → `/communities/real-estate-professionals-old/`
     (renamed + reparented from `/memberships/`)
   - New 5109 → `/communities/real-estate-professionals/` (canonical)
6. 301 redirect added via `eps-301-redirects` plugin: source
   `memberships/real-estate-professionals` → target post 5109. Verified
   firing (returns HTTP 301 → 200 follow chain). Production unchanged.
7. Velocity cross-links updated (3 places) from
   `/memberships/real-estate-professionals/` to
   `/communities/real-estate-professionals/`:
   - `velocity/04-charter-offer.json`
   - `velocity/06-membership-cards.json`
   - `velocity/09-footer-line.json`
   Recomposed + pushed Velocity page 5107; rendered HTML verified.

**FSI Community Page template — first-instance characteristics:**

- 8 sections (vs Event Page's 9; no past-event photo strip applies)
- Centered-text header with gold border-bottom (NO bg-image hero) —
  deliberate visual distinction from Event pages
- Pricing-tier-cards is the dominant Section 3 visual (Free / Alliance
  / FORCE) — pattern likely recurs across all Community pages
- Two callouts (Founding Institutional Partner gold-left-border +
  Charter Member Rate gold-fill) — eligibility-vs-promotion contrast
- Governance section is Community-template-distinctive (every
  community has practitioner-led Advisory Council)
- All sections HTML widget per Option B (Velocity precedent)

**Audit pass (Playwright + getComputedStyle, 1440):** 8/8 sections in
DOM; H1 navy `rgb(31,54,92)`; Charter callout present; FIP callout
present; The7 page-title bar suppressed; canonical Elementor wrapper
`.elementor.elementor-5109` present.

**EPS-301 plugin gotcha (worth documenting):** The `eps-301-redirects`
plugin matches incoming requests against the FULL request URI including
query string. A cache-buster like `?cb=12345` BREAKS the match (returns
404). Real users hitting bare URLs are redirected correctly; cache-bust
testing must hit the bare URL to verify redirect behavior. Documented
as SOP lesson #20.

**Phase 4b.11 production promotion gate** — pending Jonathan approval.
Independent of Phase 1.11 LLSS, Phase 3.11 Velocity. Production ops:
- Replicate `/communities/` parent creation on prod
- Replicate page 5109 + JSON push on prod
- Replicate 301 redirect insertion on prod (`eps-301-redirects` is
  already active on prod per plugin-inventory)
- Slug + parent swap of prod RE Pros page (if it exists at
  `/memberships/real-estate-professionals/`) — verify first
- Cross-link updates to prod Velocity page (when Phase 3.11 ships)

**Path A vs Path B follow-up:** Phase 4b shipped with inline styles
(Path A). Class-extraction (Path B) is deferred until either (a) Phase
4b's 2nd community page is authored (Mortgage Finance / Legal / Prop
Pres) so the recurring patterns are concrete, OR (b) Phase 4a kickoff
where Membership Page template authoring begins and shared CSS would
benefit both templates. At that point: rename `fsi-event-styles.php` →
`fsi-shared-styles.php` and add `.fsi-tier-card*`, `.fsi-callout-light`,
`.fsi-events-card*` classes via Workflow A.

---

## 2026-04-27 — IA clarification: three parent-child hierarchies, three templates

**Decision:** FSI's Elementor migration is organized as three distinct
parent-child URL hierarchies, each backed by its own template. This
clarifies the 2026-04-23 Phase 4 IA-split decision (which named two
templates — Membership and Community) by adding the Event template
already proven in Phases 1-3 and locking the parent-child mapping.

| Hierarchy | Parent | Children | Template | Status |
|-----------|--------|----------|----------|--------|
| Events | `/events/` (page 5089) | Velocity, LLSS, Five Star Conference, Government Forum, … | **FSI Event Page** (Option B) | Two children migrated (LLSS 2026-04-26, Velocity 2026-04-27); Phase 2 Events hub itself + remaining children pending |
| Memberships | `/memberships/` (page 2597) | FORCE, Legal League (firms), AMDC, PPEF, NMSA, MSEA, Five Star Alliance | **FSI Membership Page** | Phase 4a — greenfield; none of these pages exist yet on staging |
| Communities | `/communities/` (NEW) | Real Estate Professionals, Mortgage Finance, Legal, Prop Pres | **FSI Community Page** | Phase 4b — `/communities/` parent doesn't exist; existing RE Pros mockup at `/memberships/real-estate-professionals/` (page 5087) relocates here |

**IA distinction (the reason for two non-event templates):**

- **Memberships** = formal member groups (organizational affinity).
  FORCE is a credentialed certification program; Legal League is a
  firm-membership organization. People *belong to* a Membership.
- **Communities** = profession-based audience cuts (practitioner
  affinity). "Real Estate Professionals" is the community of agents,
  brokers, and investors; "Legal" is the broader attorney audience
  including non-Legal-League practitioners. People *identify with* a
  Community.

The two hierarchies are related (FORCE membership lives within the RE
Pros community; Legal League membership lives within the Legal
community). But URLs and visual templates are distinct because the IA
intent is distinct.

**Implications for next-phase planning:**

1. **Phase 4b (Community Page template) leads Phase 4a.** The RE Pros
   mockup at `/memberships/real-estate-professionals/` (page 5087) is
   already designed and copy-locked. Use it as the visual reference for
   the FSI Community Page template. First-instance build relocates the
   page to `/communities/real-estate-professionals/`.
2. **Phase 4a (Membership Page template) is fully greenfield.** No
   existing Membership-tier pages exist on staging. Visual design must
   be drafted before any authoring begins, and must be visually
   distinct from the Community template (per Jonathan 2026-04-23).
3. **Cross-hierarchy linking:** Velocity's Charter Offer + Membership
   Cards + Footer-line all link to `/memberships/real-estate-professionals/`.
   When the page moves to `/communities/`, those links update
   accordingly. A 301 redirect from old to new handles any external
   inbound links.

**Relationship to prior decisions:**

- **2026-04-22 portfolio standardization:** Elementor + Elementor Pro
  is the forward builder portfolio-wide. Unchanged.
- **2026-04-23 Phase 4 IA split:** Membership and Community are two
  distinct templates. Confirmed and extended (Event is a third
  template, already proven).
- **2026-04-23 nav-wiring rule:** New nav entries require explicit
  approval. `/communities/` parent will require fresh nav approval
  before being added to top-nav. The standing exception is Phase 2
  Events hub `/conferences/` → `/events/`.
- **2026-04-26 Option B pattern:** HTML-widget-with-CSS-classes
  approach is now the architectural default for FSI page authoring.
  Both Membership and Community templates will use it. Whether the
  CSS classes live in `fsi-event-styles.php` or a renamed
  `fsi-shared-styles.php` is a per-template decision (see Phase 4
  build-plan discussion).

---

## 2026-04-27 — Phase 3 Velocity Elementor at canonical staging slug

**Decision:** Slug swap executed on staging:
- Page 5088 (WPBakery Velocity) renamed to `velocity-old`, title
  "Velocity (Old WPBakery)"
- Page 5107 (Elementor Velocity) renamed to `velocity`, title "Velocity"

**Status:** Live at the canonical staging URL
`https://thefivestarstg.wpenginepowered.com/events/velocity/`. Production
unchanged (page never existed on prod at the canonical singular slug —
Phase 3.11 production promotion is a create-new operation, not a replace).

**Rollback:** WPBakery version preserved at `-old` slug for reference and
fallback. Trash decision deferred to ~1-2 weeks post-prod-promotion.

**Verification (Playwright + curl with cache-bust):**
- Canonical URL serves wrapper class `.elementor-5107` with all 8 sections
  (hero, intro+who-belongs, what-happens, charter-offer, membership-cards,
  event-details, final-cta, footer-line); no `.fsi-page-wrap` markup
- `-old` URL serves WPBakery inline-styled markup with "(Old WPBakery)"
  title and The7 page-title bar (Velocity 5088 had `_dt_header_title='enabled'`)
- WPE Varnish + memcached + Elementor CSS + WP Rocket all flushed via
  `WpeCommon::purge_varnish_cache_all()` + `WpeCommon::purge_memcached()` +
  `Elementor\Plugin::$instance->files_manager->clear_cache()` + `wp cache flush`
- HubSpot Leadin tracking params auto-appended to swoogo CTA hrefs (same
  behavior as WPBakery version — not introduced by Elementor)

**Section structure (Velocity-specific deviations from LLSS template):**

| LLSS section | Velocity equivalent |
|--------------|---------------------|
| 01 Hero | 01 Hero (Velocity / May 20-21, 2026 / The Westin / swoogo Register CTA) |
| 02 Intro + Who Belongs | 02 same pattern (FORCE Members gold, Agents/Brokers navy, Asset Managers navy) |
| 03 What Happens | 03 6 features (LLSS had 4) — no Closing Reception strip |
| 04 Next Summit gold callout | 04 Charter Member Offer gold callout |
| 05 Recent Summit photo strip | **SKIPPED** — first-format event, no past Velocity photos in this format |
| 06 Membership Cards (Firm + Corporate) | 06 Five Star Alliance + FORCE |
| 07 Event Details | 07 same pattern (When/Where/Questions) |
| 08 Final CTA | 08 "Join Us in New Orleans" |
| 09 Footer-line | 09 same pattern (RE Pro Membership / force@ / phone) |

Numeric file prefixes preserved (no renumber across the 05 gap) so the
LLSS↔Velocity section correspondence stays visible at a glance.

**Quantitative outcomes (vs LLSS Option B as reference):**

| Metric | LLSS (9 sections) | Velocity (8 sections) | Note |
|--------|-------------------|------------------------|------|
| `_elementor_data` size | 22,032 B | 18,178 B | -17% (one fewer section) |
| Total Elementor widgets | 15 | 13 | analogous structure |
| Total `.elementor-element` count | 27 | 24 | -3 = expected for skipped Section 5 |
| Total file count | 9 | 8 | |

**Image content TODOs (8 slots — unblocks Phase 3.11 readiness):**

| Slot | Section | Dimensions | Subject |
|------|---------|------------|---------|
| Hero bg | 1 | 1900x600 | New Orleans / past Velocity event / FSI RE community moment |
| Community photo | 2 | 1100x440 | FORCE members in conversation, networking moment |
| Five Star Alliance card | 6 | 480x220 | RE professionals at work / community moment |
| FORCE card | 6 | 480x220 | FORCE-certified credential moment / Connect session |
| Final CTA bg | 8 | 1900x400 | Same as Hero or alternate New Orleans / event shot |

**Next gate:** Phase 3.11 production promotion. Awaiting explicit Jonathan
approval per the standing production-approval rule. Velocity images need
to be gathered and populated before the prod gate. Phase 1.11 LLSS
production promotion runs first (or in parallel).

---

## 2026-04-26 — Phase 1.4 Step 7: LLSS Elementor at canonical staging slug

**Decision:** Slug swap executed on staging:
- Page 5094 (WPBakery LLSS) renamed to `legal-league-servicer-summit-old`,
  title "Legal League Servicer Summit (Old WPBakery)"
- Page 5106 (Elementor LLSS) renamed to `legal-league-servicer-summit`,
  title "Legal League Servicer Summit"

**Status:** Live at the canonical staging URL
`https://thefivestarstg.wpenginepowered.com/events/legal-league-servicer-summit/`.
Production unchanged (page never existed on prod at the canonical singular
slug — Phase 1.11 production promotion is a create-new operation, not a
replace).

**Rollback:** WPBakery version preserved at `-old` slug for reference and
fallback. Trash decision deferred to ~1-2 weeks post-prod-promotion.

**Verification (Playwright + curl):**
- Canonical URL serves wrapper class `.elementor-5106` with all 9 Option B
  sections
- `-old` URL serves `.fsi-page-wrap` WPBakery markup with "(Old WPBakery)"
  title
- No `_wp_old_slug` redirects in play; no `eps-301-redirects` rules
  conflicting
- WPE Varnish + Elementor CSS + WP Rocket all flushed via `WpeCommon::purge_varnish_cache()`
  + `Elementor\Plugin::$instance->files_manager->clear_cache()` + `wp cache flush`

**Next gate:** Phase 1.11 production promotion. Awaiting explicit Jonathan
approval per the standing production-approval rule. The kit promotion +
LLSS create-new on prod will use the same direct meta-write workflow
proven on staging.

---

## 2026-04-26 — Option B: Elementor structural containers + HTML widgets for content sections

**Decision:** For event-page sections that don't need Elementor-native
structural features (background image, overlay, animation, dynamic tags),
use ONE Elementor HTML widget per section containing the existing
`fsi-page-wrap` markup. Keep Elementor widget trees ONLY for sections
where Elementor's primitives earn their keep — Hero (full-width + bg
image + overlay + Save-the-Date sub-card), Final CTA (same), Footer-line
(too small to refactor).

**Rationale:**

1. **Visual fidelity.** The widget-tree approach was reinventing visual
   designs encoded in `fsi-event-styles.php` CSS classes (e.g.,
   `.fsi-card-gold` = Offwhite card + 4px gold top border). Recreating
   that as widget settings repeatedly produced inferior, heavier visuals
   (solid-fill cards) and lost the CSS author's nuance. HTML widget +
   existing CSS = pixel-identical to source design.

2. **Performance.** LLSS retrofit measurements (2026-04-26):
   - `_elementor_data` size: 39,958 → 22,032 bytes (-45%)
   - Elementor widgets: 59 → 15 (-75%)
   - Flexbox containers: 35 → 12 (-66%)
   - DOM `.elementor-element` count: ~100+ → 27 (-73%)
   - Per-page CSS file size: ~9 KB → ~3-4 KB
   - Faster TTI, smaller DB read on every page render, smaller initial
     CSS download

3. **Editorial workflow unchanged.** WPBakery editors already paste HTML
   markup into raw-HTML widgets; HTML widget editing in Elementor is the
   same pattern. AI-first JSON authoring continues unchanged — HTML
   strings live in the JSON files in version control.

4. **Cross-site syndication still works.** Elementor pages with HTML
   widgets are syndication-compatible the same way pure-widget-tree
   Elementor pages are.

5. **Reusability for Phase 2/3.** Clone the Elementor section structure,
   copy/paste the HTML chunks, swap event-specific copy.

**When to use widget tree (the carve-outs):**

| Use case | Reason widget tree wins |
|----------|------------------------|
| Hero / Final CTA with bg image + overlay | Elementor handles overlay opacity, full-width vs boxed, parallax cleanly |
| Buttons that need `__globals__` color binding | Globals work on widget-tree buttons (with the workarounds documented earlier) |
| Animation triggers, motion effects, dynamic tags | Only available on Elementor widgets, not HTML markup |
| Theme Builder page templates | Need Elementor widgets for conditions and dynamic content |

**When to use HTML widget (the default for content):**

| Use case | Reason HTML widget wins |
|----------|------------------------|
| Cards/grids with existing CSS class system | CSS handles layout/colors/spacing; widget settings would re-encode them |
| Photo strips, image galleries with captions | CSS classes encode positioning; HTML is concise |
| Inline-styled content blocks | HTML preserves intent without translation overhead |
| Anything where the source HTML is short and well-styled by an existing class system | Don't reinvent the design |

**Trade-offs we accept:**

- **Editorial UX inside HTML widget**: editors edit raw HTML in the
  Elementor code editor, not via drag-drop image pickers. For event
  pages where images are populated once per event, this is fine. For
  marketing pages with frequent image swaps, a hybrid (HTML widget for
  layout + Elementor Image widget for the image slots) is the right
  pattern — costs more JSON complexity, gains image-picker UX.
- **Coupling to `fsi-event-styles.php` mu-plugin.** The CSS source needs
  to stay deployed. When/if it retires (Hello Elementor swap, kit
  consolidation), the rules need to migrate into the kit Custom CSS
  block or a successor plugin. Documented per-section in JSON
  `_authoring_notes`.
- **Elementor template export doesn't carry CSS.** If the FSI Event Page
  template is exported to a fresh site without `fsi-event-styles.php`,
  cards look unstyled. Mitigation: ship the CSS alongside the template
  in the SOP for Phase 7 AMAA.

**Architectural pattern (canonical):**

```
{
  "id": "section-name",
  "elType": "container",      // Elementor outer container
  "isInner": false,
  "settings": {
    "content_width": "boxed",  // or "full"
    "boxed_width": {"unit": "px", "size": 1100, "sizes": []},
    "padding": { ... },        // structural padding
    "padding_mobile": { ... }
  },
  "elements": [
    {
      "id": "section-html",
      "elType": "widget",
      "widgetType": "html",
      "settings": {
        "html": "<div class=\"fsi-grid-3\">\n  <div class=\"fsi-card-gold\">\n    <h3 class=\"fsi-card__title\">...</h3>\n    <p class=\"fsi-card__text\">...</p>\n  </div>\n  ...\n</div>"
      }
    }
  ]
}
```

**Documented in:**
- `docs/sops/elementor-json-authoring.md` lesson #15
- `sites/thefivestar/llss-elementor-build-spec.md` (per-section author notes)
- This decision log entry

**Applies to:** FSI event pages (LLSS, Velocity, Events hub). Reassessable
when other content types come up — membership / community pages might
benefit from the same pattern depending on their CSS class systems.

---

## 2026-04-25 — AI-first Elementor authoring; pin Elementor versions on FSI

**Decision:** Elementor templates, pages, and kits are authored as JSON files in
this repo and pushed to staging via WP-CLI. The Elementor UI is not an
authoring tool for production content. UI is reserved for: (a) one-time schema
discovery (build a reference instance to learn a widget's settings shape), and
(b) operations the WP-CLI surface doesn't cover (Theme Builder display
conditions, popup display rules, dynamic-tag wiring).

**Companion decision:** Pin Elementor + Elementor Pro on FSI staging at the
versions where this workflow was proven (4.0.2 / 4.0.2). Disable WP auto-update
for both. Upgrades are deliberate, with re-export of the kit and widget schema
oracle to catch any internal-data-structure drift before authoring against the
new version.

**Verified CLI surface on FSI staging Elementor 4.0.2 (2026-04-25):**

| Command | Use |
|---------|-----|
| `wp elementor kit import <zip> [--include=site-settings,templates,content] --user=<id>` | Import kit zip (admin user required) |
| `wp elementor kit export <path>` | Export current kit |
| `wp elementor kit revert` | Atomic rollback of last kit import |
| `wp elementor library import <file>` | Single template import |
| `wp elementor library import_dir <path>` | Bulk template import from directory |
| `wp elementor flush_css` | Regenerate per-page CSS cache (run after every import or `_elementor_data` write) |
| `wp elementor replace_urls <old> <new>` | Rewrite hardcoded URLs (staging→prod) |

**Push pipe (verified end-to-end 2026-04-25):**

WPE SSH Gateway whitelists commands; SCP and `cat > file` are blocked. Binary
push uses `wp eval-file -` reading PHP from stdin that base64-decodes the
payload and writes to `wp_upload_dir()['basedir']`. Persistent location matters
because `/tmp/` is container-scoped (not survivable across SSH sessions on WPE).

**Round-trip proof (2026-04-25):** Re-imported the existing
`elementor-global-kit-v1.zip` to staging via the CLI path; Site Settings
preserved exactly; `/kit-test/` rendered identically (H1 Roboto 42px navy
`#1F365C`, H2 Roboto 26px navy, body Roboto 14px `#444444`). Computed-style
values match kit spec values when fetched via Playwright `getComputedStyle`.

**Rationale:**

1. **Repo as source of truth.** Site state is the database; the database is not
   diff-able. JSON files in this repo are diff-able, blame-able, and reviewable.
   Phase 1.3 was UI-only; capturing the kit now revealed 3 spec/reality drifts
   (Arial vs Roboto, 4 undocumented custom colors, breakpoint storage) that
   would have stayed silent indefinitely without the round-trip.
2. **Cross-site replication.** A kit zip + import script reproduces the same
   kit on AMAA staging when Phase 7 starts. UI builds don't replicate.
3. **Reproducible recovery.** If staging is wiped or rolled back, the kit and
   all event-page templates rebuild from the repo with no manual UI work.
4. **AI-driven authoring is viable.** Widget settings in v4 are sparse — only
   deltas from kit defaults are stored. Verified on `/kit-test/` page 5099:
   8 widget instances, average ~3 properties each. Cold-authoring widget JSON
   from a known-good schema reference is tractable.

**Out of scope for JSON authoring (UI remains the right tool):**
- Elementor Pro Theme Builder display conditions (UI has validation; CLI
  surface is thin)
- Popup display rules and triggers
- Dynamic tag wiring (depends on plugin context the CLI doesn't expose)
- One-time widget schema discovery — build one in UI, export `_elementor_data`,
  then close the loop and never edit in UI again

**Guardrails:**

1. **Version pin.** Elementor + Elementor Pro on FSI pinned at 4.0.2 / 4.0.2.
   Document upgrade with a re-export-and-verify pass before authoring proceeds
   on the new version.
2. **Bootstrap from UI.** New widget types: build one reference instance in UI,
   export `_elementor_data`, decompose into
   `sites/thefivestar/elementor-templates/widget-references/`. From then on,
   author from the reference — never cold.
3. **Cache flush after every push.** `wp elementor flush_css` runs after every
   kit import and every direct `_elementor_data` write. Skipping this leaves
   stale per-page CSS files and produces "why doesn't this look right" debugging.
4. **Visual verify gate.** Every push is followed by Playwright (or Chrome MCP)
   to fetch computed styles AND a screenshot. The verified pass is the gate;
   "import succeeded" is not.
5. **Use `--include=site-settings` when only kit-level changes are intended.**
   Full kit import re-imports custom-code (Naylor, Apollo) and templates,
   which can duplicate or override existing prod state if not intended.
6. **`wp elementor kit revert` is the atomic rollback.** Available immediately
   after any import. Document it as the first response when an import causes
   visible regression.
7. **Persistent location for the push.** `wp_upload_dir()['basedir'] /
   cli-imports/` is the staging convention. Always clean up after import.
8. **Admin user required for kit import.** `--user=<id>` is mandatory.
   FSI admin: `jhughes` / ID 816.

**Workflow C splits accordingly** in `docs/how-we-update-the-site.md`:
- **C1 (default):** JSON-driven authoring + WP-CLI push
- **C2 (escape hatch):** WP Admin UI for the listed out-of-scope cases above

**SOP:** `docs/sops/elementor-json-authoring.md`.

**Consequences:**

- Phase 1.3 is restated as "live + version-controlled" — the UI-built kit is
  now mirrored as JSON in `sites/thefivestar/elementor-kit/`. Re-exports go on
  top of those files (overwrite, not append).
- Phase 1.4 LLSS build runs on this workflow from the start. Pre-work #2 in
  the next-chat-handoff is rewritten to: bootstrap widget schema oracle by
  exporting `/kit-test-widgets/` once, then author all 8 LLSS sections as JSON.
- Phase 7 AMAA portfolio expansion gets the kit zip + the tooling pattern for
  free.
- The decision-log nav-wiring rule (2026-04-23) and Phase 4 IA split
  (2026-04-23) are unchanged.

**Alternatives considered and rejected:**

- **Continue UI-only authoring.** Rejected. Three spec/reality drifts in a
  4-day-old kit is the proof that UI-only is unauditable.
- **Build a custom Elementor authoring DSL.** Rejected. The native JSON IS the
  contract. Adding a translation layer doubles the failure surface and gains
  nothing for our scale.

**Addendum 2026-04-25 (post-verification of `wp elementor kit import`):**

`wp elementor kit import` is unsafe for routine kit-content updates on
Elementor 4.0.2. Two distinct failure modes verified on FSI staging:

1. **`--include=site-settings` is a silent no-op.** Returns
   `Success: Kit imported successfully` but the import session has
   `runners: []` (zero runners). Active kit unchanged. Verified by
   reading `_elementor_page_settings` after import — bytewise identical
   to before.
2. **Without `--include`, runners fire BUT custom_colors are APPENDED, not
   REPLACED.** Discovered after a renumber import produced a kit with 27
   custom_colors (duplicate `_id` for every slot). Elementor's resolution
   of `globals/colors?id=...` becomes undefined when slot IDs duplicate.
   Also: trashes original `elementor_snippet` posts (Naylor, Apollo) and
   creates new ones with new IDs. Also: creates a new kit post and
   switches `elementor_active_kit` to point at it.

**Revised authoring path for kit Site Settings (custom colors, system
colors, custom CSS, layout, typography):** direct meta-write to
`_elementor_page_settings` on the active kit post via `update_post_meta`,
bracketed by:
- mandatory backup to a timestamped meta key
  (`_elementor_page_settings_backup_YYYY_MM_DD_HHMMSS`) BEFORE the write
- `Elementor\Plugin::$instance->files_manager->clear_cache()` AFTER

**Revised use cases for `wp elementor kit import`:** restricted to
greenfield contexts only — first-time import on a fresh site, or
cross-site promotion (FSI→AMAA in Phase 7) where the destination has no
kit yet. Routine kit edits use direct meta-write.

**`wp elementor kit revert`** verified as a working atomic rollback after
`kit import`. It does NOT untrash trashed `elementor_snippet` posts
(verified 2026-04-25); manual `wp post update <id> --post_status=publish`
needed for those.

SOP `docs/sops/elementor-json-authoring.md` was rewritten 2026-04-25 to
reflect this revised pathway. Original 2026-04-25 SOP content recommending
`kit import --include=site-settings` was wrong and has been replaced.

---

## 2026-04-25 — Restore prod custom-color slot IDs; brand colors get `fsi*` slot IDs

**Decision:** The 7 custom-color slot IDs that Sasa overwrote during Phase
1.3 setup (`f64043d`, `fd98090`, `7836aae`, `9bb2763`, `9e77118`,
`2922fdd`, `73bb18d`) are restored on staging to their original prod
Velocity values. The 7 brand colors (Navy Hover, Gold Hover, Offwhite,
Border, Light Grey, Gold Text Dark, Hero Overlay) live at NEW slot IDs
prefixed `fsi*` (`fsi01nh` through `fsi07ho`). Net 17 custom-color slots
on the staging kit.

**Why:** prod kit 4004 was last modified 2025-11-04 (5 months stale
relative to staging). 4 prod pages bind to the 7 contested slot IDs:

| Page | Slots used | Risk if kit promoted as-is |
|------|-----------|---------------------------|
| 4497 Exit Intent (popup) | 3 slots, 5 refs | HIGH — popup button breaks visually |
| 4560 Education (active page) | 1 slot, 5 refs | MEDIUM — backgrounds white→grey |
| 4993 Five Star Access (active page) | 3 slots, 4 refs | HIGH — links become near-invisible |
| 4436 Velocity (deprecation candidate) | 3 slots, 17 refs | VERY HIGH — full identity flip |

Renumber preserves the 7 contested slots' original Velocity values, so
prod pages render unchanged after Phase 1.11 promotion. Brand colors are
additive at new IDs.

**System color slots** (`primary`, `secondary`, `text`, `accent`) were
also overwritten by Phase 1.3 with FSI brand values, but per a separate
audit only deprecation-candidate pages reference them on prod. Negligible
risk; no remediation needed.

**Slot ID convention going forward:**
- `fsi[NN][initials]` for FSI brand-kit additions (`fsi08xx` next)
- Pre-existing 7-char hex-ish slot IDs preserved for prod-page back-compat
- Before changing any slot's title or hex, query both prod and staging
  for `globals/colors?id=<slot>` references in `_elementor_data`
  (procedure documented in SOP)

**Consequences:**

- Staging kit 4004 now has 17 custom_colors. Source-of-truth
  `sites/thefivestar/elementor-kit/site-settings.json` reflects this.
- New event-page templates (Phase 1.4 onwards) bind to `fsi*` slot IDs
  for brand colors. They MUST NOT bind to the 7 restored Velocity slots.
- Phase 1.11 kit promotion to prod is now non-destructive for the 4
  affected prod pages. Velocity colors preserved at original slots; brand
  colors added alongside at `fsi*` slots.
- Velocity page 4436 deprecation can proceed independently per the
  `wpbakery-migration.md` deprecation list — no urgency from this
  decision.

**Kit spec:** `sites/thefivestar/elementor-global-kit-spec.md` updated.

---

## 2026-04-23 — Nav-wiring requires explicit approval (globally)

**Decision:** Any new navigation entry — top-nav, mobile nav, footer, any
menu — requires explicit per-entry approval from Jonathan before being
wired on production. Publishing a new page is authorized; exposing it via
nav is not. This is a standing rule, not a per-phase rule.

**Single pre-approved exception (standing):** The Phase 2 Events hub
migration may replace the existing top-nav `/conferences/` entry with
`/events/`. No other nav changes inherit this approval.

**Rationale:** FSI's current nav reflects a specific go-to-market
sequencing. Pages can be published and reviewed silently on production
without exposing incomplete IA to users. Wiring to nav is the moment a new
page becomes discoverable — that moment is business-sensitive and not
delegable to engineering.

**Consequences:**
- Phase 2 events portal wiring pre-approved (the single exception).
- Phase 4 `/communities/` nav wiring requires separate approval.
- Phase 4 `/memberships/` updates don't require nav approval (existing
  parent nav entry reused).
- Build-and-stage discipline: always build new pages, verify on staging,
  wire on staging, but hold production nav updates for approval.

---

## 2026-04-23 — Phase 4 splits into two distinct templates

**Decision:** Phase 4 (originally "Membership / profession pages" as a
single template in the 2026-04-22 portfolio standardization plan) splits
into two visually-distinct Elementor Pro templates:

1. **FSI Membership Page** — serving the `/memberships/` hub and its
   children (FORCE, Legal League, AMDC, PPEF, NMSA, MSEA, and the new
   Five Star Alliance Membership).
2. **FSI Community Page** — serving the new `/communities/` hub and its
   children (Mortgage Finance, Legal, RE Pro, Prop Pres).

**Rationale:** Jonathan confirmed 2026-04-23 that memberships (member
group affinity) and communities (profession-based audience cuts) serve
different user intents and should look visually different. Treating them
as one template would compromise both.

**Consequences:**
- Phase 4 scope doubles from template-count perspective (one → two).
- Phase 5 (Who We Are / institutional) may become a third template or a
  variant of one of these two; decide at Phase 5 kickoff after seeing
  how similar the structural requirements end up being.
- `/communities/` is greenfield — no existing pages to migrate, but also
  no existing content or CSS to reference. Design work will be
  comparatively larger than `/memberships/` which updates in place.
- `/memberships/` retains its existing URL structure and existing child
  pages — migration is in-place rebuild, not new page creation.

**Handoff:** See `docs/next-chat-handoff.md` Phase 4 notes for current
status and queue position.

---

## 2026-04-22 — Portfolio standardization: Elementor + Elementor Pro everywhere (supersedes 2026-04-19)

**Decision:** All FSG Media WordPress sites standardize on Elementor + Elementor Pro
as the sole page builder. Every new page across thefivestar.com, amaaonline.com, and
themortgagepoint.com is built in Elementor. Every updated page moves to Elementor as
it's touched. WPBakery goes into maintenance-only mode on FSI and AMAA and is retired
site-by-site as migration completes.

**This supersedes the 2026-04-19 decision (WPBakery-only-forward, Elementor phase-out).
That earlier decision rested on incorrect assumptions about the direction of FSI page
development and the long-term viability of WPBakery.**

**Rationale:**

1. **WPBakery is upstream-stagnant.** Maintenance-mode releases, no theme builder
   equivalent, shrinking developer ecosystem. Elementor has ~15M installs,
   active feature development (Theme Builder, Flexbox containers, Loop Builder),
   and a much deeper hiring pool.

2. **MortgagePoint is the working reference.** 3,351 posts, 41 magazine issues,
   31 podcasts, cross-site house ads, Advanced Ads + GAM, AIOSEO Pro, HubSpot,
   Site Kit — all production-proven on Hello Elementor + Elementor Pro
   (audit 2026-04-22). Nothing in the FSG stack requires WPBakery specifically.

3. **Cross-site content syndication becomes native.** Importing MortgagePoint
   posts into thefivestar.com is a real editorial intent. Between two Elementor
   sites the post meta and block structure are schema-compatible. Between
   Elementor (MP) and WPBakery (FSI) each imported post requires a manual
   layout rebuild. That tax would accumulate forever.

4. **Elementor Pro Theme Builder is a capability WPBakery lacks.** MortgagePoint
   renders thousands of posts consistently via 36 published
   `elementor_library` templates (Single Post, Archive Blog, Search Results, etc).
   FSI needs this for event pages, and AMAA needs it for deal/tombstone CPTs.

5. **WPBakery chain update is currently 🔴 High risk with no SOP on FSI.**
   Eliminating the WPBakery stack retires this risk permanently. Replaced by
   the Elementor + Elementor Pro + ElementsKit update chain, which is more
   granular and lower-risk.

6. **License supports it.** Elementor Pro Expert tier, 25 seats, 20 currently
   assigned. Priority sites (thefivestar, amaaonline, mortgagepoint + their
   staging/dev) need 6–9 seats. Defunct activations can be pruned; no license
   purchase required.

7. **AMAA already runs both builders.** 22 pages + 23 posts on Elementor today.
   Picking one ends a hybrid state that currently loads both builder CSS/JS
   sitewide. Picking Elementor aligns with portfolio direction.

**Scope (all three WordPress sites):**

| Site | Current | Target | Migration shape |
|------|---------|--------|-----------------|
| thefivestar.com | The7 + WPBakery (dominant) | Elementor + Elementor Pro | Build new pages in Elementor; rebuild the LLSS, Velocity, and Events hub pages first to establish templates; migrate remaining live pages as they're touched |
| amaaonline.com | The7 + WPBakery + Elementor (hybrid) | Elementor + Elementor Pro | End the hybrid; migrate WPBakery pages; retain Toolset Views for deal/tombstone until Elementor Pro loop templates replace them |
| themortgagepoint.com | Hello Elementor + Elementor Pro | No change | Reference implementation |

**Theme direction — deferred as separate decision:** Hello Elementor is
MortgagePoint's current theme and the obvious portfolio default. However:
- The7 is fully compatible with Elementor Pro (both sites already run it alongside WPBakery).
- The7 ships mega-menu, portfolio, testimonials, team CPTs out of the box that
  Hello Elementor doesn't.
- Swapping The7 → Hello Elementor on FSI/AMAA is a separate, larger effort
  that includes rebuilding those theme-level features in Elementor Pro templates.

**For now:** keep The7 on FSI and AMAA as the theme. Build new pages with
Elementor (Elementor works fine inside The7). Evaluate Hello Elementor on a
dev environment later, and commit to theme swap as a separate decision when
the pattern is proven.

**Migration approach for FSI (immediate):**

1. Rebuild the three already-built event pages (Events hub, Velocity, LLSS) in
   Elementor to establish the FSI event-page template pattern. These are the
   pages where the shared stylesheet system (`fsi-event-styles.php`) is currently
   backing plain-HTML content — they're the ideal first migration target because
   the content is fresh, the structure is documented in `docs/sops/new-event-page.md`,
   and the CSS token work is already done.
2. As the template matures, convert it into an Elementor Pro saved template
   or section library so subsequent event pages are created from the pattern,
   not from scratch.
3. Deprecate dead FSI pages (many of the ~200 are legacy per Jonathan's note).
   Active-page count for migration is significantly lower than the raw count.
4. Migrate live WPBakery pages as they're touched for editorial or structural
   updates — no forced mass migration.
5. Once all active FSI pages are Elementor-native and WPBakery page count is
   zero, deactivate WPBakery chain on staging → verify → production.

**Migration approach for AMAA (sequenced after FSI):**

1. Apply FSI-proven Elementor patterns to AMAA's page types.
2. Build Elementor Pro loop templates for `deal` and `tombstone` CPTs to
   replace Toolset Views as they're touched.
3. Event integration: replace EventON with ReMembers AMS event integration
   (planned, external to this decision). EventON is not a portfolio-standard
   plugin long-term.
4. Wild Apricot SSO (`wild-apricot-login`) is being deprecated for all
   memberships (planned, external to this decision). Not a constraint.
5. After migration: deactivate WPBakery chain on AMAA. Resolve hybrid state.

**Alternatives considered and rejected:**

- **Stay on WPBakery portfolio-wide (2026-04-19 decision):** Rejected.
  Blocks cross-site syndication, keeps 🔴 WPBakery chain risk, bets on a
  maintenance-mode builder.
- **Hybrid: Elementor on MP + AMAA, WPBakery on FSI:** Rejected. FSI's
  intent to syndicate MP content makes a shared builder necessary.
- **Move the portfolio to Gutenberg / Full Site Editing:** Rejected for now.
  Editorial team is page-builder-oriented; Elementor Pro is already paid and
  proven. Revisit in 2027+.
- **Migrate to a different page builder (Bricks, Breakdance):** Rejected.
  License already purchased on Elementor Pro; MortgagePoint already proves
  the stack; no compelling case to re-platform twice.

**Consequences:**

- `docs/decisions.md` 2026-04-19 "WPBakery is the sole forward-going builder"
  decision is superseded. Original text preserved below with supersede note
  for log integrity.
- `sites/thefivestar/elementor-migration.md` is retired — it tracked an
  Elementor phase-out that is no longer policy. Replaced by
  `sites/thefivestar/wpbakery-migration.md` (tracks WPBakery → Elementor).
- `brands/fsi/CLAUDE.md` and `docs/how-we-update-the-site.md` updated to
  reflect Elementor as the forward builder.
- `docs/sops/wpbakery-chain-update.md` remains on the backlog but is lower
  priority — the chain is now maintenance-only. If a critical update ships,
  we still need the SOP; if not, the chain retires before the SOP is needed.
- New SOPs needed: Elementor chain update (Elementor + Pro + ElementsKit + add-ons),
  Elementor Pro license management, Elementor Pro Theme Builder template
  pattern for event pages.
- FSI's event-page CSS system (`fsi-event-styles.php`) persists but its role
  changes: shared tokens live in the Elementor Pro kit (global styles); the
  mu-plugin retains only CSS that Elementor's kit cannot express, or is
  retired entirely if the kit covers everything.
- Cross-site content syndication (FSI ← MP) becomes native capability after
  FSI migration completes.

**Open items pending Jonathan's input (not blockers to starting):**

1. Theme direction (The7 kept vs Hello Elementor swap) — separate later decision.
   Scoping audit completed 2026-04-23: see `sites/thefivestar/the7-dependency-audit.md`.
   Findings: CPT/shortcode/widget/nav layers are low-cost; homepage rebuild is
   the one medium-cost item. Recommendation in the audit is to revisit this
   question at Phase 4 kickoff, not now.
2. Elementor Pro license cleanup — ~10 defunct site activations to prune before
   adding FSI to the license
3. Elementor Pro 3.35.1 → 4.0.3 update on MortgagePoint — needs proven path
   before MP is promoted as "the pattern" for other sites

---

## 2026-04-19 — [SUPERSEDED 2026-04-22] WPBakery is the sole forward-going page builder; Elementor to be phased out

**⚠️ Superseded by 2026-04-22 portfolio standardization decision (above).
The stance below no longer reflects current direction. Retained for decision-log integrity.**

**Decision:** All new page development on thefivestar.com uses WPBakery exclusively.
Elementor and Elementor Pro will be removed once all Elementor-built pages are either
rebuilt in WPBakery or permanently deactivated (set to draft/trash).

**Rationale:**
Live audit confirmed 18 pages with `_elementor_edit_mode = builder`:
- 3 drafts (4973, 4834, 4828) — unnamed/throwaway Elementor pages, no user impact
- 1 private (4909 — Home) — not publicly visible
- 14 published pages — see `sites/thefivestar/elementor-migration.md` for full inventory

Running two page builders simultaneously creates asset bloat (Elementor loads CSS/JS
on every page regardless of whether that page uses it), maintenance surface, and
training confusion for anyone editing the site. WPBakery is already the configured
builder for The7 theme. Elementor is legacy.

Most of the 14 live Elementor pages are event asset and lander pages that are outdated
or low-traffic and should be reviewed for deactivation before any rebuild work begins.
Migration scope is likely smaller than the raw count suggests.

**Migration approach (phased):**
1. Review all 14 published Elementor pages — identify which to trash vs. rebuild
2. Trash confirmed-dead pages (reduces rebuild scope)
3. Rebuild remaining pages in WPBakery on staging, verify, promote to production
4. Once zero published pages have `_elementor_edit_mode = builder`, deactivate Elementor + Elementor Pro
5. Verify staging, then delete both plugins from production

**Alternatives considered:**
- Keep both builders indefinitely — rejected; doubles asset load and maintenance burden
- Migrate to Elementor fully — rejected; WPBakery is the configured The7 builder and
  all infrastructure/training is WPBakery-oriented

**Consequences:**
- No new pages or sections to be built in Elementor
- Elementor plugins stay installed but are lower priority until migration completes
- See `sites/thefivestar/elementor-migration.md` for page-by-page tracking

**Supersede note 2026-04-22:** The "Elementor is legacy" framing was wrong —
Elementor is the portfolio-standard builder and the active direction for new
FSI page development. See 2026-04-22 entry.

---

## 2026-04-19 — Use WPE official GitHub Action (SSH rsync), not Git Push

**Decision:** Deploy via `wpengine/github-action-wpe-site-deploy@v3` (SSH rsync),
not via WP Engine Git Push (`git.wpengine.com`).

**Rationale:**
The original `deploy.yml` used WP Engine's Git Push feature, which requires a
separate passphrase-free SSH key registered specifically for that feature, and
`git push` to `git.wpengine.com`. After extended troubleshooting, it became clear
that:

1. WP Engine's official GitHub Action explicitly states it does NOT use Git Push.
2. The official action uses SSH rsync via the SSH Gateway — the same connection
   that already works for WP-CLI operations (`ssh thefivestar`).
3. Git Push is a separate WPE feature with its own key requirements and complexity
   that adds no benefit for our use case.

The official action is simpler: one secret (`WPE_SSHG_KEY_PRIVATE`), one step,
cache clear built in, no git remote configuration required.

**Secrets after migration:**
- `WPE_SSHG_KEY_PRIVATE` (repo-level) — private key of `id_ed25519_itmanager`
- `WPE_SSH_PRIVATE_KEY`, `WPE_CREDS`, `WPE_INSTALL_ID_*` — all removed

**Org-level secrets decision:** Skipped GitHub Organization creation. With only
3 site repos, adding `WPE_SSHG_KEY_PRIVATE` as a repo secret to each on scaffold
is faster than managing an org. Revisit if the portfolio grows beyond ~10 repos.

**Alternatives considered:**
- Keep Git Push approach — rejected due to complexity and separate key management
- GitHub org for shared secrets — rejected due to overhead at current scale

**Consequences:** `deploy.yml` is simpler and more maintainable. The `wpengine_ed25519`
key generated during the Git Push investigation is now unused — it remains registered
in WPE but is not referenced in any workflow.

---

## 2026-04-18 — Two separate deployment workflows, not one pipeline

**Decision:** Maintain a strict mental separation between code deployment (git-based)
and plugin/operational changes (WP-CLI-based). Never route plugin operations through
GitHub Actions. Never track third-party plugins in git.

**Rationale:**
These are fundamentally different classes of work:

- Code changes (custom theme, custom plugins) are version-controlled in git and
  deployed via GitHub Actions → WP Engine SSH rsync. Staging auto-deploys on
  every push to main; production is a manual trigger.

- Plugin and operational changes (updates, deactivations, deletions, cache, DB)
  happen directly on the WP Engine server via SSH + WP-CLI. GitHub is not in
  this loop. Plugins live on the server; they are not tracked in git.

Conflating these leads to: trying to commit plugin zips to git, routing cache
purges through CI, or expecting GitHub Actions to handle plugin updates. All wrong.

**Practical consequence:** Most near-term work (plugin cleanup) is entirely
Workflow B — SSH + WP-CLI, staging first, then production. No code to push,
no GitHub Actions involved.

**Staging cadence:** Staging gets updated far more than production. Every code
push auto-deploys to staging. Every plugin op runs on staging first. Production
is touched deliberately and rarely.

See `docs/how-we-update-the-site.md` for the full reference.

---

## 2026-04-18 — Child theme: defer creation until theme-level code is needed

**Decision:** Do not create a `dt-the7-child` child theme yet.

**Rationale:**
A WordPress child theme is only necessary when you need to:
1. Override theme template files (header.php, footer.php, single.php, etc.)
2. Add custom PHP functions (functions.php)
3. Add custom CSS outside of what The7's own options provide

The thefivestar.com site currently stores all its configuration in the database:
- Page layouts → WPBakery shortcodes in post_content (DB)
- Design settings → The7 Theme Options / Customizer (DB)
- Custom post types → The7 Core plugin and Toolset Types (plugin-managed)

None of that lives in theme files. The7 updates don't touch the DB. So the site
has operated safely without a child theme since launch and will continue to do so
for any plugin-level or content-level work.

**When to revisit:** Create the child theme immediately before writing any custom
PHP, overriding any template file, or adding CSS that can't be handled by
The7's built-in options. Do not create it speculatively.

**Consequences:** Removed from 🔴 High priority in site-profile.md. Will be added
back if theme-level code work is planned.

**Alternatives considered:** Create it now "just in case" — rejected because it
adds a file to manage/deploy with no immediate benefit and creates confusion about
where theme customizations live.

**Note 2026-04-22:** Under the Elementor standardization decision, The7 is retained
for now. A child theme may still be unnecessary — Elementor Pro provides custom
CSS per-section, per-page, and via the global kit. Revisit if/when Hello Elementor
migration becomes active.

---

## 2026-04-18 — [SUPERSEDED 2026-04-22] WPBakery as primary page builder (not Elementor)

**⚠️ Superseded by 2026-04-22 portfolio standardization decision.**

**Decision:** Keep WPBakery Page Builder as the primary builder for thefivestar.com.
Do not migrate to Elementor even though Elementor Pro is now active.

**Rationale:**
All existing page layouts are built in WPBakery shortcodes stored in post_content.
Migrating to Elementor would require rebuilding every page manually — there is no
automated migration path from WPBakery shortcodes to Elementor widgets.

Elementor Pro being active (per the live audit) needs investigation: confirm which
pages (if any) use Elementor, then decide whether to keep it for those pages or
rebuild them in WPBakery and remove it.

**Consequences:** Elementor Pro stays installed pending audit. Classic Editor and
Classic Widgets must remain active. The7 Theme Settings must stay in WPBakery mode.

**Supersede note 2026-04-22:** The manual-rebuild concern still applies —
there's no automated WPBakery → Elementor converter. But rebuilding is now
the accepted cost to get the portfolio onto one maintained builder. See
2026-04-22 entry.

---

## 2026-04-18 — AIOSEO Pro as sole SEO plugin (remove Yoast)

**Decision:** Remove Yoast SEO. AIOSEO Pro is the single SEO plugin.

**Rationale:**
Both plugins were active simultaneously. This causes:
- Duplicate meta tags in the page <head>
- Competing XML sitemaps
- Redundant structured data output
- Performance overhead (two plugins doing the same job)

AIOSEO Pro is the paid investment with the fuller add-on suite. Yoast is inactive
(confirmed in live audit) but still installed — remove it entirely.

**Process:** Deactivate on staging → confirm no SEO regressions → delete on prod.

---

## 2026-04-18 — thefivestar-wp is the reference implementation

**Decision:** Build and prove the complete deployment pattern on thefivestar-wp
before scaffolding amaaonline-wp or themortgagepoint-wp.

**Rationale:**
Each site has a different theme, page builder, and plugin stack. The deployment
pipeline (GitHub → GitHub Actions → WP Engine) needs to be validated end-to-end
on one site before replicating. FSI is the primary operational focus and the
best-understood site.

**Consequences:** amaaonline-wp and themortgagepoint-wp are stubs. Brand files for
AMAA and MortgagePoint are stubs. No work begins on those until FSI is confirmed.

---

## 2026-04-18 — SSH config: explicit per-install entries (not wildcard User %h)

**Decision:** Use individual Host entries in ~/.ssh/config with hardcoded User values
for each WP Engine install.

**Rationale:**
A wildcard approach using `User %h` was attempted. OpenSSH expands `%h` in the User
directive to the final HostName value (e.g., `thefivestar.ssh.wpengine.net`) rather
than the original host alias (`thefivestar`). WP Engine rejected the connection with
"Cannot access install" because it couldn't find an install matching the full
hostname as a username. Explicit entries are unambiguous and correct.

**Lesson:** In SSH config, `%h` in HostName expands from the alias; `%h` in User
expands from the final hostname. They are not the same token in practice.
