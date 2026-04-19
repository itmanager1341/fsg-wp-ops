# GitHub Setup

What needs to happen before GitHub Actions can deploy code to WP Engine.

## Current state (as of 2026-04-19)

Both repos are initialized and pushed to GitHub:
- `fsg-wp-ops/` — ✅ pushed to github.com/itmanager1341/fsg-wp-ops
- `thefivestar-wp/` — ✅ pushed to github.com/itmanager1341/thefivestar-wp

GitHub Actions deploy workflow is live and confirmed working.

---

## Deployment method

Uses the official WP Engine GitHub Action: `wpengine/github-action-wpe-site-deploy@v3`

This action deploys via **SSH rsync** — NOT via WP Engine Git Push.
Do not confuse the two. WP Engine Git Push (`git.wpengine.com`) is a separate,
unrelated feature that this workflow does not use.

The SSH key authenticates via WPE's SSH Gateway — the same key and same pathway
as `ssh thefivestar` in the terminal.

---

## Step 1 — Initialize repos and push to GitHub ✅

Both repos initialized via Cursor and pushed to GitHub under itmanager1341.

```
github.com/itmanager1341/fsg-wp-ops       — ops hub (no Actions, reference only)
github.com/itmanager1341/thefivestar-wp   — site code, deploy workflow lives here
```

Note: `fsg-wp-ops` uses SSH remote; `thefivestar-wp` uses HTTPS remote. Both work.

---

## Step 2 — Configure GitHub Environments ✅

In GitHub → itmanager1341/thefivestar-wp → Settings → Environments:

- `staging` — exists, no protection rules (auto-deploys on push to main) ✅
- `production` — exists, no protection rules ✅

Note: Required reviewers (approval gate) requires GitHub Team plan ($4/user/month).
On GitHub Free, the manual `workflow_dispatch` trigger serves as the production gate —
you must go to Actions → Run workflow → select "production" to deploy there.

---

## Step 3 — Add GitHub Actions Secrets ✅

In GitHub → itmanager1341/thefivestar-wp → Settings → Secrets → Actions:

| Secret name | Value source | Purpose |
|-------------|-------------|---------|
| `WPE_SSHG_KEY_PRIVATE` | `cat ~/.ssh/id_ed25519_itmanager` | SSH Gateway auth for deploy action |

**Removed secrets (no longer needed):**
- `WPE_SSH_PRIVATE_KEY` — was for Git Push method, now obsolete
- `WPE_CREDS` — was for WPE API backup trigger, removed
- `WPE_INSTALL_ID_PROD` — removed
- `WPE_INSTALL_ID_STG` — removed

When scaffolding amaaonline-wp and themortgagepoint-wp, add `WPE_SSHG_KEY_PRIVATE`
as a repo secret to each. Same key value — it's registered globally in WPE.

---

## Step 4 — WP Engine SSH Key Registration ✅

The deploy key (`id_ed25519_itmanager`) is registered in:
**WP Engine portal → My Profile → SSH Keys**

Fingerprint: `af:c0:8b:73:c0:b1:d7:39:cd:57:5f:5d:3c:76:3b:57`

A second key (`wpengine_ed25519`, labeled "WPE GHA") was also added during setup
and is registered in WPE. It is NOT used by the deploy workflow — `id_ed25519_itmanager`
is the key referenced in `WPE_SSHG_KEY_PRIVATE`.

---

## Step 5 — First deploy test ✅

Push a change to main → Actions tab → staging job runs automatically.
Production: Actions → Run workflow → select "production" → confirm.

---

## What deploy.yml does

See `.github/workflows/deploy.yml` for full detail. Summary:
- Push to `main` → auto-deploys to `thefivestarstg` (staging) via SSH rsync
- Clears WPE cache after each deploy
- Production deploy requires manual `workflow_dispatch` trigger (the gate on Free plan)

## What GitHub Actions does NOT do

- Does not update plugins (that's WP-CLI via SSH — Workflow B)
- Does not manage the database
- Does not touch wp-config.php (WPE manages it)
- Only syncs the tracked contents of `thefivestar-wp/` to WPE's `wp-content/`
