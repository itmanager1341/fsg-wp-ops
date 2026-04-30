# SOP: Elementor JSON-Authoring (Workflow C1)

The default authoring path for Elementor kits, templates, and pages on FSG
Media WordPress sites. Source-of-truth lives in this repo as JSON; staging
state is reproduced via `wp elementor` WP-CLI commands over SSH.

**Decision basis:** `docs/decisions.md` 2026-04-25 entry — AI-first Elementor
authoring + Elementor version pin.

**Where UI is still required:** see Workflow C2 in `how-we-update-the-site.md`.

**Verified on:** FSI staging, Elementor + Elementor Pro 4.0.2, The7 14.3.0,
2026-04-25.

---

## Repo layout

```
sites/thefivestar/
  elementor-kit/                          # SOURCE OF TRUTH for Elementor Pro Site Settings
    site-settings.json                    # Global Colors, Layout, Custom CSS
    custom-fonts.json                     # Custom font uploads (TTF refs)
    custom-code.json                      # Custom Code blocks (Naylor, Apollo, etc.)
    manifest.json                         # Kit metadata (plugin list, experiments, theme info)
  elementor-global-kit-v1.zip             # BUILT ARTIFACT (rezip of elementor-kit/)
  elementor-templates/
    widget-references/                    # READ-ONLY widget schema oracle
      kit-test-page-5099.json
      <widget-type>.json (per type)
    event-pages/                          # One subdirectory per event page (URL slug = directory name)
      legal-league-servicer-summit/       # Phase 1.4 LLSS — 9 sections (2026-04-26)
        01-hero.json
        02-intro-who-belongs.json
        03-what-happens.json
        04-next-summit.json
        05-recent-summit-strip.json
        06-membership-cards.json
        07-event-details.json
        08-final-cta.json
        09-footer-line.json
      velocity/                           # Phase 3 Velocity — 8 sections (2026-04-27, Section 5 skipped)
        01-hero.json
        02-intro-who-belongs.json
        03-what-happens.json
        04-charter-offer.json             # Velocity-specific (analog to LLSS 04-next-summit.json)
        06-membership-cards.json          # Five Star Alliance + FORCE
        07-event-details.json
        08-final-cta.json
        09-footer-line.json
      events/                             # Phase 2 Events hub (later)
    membership-pages/                     # Phase 4a Membership template (FORCE, Legal League firms, AMDC, etc.)
      force/                              # Phase 4a — greenfield (planned)
      legal-league/                       # Phase 4a — greenfield (planned)
      five-star-alliance/                 # Phase 4a — greenfield (planned)
      ...                                  # AMDC, PPEF, NMSA, MSEA
    community-pages/                      # Phase 4b Community template (profession pages)
      real-estate-professionals/          # Phase 4b — first-instance (relocates existing 5087 mockup from /memberships/)
      mortgage-finance/                   # Phase 4b — greenfield (planned)
      legal/                              # Phase 4b — greenfield (planned)
      prop-pres/                          # Phase 4b — greenfield (planned)
  visual-baselines/                       # Pre/post screenshots from verification runs
    kit-test-post-roundtrip-2026-04-25.png
```

`elementor-kit/*.json` is the source. The `.zip` is the deployable artifact;
rebuild it before each push.

---

## Pinned versions (FSI)

| Component | Pinned version |
|-----------|----------------|
| Elementor | 4.0.2 |
| Elementor Pro | 4.0.2 |
| The7 | 14.3.0 |

Disable WP auto-update for `elementor` and `elementor-pro` on FSI staging and
production. Manual upgrade only, per the decision-log entry.

Verify before authoring:

```bash
ssh thefivestarstg 'wp plugin get elementor --field=version && wp plugin get elementor-pro --field=version'
# Expected: 4.0.2 / 4.0.2
```

If versions drift: stop, re-export the kit + widget-references, diff against
repo, decide whether the new version is a controlled upgrade or an unwanted
auto-update to roll back.

---

## SSH session startup

Per `docs/sops/ssh-session-startup.md`. Persistent shell with ssh-agent loaded
once. All commands below assume agent is loaded and the host alias resolves.

---

## Push pipe — binary file to staging

WPE SSH Gateway whitelists commands. SCP, `cat > file`, and direct shell
redirects are blocked. Use `wp eval-file -` reading PHP from stdin.

Push location: `wp_upload_dir()['basedir'] . '/cli-imports/'` — persistent
across SSH container recycles (unlike `/tmp/` on WPE).

```bash
B64=$(base64 -i /path/to/local/file.zip)
PHP_SCRIPT=$(cat <<EOF
<?php
\$dir = wp_upload_dir()['basedir'] . '/cli-imports';
if (!is_dir(\$dir)) { mkdir(\$dir, 0755, true); }
\$path = \$dir . '/file.zip';
file_put_contents(\$path, base64_decode('$B64'));
echo \$path . ' size=' . filesize(\$path) . ' md5=' . md5_file(\$path) . PHP_EOL;
EOF
)
echo "$PHP_SCRIPT" | ssh thefivestarstg 'wp eval-file - 2>/dev/null'
```

**Verify integrity:** the script returns `md5=...`. Compare to
`md5 -q /local/path/file.zip`. They must match before importing.

**Cleanup after import:**

```bash
echo '<?php
$p = wp_upload_dir()["basedir"] . "/cli-imports/file.zip";
if (file_exists($p)) { unlink($p); echo "deleted\n"; }
$dir = wp_upload_dir()["basedir"] . "/cli-imports";
if (is_dir($dir) && count(scandir($dir)) === 2) { rmdir($dir); echo "rmdir\n"; }' \
| ssh thefivestarstg 'wp eval-file - 2>/dev/null'
```

---

## Kit Site Settings — direct meta-write (DO NOT use `wp elementor kit import` for kit-only changes)

**⚠️ Critical gotcha (verified 2026-04-25 on FSI staging Elementor 4.0.2):**
`wp elementor kit import` is broken for our use case in two distinct ways:

1. **`--include=site-settings` silently no-ops.** The CLI command returns
   `Success: Kit imported successfully` but creates an import session with
   `runners: []` (zero runners). Nothing is written. The active kit is
   unchanged. The "success" message is meaningless.
2. **Without `--include`, runners fire BUT the import APPENDS instead of
   REPLACES.** Custom colors are appended to the existing `custom_colors`
   array, producing duplicate `_id` entries in the kit (e.g., slot
   `f64043d` listed twice with different titles/hex). Elementor's runtime
   resolution of `globals/colors?id=...` becomes undefined. It also
   trashes the original `elementor_snippet` posts (Naylor, Apollo) and
   creates new ones with new IDs — breaking any reference to the old IDs.
   It also creates a new kit post and switches `elementor_active_kit` to
   point at it, orphaning the previous kit.

**Use `wp elementor kit import` ONLY when you explicitly want a brand-new
kit post created with full kit semantics** (e.g., importing onto a fresh
site). For routine kit-content updates (color tweaks, typography changes,
layout adjustments, custom CSS edits), use direct meta-write.

### Direct meta-write (the safe path)

```bash
# 1. Pretty-print every JSON file (keeps git diffs readable)
cd sites/thefivestar/elementor-kit
for f in *.json; do python3 -m json.tool "$f" > "$f.pretty" && mv "$f.pretty" "$f"; done

# 2. Push site-settings.json to staging via the binary push pipe (above),
#    OR base64-encode and inline directly into the PHP script below

# 3. Direct write to active kit's _elementor_page_settings, with backup
B64=$(base64 -i sites/thefivestar/elementor-kit/site-settings.json)
PHP_SCRIPT=$(cat <<EOF
<?php
\$decoded = json_decode(base64_decode('$B64'), true);
if (!\$decoded || !isset(\$decoded['settings'])) {
  WP_CLI::error('Failed to decode site-settings.json');
}
\$kit_id = (int) get_option('elementor_active_kit');
echo "Active kit: " . \$kit_id . PHP_EOL;
echo "Writing " . count(\$decoded['settings']['custom_colors']) . " custom_colors, " .
     count(\$decoded['settings']['system_colors']) . " system_colors\n";

# BACKUP first (mandatory — gives instant rollback)
\$backup_key = '_elementor_page_settings_backup_' . date('Y_m_d_His');
update_post_meta(\$kit_id, \$backup_key, get_post_meta(\$kit_id, '_elementor_page_settings', true));
echo "Backup saved at meta key: " . \$backup_key . PHP_EOL;

# WRITE
\$result = update_post_meta(\$kit_id, '_elementor_page_settings', \$decoded['settings']);
echo "update_post_meta result: " . (\$result ? 'true (changed)' : 'false (unchanged or failed)') . PHP_EOL;

# FLUSH per-page CSS
Elementor\\Plugin::\$instance->files_manager->clear_cache();
echo "Elementor CSS cache cleared\n";
EOF
)
echo "$PHP_SCRIPT" | ssh thefivestarstg 'wp eval-file - 2>&1' | grep -v Deprecated | tail -10
```

**Why this works:** `update_post_meta` REPLACES the value cleanly — no
appending, no duplicate slot IDs, no new posts created. It writes
exactly the JSON we sent. The Elementor `files_manager->clear_cache()`
call replaces `wp elementor flush_css` (same underlying function).

**Atomic rollback:** restore from the backup meta key.

```bash
echo "<?php
\$kit = (int) get_option('elementor_active_kit');
\$backups = array_filter(array_keys(get_post_meta(\$kit)), function(\$k){
  return strpos(\$k, '_elementor_page_settings_backup_') === 0;
});
sort(\$backups);
\$latest = end(\$backups);
echo 'Restoring from: ' . \$latest . PHP_EOL;
\$prev = get_post_meta(\$kit, \$latest, true);
update_post_meta(\$kit, '_elementor_page_settings', \$prev);
Elementor\\Plugin::\$instance->files_manager->clear_cache();
echo 'restored' . PHP_EOL;" | ssh thefivestarstg 'wp eval-file - 2>/dev/null'
```

**Periodic backup cleanup:** the backup meta keys accumulate. After verifying
a kit change is good for a few days, delete older backups via
`delete_post_meta(<kit_id>, <backup_key>)`. Keep the 2-3 most recent.

### When to use `wp elementor kit import` (the rare cases)

- **First-time import on a fresh site.** No active kit exists; the import-system
  pathway is correct.
- **Importing custom-code/custom-fonts/templates that don't yet exist.** The
  runners that handle these create the necessary posts. (Verify your destination
  doesn't already have entries that would be duplicated — query first.)
- **Cross-site kit promotion** (e.g., FSI→AMAA in Phase 7) where the destination
  has no FSI kit yet. Use full import. Then switch to direct meta-write for
  ongoing changes.

For these cases, the command pattern is:

```bash
# Push the zip first via the binary push pipe (above)
ssh thefivestarstg \
  'wp elementor kit import \
   /sites/thefivestarstg/wp-content/uploads/cli-imports/elementor-global-kit-v1.zip \
   --user=816 2>&1' | grep -v Deprecated | tail -10
ssh thefivestarstg 'wp elementor flush_css'
```

Note the `--user=<id>` is required. FSI staging admin is `jhughes` / ID 816.

### `wp elementor kit revert` — atomic rollback for `kit import`

Verified working 2026-04-25. After a `kit import` operation, this restores the
previous active kit pointer and removes the imported kit post. **Does NOT
restore trashed `elementor_snippet` posts** — manual `wp post update <id>
--post_status=publish` is needed for those.

```bash
ssh thefivestarstg 'wp elementor kit revert 2>&1' | tail -5
```

Use only after a `kit import`. For direct-meta-write rollback, use the backup
meta key approach above.

---

## Template / section import

Phase 1.4 sections live in `sites/thefivestar/elementor-templates/event-pages/legal-league-servicer-summit/`.
Each `.json` file is one Elementor template export.

```bash
# Push the directory contents to staging
# (loop the push-pipe pattern over each .json file, OR build a single zip
#  containing all sections)

# Bulk import from a directory:
ssh thefivestarstg \
  'wp elementor library import_dir /sites/thefivestarstg/wp-content/uploads/cli-imports/event-page/ \
   --user=816 2>&1' | grep -v Deprecated | tail -20

# Single-file import:
ssh thefivestarstg \
  'wp elementor library import /sites/thefivestarstg/wp-content/uploads/cli-imports/01-hero.json \
   --user=816 2>&1'

# Flush:
ssh thefivestarstg 'wp elementor flush_css'
```

---

## Direct `_elementor_data` write (page content)

For pages where the content (not a template) is authored as JSON in the repo:

```bash
PAGE_ID=5094
JSON_DATA=$(cat sites/thefivestar/elementor-templates/event-pages/legal-league-servicer-summit/llss-page.json | python3 -c "import json,sys; print(json.dumps(json.load(sys.stdin)))")

# Write the JSON-encoded data + required Elementor meta
echo "<?php
update_post_meta($PAGE_ID, '_elementor_data', wp_slash('$JSON_DATA'));
update_post_meta($PAGE_ID, '_elementor_edit_mode', 'builder');
update_post_meta($PAGE_ID, '_elementor_template_type', 'wp-page');
update_post_meta($PAGE_ID, '_elementor_version', '4.0.2');
update_post_meta($PAGE_ID, '_elementor_pro_version', '4.0.2');
echo 'wrote page $PAGE_ID' . PHP_EOL;
" | ssh thefivestarstg 'wp eval-file - 2>/dev/null'

# Mandatory: flush per-page CSS cache
ssh thefivestarstg "wp eval 'Elementor\\Plugin::\$instance->files_manager->clear_cache();' 2>/dev/null"
# OR
ssh thefivestarstg 'wp elementor flush_css'
```

**Note on `wp_slash`:** WordPress automatically slashes data passed to
`update_post_meta`. The `_elementor_data` value is itself JSON containing
escaped quotes and backslashes, so it gets double-slashed. Use `wp_slash()` to
match the convention or read the existing value with
`wp post meta get <id> _elementor_data` to see the storage format.

**Element ID convention:** use deterministic IDs (e.g.,
`hero-section-2026-04`, not random hashes) so diffs are readable across pushes
and re-imports are idempotent. Element IDs must be unique within a page.

---

## Verification gate (mandatory after every push)

Two reads. The push is not done until both pass.

### 1. Computed-style assertion (structured)

```bash
# Spawn a Playwright browser, navigate, fetch computed styles
# (use mcp__playwright__browser_navigate + browser_evaluate)
```

Inspect at minimum:
- Heading widgets: `color`, `fontFamily`, `fontSize`, `fontWeight`, `lineHeight`
- Body text: `color`, `fontFamily`, `fontSize`
- Container: `width`, `maxWidth`
- Any widget you specifically changed

Compare to expected values from the kit spec or section spec. Mismatch =
push not complete.

### 2. Visual screenshot (full-page)

Save full-page screenshot to `sites/thefivestar/visual-baselines/{slug}-{date}.png`.
For Phase 1.4 sections, also screenshot at 768px and 480px breakpoints.

The screenshots are committed to the repo as the visual baseline. Future
pushes diff visually against the baseline.

---

## Color slot ID convention (Phase 1.3 remediation context, 2026-04-25)

When the Phase 1.3 kit was set up via the UI (Sasa, 2026-04-23), 7 of the 10
pre-existing prod custom-color slot IDs were *replaced in place* with brand
colors:

| Slot ID | Original (still on prod) | Was replaced with (Phase 1.3) |
|---------|-------------------------|--------------------------------|
| `f64043d` | Velocity Blue `#0086DB` | Navy Hover `#162848` |
| `fd98090` | Velocity Lighter Blue `#EEAC04` | Gold Hover `#B8922E` |
| `7836aae` | Velocity Yellow `#EEAC04` | Offwhite `#F7F7F5` |
| `9bb2763` | Velocity Red `#D12726` | Border `#E0E0DC` |
| `9e77118` | Velocity White `#FFFFFF` | Light Grey `#CFD5DE` |
| `2922fdd` | Velocity CP Red `#D02422` | Gold Text Dark `#3D2E00` |
| `73bb18d` | Velocity CP Orange `#F09A1E` | Hero Overlay `#1F365CD9` |

4 prod pages bind to those slot IDs (Exit Intent popup 4497, Education 4560,
Five Star Access 4993, Velocity 4436). Promoting the Phase 1.3 kit to prod
without remediation would change the rendered color on every binding.

**Remediation (applied to staging kit 4004 via direct meta-write, 2026-04-25):**

- The 7 contested slot IDs are restored to their prod Velocity values
- The 7 brand colors get NEW slot IDs prefixed `fsi*` (`fsi01nh`, `fsi02gh`,
  `fsi03ow`, `fsi04bd`, `fsi05lg`, `fsi06gt`, `fsi07ho`)
- Net 17 custom-color slots — backwards-compatible with prod, forwards-
  compatible with brand work

**Slot ID convention going forward:**
- `fsi[NN][initials]` — FSI brand colors (e.g., `fsi08xx` for the next addition)
- Pre-existing 7-char hex-ish IDs are preserved for whatever pages currently
  reference them
- Never overwrite a pre-existing slot's title/hex without first querying
  `_elementor_data` across all post types for `globals/colors?id=<slot>`
  references on the destination environment

## Pre-flight: check global-color usage before changing any slot

Before changing the title or hex of any pre-existing custom-color slot,
query the destination environment for usages:

```bash
echo "<?php
global \$wpdb;
\$sid = '<slot_id_to_check>';
\$rows = \$wpdb->get_results(\$wpdb->prepare(
  \"SELECT pm.post_id, p.post_title, p.post_type, p.post_status
     FROM {\$wpdb->postmeta} pm JOIN {\$wpdb->posts} p ON p.ID = pm.post_id
     WHERE pm.meta_key='_elementor_data' AND pm.meta_value LIKE %s
     ORDER BY p.post_status, p.post_type\",
  '%globals/colors?id=' . \$sid . '%'
));
echo count(\$rows) . ' pages reference slot ' . \$sid . PHP_EOL;
foreach (\$rows as \$r) { echo sprintf('  [%s/%s] %5d  %s' . PHP_EOL, \$r->post_status, \$r->post_type, \$r->post_id, \$r->post_title); }" \
| ssh thefivestar 'wp eval-file - 2>/dev/null'
```

Run this on **both staging AND production** before any slot-modifying change.
Prod and staging kits can drift (we discovered 2026-04-25 that prod kit 4004
was last modified 2025-11-04 — five months stale relative to staging).

## Lessons learned (apply, then update this file as more land)

1. **WPE `/tmp/` is container-scoped.** A push to `/tmp/file.zip` is gone the
   next SSH connection. Always push to `wp_upload_dir()['basedir']/cli-imports/`.
2. **`scp` is blocked on WPE SSH Gateway.** Only `wp eval-file -` works for
   binary push.
3. **`wp elementor kit import --include=site-settings` is silently broken
   in Elementor 4.0.2.** Returns "Success" but creates a session with zero
   runners. Use direct meta-write instead.
4. **`wp elementor kit import` (no `--include`) APPENDS custom_colors instead
   of replacing.** Produces duplicate slot IDs in the kit. Also creates
   duplicate elementor_snippet posts (Naylor, Apollo). Also creates a new
   kit post and switches `elementor_active_kit`. Use ONLY for first-time
   imports on fresh sites or cross-site promotion to greenfield destinations.
5. **`wp elementor kit revert` works as advertised** for atomic rollback after
   `kit import`. But it does NOT untrash trashed `elementor_snippet` posts —
   restore those manually with `wp post update <id> --post_status=publish`.
6. **Direct meta-write to `_elementor_page_settings`** is the safe path for
   kit-content updates. Always backup to a timestamped meta key first
   (`_elementor_page_settings_backup_YYYY_MM_DD_HHMMSS`).
7. **PROD and staging kits drift independently.** Check `post_modified` on
   the active kit on both sides before any kit promotion. Discovered 2026-04-25
   that prod kit was 5 months stale — would have caused regressions.
8. **Long WP-CLI commands need patient timeouts.** `wp elementor kit import`
   on Elementor 4.0.2 takes ~30-60s. Set timeout ≥ 120s.
9. **PHP 8.4 deprecation noise on FSI staging.** `Toolset`, `Views`,
   `WP-Rocket`, and `Elementor` itself emit notices on every CLI command.
   Filter with `grep -v Deprecated`. Production runs on PHP 8.2 and is silent.
10. **Elementor's `unfilteredFilesUpload` warning on `kit import`** is a
    benign internal CLI bug (missing default for an optional flag). Ignore.
11. **The kit zip captures plugin list + experiment flags + theme info** in
    `manifest.json`. Re-importing on AMAA may surface plugin-version
    mismatch warnings — those are advisory, not blocking.
12. **`__globals__` bindings for buttons + overlays don't work on FSI v4 +
    The7** (verified 2026-04-26). The per-page CSS Elementor generates
    has both `background-color: var(--color)` AND
    `background-image: var(--color)` — the latter is invalid (color into
    image), and browsers drop both declarations during parse, leaving
    The7's `.elementor-button { background: ... }` to win. Workaround:
    hardcode hex values directly in `button_text_color`,
    `background_color`, `button_background_hover_color`,
    `background_overlay_color` settings. Other widgets (Heading via Custom
    CSS, Text Editor `text_color`) honor globals correctly.
    See `sites/thefivestar/the7-elementor-specificity-notes.md` for the
    cascade analysis. Revisit on Hello Elementor swap.
13. **Strip ONLY authoring-only keys when composing pages from section
    JSON** (verified 2026-04-26). My initial strip-meta function was too
    aggressive — it removed every key starting with `_`, which silently
    deleted `__globals__` (Elementor's official internal-binding key).
    Current convention: only strip the exact key set
    `{_authoring_notes, _TODO, _comment, _meta, _NOTE}` and preserve all
    other underscore-prefixed keys (`__globals__`, `_id`, `_element_id`,
    `_element_cache`, `_inline_size`, `_column_size`, `_css_classes`).
14. **Browser-side `cssRules` inspection beats reading the CSS file**
    when diagnosing why a declaration isn't applying. The file-on-disk
    content can include declarations that the browser parses-and-drops
    (e.g., `background-image: var(--color)`). Use Playwright
    `getComputedStyle(el)`, then walk `document.styleSheets[*].cssRules`
    in the browser to see what the browser actually has in its cascade.
15. **Use Elementor's HTML widget when an existing CSS class system
    already encodes the visual design.** Don't translate well-styled
    HTML markup (e.g., `<div class="fsi-card-gold">`) into widget trees —
    the widget tree loses the CSS author's nuance and bloats DOM. Verified
    2026-04-26 on Phase 1.4 LLSS retrofit:
    - Widget tree version: 59 widgets / 35 containers / 39,958 bytes `_elementor_data`,
      visually inferior (recreated cards as solid-fill, not Offwhite-with-top-border)
    - HTML widget version: 15 widgets / 12 containers / 22,032 bytes (45% smaller),
      visually identical to source design (CSS classes apply automatically)
    - Pattern: Elementor outer Container provides structural layout
      (full-width vs boxed, padding, bg image, overlay). HTML widget
      inside contains the styled markup chunk. CSS comes from existing
      mu-plugin or kit Custom CSS.
    - When to use widget tree instead: hero sections with bg image +
      overlay (Elementor's container handles this elegantly), buttons
      where global-binding matters, anywhere you need animation/dynamic
      tags/Theme Builder integration.
    - When to use HTML widget: cards, grids, photo strips, content
      blocks where the visual design lives in CSS classes already.
    - SOP: include the existing CSS markup as-is in the HTML widget's
      `html` setting. Document the CSS source dependency in the JSON
      `_authoring_notes`. When the CSS source ever retires, plan a
      separate migration step to move the rules into the kit Custom CSS
      block.
16. **WPE Varnish + memcached require explicit purge after slug swap or
    `_elementor_data` push** (verified 2026-04-27 on Phase 3 Velocity
    slug swap). The standard cache-flush sequence (`wp cache flush`,
    `rm -rf wp-rocket/*`, `Elementor flush_css`) is NOT sufficient — WPE
    has its own Varnish HTTP cache and memcached object-cache layers
    that survive those calls. First post-swap visit served the OLD
    cached page; cache-busted curl revealed the new content was live in
    the DB. Add to the flush sequence:
    ```php
    if (class_exists("WpeCommon")) {
      WpeCommon::purge_varnish_cache_all();
      WpeCommon::purge_memcached();
    }
    ```
    Or per-page:
    ```php
    WpeCommon::purge_varnish_cache($post_id);
    ```
    Always run a cache-busted verify (`?cb=$RANDOM`) AFTER the purge
    before declaring the swap successful. If the cache-bust shows new
    content but the bare URL shows old, you have a Varnish miss to
    backfill — wait ~30s and re-check, or hit the bare URL once to
    repopulate.
17. **Page-create + slug-swap workflow proven across 2 events**
    (LLSS 2026-04-26, Velocity 2026-04-27). Repeatable pattern:
    1. `wp_insert_post` with parent + provisional slug (`<event>-elementor`)
       and status=publish
    2. `update_post_meta` for `_elementor_edit_mode='builder'`,
       `_elementor_template_type='wp-page'`,
       `_elementor_version='4.0.2'`,
       `_elementor_pro_version='4.0.2'`,
       `_dt_header_title='disabled'` (suppress The7 page-title bar),
       `_elementor_data='[]'` (empty initial)
    3. Compose section JSONs (Python script: load each
       `[0-9][0-9]-*.json` in numeric order, strip authoring-only keys
       `{_authoring_notes, _TODO, _NOTE, _comment, _meta}`, output as
       JSON array)
    4. Push via `wp eval-file -` running base64-decode +
       `update_post_meta($id, '_elementor_data', wp_slash($json))`
       with timestamped backup at `_elementor_data_backup_*` meta key
    5. `Elementor\Plugin::$instance->files_manager->clear_cache()`
    6. `wp cache flush` + `rm -rf wp-rocket/*`
    7. **(Lesson #16)** `WpeCommon::purge_varnish_cache_all()` +
       `WpeCommon::purge_memcached()`
    8. Visual verify at 1440/768/420 (Playwright + getComputedStyle audit)
    9. Slug swap when verified: original page → `<slug>-old` w/ "(Old
       WPBakery)" title; new page → canonical slug
    10. `flush_rewrite_rules(false)` + repeat the cache-purge steps
    11. Cache-busted verify on canonical + `-old` URLs
    Total wall-clock for a same-template clone (e.g., LLSS → Velocity):
    ~60-90 min.
18. **Element ID convention: prefix with the page slug** (e.g.,
    `velocity-hero-section`, `llss-hero-section` — not just
    `hero-section`). Prevents collisions if section JSONs ever get
    exported as Elementor library templates and shared across pages.
    Verified 2026-04-27 on Velocity build — using `velocity-*` prefix
    means the LLSS and Velocity sections can coexist in the same
    `elementor_library` post type without ID conflicts.
19. **Numeric file prefixes preserve cross-event correspondence even
    when sections are skipped** (verified 2026-04-27 on Velocity, which
    skipped Section 5 photo strip). Files are named `01-hero.json`,
    `02-intro-who-belongs.json`, etc. Velocity has no `05-*.json` —
    Section 5 is intentionally absent. The composer script globs
    `[0-9][0-9]-*.json` and sorts, which handles the gap automatically.
    Don't renumber across the gap — losing the LLSS↔Velocity
    correspondence (e.g., "section 6 is always membership cards") makes
    cross-event reasoning harder.
20. **`eps-301-redirects` plugin matches the FULL request URI including
    query string** (verified 2026-04-27 during Phase 4b RE Pros
    relocation). A cache-buster like `?cb=12345` BREAKS the match —
    returns 404 instead of 301. Bare URLs work fine; real user requests
    redirect correctly. When testing redirect behavior post-insert,
    hit the bare URL with curl, NOT a query-string-augmented URL. To
    bypass Cloudflare/Varnish without adding a query string, use a
    different host header, force-disable curl's local cache, or simply
    wait for cache TTL.
    - Wrong: `curl -sI ".../memberships/real-estate-professionals/?cb=$RANDOM"` → 404
    - Right: `curl -sI ".../memberships/real-estate-professionals/"` → 301
    - The eps-301 source (line 510) compares `rtrim(trim($url_request), '/') === self::format_from_url(trim($from))` — neither side strips the query string, so any `?param=value` blocks the match.
    - Insert format for `wp_0edpxsjfuc_redirects`: `url_from` = relative path WITHOUT leading slash and WITHOUT trailing slash (e.g., `memberships/real-estate-professionals`); `url_to` = post ID (with `type='post'`) or absolute URL (with `type='url'`); `status` = `'301'`.
21. **Element-ID slug-prefix convention applies across all templates**
    (verified 2026-04-27). LLSS uses `*` (no prefix, deterministic
    section names like `hero-section`); Velocity uses `velocity-*`;
    RE Pros uses `repro-*`. Going forward, ALL new builds use the
    page-slug prefix. The earliest LLSS sections that lack prefix
    are grandfathered (renaming would require recomposing + pushing).
22. **The7 forces `text-transform:uppercase` on H1/H2/H3 globally**
    (verified 2026-04-27 PM on Memberships hub build). When authoring
    HTML widgets that include heading tags, the headings inherit
    The7's uppercase rule even if the inline style doesn't ask for it.
    Mockup intent: title-case "Five Star Alliance" → rendered: ALL CAPS
    "FIVE STAR ALLIANCE". Fix: add explicit
    `text-transform:none` (or `text-transform:capitalize` for
    title-case-on-lowercase-input) to every heading inline style in
    HTML widget content. Verified working on hub `<h1>`, `<h2>`, `<h3>`
    after fix. Lesson applies to any HTML-widget-authored heading
    going forward; widget-tree Heading widgets via Elementor's `heading`
    widgetType honor the kit's Custom CSS properly without this
    override (kit CSS doesn't set uppercase). Documented in
    `the7-elementor-specificity-notes.md` extension as well.
23. **Mockup-derived hub layouts can use serif headings (Roboto Slab)
    while detail pages use the kit default (Open Sans Condensed)**
    (introduced 2026-04-27 PM on Memberships hub). Roboto Slab is the
    kit Secondary typography token (15px section intro at default,
    scales up via inline `font-size`). Use it for hub-page hero H1 +
    section H2/H3 to visually distinguish hub-shape pages from
    detail-shape pages without adding new font loads. The7 forces
    fontFamily based on element type — but inline `font-family:'Roboto
    Slab', Georgia, serif;` overrides cleanly because The7's selector
    is on `.elementor-heading-title` not on inline `<h1>` tags within
    HTML widgets. Detail pages stay on the default for now.
24. **In-place swap pattern for hub pages with children**
    (introduced 2026-04-27 on Phase 2 Events hub). When the page being
    migrated is a parent with child pages, the create-new + slug-swap
    pattern (used on LLSS / Velocity / RE Pros / Memberships hub)
    BREAKS child URLs because WordPress builds child permalinks from
    parent_slug + child_slug. Renaming `events` → `events-old` would
    have changed `/events/velocity/` to `/events-old/velocity/`,
    undoing canonical URLs we shipped in earlier phases.
    **In-place swap technique:**
    1. Compose new `_elementor_data` JSON via the standard Python
       composer
    2. Backup the current page state to timestamped meta keys:
       ```
       update_post_meta($id, '_elementor_inplace_swap_backup_YYYY_MM_DD_HHMMSS_post_content', $old_post_content);
       update_post_meta($id, '_elementor_inplace_swap_backup_*_elementor_data', $old_elementor_data);
       update_post_meta($id, '_elementor_inplace_swap_backup_*_elementor_edit_mode', $old_edit_mode);
       ```
    3. Apply Elementor mode meta:
       ```
       update_post_meta($id, '_elementor_edit_mode', 'builder');
       update_post_meta($id, '_elementor_template_type', 'wp-page');
       update_post_meta($id, '_elementor_version', '4.0.2');
       update_post_meta($id, '_elementor_pro_version', '4.0.2');
       update_post_meta($id, '_elementor_data', wp_slash($json));
       ```
    4. Clear `post_content` (Elementor takes precedence with edit_mode='builder',
       but clearing is cleaner for fallback safety):
       `wp_update_post(['ID'=>$id, 'post_content'=>'']);`
    5. Standard cache-flush sequence (Lesson #16)
    6. Verify ALL child permalinks resolve post-swap (HTTP 200 on each)
    **Atomic rollback:** restore from the backup meta keys.
    **When to use create-new + slug-swap vs in-place swap:**
    - Create-new + slug-swap: page has NO children, OR moving the
      page to a different parent (Phase 4b RE Pros relocate)
    - In-place swap: page has children whose URLs depend on the
      parent slug (Events hub, possibly Memberships parent in future
      iterations once Phase 4a builds individual member pages under it)
25. **Compose-from-disk is canonical; compose-from-DB-and-patch is a
    deviation** (verified 2026-04-29 on Memberships hub hero copy edit).
    The SOP step 3 of Lesson #17 says "load each [0-9][0-9]-*.json in
    numeric order, strip authoring keys, output as JSON array." That
    treats the on-disk section files as the unambiguous source of truth.
    A shortcut approach (read live `_elementor_data` from DB, swap one
    section, write back) works functionally when on-disk and deployed
    are byte-identical for untouched sections, but masks any drift that
    may exist. Always use the canonical compose-from-disk pipeline.
    **Verification step before push:** the compose script should diff
    the on-disk-composed payload against the deployed `_elementor_data`
    by section ID; report which sections are ADDED / REMOVED / CHANGED
    / unchanged. If any section is "unchanged" but has on-disk diffs
    not present in deployed, that's a drift surface to investigate
    before pushing.
26. **New-section file naming + glob update** (verified 2026-04-30 on
    Velocity 01b-info-bar.json). When inserting a new section that
    doesn't fit the original 01-09 numeric scheme (e.g., Velocity's
    info bar that sits between hero and Section 2), name it
    `01b-<slug>.json` (lexically sorts after `01-` and before `02-`).
    The default compose glob `[0-9][0-9]-*.json` only matches
    two-digit-prefix files and skips `01b-`. Update the compose glob
    to `[0-9]*.json` to pick up letter-suffixed files; natural
    lexical sort handles the order. Document the new section's
    Velocity-specific status in `_authoring_notes` if it has no
    LLSS analog (so future LLSS Template A revision picks up the
    parallel section file at the right slot).
27. **Template-level changes need explicit propagation plans**
    (verified 2026-04-30 on Velocity Template A revision). When a
    page-template change is decided (e.g., "image-only hero + 3-col
    info bar + 20/20 padding cap" supersedes the 2026-04-26 Option B
    Conversion Hero), the change applies to every page using that
    template. For FSI Event Page template (Template A): LLSS + Velocity
    are FSI-hosted and need the change; Government Forum + FSC are
    external and don't. Document the propagation plan in `decisions.md`
    at the time the change is decided, NOT when each page is updated;
    that way pages don't drift template patterns silently between
    revisions. Tag deployed pages that haven't been updated yet (e.g.,
    LLSS pre-Template-A-revision) with a `🟡 Pending Template A
    revision` flag in `site-profile.md` Open Issues until they catch up.
28. **Image-only hero with sr-only H1** (verified 2026-04-30 on
    Velocity). When the hero IMAGE itself contains the title (embossed
    wordmark + decorative typography baked into the artwork), don't
    overlay a visible H1. The visible H1 will be redundant and the
    overlay text vs. image text creates double-exposure. Two
    requirements still apply:
    - **SEO/accessibility:** keep an H1 in the DOM. Use a sr-only
      HTML widget with inline-styled hidden h1:
      `<h1 style="position:absolute; left:-9999px; width:1px;
      height:1px; overflow:hidden;">…</h1>`. Screen readers + search
      engines pick it up; sighted users don't.
    - **Hero overlay color:** typically remove entirely (was 0.85 navy,
      tested at 0.5 navy, settled at no overlay). Image was designed
      without overlay in mind; don't tint.
    - **Section padding:** 0/0 (image is the section content; no padding
      around the image).
29. **20/20 padding cap rule for FSI event pages** (decided 2026-04-30
    after audit revealed 80-140px combined inter-section gaps in the
    original Velocity build). Standardize body-section vertical padding
    at 20px top + 20px bottom. Combined adjacent-section gap = 40px.
    Hero (0/0) + info bar (20/20) and footer-line (20/12) are exceptions.
    **Why cumulative-gap math matters:** per-section padding is misleading
    in audits; the user-visible gap is the SUM of section A's bottom
    padding + section B's top padding + any margins on the first/last
    children of either section. A standard 20/20 cap removes the surprise
    of compounding paddings. Visual section separation comes from bg
    color rhythm (offwhite vs white vs navy bands) and section-heading
    underlines, not padding inflation.
30. **Cumulative gap audit before claiming "consistent rhythm"**
    (lesson learned 2026-04-30). When auditing visual padding/spacing,
    compute the CUMULATIVE gap between adjacent sections, not just the
    per-section padding. Format:
    `gap_AB = padding_A_bottom + padding_B_top + margin_A_last_child + margin_B_first_child`.
    If the user reports "wasted space," the audit must show the
    cumulative gap, not the per-section number. Quoting "60/60" when
    the visual gap is 120px+ is misleading.
