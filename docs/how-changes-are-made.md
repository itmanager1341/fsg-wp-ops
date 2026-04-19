# How Changes Are Made

Two completely separate workflows. Do not conflate them.

---

## Workflow A: Code changes

Applies to: custom theme files, custom plugins, mu-plugins.
These are tracked in the `thefivestar-wp` git repo.

```
Local machine
  └─▶ git push → GitHub (itmanager1341/thefivestar-wp)
        └─▶ GitHub Actions (wpengine/github-action-wpe-site-deploy@v3)
              ├─▶ SSH rsync → thefivestarstg  (auto, on push to main)
              └─▶ SSH rsync → thefivestar     (manual trigger only)
```

**Deployment method:** WPE official GitHub Action (SSH rsync via SSH Gateway).
Does NOT use WP Engine Git Push (`git.wpengine.com`) — that is a separate,
unrelated feature. See `docs/decisions.md` for why.

WP-CLI is NOT in this loop. GitHub Actions handles the file sync to WP Engine.
The `.deployignore` file in each site repo protects WPE-managed files (mu-plugins,
uploads, third-party plugins) from being deleted by rsync `--delete`.

**When this applies:**
- Editing The7 child theme files (once child theme exists)
- Adding or editing a custom FSI plugin
- Adding a mu-plugin
- Any file that belongs in `wp-content/themes/dt-the7-child/`,
  `wp-content/plugins/fsg-*/`, or `wp-content/mu-plugins/`

**Staging vs. production cadence:**
- Staging updates automatically — every push to main auto-deploys there
- Production is manual — Actions → Run workflow → select "production"
- Required reviewer gate requires GitHub Team plan; on Free plan, the manual
  trigger itself is the gate

---

## Workflow B: Plugin and operational changes

Applies to: plugin installs, updates, deactivations, deletions, DB operations, cache purges.
These happen directly on the WP Engine server via SSH + WP-CLI. GitHub is not involved.
Plugins are not tracked in git — they live on the server.

```
SSH → WP-CLI on thefivestarstg (staging)
  └─▶ verify: HTTP 200, no PHP errors, feature works as expected
        └─▶ STOP — report results, ask for production approval
              └─▶ (on explicit approval) SSH → WP-CLI on thefivestar (production)
```

**⛔ Production approval is required every time.** Staging verification is not
permission to proceed. Stop, report, ask, wait. See CLAUDE.md for the full gate.

**When this applies:**
- Deactivating or deleting a plugin
- Updating a plugin or the WPBakery chain
- Purging cache
- Any database operation
- Writing files directly to the server (use `wp eval-file -` — see below)
- Changing plugin configuration not exposed in WP Admin

**Example: deactivating a plugin**
```bash
# Step 1: staging
ssh thefivestarstg wp plugin deactivate plugin-slug
# verify: curl -s -o /dev/null -w '%{http_code}' https://thefivestarstg.wpenginepowered.com/
# STOP — report HTTP 200, ask for production approval

# Step 2: production (only after explicit approval)
ssh thefivestar wp plugin deactivate plugin-slug
```

No git. No GitHub Actions. Direct SSH to each environment in sequence.

---

## SSH session startup

Before any SSH-heavy session, initialize the agent once and reuse it.
See `docs/sops/ssh-session-startup.md` for the full procedure.

**Critical:** Each Desktop Commander process is isolated — the SSH agent does not
persist between tool calls. Initialize it once in a long-running shell process
and use `interact_with_process` for all subsequent commands into that same PID.

```bash
# Start a persistent shell and initialize the agent
eval "$(ssh-agent -s)" && ssh-add /Users/jonathanhughes/.ssh/id_ed25519_itmanager

# Then reuse that process PID for all SSH commands in the session
```

**WPE SSH notes:**
- WPE SSH Gateway does NOT support SCP. Use `wp eval-file -` to write files to server.
- WP core files are NOT present in the SSH container on staging/dev when first
  provisioned. If WP-CLI fails with "not a WordPress installation," run
  `wp core download --skip-content` first.
- WP-CLI path on WPE is controlled by `~/.wp-cli/config.yml` — do not pass
  `--path` unless overriding the config.

**Writing files to WPE servers (no SCP):**
```bash
# Write a local PHP file to a WPE server via WP-CLI pipe
cat /path/to/local/file.php | ssh thefivestar wp eval-file -
```

---

## Which workflow for what

| Task | Workflow | Staging first? |
|------|----------|---------------|
| Edit child theme CSS | A (git) | Yes — auto via Actions |
| Add custom plugin | A (git) | Yes — auto via Actions |
| Add mu-plugin | A (git) or B (wp eval-file) | Yes |
| Deactivate a plugin | B (WP-CLI) | Yes — manual SSH |
| Update a plugin | B (WP-CLI) | Yes — manual SSH |
| Delete a plugin | B (WP-CLI) | Yes — manual SSH |
| Purge cache | B (WP-CLI) | No — production direct is fine |
| Update content | WP Admin | No — production direct is fine |
| DB search-replace | B (WP-CLI) | Yes — always |
| Write file to server | B (wp eval-file) | Yes |

---

## Risk levels

Claude states the risk before every B-workflow operation and waits for confirmation.

🟢 **Safe** — Reversible instantly. No user impact.
(deactivating an already-inactive plugin, cache purge, status check, read-only queries)

🟡 **Moderate** — Staging required. Minor user impact possible.
(deactivating an active plugin, updating a non-critical plugin, adding a mu-plugin)

🔴 **High** — Backup required before proceeding. Explicit confirmation required.
(deleting a plugin, updating the WPBakery chain, any production DB write)

Backup command before any 🔴 operation:
```bash
cd /Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops
./scripts/wpe-backup.sh thefivestar "Pre-[operation description]"
# Script polls until backup confirmed complete before returning
```

---
