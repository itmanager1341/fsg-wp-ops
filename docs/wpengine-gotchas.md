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

---

## WP core disappears from SSH container on idle staging

WP Engine staging environments provision WP core separately for HTTP requests vs.
SSH access. When WPE recycles an idle SSH container, core files vanish from the SSH
filesystem. WP-CLI fails with "not a WordPress installation."

**Fix:** Run at the start of every SSH session on staging or dev:
```bash
wp core download --skip-content
```
This does NOT affect the live site — WPE mounts core separately for HTTP. Takes ~30 seconds.
This will keep happening. It's not something we caused; it's WPE's architecture.

---

## wp_update_nav_menu_item clears the title if not all fields passed

Passing only `menu-item-url` to `wp_update_nav_menu_item` silently clears
`post_title` on the nav item post, removing the label from the menu.

**Rule:** Never use `wp_update_nav_menu_item` to change only the URL.
Use `wp_update_post` on the nav item post ID to update title only,
and `update_post_meta` to update `_menu_item_url` only.

```php
// Safe: update URL only
update_post_meta($item_id, '_menu_item_url', $new_url);

// Safe: update title only
wp_update_post(array('ID' => $item_id, 'post_title' => 'Events'));
```

---

## WPBakery vc_raw_html re-encoding is fragile — use plain HTML instead

WPBakery stores raw HTML inside `vc_raw_html` shortcodes as base64(urlencode(html)).
Attempting to decode, modify, and re-encode this content programmatically is error-prone
— the re-encoded content frequently fails to render, showing only other WPBakery elements.

**Rule for pages we control:** Push plain HTML via `wp eval-file -`. Do not wrap
in WPBakery shortcodes. Classic Editor renders plain HTML directly in the content area.
The theme's header, footer, and breadcrumbs still render — only the content zone changes.

```php
// Correct approach for event pages
wp_update_post(array(
    'ID'           => $page_id,
    'post_content' => '<div class="fsi-page-wrap">...</div>',
));
```

Only use WPBakery shortcodes when editing pages through the WPBakery Backend Editor UI.
Do not attempt to construct or modify WPBakery shortcode blocks programmatically.
