# Runbook: R1b — Collapse Multisite → Single-site + Retire /mediakit/

Runs on the **clone (`thefivestardev`) only**. Prod is untouched. Reversible via WPE checkpoint
`48b72dd4-1eec-49a4-bead-b3a454f4ea91` ("R1-clone-parity-good"). Implements decision 2026-07-11.

> **Destructive.** Deletes the `/mediakit/` subsite and converts the network to single-site.
> Safe because it's the disposable clone with a fresh checkpoint. If anything breaks, restore
> the checkpoint and re-plan (WPE multisite conversion may need WPE support).

## Preconditions

- ✅ R1 clone complete + checkpoint taken.
- ✅ Subsite recorded: `audits/2026-07-11-mediakit-subsite-inventory.csv`.
- Rollback ready: restore backup `48b72dd4…` via WPE portal or API if the conversion breaks.

## Steps

### 1. Delete the /mediakit/ subsite (blog_id 6)
```bash
ssh thefivestardev "wp site delete 6 --yes --url=thefivestardev.wpengine.com"
ssh thefivestardev "wp site list --fields=blog_id,domain,path"   # expect only blog 1
```

### 2. Convert network → single-site
Remove multisite constants from wp-config and drop the network tables:
```bash
for c in MULTISITE SUBDOMAIN_INSTALL DOMAIN_CURRENT_SITE PATH_CURRENT_SITE SITE_ID_CURRENT_SITE BLOG_ID_CURRENT_SITE WP_ALLOW_MULTISITE; do
  ssh thefivestardev "wp config delete $c 2>/dev/null" || true
done
# Drop network-only tables (single-site doesn't use them):
printf 'DROP TABLE IF EXISTS wp_0edpxsjfuc_blogs, wp_0edpxsjfuc_blogmeta, wp_0edpxsjfuc_site, wp_0edpxsjfuc_sitemeta, wp_0edpxsjfuc_registration_log, wp_0edpxsjfuc_signups;\n' \
  | ssh thefivestardev "wp db query"
```

### 3. Verify single-site + parity
```bash
ssh thefivestardev "wp eval 'echo is_multisite() ? \"STILL-MULTISITE\" : \"single-site\";'"  # expect single-site
# key pages still 200 on temp domain:
for u in / /five-star-conference/ /careers/ /events/ /memberships/alliance/; do
  curl -s -o /dev/null -w "$u %{http_code}\n" "https://thefivestardev.wpengine.com${u}?cb=$RANDOM"
done
# /mediakit/ should now 404 (301 added later in R2 redirect consolidation):
curl -s -o /dev/null -w "/mediakit/ %{http_code}\n" "https://thefivestardev.wpengine.com/mediakit/?cb=$RANDOM"
ssh thefivestardev "wp option get siteurl; wp option get home"   # confirm intact
```

### 4. If broken
Restore checkpoint `48b72dd4…` (WPE portal → Development → Backups, or API), and flag that the
WPE platform needs its multisite flag toggled by WPE support before retrying the conversion.

## Follow-on (not in R1b)
- `/mediakit/(.*)` → `/` 301 is added in **R2 redirect consolidation** (with the LMS + existing
  redirects), once we pick the single canonical redirect manager. Until then `/mediakit/` 404s on
  the noindexed clone — acceptable.

## Gate R1b
- [ ] mediakit subsite deleted; `wp site list` shows only blog 1
- [ ] `is_multisite()` false
- [ ] main site + key pages still 200; siteurl/home intact
- [ ] wp-admin loads on the clone
