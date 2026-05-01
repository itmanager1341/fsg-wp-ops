# SOP: FSI Production Promotion (Wave 1)

Comprehensive runbook for promoting the FSI Elementor migration from staging
(`thefivestarstg`) to production (`thefivestar`). Each foundation step (F1-F4)
runs once. Each wave-1 phase (.11) is an independent prod gate requiring
explicit Jonathan approval.

**Decision basis:** `docs/decisions.md` 2026-04-22 portfolio standardization,
2026-04-26 Option B pattern, 2026-04-30 PM Velocity Template A revision, plus
all subsequent staging shipments.

**Production approval gate (verbatim from `CLAUDE.md`):**

> Never run any operation on production without explicit per-stage approval
> from Jonathan. Blanket session approval ≠ production approval. Approval to
> run on staging ≠ production approval. Steps 5+6 of the gate (ask in chat,
> wait for explicit "yes") have no exceptions.

**Staging confirmed ✅ → STOP → ask in chat → wait for "yes" → only then prod.**

---

## Pre-flight findings (2026-04-30, captured for reference)

| Check | Status | Action |
|---|---|---|
| `fsi-event-styles.php` mu-plugin on prod | ✅ deployed (after incident + workflow fix) | F1 done 2026-04-30 18:08 |
| `eps-301-redirects` plugin on prod | ✅ active | none |
| Elementor on prod | 4.0.3 (staging 4.0.2) | F4 accept |
| Elementor Pro on prod | 4.0.2 (matches staging) | none |
| Active kit on prod | ID 4004, settings promoted from staging | F3 done 2026-04-30 18:43 (backup at `_elementor_page_settings_backup_2026_04_30_184340`) |
| 11 media assets on prod | ✅ all 11 registered | F2 done (Jonathan via WP Admin); FORCE + LL got `-scaled-1` suffix from name conflict, flagged for Wave 1 Step 2 |
| `/communities/` parent on prod | does not exist | created in step 4b-hub.11 |

**Foundation status as of 2026-04-30 PM:** F1, F2, F3 all complete. F4 = accept version drift, no action. Wave 1 unblocked.

**Prod page IDs (resolved 2026-04-30):**

| Page | Prod ID | Current state on prod | Phase .11 pattern |
|---|---|---|---|
| Events parent (`/events/`) | **5089** | WPBakery (matches staging pre-migration) | 2.11 in-place swap |
| Velocity (`/events/velocity/`) | **5088** | WPBakery (matches staging pre-migration) | 3.11 create-new + slug-swap (5088 → `velocity-old`) |
| Memberships parent (`/memberships/`) | **2597** | WPBakery (matches staging pre-migration) | 4a-hub.11 create-new + slug-swap (2597 → `memberships-old`) |
| Real Estate Professionals | **5087** under parent 2597 | WPBakery, mis-located under /memberships/ | 4b.11 create-new under /communities/ + slug-swap + 301 |
| Communities parent | (does not exist) | — | 4b-hub.11 create new parent + push Elementor data |
| LLSS (existing prod page at plural slug) | **3579** at `legal-league-servicers-summit` (parent 2683) | WPBakery, different historical slug | 1.11 create-new at canonical singular slug; no collision |
| Velocity 2024 archive | 4436 | deprecation candidate | untouched |

---

## SSH session startup (every session)

Per `docs/sops/ssh-session-startup.md`. Confirm:

```bash
ssh thefivestarstg 'wp option get siteurl'   # expect https://thefivestarstg.wpenginepowered.com
ssh thefivestar    'wp option get siteurl'   # expect https://thefivestar.com
```

If staging WP-CLI fails: `ssh thefivestarstg 'wp core download --skip-content'`.

---

# F1: Deploy `fsi-event-styles.php` mu-plugin to production

**STATUS as of 2026-04-30 18:08:** ✅ DONE. Mu-plugin live on prod. md5 parity local + staging + prod = `4814b1f8b145c8381bc40c46f53b2f3e`. Skip this section unless re-deploying. Original runbook below preserved for reference + post-mortem context.

**INCIDENT NOTE:** the first F1 attempt deleted WP core from prod (rsync `--delete` reached install root because `SRC_PATH` defaulted to repo root). Recovered via `wp core download --skip-content --force`. Workflow fixed in `thefivestar-wp` commit `e9db426` (`SRC_PATH: wp-content/` + `REMOTE_PATH: wp-content/`). Retry succeeded with corrected workflow. See `decisions.md` 2026-04-30 entry for full incident detail. **Going forward:** F1 (and any future deploy) only operates inside `wp-content/`; install-root WP core is physically out of rsync scope.

---

**Risk:** 🟡 Medium (adds a CSS-only mu-plugin; staging-validated for weeks)
**Reversible via:** git revert + GHA deploy
**Why now:** every staged page (Velocity, LLSS, RE Pros, Memberships hub, Communities hub) references CSS classes from this plugin (`.fsi-card-gold`, `.fsi-grid-3`, `.fsi-callout-gold`, `.fsi-membership-card`, `.fsi-photo-strip`, `.fsi-section-heading`, etc.). Without it, those classes resolve to nothing → unstyled blocks.

## Pre-flight

```bash
# 1. Confirm mu-plugin file exists in repo
ls ../thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php

# 2. Confirm WPE GHA deploy workflow on main is healthy
gh run list --repo itmanager1341/thefivestar-wp --workflow="Deploy to WP Engine" --limit 5

# 3. Confirm prod has no in-flight deployments
ssh thefivestar 'ls -la /nas/content/live/thefivestar/wp-content/mu-plugins/'
```

## Execution

```bash
cd ../thefivestar-wp

# 1. Confirm working tree is clean
git status

# 2. Verify the mu-plugin is what we expect (CSS classes used by staging)
grep -c 'fsi-' wp-content/mu-plugins/fsi-event-styles.php
# expect: ~25-30 class references

# 3. (If needed) commit any pending change to the mu-plugin
# git add wp-content/mu-plugins/fsi-event-styles.php
# git commit -m "feat: deploy fsi-event-styles.php for FSI Elementor migration"

# 4. Push to main → GHA auto-deploys to staging
git push origin main

# 5. Watch the staging deploy succeed
gh run watch --repo itmanager1341/thefivestar-wp

# 6. STOP. Confirm staging still renders cleanly (cache-busted curl on a known page)
curl -sI "https://thefivestarstg.wpenginepowered.com/events/velocity/?cb=$RANDOM" -o /dev/null -w "%{http_code}\n"

# 7. STOP. Ask Jonathan: "Staging confirmed. Ready to deploy mu-plugin to PRODUCTION via GHA. Approve?"
# 8. After explicit "yes":
gh workflow run "Deploy to WP Engine" --ref main --field environment=production --repo itmanager1341/thefivestar-wp
gh run watch --repo itmanager1341/thefivestar-wp
```

## Verification

```bash
# 1. File present on prod
ssh thefivestar 'ls -la /nas/content/live/thefivestar/wp-content/mu-plugins/fsi-event-styles.php'

# 2. Plugin loaded by WP (no fatal errors)
ssh thefivestar 'wp option get siteurl 2>&1'

# 3. CSS classes accessible — load any prod page that uses .fsi-event-card / .fsi-page-wrap and confirm CSS is present
curl -s 'https://thefivestar.com/events/' | grep -oE 'class="fsi-[^"]+"' | head -5
```

## Rollback

```bash
cd ../thefivestar-wp
git revert HEAD
git push origin main
gh workflow run "Deploy to WP Engine" --ref main --field environment=production
```

---

# F2: Upload 11 media assets to production

**STATUS as of 2026-04-30 14:38:** ✅ DONE. All 11 assets registered on prod with attachment records + responsive variants. Jonathan uploaded via WP Admin → Media → Add New (Path A from this runbook). FORCE_COLOR + LL_COLOR got `-scaled-1` filename suffixes due to name conflicts; **this requires resolution before Wave 1 Step 2** (Memberships hub references the un-suffixed filenames). See section JSONs at `sites/thefivestar/elementor-templates/membership-pages/_hub/03-specialty-grid.json`. Either re-upload without conflict OR URL-rewrite at deploy time. Non-blocking for F1/F3.

---

**Risk:** 🟢 Safe (additive; no overwrites)
**Reversible via:** delete attachments via WP Admin Media or `wp post delete <id>`
**Why now:** Every staged page references these assets. Without them, images broken on prod.

## Asset list

| File | Used by | Source on staging |
|---|---|---|
| Velocity_Conference_2026_Hero_1900-x-600.jpg | Velocity Section 1 hero bg | uploads/2026/04/ |
| FSAlliance_Logo_480-x-220.jpg | Velocity Section 6 Alliance card | uploads/2026/04/ |
| Community-Velocity4.jpg | Velocity Section 2 community photo | uploads/2026/04/ |
| LogoForce1.jpg | Velocity Section 6 FORCE card | uploads/2026/04/ |
| FS_Alliance_Logo_v2.png | Memberships hub Alliance hero | uploads/2026/04/ |
| FSI-Brand-logo_FORCE_COLOR.png | Memberships hub FORCE tile | uploads/2026/04/ |
| FSI-Brand-logo_LL_COLOR.png | Memberships hub Legal League tile | uploads/2026/04/ |
| FSI-Brand-logo_NMSA_COLOR.png | Memberships hub NMSA tile | uploads/2026/04/ |
| FSI-Brand-logo_MSEA_COLOR.png | Memberships hub MSEA tile | uploads/2026/04/ |
| FSI-Brand-logo_PPEF_COLOR.png | Memberships hub PPEF tile | uploads/2026/04/ |
| FSI-Brand-logo_AMDC_COLOR.png | Memberships hub AMDC tile | uploads/2026/04/ |

**⚠️ Critical:** filenames + upload month must match staging URL bindings. All staging URLs are at `uploads/2026/04/`. Uploading in May lands files at `uploads/2026/05/` and breaks every URL reference. Either:
- Upload before midnight 2026-04-30 (preferred; uses WordPress's auto-date routing)
- OR use the controlled-path script below (overrides date routing)

## Path A: WP Admin upload (Jonathan does this manually)

1. Open https://thefivestar.com/wp-admin/upload.php
2. Click **Add New** → drag all 11 files OR upload one at a time
3. Verify each lands at `/wp-content/uploads/2026/04/<filename>` (not 2026/05/)
4. Verify each gets an attachment ID + responsive variants

## Path B: Pull-from-staging script (controlled, preserves /2026/04/ path)

This script copies each asset from staging to prod via base64 push, then
registers as a proper WP attachment with `wp_insert_attachment` + responsive
variants generated.

```bash
# Run this from local machine
cat > /tmp/asset-promote.php <<'PHP'
<?php
$assets = [
  ['Velocity_Conference_2026_Hero_1900-x-600.jpg', 'image/jpeg'],
  ['FSAlliance_Logo_480-x-220.jpg',                'image/jpeg'],
  ['Community-Velocity4.jpg',                      'image/jpeg'],
  ['LogoForce1.jpg',                               'image/jpeg'],
  ['FS_Alliance_Logo_v2.png',                      'image/png'],
  ['FSI-Brand-logo_FORCE_COLOR.png',               'image/png'],
  ['FSI-Brand-logo_LL_COLOR.png',                  'image/png'],
  ['FSI-Brand-logo_NMSA_COLOR.png',                'image/png'],
  ['FSI-Brand-logo_MSEA_COLOR.png',                'image/png'],
  ['FSI-Brand-logo_PPEF_COLOR.png',                'image/png'],
  ['FSI-Brand-logo_AMDC_COLOR.png',                'image/png'],
];

$target_dir = wp_upload_dir(date('Y-m-01', strtotime('2026-04-15')))['path'];
// Force /2026/04/ regardless of current date by passing 2026-04-15 as the date

foreach ($assets as [$filename, $mime]) {
  $src = "/nas/content/cli-staging-pull/{$filename}";  // populated by base64 push
  if (!file_exists($src)) {
    echo "SKIP missing source: {$filename}\n";
    continue;
  }
  $dest = "{$target_dir}/{$filename}";
  copy($src, $dest);
  $attachment = [
    'post_mime_type' => $mime,
    'post_title'     => preg_replace('/\.[^.]+$/', '', $filename),
    'post_content'   => '',
    'post_status'    => 'inherit',
  ];
  $attach_id = wp_insert_attachment($attachment, $dest);
  require_once(ABSPATH . 'wp-admin/includes/image.php');
  $meta = wp_generate_attachment_metadata($attach_id, $dest);
  wp_update_attachment_metadata($attach_id, $meta);
  echo "REGISTERED ID={$attach_id}  {$filename}\n";
}
PHP

# 1. Push each file from staging to prod via base64 push
for f in Velocity_Conference_2026_Hero_1900-x-600.jpg FSAlliance_Logo_480-x-220.jpg Community-Velocity4.jpg LogoForce1.jpg FS_Alliance_Logo_v2.png FSI-Brand-logo_FORCE_COLOR.png FSI-Brand-logo_LL_COLOR.png FSI-Brand-logo_NMSA_COLOR.png FSI-Brand-logo_MSEA_COLOR.png FSI-Brand-logo_PPEF_COLOR.png FSI-Brand-logo_AMDC_COLOR.png; do
  echo "=== pulling $f from staging ==="
  ssh thefivestarstg "cat /nas/content/live/thefivestarstg/wp-content/uploads/2026/04/$f | base64" \
    | ssh thefivestar "mkdir -p /nas/content/cli-staging-pull && base64 -d > /nas/content/cli-staging-pull/$f && ls -la /nas/content/cli-staging-pull/$f"
done

# 2. Register all as WP attachments (preserves /2026/04/ path)
cat /tmp/asset-promote.php | ssh thefivestar 'wp eval-file - 2>&1' | grep -v Deprecated

# 3. Cleanup the staging-pull dir
ssh thefivestar 'rm -rf /nas/content/cli-staging-pull'
```

## Verification

```bash
# All 11 should report REGISTERED with attachment IDs
cat /tmp/asset-check.php | ssh thefivestar 'wp eval-file -' 2>&1 | grep -v Deprecated

# Spot-check a few URLs work
curl -sI 'https://thefivestar.com/wp-content/uploads/2026/04/Velocity_Conference_2026_Hero_1900-x-600.jpg' -o /dev/null -w "%{http_code}\n"
curl -sI 'https://thefivestar.com/wp-content/uploads/2026/04/FS_Alliance_Logo_v2.png' -o /dev/null -w "%{http_code}\n"
```

## Rollback

```bash
# Delete by attachment ID via wp post delete
# Files on disk: rm /nas/content/live/thefivestar/wp-content/uploads/2026/04/<filename>
```

---

# F3: Promote Elementor kit (staging → prod)

**STATUS as of 2026-04-30 18:43:** ✅ DONE. Prod kit 4004 now has 17 custom_colors (10 legacy preserved + 7 fsi*), system_colors at FSI brand values (primary `#1F365C`, secondary `#C9A040`), custom_css with heading scoping, container_widths 1100/768/480. Pre-state HTML diff on 5 sample prod pages: 4 had ZERO byte diff, 1 (/velocity/ which is the deprecation candidate page 4436) had -756 bytes from regenerated CSS query strings + container_width adjustment + dropped Bangers/Comic Book font face declarations. Atomic rollback at meta key `_elementor_page_settings_backup_2026_04_30_184340`. Skip this section unless re-promoting; original runbook below preserved for reference.

---

**Risk:** 🔴 High (kit changes affect EVERY Elementor page on prod, not just our migrated ones)
**Reversible via:** restore from `_elementor_page_settings_backup_*` meta key
**Why now:** Staging kit (modified 2026-04-23) has 17 custom colors including the `fsi*` brand-color slot IDs that all migrated pages bind to. Prod kit (modified 2025-11-04) doesn't have them. If we ship Phase .11 pages without kit promotion, the brand-color CSS variables resolve to nothing → broken brand colors on the new pages. The 7 prod-back-compat slot IDs (`f64043d`, `fd98090`, etc.) are preserved in the staging kit by design (per 2026-04-25 decision), so prod pages bound to those slot IDs render unchanged.

## Pre-flight

```bash
# 1. Confirm staging kit ID + last modified
ssh thefivestarstg 'echo "kit ID: $(wp option get elementor_active_kit)"; wp post get $(wp option get elementor_active_kit) --field=post_modified'

# 2. Confirm prod kit ID + last modified
ssh thefivestar 'echo "kit ID: $(wp option get elementor_active_kit)"; wp post get $(wp option get elementor_active_kit) --field=post_modified'

# 3. Audit prod custom-color slot usage (which prod pages bind to which slots)
# Use scripts/wpe-api.sh or manual query to identify pages using globals/colors?id=...
# Specifically check pages: 4497 Exit Intent, 4560 Education, 4993 Five Star Access, 4436 Velocity (deprecation candidate)
```

## Execution

```bash
# 1. Pull staging kit's _elementor_page_settings to local
ssh thefivestarstg 'wp post meta get $(wp option get elementor_active_kit) _elementor_page_settings' \
  > /tmp/staging-kit-settings.json

# 2. Validate JSON
python3 -c "import json; d=json.load(open('/tmp/staging-kit-settings.json')); print('custom_colors:', len(d.get('custom_colors',[]))); print('system_colors:', len(d.get('system_colors',[])))"
# expect: custom_colors: 17, system_colors: 4

# 3. Push to prod with backup-first per SOP Lesson #6
B64=$(base64 -i /tmp/staging-kit-settings.json)
TS=$(date +%Y_%m_%d_%H%M%S)
cat <<EOF | ssh thefivestar 'wp eval-file - 2>&1' | grep -v Deprecated
<?php
\$kit_id = (int) get_option('elementor_active_kit');
\$decoded = json_decode(base64_decode('${B64}'), true);
if (!\$decoded) { fwrite(STDERR, "decode fail\n"); exit(1); }

# BACKUP MANDATORY
\$backup_key = '_elementor_page_settings_backup_${TS}';
\$current = get_post_meta(\$kit_id, '_elementor_page_settings', true);
update_post_meta(\$kit_id, \$backup_key, \$current);
echo "backup at meta key: " . \$backup_key . "\n";

# Sanity: confirm kit will have BOTH legacy + fsi slot IDs
\$slot_ids = array_column(\$decoded['custom_colors'] ?? [], '_id');
echo "writing custom_colors slot IDs: " . implode(',', \$slot_ids) . "\n";

# WRITE
update_post_meta(\$kit_id, '_elementor_page_settings', \$decoded);
echo "kit settings written\n";

# FLUSH per-page CSS (regenerates EVERY page's CSS using new kit)
Elementor\Plugin::\$instance->files_manager->clear_cache();
echo "elementor css cache cleared\n";

if (class_exists('WpeCommon')) {
  WpeCommon::purge_varnish_cache_all();
  WpeCommon::purge_memcached();
  echo "wpe varnish + memcached purged\n";
}
EOF

# 4. wp cache flush + wp-rocket
ssh thefivestar 'wp cache flush && rm -rf /nas/content/cache/wp-rocket/thefivestar.com/*'
```

## Verification

```bash
# 1. Spot-check a known-bound prod page renders correctly
# Page 4560 Education uses slot 7836aae (Velocity Yellow)
# Page 4993 Five Star Access uses slots f64043d, 7836aae, 9e77118
# These should render UNCHANGED if the legacy slot IDs are preserved
curl -s 'https://thefivestar.com/education/' -o /tmp/prod-education.html -w "%{http_code}\n"
curl -s 'https://thefivestar.com/five-star-access/' -o /tmp/prod-five-star-access.html -w "%{http_code}\n"
# Manual visual diff against pre-promotion screenshot

# 2. Confirm fsi* slots are now available
ssh thefivestar 'wp post meta get $(wp option get elementor_active_kit) _elementor_page_settings' \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print('fsi* slots:', sum(1 for c in d.get('custom_colors',[]) if c.get('_id','').startswith('fsi')))"
# expect: 7
```

## Rollback

```bash
# Restore from the backup meta key (find timestamp from execution log above)
TS=<timestamp_from_step_3>
ssh thefivestar "wp eval 'update_post_meta(get_option(\"elementor_active_kit\"), \"_elementor_page_settings\", get_post_meta(get_option(\"elementor_active_kit\"), \"_elementor_page_settings_backup_${TS}\", true)); Elementor\\Plugin::\$instance->files_manager->clear_cache();'"
```

---

# F4: Elementor version drift decision

**Risk:** 🟢 Safe to defer (4.0.x patch series; schema-compatible)

**Status:** Prod is on Elementor 4.0.3 / Pro 4.0.2. Staging is on 4.0.2 / 4.0.2.

**Recommendation:** **Accept the drift.** 4.0.3 is a patch release in the same minor; widget schemas are stable across patches. Don't downgrade prod (risky), don't upgrade staging mid-promotion (introduces variables). Re-evaluate after Wave 1 ships.

**If you decide to align:** the safe direction is staging → 4.0.3. Update via WP Admin → Plugins → Update on staging, then re-export the kit + widget references and verify staged pages still render. Don't touch prod versions during the migration window.

**No action required for Wave 1.** Documented for the record.

---

# Wave 1, Step 1: Phase 3.11 Velocity production promotion

**STATUS as of 2026-04-30 ~19:50:** ✅ DONE. New prod page 5110 at canonical `/events/velocity/`. Old WPBakery 5088 preserved at `/events/velocity-old/`. Backup `834949a1-6720-42ce-8dc9-4bddf772081e` + atomic `_elementor_data_backup_2026_04_30_193938` on prod page 5110.

---

**Risk:** 🟡 Medium (create-new + slug-swap; existing prod 5088 preserved)
**Pre-reqs:** F1 ✅ + F2 (Velocity assets registered: Velocity_Conference_2026_Hero, FSAlliance_Logo, Community-Velocity4, LogoForce1) + F3 ✅
**Reversible via:** slug-swap back (reverse the operation) + delete the new page
**Pages affected:** Creates new prod page; renames existing prod 5088 (`/events/velocity/`) → `/events/velocity-old/`

## Pre-flight

```bash
# 1. F1 confirmed (mu-plugin on prod)
ssh thefivestar 'ls /nas/content/live/thefivestar/wp-content/mu-plugins/fsi-event-styles.php'

# 2. F2 confirmed (4 Velocity assets registered)
cat /tmp/asset-check.php | ssh thefivestar 'wp eval-file -' 2>&1 | grep -v Deprecated | grep -E 'Velocity|FSAlliance|Community-Velocity|LogoForce'
# all 4 should be REGISTERED

# 3. F3 confirmed (kit promoted)
ssh thefivestar 'wp post meta get $(wp option get elementor_active_kit) _elementor_page_settings' \
  | python3 -c "import json,sys; d=json.load(sys.stdin); print('custom_colors:', len(d.get('custom_colors',[])))"
# expect: 17

# 4. Capture pre-state baseline of prod /events/velocity/ (rollback reference)
curl -s 'https://thefivestar.com/events/velocity/' -o /tmp/prod-velocity-pre.html -w "%{http_code}\n"
# Optional: Playwright screenshot at 1440 of pre-state
```

## Execution

```bash
# 1. Create new Elementor page on prod (same metadata as staging 5107)
cat <<'PHP' | ssh thefivestar 'wp eval-file - 2>&1' | grep -v Deprecated
<?php
$post_id = wp_insert_post([
  'post_title'   => 'Velocity',
  'post_name'    => 'velocity-elementor',
  'post_status'  => 'publish',
  'post_type'    => 'page',
  'post_parent'  => 5089,
  'post_content' => '',
]);
update_post_meta($post_id, '_elementor_edit_mode', 'builder');
update_post_meta($post_id, '_elementor_template_type', 'wp-page');
update_post_meta($post_id, '_elementor_version', '4.0.3');
update_post_meta($post_id, '_elementor_pro_version', '4.0.2');
update_post_meta($post_id, '_dt_header_title', 'disabled');
update_post_meta($post_id, '_elementor_data', '[]');
echo "new prod page ID: " . $post_id . "\n";
PHP

# Capture the new page ID for next steps
PROD_VELOCITY_ID=<from_above>

# 2. Compose Velocity sections from disk (per SOP Lesson #25 + #26)
python3 << 'EOF'
import json, glob, os
VEL = '/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/elementor-templates/event-pages/velocity'
STRIP_KEYS = {'_authoring_notes', '_TODO', '_NOTE', '_comment', '_meta'}
def strip(o):
    if isinstance(o, dict): return {k: strip(v) for k,v in o.items() if k not in STRIP_KEYS}
    if isinstance(o, list): return [strip(v) for v in o]
    return o
files = sorted(glob.glob(f'{VEL}/[0-9]*.json'))
sections = [strip(json.load(open(f))) for f in files]
# REWRITE bg image URLs from staging → prod domain
def rewrite_urls(o):
    if isinstance(o, dict): return {k: rewrite_urls(v) for k,v in o.items()}
    if isinstance(o, list): return [rewrite_urls(v) for v in o]
    if isinstance(o, str): return o.replace('thefivestarstg.wpenginepowered.com', 'thefivestar.com')
    return o
sections = rewrite_urls(sections)
# Hero image attachment ID needs to be the PROD attachment ID, not staging 5143
# Look up prod ID via wp post list before this step and replace inline
json.dump(sections, open('/tmp/velocity-prod.json','w'), separators=(',',':'))
print(f'composed: {os.path.getsize("/tmp/velocity-prod.json")} bytes, {len(sections)} sections')
EOF

# 2b. Look up prod attachment IDs and replace in the composed payload
PROD_HERO_ID=$(ssh thefivestar 'wp post list --post_type=attachment --posts_per_page=1 --fields=ID --format=csv --s="Velocity_Conference_2026_Hero_1900-x-600.jpg" 2>/dev/null | tail -1')
PROD_ALLIANCE_ID=$(ssh thefivestar 'wp post list --post_type=attachment --posts_per_page=1 --fields=ID --format=csv --s="FSAlliance_Logo_480-x-220.jpg" 2>/dev/null | tail -1')
# Replace staging IDs (5143 → $PROD_HERO_ID) in the JSON
python3 -c "
import json
d = json.load(open('/tmp/velocity-prod.json'))
def fix(o):
    if isinstance(o, dict):
        if 'background_image' in o and isinstance(o['background_image'], dict) and o['background_image'].get('id') == 5143:
            o['background_image']['id'] = $PROD_HERO_ID
        return {k: fix(v) for k, v in o.items()}
    if isinstance(o, list): return [fix(v) for v in o]
    return o
d = fix(d)
json.dump(d, open('/tmp/velocity-prod.json', 'w'), separators=(',', ':'))
print('fixed prod hero ID')
"

# 3. Push payload + cache flush
B64=$(base64 -i /tmp/velocity-prod.json)
TS=$(date +%Y_%m_%d_%H%M%S)
cat <<EOF | ssh thefivestar 'wp eval-file - 2>&1' | grep -v Deprecated
<?php
\$post_id = ${PROD_VELOCITY_ID};
\$json = base64_decode('${B64}');
\$decoded = json_decode(\$json, true);
if (!\$decoded) { fwrite(STDERR, "decode fail\n"); exit(1); }
echo "sections: " . count(\$decoded) . "\n";

\$backup_key = '_elementor_data_backup_${TS}';
update_post_meta(\$post_id, \$backup_key, get_post_meta(\$post_id, '_elementor_data', true));
echo "backup at: " . \$backup_key . "\n";

update_post_meta(\$post_id, '_elementor_data', wp_slash(\$json));
echo "data written: " . strlen(\$json) . " bytes\n";

Elementor\Plugin::\$instance->files_manager->clear_cache();
if (class_exists('WpeCommon')) {
  WpeCommon::purge_varnish_cache_all();
  WpeCommon::purge_memcached();
}
echo "DONE\n";
EOF

ssh thefivestar 'wp cache flush && rm -rf /nas/content/cache/wp-rocket/thefivestar.com/*'

# 4. STOP. Verify prod /events/velocity-elementor/ renders correctly BEFORE slug-swap
curl -s "https://thefivestar.com/events/velocity-elementor/?cb=\$RANDOM" -w "HTTP %{http_code}\n" -o /tmp/prod-velocity-new.html
# spot-check rendering: hero image, info bar, all 9 sections present
grep -oE 'velocity-(hero|info-bar|intro|what-happens|charter-offer|membership|event-details|final|footer)' /tmp/prod-velocity-new.html | sort -u | wc -l
# expect: 9

# 5. STOP. Ask Jonathan: "Staging-pattern Velocity rendered cleanly at /events/velocity-elementor/. Ready to slug-swap (5088 → velocity-old, new page → velocity)?"
# 6. After explicit "yes":
cat <<EOF | ssh thefivestar 'wp eval-file - 2>&1' | grep -v Deprecated
<?php
# Rename existing prod 5088 → velocity-old + add "(Old WPBakery)" suffix
wp_update_post([
  'ID'         => 5088,
  'post_name'  => 'velocity-old',
  'post_title' => 'Velocity (Old WPBakery)',
]);
echo "5088 renamed to velocity-old\n";

# Promote new page to canonical slug
wp_update_post([
  'ID'         => ${PROD_VELOCITY_ID},
  'post_name'  => 'velocity',
  'post_title' => 'Velocity',
]);
echo "${PROD_VELOCITY_ID} promoted to /events/velocity/\n";

# Flush rewrite rules
flush_rewrite_rules(false);

if (class_exists('WpeCommon')) {
  WpeCommon::purge_varnish_cache_all();
  WpeCommon::purge_memcached();
}
EOF

ssh thefivestar 'wp cache flush && rm -rf /nas/content/cache/wp-rocket/thefivestar.com/*'
```

## Verification

```bash
# 1. Canonical URL serves new Elementor page
curl -s "https://thefivestar.com/events/velocity/?cb=\$RANDOM" -o /tmp/v.html -w "HTTP %{http_code}\n"
grep -c "elementor-element-velocity-hero-section" /tmp/v.html  # expect: 1

# 2. -old URL serves WPBakery version (preserved)
curl -s "https://thefivestar.com/events/velocity-old/?cb=\$RANDOM" -w "HTTP %{http_code}\n" -o /dev/null

# 3. Bare URL (no cache-bust) returns the new page (Varnish flushed clean)
curl -sI "https://thefivestar.com/events/velocity/" -w "HTTP %{http_code}\n" -o /dev/null
```

## Rollback

```bash
# Reverse slug-swap
cat <<EOF | ssh thefivestar 'wp eval-file -'
<?php
wp_update_post(['ID' => 5088,                  'post_name' => 'velocity', 'post_title' => 'Velocity']);
wp_update_post(['ID' => ${PROD_VELOCITY_ID},   'post_name' => 'velocity-elementor', 'post_title' => 'Velocity (Elementor)']);
flush_rewrite_rules(false);
EOF
ssh thefivestar 'wp cache flush && rm -rf /nas/content/cache/wp-rocket/thefivestar.com/*'

# If new page itself is broken, restore from backup meta key:
# update_post_meta(${PROD_VELOCITY_ID}, '_elementor_data', get_post_meta(${PROD_VELOCITY_ID}, '_elementor_data_backup_${TS}', true))
```

---

# Wave 1, Step 2: Phase 4a-hub.11 Memberships hub production promotion

**STATUS as of 2026-04-30 ~20:30:** ✅ DONE. New prod page 5113 at canonical `/memberships/`. Old WPBakery 2597 preserved at `/memberships-old/`. Backup `4b7f4e62-dd2d-421f-96dc-1a2f80fcb9d9` + atomic `_elementor_data_backup_2026_04_30_202430` on prod page 5113. Followed by Step 3.5 nav repoint (TFSI menu item 2622 + Footer Menu item 2779 both repointed from object_id 2597 → 5113).

**Pre-flight cleanup that happened during this step:** FORCE_COLOR + LL_COLOR logos had `-scaled-1` filename suffix from name-collision on prod upload. Jonathan trashed and re-uploaded clean. New prod attachment IDs: 5112 (FORCE_COLOR), 5111 (LL_COLOR). Section JSONs work as-authored.

---

**Risk:** 🟡 Medium (create-new + slug-swap per Jonathan 2026-04-30; existing prod 2597 preserved)
**Pre-reqs:** F1 ✅ + F2 (7 logos registered: FS_Alliance_Logo_v2, FSI-Brand-logo_*_COLOR x6) + F3 ✅
**Pages affected:** Creates new prod page; renames existing prod 2597 (`/memberships/`) → `/memberships-old/`

**Same pattern as Velocity (Wave 1 step 1):** new page → push composed JSON → verify → slug-swap. Section files at `sites/thefivestar/elementor-templates/membership-pages/_hub/[01-hero, 03-specialty-grid, 04-alliance-foundation, 05-footer-line].json` (4 sections, no info bar).

**Specifics:**

```bash
# Create new page
cat <<'PHP' | ssh thefivestar 'wp eval-file -' | grep -v Deprecated
<?php
$post_id = wp_insert_post([
  'post_title'   => 'Memberships',
  'post_name'    => 'memberships-elementor',
  'post_status'  => 'publish',
  'post_type'    => 'page',
  'post_parent'  => 0,  # root level
  'post_content' => '',
]);
update_post_meta($post_id, '_elementor_edit_mode', 'builder');
update_post_meta($post_id, '_elementor_template_type', 'wp-page');
update_post_meta($post_id, '_elementor_version', '4.0.3');
update_post_meta($post_id, '_elementor_pro_version', '4.0.2');
update_post_meta($post_id, '_dt_header_title', 'disabled');
update_post_meta($post_id, '_elementor_data', '[]');
echo "new prod page ID: " . $post_id . "\n";
PHP

# Compose from disk + replace 7 logo attachment IDs (5126, 5127, 5129, 5131, 5133, 5136, 5137)
# with corresponding prod IDs (look up via wp post list)
# (script analogous to Velocity step 2b above)

# Push + cache flush + verify at /memberships-elementor/

# STOP. Approve.

# Slug-swap: 2597 → memberships-old, new page → memberships
cat <<EOF | ssh thefivestar 'wp eval-file -' | grep -v Deprecated
<?php
wp_update_post(['ID' => 2597, 'post_name' => 'memberships-old', 'post_title' => 'Memberships (Old WPBakery)']);
wp_update_post(['ID' => \${PROD_MEMBERSHIPS_ID}, 'post_name' => 'memberships', 'post_title' => 'Memberships']);
flush_rewrite_rules(false);
EOF
```

**Pre-promotion cleanup tasks:** em-dash violations in 3 specialty card subtitles (NMSA, MSEA, AMDC). Fix in `sites/thefivestar/elementor-templates/membership-pages/_hub/03-specialty-grid.json` BEFORE composing for prod push.

---

# Wave 1, Step 3: Phase 4b-hub.11 Communities hub production promotion

**STATUS as of 2026-04-30 ~21:20:** ✅ DONE. New prod page 5114 at canonical `/communities/`. Single create-and-populate op (no slug-swap needed). Backup `590aec49-e7e3-4154-ac9d-7bdf3dac69a0`. Per the standing nav-wiring rule, /communities/ is published but NOT added to top-nav.

---

**Risk:** 🟡 Medium (creates new `/communities/` parent — does not exist on prod)
**Pre-reqs:** F1 ✅ + F2 ✅ + F3 ✅
**Pages affected:** Creates new `/communities/` parent on prod (no slug-swap needed since no existing /communities/)

```bash
# Single op: create the parent page directly with Elementor data populated
cat <<'PHP' | ssh thefivestar 'wp eval-file -' | grep -v Deprecated
<?php
$post_id = wp_insert_post([
  'post_title'   => 'Communities',
  'post_name'    => 'communities',
  'post_status'  => 'publish',
  'post_type'    => 'page',
  'post_parent'  => 0,
  'post_content' => '',
]);
update_post_meta($post_id, '_elementor_edit_mode', 'builder');
update_post_meta($post_id, '_elementor_template_type', 'wp-page');
update_post_meta($post_id, '_elementor_version', '4.0.3');
update_post_meta($post_id, '_elementor_pro_version', '4.0.2');
update_post_meta($post_id, '_dt_header_title', 'disabled');
update_post_meta($post_id, '_elementor_data', '[]');
echo "new /communities/ parent ID: " . $post_id . "\n";
PHP

# Compose 6 sections from sites/thefivestar/elementor-templates/community-pages/_hub/
# (no logos to remap; no inline image URLs)
# Push, flush, verify

# Nav-wiring: STOP. Per the standing rule (decisions.md 2026-04-23), DO NOT add /communities/ to top-nav without explicit approval.
```

---

# Post-slug-swap nav audit (REQUIRED after any Phase .11 that renames a page)

**Why this exists:** WP nav menu items reference pages by post ID. When a slug-swap renames an existing page (e.g., 2597 → `memberships-old`), nav items still pointing to that post ID will display the renamed page's title ("Memberships (Old WPBakery)") and link to the renamed URL. Lesson learned 2026-04-30 during Wave 1 Step 2 → Step 3.5 sequence.

**When to run:** any Phase .11 that uses create-new + slug-swap (Steps 1, 2; future LLSS 1.11). NOT needed for in-place swap (no rename) or pure create-new (no existing page).

**Find nav items pointing to the renamed page:**

```bash
cat <<'PHP' | ssh thefivestar 'wp eval-file -' | grep -v Deprecated
<?php
$RENAMED_OLD_ID = <old_page_id>;  # e.g., 2597 (now memberships-old)
$NEW_PAGE_ID = <new_page_id>;     # e.g., 5113 (the new memberships)

global $wpdb;
$rows = $wpdb->get_results($wpdb->prepare("
  SELECT p.ID, p.post_title, m1.meta_value AS object_type, m2.meta_value AS object_id
  FROM {$wpdb->posts} p
  LEFT JOIN {$wpdb->postmeta} m1 ON p.ID = m1.post_id AND m1.meta_key = '_menu_item_type'
  LEFT JOIN {$wpdb->postmeta} m2 ON p.ID = m2.post_id AND m2.meta_key = '_menu_item_object_id'
  WHERE p.post_type = 'nav_menu_item' AND p.post_status = 'publish' AND m2.meta_value = %s
", (string)$RENAMED_OLD_ID), ARRAY_A);
foreach ($rows as $r) echo "  Item ID={$r['ID']} title={$r['post_title']} object_id={$r['object_id']}\n";
PHP
```

**Repoint each item (per `how-we-update-the-site.md` nav gotcha — never `wp_update_nav_menu_item` for partial updates):**

```bash
cat <<EOF | ssh thefivestar 'wp eval-file -'
<?php
foreach ([<item_id_1>, <item_id_2>] as \$item_id) {
    update_post_meta(\$item_id, '_menu_item_object_id', '<new_page_id>');
}
wp_cache_flush();
if (class_exists('WpeCommon')) { WpeCommon::purge_varnish_cache_all(); WpeCommon::purge_memcached(); }
EOF
ssh thefivestar 'wp cache flush && rm -rf /nas/content/cache/wp-rocket/thefivestar.com/*'
```

**Verify:** load home page + footer; confirm nav text reads correctly + links resolve to new URL.

---

# Wave 1, Step 4: Phase 2.11 Events hub production promotion

**Risk:** 🔴 High (in-place swap on prod page 5089 with 4 child URLs that must remain HTTP 200)
**Pre-reqs:** F1 ✅ + Steps 1+2 (Velocity prod-shipped so child URL `/events/velocity/` already migrated)
**Pages affected:** In-place swap on prod 5089 (Events parent). Child URLs preserved.

**Same in-place swap technique as staging 2026-04-27 (decisions.md entry + SOP Lesson #24):**

```bash
TS=$(date +%Y_%m_%d_%H%M%S)
cat <<EOF | ssh thefivestar 'wp eval-file -' | grep -v Deprecated
<?php
\$post_id = 5089;

# BACKUP everything first (atomic rollback)
update_post_meta(\$post_id, '_elementor_inplace_swap_backup_${TS}_post_content',     get_post_field('post_content', \$post_id));
update_post_meta(\$post_id, '_elementor_inplace_swap_backup_${TS}_elementor_data',   get_post_meta(\$post_id, '_elementor_data', true));
update_post_meta(\$post_id, '_elementor_inplace_swap_backup_${TS}_edit_mode',        get_post_meta(\$post_id, '_elementor_edit_mode', true));

# Apply Elementor mode meta
update_post_meta(\$post_id, '_elementor_edit_mode', 'builder');
update_post_meta(\$post_id, '_elementor_template_type', 'wp-page');
update_post_meta(\$post_id, '_elementor_version', '4.0.3');
update_post_meta(\$post_id, '_elementor_pro_version', '4.0.2');
update_post_meta(\$post_id, '_dt_header_title', 'enabled');  # preserve "EVENTS" page-title bar

# Push composed _elementor_data
\$json = file_get_contents('/tmp/events-hub-prod.json');
update_post_meta(\$post_id, '_elementor_data', wp_slash(\$json));

# Clear post_content
wp_update_post(['ID' => \$post_id, 'post_content' => '']);

Elementor\Plugin::\$instance->files_manager->clear_cache();
if (class_exists('WpeCommon')) {
  WpeCommon::purge_varnish_cache_all();
  WpeCommon::purge_memcached();
}
EOF

# CRITICAL VERIFY: all 4 child URLs still HTTP 200
for slug in legal-league-servicer-summit velocity legal-league-servicers-summit; do
  curl -sI "https://thefivestar.com/events/${slug}/" -w "${slug}: HTTP %{http_code}\n" -o /dev/null
done
```

## Rollback (in-place swap)

```bash
TS=<from_step_above>
cat <<EOF | ssh thefivestar 'wp eval-file -'
<?php
\$post_id = 5089;
update_post_meta(\$post_id, '_elementor_data',  get_post_meta(\$post_id, '_elementor_inplace_swap_backup_${TS}_elementor_data', true));
update_post_meta(\$post_id, '_elementor_edit_mode', get_post_meta(\$post_id, '_elementor_inplace_swap_backup_${TS}_edit_mode', true));
wp_update_post(['ID' => \$post_id, 'post_content' => get_post_meta(\$post_id, '_elementor_inplace_swap_backup_${TS}_post_content', true)]);
Elementor\Plugin::\$instance->files_manager->clear_cache();
EOF
```

---

# Wave 1, Step 5: Phase 4b.11 RE Pros production promotion

**Risk:** 🟡 Medium (creates new under /communities/, slug-swap of prod 5087, 301 redirect)
**Pre-reqs:** F1 ✅ + Step 3 (/communities/ parent exists on prod)
**Pages affected:** Existing prod 5087 (currently at `/memberships/real-estate-professionals/`) → relocate to `/communities/real-estate-professionals-old/`. New page at `/communities/real-estate-professionals/`. 301 redirect from old URL.

**Three operations in one Phase .11:**

```bash
# 1. Create new RE Pros under /communities/
COMMUNITIES_ID=<from step 3>
cat <<PHP | ssh thefivestar 'wp eval-file -' | grep -v Deprecated
<?php
$post_id = wp_insert_post([
  'post_title'   => 'Real Estate Professionals',
  'post_name'    => 'real-estate-professionals-elementor',
  'post_status'  => 'publish',
  'post_type'    => 'page',
  'post_parent'  => ${COMMUNITIES_ID},
  'post_content' => '',
]);
update_post_meta($post_id, '_elementor_edit_mode', 'builder');
update_post_meta($post_id, '_elementor_template_type', 'wp-page');
update_post_meta($post_id, '_elementor_version', '4.0.3');
update_post_meta($post_id, '_elementor_pro_version', '4.0.2');
update_post_meta($post_id, '_dt_header_title', 'disabled');
update_post_meta($post_id, '_elementor_data', '[]');
echo "new RE Pros ID: " . $post_id . "\n";
PHP

# 2. Compose 8 sections from community-pages/real-estate-professionals/, push (no images to remap)
# Verify at /communities/real-estate-professionals-elementor/

# STOP. Approve.

# 3. Slug + parent swap of existing 5087: relocate from /memberships/ to /communities/, rename to -old
cat <<EOF | ssh thefivestar 'wp eval-file -' | grep -v Deprecated
<?php
wp_update_post([
  'ID'          => 5087,
  'post_name'   => 'real-estate-professionals-old',
  'post_title'  => 'Real Estate Professionals (Old WPBakery)',
  'post_parent' => ${COMMUNITIES_ID},
]);
wp_update_post([
  'ID'         => \${PROD_REPRO_ID},
  'post_name'  => 'real-estate-professionals',
  'post_title' => 'Real Estate Professionals',
]);
flush_rewrite_rules(false);
EOF

# 4. Add 301 redirect via eps-301-redirects (per SOP Lesson #20: NO query string)
ssh thefivestar 'wp db query "INSERT INTO wp_0edpxsjfuc_redirects (url_from, url_to, type, status) VALUES (\"memberships/real-estate-professionals\", \"\${PROD_REPRO_ID}\", \"post\", \"301\")"'
# (table name 'wp_0edpxsjfuc_redirects' is from staging; verify prod table name first via SHOW TABLES LIKE '%redirects%')

# 5. Verify 301 fires (use BARE URL, no cache-buster per Lesson #20)
curl -sI "https://thefivestar.com/memberships/real-estate-professionals/" -w "HTTP %{http_code}\n"
# expect: 301 → 200 follow chain to /communities/real-estate-professionals/
```

---

# Wave 2 (next session, after Wave 1 complete)

| # | Phase | Page | Pattern |
|---|---|---|---|
| 6 | LLSS Template A revision (staging) | LLSS staging 5106 | Apply Velocity 2026-04-30 pattern: image-only hero, 3-col info bar, 20/20 padding cap. Same operations as Velocity 2026-04-30 deploy. |
| 7 | **1.11 LLSS** | prod | Create-new at canonical singular slug `/events/legal-league-servicer-summit/`. Prod 3579 (plural slug `legal-league-servicers-summit`) untouched (no collision). |

---

# Cross-cutting: pre-promotion cleanup tasks

Before any Phase .11 ships:

| Task | Why | Where |
|---|---|---|
| Em-dash cleanup in 3 Memberships hub specialty card subtitles | Per em-dash rule | `sites/thefivestar/elementor-templates/membership-pages/_hub/03-specialty-grid.json` (NMSA, MSEA, AMDC subtitles) |
| Em-dash cleanup in 5 Memberships hub image alt-text strings | Per em-dash rule (screen readers) | Same file |
| Em-dash cleanup in 3 CSS comments in `fsi-event-styles.php` | Per em-dash rule (consistency) | `thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php`. Bundle with F1. |
| Footer "Membership Groups" widget link drift `/memberships-old/` → `/memberships/` | Cleanup from prior 4a-hub slug swap on staging | WP Admin → Appearance → Widgets → Footer. Apply on prod after 4a-hub.11 ships. |

---

# Glossary

- **Foundation step (F1-F4):** runs once, enables every Phase .11 promotion.
- **Phase .11:** prod promotion of a specific staged page/template.
- **In-place swap:** direct meta-write to existing post ID (preserves child URLs). Use when page has children.
- **Create-new + slug-swap:** create new Elementor page, verify, then rename old page to `-old` and promote new page to canonical slug. Use when page has no children OR moving to different parent.
- **Production approval gate:** verbatim block in `CLAUDE.md`. Steps 5+6 (ask, wait) have no exceptions.
- **Atomic rollback:** restore from `_elementor_data_backup_*` (or `_elementor_inplace_swap_backup_*`) timestamped meta keys.
- **Cache flush sequence (Lesson #16):** Elementor `flush_css` + `wp cache flush` + `rm -rf wp-rocket/*` + `WpeCommon::purge_varnish_cache_all()` + `WpeCommon::purge_memcached()`.
