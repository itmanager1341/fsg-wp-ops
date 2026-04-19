# SOP: Plugin Updates

Risk level: Medium — bad updates break pages, SEO, or ad revenue.
Check the SOPs before improvising. If this SOP doesn't cover your case, flag it.

---

## Before you touch anything

1. Confirm there is a current WPE automated backup (portal → Backups).
   If not, trigger one manually and wait for it to complete.
2. Note current plugin versions:
   ```bash
   ssh thefivestar@thefivestar.ssh.wpengine.net
   wp plugin list --fields=name,version,update_version --update=available
   ```
3. Check the plugin changelog for breaking changes before updating.
4. Identify whether the plugin is in the high-risk dependency chain (see below).

---

## Standard update flow

### Step 1 — Update on staging

```bash
ssh thefivestarstg@thefivestarstg.ssh.wpengine.net
wp plugin update {slug}
```

### Step 2 — Smoke test staging

- Homepage loads
- A post/article loads
- Navigation works (especially Mega Menu on FSI)
- A HubSpot form renders and submits
- Check PHP error log: WPE portal → thefivestarstg → Logs → PHP Errors

### Step 3 — Update production

Only after staging passes:
```bash
ssh thefivestar@thefivestar.ssh.wpengine.net
wp plugin update {slug}
wp rocket clean --confirm
```
Then purge WPE server cache via portal or `scripts/wpe-cache-purge.sh`.

### Step 4 — Post-update checks

- Verify homepage and a content page load cleanly
- Re-check PHP error log on production
- Spot-check any feature the updated plugin powers (ads, forms, SEO meta)

---

## High-risk dependency chain (FSI / thefivestar.com)

These plugins are tightly coupled. Update them together in order:

```
1. WPBakery Page Builder
2. Ultimate Addons for WPBakery Page Builder
3. Ads for WPBakery Page Builder (formerly Visual Composer)
4. The7 Elements
5. The7 theme (via Appearance → Themes, not WP CLI)
```

**Never update these individually.** A version mismatch between The7 and WPBakery
can break every page on the site.

---

## Special cases

**WP Rocket** — Read changelog. Major versions can reset cache configuration.
After updating, verify WP Rocket settings are intact and do a full dual cache purge.

**All in One SEO Pro** — Update core before any AIOSEO add-on modules.

**Slider Revolution** — Check license status first. If license is lapsed,
updating may disable features. Verify all sliders on staging before prod.

---

## Rollback

```bash
# Deactivate the broken plugin
wp plugin deactivate {slug}

# If you have the old zip:
wp plugin install old-version.zip --force
wp plugin activate {slug}

# Or restore entire environment from WPE backup:
# WPE portal → Backups → Restore (replaces files AND database)
```

Log the update in `sites/thefivestar/audits/YYYY-MM-DD-plugin-update.md`.
