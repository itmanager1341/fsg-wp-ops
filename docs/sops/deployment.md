# SOP: Deployment

Applies to: code changes (themes, plugins, mu-plugins) pushed via Git.
For plugin-only updates, see `sops/plugin-update.md`.
For content changes, see `sops/content-update.md`.

**Deployment method:** GitHub Actions → `wpengine/github-action-wpe-site-deploy@v3` (SSH rsync).
We do NOT use WP Engine's Git Push (`git.wpengine.com`) — see `docs/decisions.md` for why.

---

## Standard flow: feature → staging → production

```bash
# 1. Work on a branch locally
git checkout -b feature/your-change

# 2. Commit and push to GitHub
git push origin feature/your-change

# 3. Merge PR to main on GitHub

# 4. GitHub Actions auto-deploys main → staging (watch Actions tab)

# 5. Smoke test staging
#    https://thefivestarstg.wpenginepowered.com

# 6. Deploy to production — manual trigger in GitHub Actions
#    Actions → Deploy to WP Engine → Run workflow → environment: production
```

Secret required: `WPE_SSHG_KEY_PRIVATE` (repo-level) — private key of `id_ed25519_itmanager`.

---

## What gets deployed

The `thefivestar-wp` repo maps to `wp-content/` on WPE.
Only custom code belongs in the repo:
- `wp-content/themes/dt-the7-child/` (child theme, if it exists)
- `wp-content/plugins/fsg-*/` (custom FSI plugins only)
- `wp-content/mu-plugins/` (must-use plugins)

Files in `.deployignore` are excluded from the WPE sync.
Third-party plugins install via WP Admin — not tracked in git.

---

## Post-deploy checklist

- [ ] Homepage loads on production
- [ ] PHP error log clean: WPE portal → thefivestar → Logs
- [ ] Purge caches: `scripts/wpe-cache-purge.sh thefivestar --rocket`
- [ ] Spot-check: a content page, the nav (Mega Menu), a HubSpot form
- [ ] If CSS/JS changed: hard-refresh to bypass browser cache

---

## Emergency rollback

```bash
# Revert the commit and push to trigger a new deploy
git revert HEAD --no-edit
git push origin main
# GitHub Actions will deploy the revert to staging, then you approve production.

# Or: restore from WPE backup
# WPE portal → thefivestar → Backups → Restore
# Note: backup restore replaces files AND database.
```
