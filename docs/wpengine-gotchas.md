# WP Engine Gotchas

Institutional knowledge for working on WPE managed hosting.
Read this before any unfamiliar operation.

---

## Cache: three layers, purge all three

WP Engine sites have three independent cache layers:

1. **WP Rocket** — plugin-level object/page/browser cache
2. **WP Engine page cache** — server-level, sits in front of WP Rocket
3. **WP Engine CDN** — edge cache (if enabled on plan)

Purging WP Rocket alone does not clear the WPE server cache. After any deploy
or significant content change, purge in order:

```
WP Rocket → Purge All Cache
WPE portal → Caching → Clear All (or use scripts/wpe-cache-purge.sh)
```

---

## Git push to WPE = immediate production deploy

WP Engine's Git integration promotes the last-pushed branch directly to the
environment it's mapped to. There is no staging step built into WPE's Git.

**Rule:** Never push to the WPE production remote directly. GitHub Actions is
the only thing that should touch the WPE production remote, and only after
staging passes.

```
GitHub (source of truth)
  └─▶ GitHub Actions
        ├─▶ WPE staging remote  (auto on push to main)
        └─▶ WPE production remote  (manual trigger + approval gate)
```

---

## File system rules on WPE

- `wp-content/uploads/` — writable; managed by WPE and not tracked in git.
- Theme and plugin files — deploy via Git only. No SFTP edits in non-emergencies.
- `/tmp` — ephemeral. Do not write files there expecting them to persist between requests.
- WP core (`wp-admin/`, `wp-includes/`, root `wp-*.php`) — managed by WPE. Never touch.


---

## Blocked plugins

WPE blocks plugins that conflict with managed hosting. Key ones:
- W3 Total Cache, WP Super Cache — use WP Rocket instead
- Wordfence, iThemes Security — WPE provides its own security layer
- WP-DBManager — use WP CLI or phpMyAdmin via portal

Full list: https://wpengine.com/support/disallowed-plugins/

---

## DB access

No direct DB connection (standard plans). Use:
- WP CLI over SSH for data operations
- WPE portal → phpMyAdmin link for one-off queries

After cloning production to staging, always run domain search-replace:
```bash
wp search-replace 'https://thefivestar.com' \
  'https://thefivestarstg.wpenginepowered.com' --all-tables
```

---

## SSH + WP CLI

```bash
# Connect
ssh thefivestar@thefivestar.ssh.wpengine.net

# WP CLI is available
wp plugin list --update=available
wp rocket clean --confirm
```

SSH key must be registered in WPE portal → Users → SSH Keys.
One key per user. Key changes take ~5 min to propagate.

---

## Application passwords

Use Application Passwords (WP Admin → Users → Application Passwords) for any
tool that needs WP REST API access. Never use the main admin password.

---

## PHP version notes

- Production runs PHP 8.2 across FSI, AMAA, MortgagePoint.
- Staging/dev for FSI runs PHP 8.4 — intentional, testing forward compat.
- `tfsiforce` is on PHP 7.4 (EOL). Do not update plugins on that install
  until PHP is upgraded — incompatibilities will surface.

---

## WPE environment cloning

WPE portal → Site → Copy environment copies files + DB.
After clone, always: (1) search-replace domains, (2) purge cache.

---

## WPE API base URL

```
https://api.wpengineapi.com/v1/
```

Auth: `Authorization: Basic <base64(user_id:password)>` using API credentials
(not admin password). See `docs/references/wpengine-api-cheatsheet.md`.
