# Runbook: R4 — Re-author All Pages to Native Widgets (NL → JSON)

Phase R4 of `../rebuild-plan.md`, per authoring decision **2026-07-11**. Runs on the clone
(`thefivestardev`, Hello active after R3). Re-authors **all 30 published pages** to native
Elementor widgets generated from natural-language specs and pushed via code. **Gated by a spike.**

## Scope — all 30 pages → native

| Bucket | Count | From | To |
|--------|-------|------|-----|
| MIGRATE | 14 | WPBakery (`[vc_row`) | native widgets |
| REFACTOR | 16 | HTML-embed Option B (`widgetType:html`) | native widgets |

"LEAVE" in the R2 disposition CSV = **REFACTOR** (Elementor shell exists; body is HTML-embed,
not native). Nothing is truly left as-is.

## Preconditions

- ✅ R3 done: Hello Elementor active; `__globals__` now bind (were broken under The7, Lesson #12).
- Native-widget **schema reference library** built (see R4.0 step 1).
- Pipeline ready: `docs/sops/elementor-json-authoring.md` (compose → base64 → `wp eval-file -` →
  `update_post_meta`; cache purge Lesson #16). Kit 4004 globals verified.
- Copy source: existing `elementor-templates/**` HTML-embed JSON = **source of copy/structure**, not deploy artifact.

---

## R4.0 — SPIKE (gate): validate the workflow on ONE page

Prove NL→native-JSON→push before committing the other 29. Target: **Contact (ID 13)** — simple,
high-traffic, single-column.

1. **Capture native-widget schema references.** In Elementor (GUI), on a scratch/kit-test page,
   drop each widget we'll use (heading, text-editor, button, image, image-box, icon-box,
   container/flexbox, spacer, divider, icon-list), set a value + a `__globals__` binding, save,
   then export its JSON to `sites/thefivestar/elementor-templates/widget-references/<widget>.json`.
   This is the ground truth Claude generates against (extends existing `image-box.json`).
2. **Write the Contact page spec** in natural language (sections, copy pulled from the current
   page, which widget per block, which kit global per color/type slot).
3. **Generate** the native-widget `_elementor_data` JSON for page 13 from that spec.
4. **Backup + push** (per SOP): back up current `_elementor_data` meta, then `update_post_meta`
   with the generated JSON; Elementor `clear_cache` + full cache purge.
5. **Verify the spike:**
   ```bash
   # no html/wpbakery bodies remain on 13:
   printf "SELECT (meta_value LIKE '%%widgetType\\\":\\\"html%%') AS has_html FROM wp_0edpxsjfuc_postmeta WHERE post_id=13 AND meta_key='_elementor_data';\n" | ssh thefivestardev "wp db query"
   curl -s -o /dev/null -w "13 -> %{http_code}\n" "https://thefivestardev.wpengine.com/contact/?cb=$RANDOM"
   ```
   - Open page 13 in the Elementor editor → confirm **native, editable widgets** (no raw-HTML blob).
   - Visual parity vs the current Contact page; `__globals__` colors/type honored; 200.

**Spike gate:** renders clean + GUI-editable + globals honored → workflow validated, proceed.
If schema fighting is severe → reassess (fallback: GUI-author one family template, clone-and-fill
per page instead of full NL generation).

---

## Per-page workflow (repeat for all 30 after spike)

1. **Family template first.** Author one canonical native-widget structure per family, reused
   across its pages (also save as an Elementor Library template for editor clone-and-fill):
   - **Event:** 5089 Events, 5110 Velocity, 3146 Five Star Conference, 2683 Conferences, 2725 Virtual Events, 4860 Velocity signup, 5402 FSC2026 Assets
   - **Membership:** 5113 Memberships, 5128 Alliance, 5051 Member Benefits, 4993 Five Star Access, 5386 Join Alliance, 5380 Join Access
   - **Community:** 5114 Communities, 5135 RE Professionals
   - **Resource:** 5127 FSI Offers, 4560 Education, 4550 Certifications, 4556 Courses, 4558 Seminars, 4081 Five Star Academy, 9 Resources, 2660 Media, 4970 REIF Deal Room
   - **Standalone/simple:** 363 Home, 13 Contact, 2784 Careers, 3283 Privacy, 2937 Confirmation, 5086 Who We Are
2. **NL spec → native JSON** for the page (copy from the HTML-embed source; structure from family template).
3. **Version-control** the section JSON under `sites/thefivestar/elementor-templates/**` (native, not HTML).
4. **Backup + push + purge** per SOP. Preserve post/attachment IDs (clone kept them).
5. **Verify** per page: 200, native widgets in editor, visual parity, globals honored.

## Gate R4

- [ ] Spike (page 13) validated
- [ ] Native-widget reference library complete + committed
- [ ] All 30 pages: no `[vc_row` and no `widgetType:html` in `_elementor_data`
- [ ] Spot-open several in Elementor UI — native editable widgets, no raw-HTML sections
- [ ] Full 200-sweep + visual regression pass on temp domain
- [ ] `fsi-event-styles.php` retired (no rebuilt page depends on it)

## Rollback

Per-page: restore the `_elementor_data` meta backup taken before each push. Whole-clone:
restore checkpoint `48b72dd4…`. No prod impact.
