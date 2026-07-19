# Runbook: R3 — Build Hello Elementor Chrome + Activate

Phase R3 of `../rebuild-plan.md`. Runs on the clone (`thefivestardev`). Builds the Header,
Footer, and Mega Menu as Elementor Pro Theme Builder templates **while The7 is still active**,
adds a fallback page template, then activates Hello Elementor in one step so the site never
renders chrome-less. **This is GUI work in the Elementor editor** — Claude preps + verifies via
CLI; the template building happens in WP Admin.

## State at R3 start (verified 2026-07-11)

| Item | Value |
|------|-------|
| Active theme | `dt-the7` 14.4.2 (Hello Elementor **not yet installed**) |
| Elementor / Pro | 4.1.4 / 4.1.2 (Pro active — Theme Builder available) |
| Active kit | 4004 (do NOT clean `__globals__` here — that's R5) |
| PHP | 8.4 (dev already on target) |
| Main nav menu | menu 14 "Navigation" (8) or 31 "TFSI" (13) — confirm header assignment |
| Footer menus | 32 "Footer Menu" (6); 83 "Learn More About Our Member Groups" (6) |

## Preconditions

- ✅ R2 complete (pages classified/trashed, LMS gone).
- 🔴 WPE Password protection ON for dev (still pending — enable before front-end review).
- Reference for visual match: `sites/thefivestar/visual-baselines/` (The7 header/footer at
  1440/768/420), `brands/fsi/design-system.md` (tokens), `sites/thefivestar/the7-dependency-audit.md`.

## Pre-work (Claude, CLI)

1. Confirm which menu is assigned to the header/primary location:
   ```bash
   ssh thefivestardev "wp menu location list --url=thefivestardev.wpengine.com"
   ```
2. Capture fresh The7 reference screenshots of header + footer + mega-menu open, at 1440/768/420,
   for side-by-side parity checks (Playwright against the temp domain).
3. Note the footer "Membership Groups" widget link set (menu 83) — watch known link drift
   (`site-profile.md`).

## Build steps (Elementor editor, The7 still active)

Templates don't take over until Hello is the active theme, so building now is safe.

### 1. Header template
- Templates → Theme Builder → **Header** → Add New → **Display condition: Entire Site**.
- Rebuild to match The7 header against the visual baseline: logo (left), primary nav (menu
  confirmed in pre-work), utility/CTA items, sticky behavior.
- Style via kit 4004 globals where possible (final `__globals__` conversion is R5).

### 2. Mega Menu (native, replaces The7/legacy dependency)
- Build the mega menu **natively in Elementor Pro** (Nav Menu / Mega Menu widget) — do NOT rely
  on The7's mega menu or the legacy plugin (removed with The7). Recreate the dropdown panels/
  columns from the current live mega menu (reference screenshots).

### 3. Footer template
- Theme Builder → **Footer** → **Entire Site**.
- Rebuild: footer menu (32), "Member Groups" columns (menu 83), copyright, social icons —
  match The7 footer baseline.

### 4. Fallback singular Page template (safety net)
- Theme Builder → **Single → Page** → condition **All Pages** (lowest priority).
- Minimal content-only template so any of the **14 still-WPBakery pages** renders with the new
  header/footer under Hello instead of naked. (`theme-migration.md` resolution option 2.)

## Activate Hello Elementor

```bash
ssh thefivestardev "wp theme install hello-elementor --url=thefivestardev.wpengine.com"   # do NOT --activate yet
```
- Verify Header/Footer/fallback templates exist and are published first.
- Then activate in one step:
  ```bash
  ssh thefivestardev "wp theme activate hello-elementor --url=thefivestardev.wpengine.com"
  ```

## Verification (Claude, CLI + visual)

```bash
# Full 200-sweep of the surviving URL set on the temp domain (cache-busted):
# (build the list from the 30 published pages + posts; expect all 200)
# Header/footer present on: an Elementor page, a still-WPBakery page (via fallback), a post.
ssh thefivestardev "wp theme list --status=active --field=name --url=thefivestardev.wpengine.com"  # hello-elementor
```
- Visual: header, footer, mega-menu open — parity vs The7 baseline at 1440/768/420.
- Spot-check a **WPBakery page** (e.g. 3146 Five Star Conference, 13 Contact) renders WITH chrome.
- PHP error log clean (WPE → Logs) on 8.4.
- Kit 4004 still active; no visual collapse on Elementor pages.

## Gate R3

- [ ] Header + Footer + Mega Menu + fallback Page templates built and published
- [ ] Hello Elementor active; The7 deactivated
- [ ] Full 200-sweep passes on temp domain
- [ ] Chrome renders on Elementor pages, WPBakery pages (fallback), and posts
- [ ] Mega menu works natively (no The7/legacy dependency)
- [ ] PHP log clean; kit 4004 intact

## Rollback

Single step — reactivate The7: `wp theme activate dt-the7`. Or restore checkpoint
`48b72dd4…`. No prod impact (all on the clone).

## Not in R3
- `__globals__` kit cleanup + hardcoded-hex removal → **R5**.
- Re-authoring the 14 MIGRATE pages + 16 LEAVE pages to native widgets → **R4**.
