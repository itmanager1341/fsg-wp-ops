# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-04-19
Last completed: GitHub pipeline, plugin cleanup Phase 1 + 2, AIOSEO warning fix,
                session efficiency improvements, SOP + rule updates

---

## PROMPT TO PASTE INTO NEXT CHAT:

---

Continuing FSG Media WP ops. Before responding, read these files in order:

1. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/CLAUDE.md`
2. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/brands/fsi/CLAUDE.md`
3. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/how-changes-are-made.md`
4. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/decisions.md`
5. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/site-profile.md`
6. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/plugin-inventory.md`
7. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/ssh-session-startup.md`

Then confirm you've read them and summarize:
- Current state of thefivestar.com (theme, PHP, environments, WP-CLI status)
- The two deployment workflows and when each applies
- The production approval gate rule (verbatim from CLAUDE.md)
- What plugin cleanup has been completed and what remains

Do not proceed until that summary is confirmed.

---

## Completed this session (2026-04-19)

### Goal 1 — GitHub pipeline ✅
- `fsg-wp-ops` and `thefivestar-wp` both initialized and pushed to GitHub (itmanager1341)
- `thefivestar-wp` GitHub Environments created: `staging` (auto), `production` (manual trigger)
- 4 secrets originally added, corrected to single `WPE_SSHG_KEY_PRIVATE` using official WPE action
- `deploy.yml` rewritten: `wpengine/github-action-wpe-site-deploy@v3` (SSH rsync, not Git Push)
- `.deployignore` added to protect WPE-managed files (mu-plugins, uploads, third-party plugins)
- Pipeline confirmed working: staging auto-deploys on push to main ✅

### Goal 2 — Plugin cleanup Phase 1 ✅
Deleted from production (were already inactive):
- `wordpress-seo` — redundant with AIOSEO Pro
- `blocksy-companion-pro` — wrong theme companion
- `matchheight` — legacy jQuery
- `safe-svg` — duplicate of SVG Support

### Goal 3 — Plugin cleanup Phase 2 ✅
Deactivated (staging verified → production):
- `aioseo-local-business` — FSI is not a local business
- `aioseo-rest-api` — not a headless install

### Goal 4 — AIOSEO redirects PHP warning ✅
- Confirmed: upstream AIOSEO bug — `getAddon()` returns array instead of object
- No update available; suppressed via mu-plugin `fsg-suppress-aioseo-warning.php`
- Applied to staging and production; warning gone from all WP-CLI output
- Mu-plugin committed to `thefivestar-wp` repo

### Infrastructure fixes ✅
- Staging WP-CLI repaired (`wp core download --skip-content`)
- Staging pushed from production (WPE portal) — now a current clone
- SSH known_hosts populated for all WPE environments
- `~/.ssh/config` updated with dedicated `git.wpengine.com` entry

### Documentation + rules updated ✅
- `CLAUDE.md` — added explicit production approval gate (non-negotiable rule)
- `docs/how-changes-are-made.md` — updated deployment method, SSH notes, file-writing method
- `docs/sops/ssh-session-startup.md` — new SOP for SSH-heavy sessions
- `docs/decisions.md` — WPE official action decision logged

---

## Next session goals (suggested order)

### 1. Elementor Pro audit (🟡 Medium priority)
Elementor Pro is active at v4.0.2 but the site runs on WPBakery. Need to determine:
- Which pages (if any) use Elementor content
- Whether those pages are live/published or drafts
- Decision: keep Elementor for those pages, rebuild in WPBakery, or remove entirely

```bash
# Quick audit command to run on production
ssh thefivestar wp post list --meta_key=_elementor_edit_mode --meta_value=builder \
  --fields=ID,post_title,post_status --format=table
```

### 2. MonsterInsights decision (🟢 Low priority)
MonsterInsights (`google-analytics-for-wordpress`) is inactive and overlaps with
Site Kit by Google (active). Decision needed: keep one, remove the other. Site Kit
is already active and doing the job. Recommendation: remove MonsterInsights.

### 3. Remaining cleanup backlog (🟢 Low priority)
From `plugin-inventory.md`:
- `image-optimization` — activate or remove
- `optinmonster` — activate or remove
- `eventon-lite` — activate or remove (depends on events use case)
- `aioseo-eeat` — activate or remove (depends on author authority strategy)

### 4. WPBakery chain update (🔴 High priority when ready)
The WPBakery dependency chain (WPBakery → Ultimate Addons → Ads for WPBakery →
The7 Core → The7 theme) needs to be updated together, in order, on staging first.
No SOP exists for this yet — create it before starting.

Current versions:
- WPBakery: 8.7.2
- Ultimate Addons: 3.21.3
- Ads for WPBakery: 2.0.0
- The7 Core: 2.7.12

Check current versions before starting — these may have been auto-updated by WPE.

### 5. amaaonline-wp scaffolding (when FSI pipeline is fully proven)
Per `docs/decisions.md`: don't scaffold until thefivestar-wp is confirmed working
end-to-end. The pipeline is now proven. This can begin whenever ready.

---

## Key facts to remember

**Environments:**
- Production: `thefivestar` / PHP 8.2 / WP-CLI works ✅
- Staging: `thefivestarstg` / PHP 8.4 / WP-CLI works ✅ (core downloaded 2026-04-19)
- Dev: `thefivestardev` / PHP 8.4 / WP-CLI works ✅ / active dev environment (devs working here)

**Deploy key:** `id_ed25519_itmanager` (SSH Gateway / WP-CLI)
**GitHub Actions key:** `wpengine_ed25519` (registered in WPE as "WPE GHA", in GitHub as `WPE_SSHG_KEY_PRIVATE`)

**File writing to WPE (no SCP):**
```bash
cat /path/to/local/file.php | ssh thefivestar wp eval-file -
```

**Production approval gate (from CLAUDE.md):**
Run on staging → verify → STOP → report → ask "Approve?" → wait → then production.
No exceptions. Blanket task approval ≠ production approval.
