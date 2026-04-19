# How Changes Are Made

Two completely separate workflows. Do not conflate them.

---

## Workflow A: Code changes

Applies to: custom theme files, custom plugins, mu-plugins.
These are tracked in the `thefivestar-wp` git repo.

```
Local machine
  └─▶ git push → GitHub (itmanager1341/thefivestar-wp)
        └─▶ GitHub Actions
              ├─▶ WP Engine Git remote → thefivestarstg  (auto, on push to main)
              └─▶ WP Engine Git remote → thefivestar     (manual trigger + approval)
```

WP-CLI is NOT in this loop. GitHub Actions handles the file sync to WP Engine.

**When this applies:**
- Editing The7 child theme files (once child theme exists)
- Adding or editing a custom FSI plugin
- Adding a mu-plugin
- Any file that belongs in `wp-content/themes/custom/` or `wp-content/plugins/fsg-*/`

**Staging vs. production cadence:**
- Staging updates constantly — every merge to main auto-deploys there
- Production updates rarely — manual trigger, requires approval, backup fires first

---

## Workflow B: Plugin and operational changes

Applies to: plugin installs, updates, deactivations, deletions, DB operations, cache purges.
These happen directly on the WP Engine server. GitHub is not involved.
Plugins are not tracked in git — they live on the server.

```
SSH → WP-CLI on thefivestarstg (staging)
  └─▶ verify: site loads, no PHP errors, feature works
        └─▶ SSH → WP-CLI on thefivestar (production)
```

**When this applies:**
- Deactivating or deleting a plugin
- Updating a plugin or the WPBakery chain
- Purging cache
- Any database operation
- Changing plugin configuration that isn't exposed in WP Admin

**Example: deactivating a plugin**
```bash
# Step 1: staging
ssh thefivestarstg "wp plugin deactivate wordpress-seo"
# verify site loads, check error log

# Step 2: production (only after staging confirmed)
ssh thefivestar "wp plugin deactivate wordpress-seo"
```

No git. No GitHub Actions. Direct SSH to each environment in sequence.

**Staging vs. production cadence:**
- Staging is the test bed — run operations here first, always
- Production only after staging is confirmed stable
- For deletions: deactivate → confirm → delete (never delete without deactivating first)

---

## Which workflow for what

| Task | Workflow | Staging first? |
|------|----------|---------------|
| Edit child theme CSS | A (git) | Yes — auto via Actions |
| Add custom plugin | A (git) | Yes — auto via Actions |
| Deactivate a plugin | B (WP-CLI) | Yes — manual SSH |
| Update a plugin | B (WP-CLI) | Yes — manual SSH |
| Delete a plugin | B (WP-CLI) | Yes — manual SSH |
| Purge cache | B (WP-CLI) | No — production direct is fine |
| Update content | WP Admin | No — production direct is fine |
| DB search-replace | B (WP-CLI) | Yes — always |

---

## Risk levels

Claude states the risk before every B-workflow operation and waits for confirmation.

🟢 **Safe** — Reversible instantly. No user impact.
(deactivating an already-inactive plugin, cache purge, status check)

🟡 **Moderate** — Staging required. Minor user impact possible.
(deactivating an active plugin, updating a non-critical plugin)

🔴 **High** — Backup required before proceeding. Explicit confirmation required.
(deleting a plugin, updating the WPBakery chain, any production DB write)

Backup command before any 🔴 operation:
```bash
cd /Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops
./scripts/wpe-backup.sh thefivestar "Pre-[operation description]"
# Script polls until backup confirmed complete before returning
```
