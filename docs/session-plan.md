# Next Session Plan: Plugin Cleanup + GitHub Setup

## Before starting any session

1. Claude reads `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/CLAUDE.md`
2. Claude reads `brands/fsi/CLAUDE.md` (FSI-specific context)
3. Claude reads `sites/thefivestar/site-profile.md` and `plugin-inventory.md`
4. If any changes were made since last session, run `audit-site.sh thefivestar` to get a fresh baseline

---

## How changes are made

Two separate workflows — do not conflate them. See `docs/how-changes-are-made.md` for full detail.

**Workflow A (code):** `local → GitHub → GitHub Actions → WP Engine`
Only for tracked code: child theme, custom plugins, mu-plugins.
Staging auto-deploys on every push to main. Production is manual + approval.

**Workflow B (plugins/ops):** `SSH → WP-CLI → thefivestarstg, then thefivestar`
For everything else: plugin updates, deactivations, deletions, cache, DB.
GitHub is not involved. Plugins live on the server, not in git.

For the plugin cleanup sessions below, **Workflow B applies throughout.**
No code is being changed — only server-side plugin state.

---

## Session 1: GitHub repo initialization

**Goal:** Get both repos on GitHub so the deployment pipeline is real.
**Breakage risk:** 🟢 — no production changes, purely additive.
**Prereq:** None.

Steps:
1. Initialize `fsg-wp-ops` as git repo and push to GitHub
2. Initialize `thefivestar-wp` as git repo and push to GitHub
3. Create GitHub Environments (staging, production with approval gate)
4. Add GitHub Secrets (WPE_SSH_PRIVATE_KEY, WPE_CREDS, install IDs)
5. Add WPE Git remotes locally
6. Test pipeline with an innocuous commit to staging

See `docs/github-setup.md` for exact commands.

---

## Session 2: Plugin cleanup — safe removals

**Goal:** Remove the zero-risk plugins that have no business case.
**Breakage risk:** 🟢 for the inactive ones; 🟡 for active ones.

### Order of operations

**Phase 1 — Already inactive, safe to remove (🟢):**
These are deactivated and have been for some time. Low-to-zero breakage risk.

| Plugin | Slug | Reason |
|--------|------|--------|
| Yoast SEO | `wordpress-seo` | Redundant with AIOSEO Pro |
| Blocksy Companion Pro | `blocksy-companion-pro` | Wrong theme companion |
| matchheight | `matchheight` | Legacy jQuery; nothing relies on it |
| Safe SVG | `safe-svg` | SVG Support covers it |

Process for each: deactivate on staging (already inactive — just delete) →
confirm site loads → delete on production → check error log.

**Phase 2 — Active but should be deactivated (🟡):**
These are currently active but serving no legitimate purpose.

| Plugin | Slug | Reason | Risk |
|--------|------|--------|------|
| AIOSEO – Local Business | `aioseo-local-business` | Not applicable to FSI | Low — schema module only |
| AIOSEO – REST API | `aioseo-rest-api` | Only for headless | Low — REST endpoint only |

Process: deactivate on staging → confirm SEO meta still renders → deactivate on prod.

**Phase 3 — Require audit before decision (🟡–🔴):**
These need more information before touching.

| Plugin | Issue |
|--------|-------|
| Elementor Pro | Active — audit which pages (if any) use Elementor |
| MonsterInsights | Inactive — overlaps Site Kit; pick one and remove the other |
| Image Optimizer | Inactive — confirm if it's being used or was replaced |
| OptiMonster | Inactive — confirm if any popups/campaigns are configured |

Claude will run the audit, present findings, and wait for go/no-go on each.

---

## Session 3: AIOSEO PHP warning

**Goal:** Resolve `Attempt to read property "hasMinimumVersion" on array` in aioseo-redirects.
**Breakage risk:** 🟡 — involves updating an active plugin.

Steps:
1. Check if an update is available for `aioseo-redirects`
2. Update on staging, confirm warning is gone in error log
3. Update on production

---

## What is NOT in scope (yet)

- WPBakery chain update (The7, WPBakery, Ultimate Addons) — separate session, high risk
- Child theme creation — defer until theme-level code work is needed
- Elementor Pro removal — depends on Phase 3 audit
- Performance audit — after plugin cleanup reduces overhead
