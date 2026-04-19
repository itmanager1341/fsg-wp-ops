# GitHub Setup

What needs to happen before GitHub Actions can deploy code to WP Engine.

## Current state (as of 2026-04-18)

Neither repo is initialized as a git repository yet:
- `fsg-wp-ops/` — files exist, no .git
- `thefivestar-wp/` — files exist, no .git

GitHub repos do not yet exist under itmanager1341.
The `deploy.yml` workflow file is written and ready but non-functional until
the repo exists and secrets are configured.

---

## Step 1 — Initialize repos and push to GitHub

Do this in Terminal. Two separate repos:

```bash
# fsg-wp-ops
cd /Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops
git init
git add .
git commit -m "Initial commit: ops hub structure, docs, SOPs, FSI site profile"
# Create repo on GitHub first (github.com → itmanager1341 → New repository)
# Name: fsg-wp-ops | Private | No README (we have one)
git remote add origin git@github.com:itmanager1341/fsg-wp-ops.git
git push -u origin main

# thefivestar-wp
cd /Users/jonathanhughes/Development/itmanager1341/thefivestar-wp
git init
git add .
git commit -m "Initial commit: scaffold, deploy workflow, CLAUDE.md"
# Create repo on GitHub: itmanager1341/thefivestar-wp | Private | No README
git remote add origin git@github.com:itmanager1341/thefivestar-wp.git
git push -u origin main
```

---

## Step 2 — Configure GitHub Environments

In GitHub → itmanager1341/thefivestar-wp → Settings → Environments:

1. Create environment named **`staging`**
   - No protection rules (deploys automatically on push to main)

2. Create environment named **`production`**
   - Add "Required reviewers": yourself (Jonathan)
   - This creates an approval gate — deploys pause until you click Approve

---

## Step 3 — Add GitHub Actions Secrets

In GitHub → itmanager1341/thefivestar-wp → Settings → Secrets → Actions:

| Secret name | Value | How to get it |
|-------------|-------|---------------|
| `WPE_SSH_PRIVATE_KEY` | Contents of `~/.ssh/id_ed25519_itmanager` | `cat ~/.ssh/id_ed25519_itmanager` |
| `WPE_CREDS` | Value of WPE_CREDS from `.env` | Open `fsg-wp-ops/.env` |
| `WPE_INSTALL_ID_PROD` | `eda9de4f-5270-45c1-9e0f-3546913decb8` | Already in `.env` |
| `WPE_INSTALL_ID_STG` | `1558af1f-7b30-40f5-bbe6-bf1988b91693` | Already in `.env` |

To get the private key content:
```bash
cat ~/.ssh/id_ed25519_itmanager
```
Copy the entire output including the `-----BEGIN...` and `-----END...` lines.

---

## Step 4 — Add WPE Git remotes

WP Engine's Git remote requires a separate SSH key registered in the WPE portal.
(The same key already registered works — WPE uses it for both SSH shell and Git.)

```bash
cd /Users/jonathanhughes/Development/itmanager1341/thefivestar-wp
git remote add wpe-stg git@git.wpengine.com:staging/thefivestarstg.git
git remote add wpe     git@git.wpengine.com:production/thefivestar.git
```

Test the WPE Git remote:
```bash
ssh -T git@git.wpengine.com
```
Expected response: `Hi thefivestar! You've successfully authenticated...`

---

## Step 5 — First deploy test

Push a harmless change (e.g., update a comment in CLAUDE.md) to main and watch
the Actions tab. The staging job should run automatically. Then manually trigger
the production job to test the approval gate.

**Do not push any actual wp-content changes** until the pipeline is confirmed working
with an innocuous commit.

---

## What deploy.yml does

See `.github/workflows/deploy.yml` for full detail. Summary:
- Push to `main` → auto-deploys to `thefivestarstg` (staging)
- Triggers WPE cache purge after each deploy
- Triggers a backup before any production deploy
- Production deploy requires manual trigger + approval gate

---

## What GitHub Actions does NOT do

- Does not update plugins (that's WP CLI via SSH)
- Does not manage the database
- Does not touch wp-config.php (WPE manages it)
- Only syncs the tracked contents of `thefivestar-wp/` to WPE's `wp-content/`
