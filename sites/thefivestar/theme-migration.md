# Theme Migration Plan: The7 → Hello Elementor

Site: thefivestar.com
Created: 2026-05-14
Status: **Planning** — not yet approved for execution

---

## Why migrate

The7 theme causes CSS specificity conflicts with Elementor that require ongoing workarounds:

- Heading colors require `!important` on `.elementor-heading-title` in the Global Kit Custom CSS
- Button and container overlay colors cannot use `__globals__` bindings — they must be hardcoded
  as hex values in every section JSON file (breaks if brand colors change)
- Every new Elementor widget type added to templates needs a corresponding specificity override rule
  (~15 min per widget type audit)

Hello Elementor eliminates all of these. It is a minimal, Elementor-native theme with no
conflicting CSS. MortgagePoint (`themortgagepoint.com`) already runs Hello Elementor +
Elementor Pro in production at scale.

**After migration:**

- Global Kit Custom CSS simplifies (no more `!important` heading rules)
- Section JSON files can use `__globals__` color bindings instead of hardcoded hex
- New widget types don't require specificity audits
- `the7-elementor-specificity-notes.md` becomes historical

---

## What The7 currently provides

These capabilities must be replaced or assessed before switching themes:

| Capability | Current provider | Migration path |
|------------|-----------------|----------------|
| Site header | The7 theme | Build Header template in Elementor Pro Theme Builder |
| Site footer | The7 theme | Build Footer template in Elementor Pro Theme Builder |
| Mega Menu | The7 + WPBakery Mega Menu plugin | Verify plugin works under Hello Elementor; fallback: Elementor Pro Nav menu |
| Portfolio CPT | The7 built-in | Audit: is it used on active pages? If not, CPT data stays in DB unused |
| Testimonials CPT | The7 built-in | Same audit |
| Team CPT | The7 built-in | Same audit |
| Photo Albums CPT | The7 built-in | Same audit |
| Slideshows CPT | The7 built-in | Same audit |
| WPBakery page layout chrome | The7 wraps all WPBakery pages | WPBakery pages lose The7's layout chrome — must plan for this |

### Critical constraint: WPBakery pages

The7 renders the header, footer, and page structure for all WPBakery pages currently on production.
Switching to Hello Elementor will strip that chrome from any WPBakery page not yet migrated
to Elementor. This is the primary blocker for the theme swap.

**Resolution options (choose one before proceeding):**

1. **Migrate or trash all active WPBakery pages first**, then switch. Cleanest path.
2. **Build a temporary fallback header/footer** that Hello Elementor renders for WPBakery pages
   (possible via Elementor Theme Builder conditions). More complex but allows earlier switch.
3. **Defer** theme switch until the WPBakery page count reaches near zero via the
   "migrate as you touch" approach. Lowest risk, slowest.

---

## Prerequisites before switching

- [ ] Hello Elementor installed and tested on `thefivestardev` (dev environment)
- [ ] Elementor Pro Header template built and verified (matches current The7 header visually)
- [ ] Elementor Pro Footer template built and verified
- [ ] Mega Menu plugin verified as functional under Hello Elementor (or replacement identified)
- [ ] The7 CPTs audited — list of active pages using Portfolio, Testimonials, Team, etc.
- [ ] WPBakery page disposition decided (migrate, trash, or fallback plan selected)
- [ ] Kit-test canary page (`/kit-test/`) verified visually under Hello Elementor on dev

---

## Migration phases

### Phase T1 — Audit (no site changes)

1. Run a full inventory of active WPBakery pages on production by searching post_content
   for actual shortcodes (more reliable than the `_wpb_vc_js_status` meta key, which only
   flags pages opened in the backend editor, not pages that currently contain WPBakery markup):

   ```bash
   ssh thefivestar wp eval '
   $pages = get_posts([
       "post_type"   => "page",
       "post_status" => ["publish", "private"],
       "numberposts" => -1,
       "fields"      => "ids",
   ]);
   echo "ID\tTitle\tModified\tHas_Elementor\tIn_Nav\n";
   $menus = wp_get_nav_menus();
   $menu_page_ids = [];
   foreach ($menus as $menu) {
       foreach (wp_get_nav_menu_items($menu) as $item) {
           $menu_page_ids[] = $item->object_id;
       }
   }
   foreach ($pages as $id) {
       $content = get_post_field("post_content", $id);
       if (strpos($content, "[vc_row") === false) continue;
       $has_el = get_post_meta($id, "_elementor_data", true) ? "YES" : "no";
       $in_nav = in_array($id, $menu_page_ids) ? "YES" : "no";
       echo $id . "\t" . get_the_title($id) . "\t"
            . get_post_field("post_modified", $id) . "\t"
            . $has_el . "\t" . $in_nav . "\n";
   }
   ' > /tmp/wpbakery-inventory.tsv
   ```

   Pipe output to a TSV for offline categorization. Columns: ID, Title, Modified, Has_Elementor, In_Nav.

2. Categorize each page using these signals:

   | Signal | Action |
   |--------|--------|
   | `In_Nav = YES` | Migrate — it's user-facing in a menu |
   | `Has_Elementor = YES` | Already partially migrated — confirm and clean up |
   | Modified > 2 years ago + `In_Nav = no` | Trash — do not migrate |
   | Modified < 6 months ago + `In_Nav = no` | Keep WPBakery until next touched |

   Cross-reference with GA4 / MonsterInsights: any page with meaningful traffic should
   migrate rather than trash regardless of age.
3. Audit The7 CPT usage: query each CPT type, identify any display templates or shortcodes
   referencing them
4. Document findings in `sites/thefivestar/wpbakery-migration.md` (add CPT audit section)

### Phase T2 — Dev environment build

1. On `thefivestardev`: install Hello Elementor
2. Build Header template in Elementor Pro Theme Builder:
   - Match current The7 header (logo, nav, Mega Menu integration)
   - Set condition: Entire Site
3. Build Footer template in Elementor Pro Theme Builder:
   - Match current The7 footer (links, copyright, social)
   - Set condition: Entire Site
4. Verify Mega Menu plugin loads and functions correctly
5. Run full regression on dev: all Elementor pages, all WPBakery pages still in use
6. Document CSS delta: what did The7 provide that Hello Elementor doesn't? Log any gaps.

### Phase T3 — Global Kit cleanup (on dev)

Once The7 is removed from dev, clean up the kit:

1. Remove `!important` from heading color rules in kit Custom CSS
2. Switch all section JSON `background_color` / `button_text_color` / overlay values
   from hardcoded hex to `__globals__` bindings using the fsi01nh–fsi07ho slot IDs
3. Re-export kit JSON to `sites/thefivestar/elementor-kit/*.json`
4. Verify visual parity on dev after kit cleanup

### Phase T4 — Staging promotion

1. Promote Hello Elementor + Header/Footer templates + cleaned kit to `thefivestarstg`
2. Full regression: all pages, mobile, tablet, desktop
3. Verify `/kit-test/` canary page
4. Verify Mega Menu on staging
5. Verify any WPBakery pages still on staging (they should render with the Elementor header/footer)

### Phase T5 — Production (approval gate)

Per the standing approval gate:

1. State operation and risk level: 🟡 Medium — theme switch affects all pages site-wide
2. Staging ✅ confirmed
3. STOP — report staging verification results
4. Ask: "Staging confirmed ✅ — ready to run on production. Approve?"
5. Wait for explicit approval from Jonathan
6. Switch theme on production via WP Admin → Appearance → Themes → Hello Elementor → Activate
7. Verify production: all Elementor pages, header/footer, Mega Menu, WPBakery pages

---

## Risk register

| Risk | Severity | Mitigation |
|------|----------|-----------|
| WPBakery pages break (no The7 header/footer) | High | Resolve via Phase T1 disposition decision before switch |
| Mega Menu incompatibility | Medium | Test on dev (Phase T2); fallback is Elementor Pro Nav menu |
| The7 CPT display templates break | Medium | Audit in Phase T1; most CPTs likely unused on active pages |
| CSS regressions on Elementor pages | Low | Kit cleanup (Phase T3) + full regression on dev and staging |
| Global Kit `__globals__` bindings fail | Low | Test thoroughly on dev; fallback is to keep hardcoded hex temporarily |

---

## Post-migration doc updates

After production switch is confirmed:

- `brands/fsi/design-system.md` → Update Theme section: The7 → Hello Elementor; remove migration note
- `docs/architecture.md` → Update Theme row to Hello Elementor; remove migration note
- `sites/thefivestar/the7-elementor-specificity-notes.md` → Add banner: "Resolved by Hello Elementor migration (DATE). This file is historical."
- `sites/thefivestar/elementor-global-kit-spec.md` → Update Custom CSS section (simplified rules post-cleanup)
- `brands/fsi/CLAUDE.md` → Update Theme section

---

## Reference files

- `sites/thefivestar/the7-elementor-specificity-notes.md` — full list of current CSS workarounds
- `sites/thefivestar/elementor-global-kit-spec.md` — current kit spec including Custom CSS section
- `sites/thefivestar/wpbakery-migration.md` — WPBakery page inventory and migration tracker
- `docs/decisions.md` 2026-04-22 — portfolio standardization decision (Elementor forward)
- `docs/sops/elementor-json-authoring.md` — JSON push pipeline (used in Phase T3)
