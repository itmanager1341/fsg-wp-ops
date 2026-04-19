# SOP: Incident Response

Use when: site is down, pages are broken, security event, or unexpected data change.

---

## Severity levels

| Level | Description | Target response |
|-------|-------------|-----------------|
| P1 | Production completely down (500, white screen, DNS fail) | Immediate |
| P2 | Core feature broken (forms, login, event registration) | < 1 hour |
| P3 | Degraded experience (slow, one page broken, layout issue) | < 4 hours |
| P4 | Minor issue (typo, missing image, styling glitch) | Next business day |

---

## P1 triage (site down)

### Step 1 — Confirm scope (2 min)

```bash
curl -I https://thefivestar.com
# 200 = server responding, likely app-level error
# 500/502/503 = server error
# Timeout = DNS or infrastructure
```

Check WPE status: https://status.wpengine.com

### Step 2 — Check error log (5 min)

WPE portal → thefivestar → Logs → PHP Errors

Or via SSH:
```bash
ssh thefivestar@thefivestar.ssh.wpengine.net
# PHP errors are in the WPE log viewer, not /tmp
```

Common causes: PHP fatal from a plugin update, memory exhaustion,
database connection failure.

### Step 3 — Isolate the cause (10 min)

If a recent plugin update is suspect:
```bash
wp plugin deactivate {slug}
# Test site. If it loads, that's the culprit.
# Reactivate other plugins one at a time to confirm.
```

If no recent changes: rename a plugin folder to disable via SSH:
```bash
mv wp-content/plugins/bad-plugin wp-content/plugins/bad-plugin.disabled
```

### Step 4 — Restore from backup if needed

WPE portal → thefivestar → Backups → select pre-incident backup → Restore.
**Warning:** Restore replaces files AND database. Content published after
the backup timestamp is lost. Notify team before restoring.

---

## P1 security event

Signs: unexpected admin users, PHP files in uploads, site redirecting to spam,
Google Search Console security alert.

Immediate actions:
1. Change all passwords (WP admin users, WPE portal, FTP/SSH)
2. Contact WPE support — they have malware scanning tools
3. Audit admin accounts: `wp user list --role=administrator`
4. Find recently modified files:
   ```bash
   find wp-content -newer wp-content/index.php -type f | grep -v cache
   find wp-content/uploads -name "*.php"
   ```
5. Do not just clean and leave — identify the entry point

---

## Communication

**Slack/email when P1 starts:**
> [SITE DOWN] thefivestar.com — {time CST}
> Investigating. Last known working: {time}. Recent changes: {any deploys/updates}.
> Next update in 15 min.

**When resolved:**
> [RESOLVED] thefivestar.com — {duration} downtime.
> Root cause: {what}. Fix: {what}. Prevention: {what}.

---

## After any P1 or P2

Document in `sites/thefivestar/audits/YYYY-MM-DD-incident.md`:
root cause, timeline, fix, prevention step.

WPE support: https://wpengine.com/support/ | Status: https://status.wpengine.com
