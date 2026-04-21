# How We Work — FSG Media WordPress Operations

This is the master reference for making any change to thefivestar.com.
Read this before asking which tool to use. Everything else in `docs/sops/` is detail behind one of the sections here.

Last updated: 2026-04-21

---

## The core mental model

The site has three distinct layers, and each layer has its own update method.
Mixing them up is the primary source of confusion and mistakes.

| Layer | What lives here | How you change it |
|-------|----------------|-------------------|
| **Code** | Custom CSS, mu-plugins, custom plugins | Git → GitHub → GitHub Actions → WPE |
| **Server state** | Third-party plugins, DB, cache | SSH → WP-CLI directly on WPE server |
| **Content** | Pages, posts, menus, media | WP Admin in browser |

These are not interchangeable. A plugin update cannot go through GitHub. A CSS change
cannot go through WP-CLI. Content cannot be deployed via GitHub Actions. If you find
yourself trying to use the wrong tool for a layer, stop — you're in the wrong workflow.

---

## Workflow A — Code changes (Git → GitHub Actions → WPE)

### What it's for
Any file we write and own that belongs in `wp-content/`:
- Shared CSS stylesheets (`wp-content/mu-plugins/fsi-event-styles.php`)
- Must-use plugins we write (`wp-content/mu-plugins/fsg-*.php`)
- Custom FSI plugins (`wp-content/plugins/fsg-*/`)
- Child theme files (`wp-content/themes/dt-the7-child/`) — once child theme exists

### Why this workflow exists
These files need version control. If a CSS change breaks every page on the site,
we need to be able to revert in one `git revert`. WP-CLI has no history. GitHub does.

### How it works
```
Local machine (write/edit the file)
  └─▶ git commit + git push → GitHub (itmanager1341/thefivestar-wp)
        └─▶ GitHub Actions fires automatically
              ├─▶ SSH rsync → thefivestarstg (AUTOMATIC on every push to main)
              └─▶ SSH rsync → thefivestar    (MANUAL trigger only — you click Run)
```

The deploy action is `wpengine/github-action-wpe-site-deploy@v3`. It uses SSH rsync,
not WP Engine Git Push — those are different features. See `docs/decisions.md`.

### Staging is automatic. Production is always manual.
Every push to `main` auto-deploys to staging. You must manually trigger production
in GitHub → Actions → Deploy to WP Engine → Run workflow → select "production".

### What does NOT go in git
- Third-party plugin zips
- WordPress core
- `wp-content/uploads/`
- `wp-config.php`
- Anything WPE manages

### Key file
`thefivestar-wp/.deployignore` — protects WPE-managed files from being wiped by rsync.


---

## Workflow B — Server state changes (SSH → WP-CLI)

### What it's for
Anything that lives on the WPE server but is NOT tracked in git:
- Installing, updating, deactivating, or deleting plugins
- Database operations (search-replace, direct queries)
- Cache purging
- Writing a file directly to the server when GitHub Actions isn't the right path

### Why this workflow exists
Plugins are not code we wrote — they're managed server-side. You can't put a
plugin update in a git commit. WP-CLI is the correct interface for server state.
GitHub Actions knows nothing about plugin versions.

### How it works
```
SSH into thefivestarstg (staging)
  └─▶ Run WP-CLI command
        └─▶ Verify: site loads, no PHP errors, feature works
              └─▶ STOP. Report. Ask for production approval.
                    └─▶ (on explicit "yes") SSH into thefivestar (production)
                          └─▶ Run same WP-CLI command
```

GitHub is not involved. No git commits. No Actions. Direct SSH to each environment.

### The production approval gate — non-negotiable
**Staging verification is never permission to proceed to production.**
Every Workflow B operation requires an explicit "yes" / "approved" / "go ahead"
in chat before touching production. Blanket session approval does not count.

```
1. State the operation and risk level (🟢 / 🟡 / 🔴)
2. Run on staging
3. Verify: HTTP 200, no PHP errors, feature behaves correctly
4. STOP — report what was verified
5. Ask: "Staging confirmed ✅ — approve for production?"
6. Wait for explicit approval
7. Only then run on production
```

### Risk levels
🟢 **Safe** — Reversible instantly. No user impact.
Examples: deleting an inactive plugin, cache purge, read-only queries

🟡 **Moderate** — Staging required. Minor user impact possible.
Examples: deactivating an active plugin, updating a non-critical plugin

🔴 **High** — Backup required before starting. Explicit confirmation required.
Examples: deleting a plugin from production, WPBakery chain update, any DB write on production

### Common WP-CLI commands
```bash
# Connect to environments
ssh thefivestarstg    # staging
ssh thefivestar       # production

# Plugin operations
wp plugin list --fields=name,status,version --format=table
wp plugin deactivate {slug}
wp plugin delete {slug}
wp plugin update {slug}

# Cache
wp cache flush

# Page content
wp post get {ID} --field=post_content
wp post update {ID} --post_content="..."

# Pipe a local PHP file to server (no SCP on WPE)
cat /local/file.php | ssh thefivestarstg 'wp eval-file -'
```

### Detail SOP
`docs/sops/plugin-update.md` — plugin update flow including the WPBakery chain

