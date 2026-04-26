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
    event-page/                           # Phase 1.4 — LLSS section sources
      01-hero.json
      02-intro-who-belongs.json
      ...
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

Phase 1.4 sections live in `sites/thefivestar/elementor-templates/event-page/`.
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
JSON_DATA=$(cat sites/thefivestar/elementor-templates/event-page/llss-page.json | python3 -c "import json,sys; print(json.dumps(json.load(sys.stdin)))")

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
