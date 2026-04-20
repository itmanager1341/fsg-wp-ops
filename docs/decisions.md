# Decision Log

Architectural and operational decisions for the FSG Media WordPress portfolio.
Format: date, decision, rationale, alternatives considered, consequences.

New decisions go at the top.

---

## 2026-04-19 — WPBakery is the sole forward-going page builder; Elementor to be phased out

**Decision:** All new page development on thefivestar.com uses WPBakery exclusively.
Elementor and Elementor Pro will be removed once all Elementor-built pages are either
rebuilt in WPBakery or permanently deactivated (set to draft/trash).

**Rationale:**
Live audit confirmed 18 pages with `_elementor_edit_mode = builder`:
- 3 drafts (4973, 4834, 4828) — unnamed/throwaway Elementor pages, no user impact
- 1 private (4909 — Home) — not publicly visible
- 14 published pages — see `sites/thefivestar/elementor-migration.md` for full inventory

Running two page builders simultaneously creates asset bloat (Elementor loads CSS/JS
on every page regardless of whether that page uses it), maintenance surface, and
training confusion for anyone editing the site. WPBakery is already the configured
builder for The7 theme. Elementor is legacy.

Most of the 14 live Elementor pages are event asset and lander pages that are outdated
or low-traffic and should be reviewed for deactivation before any rebuild work begins.
Migration scope is likely smaller than the raw count suggests.

**Migration approach (phased):**
1. Review all 14 published Elementor pages — identify which to trash vs. rebuild
2. Trash confirmed-dead pages (reduces rebuild scope)
3. Rebuild remaining pages in WPBakery on staging, verify, promote to production
4. Once zero published pages have `_elementor_edit_mode = builder`, deactivate Elementor + Elementor Pro
5. Verify staging, then delete both plugins from production

**Alternatives considered:**
- Keep both builders indefinitely — rejected; doubles asset load and maintenance burden
- Migrate to Elementor fully — rejected; WPBakery is the configured The7 builder and
  all infrastructure/training is WPBakery-oriented

**Consequences:**
- No new pages or sections to be built in Elementor
- Elementor plugins stay installed but are lower priority until migration completes
- See `sites/thefivestar/elementor-migration.md` for page-by-page tracking

---

## 2026-04-19 — Use WPE official GitHub Action (SSH rsync), not Git Push

**Decision:** Deploy via `wpengine/github-action-wpe-site-deploy@v3` (SSH rsync),
not via WP Engine Git Push (`git.wpengine.com`).

**Rationale:**
The original `deploy.yml` used WP Engine's Git Push feature, which requires a
separate passphrase-free SSH key registered specifically for that feature, and
`git push` to `git.wpengine.com`. After extended troubleshooting, it became clear
that:

1. WP Engine's official GitHub Action explicitly states it does NOT use Git Push.
2. The official action uses SSH rsync via the SSH Gateway — the same connection
   that already works for WP-CLI operations (`ssh thefivestar`).
3. Git Push is a separate WPE feature with its own key requirements and complexity
   that adds no benefit for our use case.

The official action is simpler: one secret (`WPE_SSHG_KEY_PRIVATE`), one step,
cache clear built in, no git remote configuration required.

**Secrets after migration:**
- `WPE_SSHG_KEY_PRIVATE` (repo-level) — private key of `id_ed25519_itmanager`
- `WPE_SSH_PRIVATE_KEY`, `WPE_CREDS`, `WPE_INSTALL_ID_*` — all removed

**Org-level secrets decision:** Skipped GitHub Organization creation. With only
3 site repos, adding `WPE_SSHG_KEY_PRIVATE` as a repo secret to each on scaffold
is faster than managing an org. Revisit if the portfolio grows beyond ~10 repos.

**Alternatives considered:**
- Keep Git Push approach — rejected due to complexity and separate key management
- GitHub org for shared secrets — rejected due to overhead at current scale

**Consequences:** `deploy.yml` is simpler and more maintainable. The `wpengine_ed25519`
key generated during the Git Push investigation is now unused — it remains registered
in WPE but is not referenced in any workflow.

---

## 2026-04-18 — Two separate deployment workflows, not one pipeline

**Decision:** Maintain a strict mental separation between code deployment (git-based)
and plugin/operational changes (WP-CLI-based). Never route plugin operations through
GitHub Actions. Never track third-party plugins in git.

**Rationale:**
These are fundamentally different classes of work:

- Code changes (custom theme, custom plugins) are version-controlled in git and
  deployed via GitHub Actions → WP Engine SSH rsync. Staging auto-deploys on
  every push to main; production is a manual trigger.

- Plugin and operational changes (updates, deactivations, deletions, cache, DB)
  happen directly on the WP Engine server via SSH + WP-CLI. GitHub is not in
  this loop. Plugins live on the server; they are not tracked in git.

Conflating these leads to: trying to commit plugin zips to git, routing cache
purges through CI, or expecting GitHub Actions to handle plugin updates. All wrong.

**Practical consequence:** Most near-term work (plugin cleanup) is entirely
Workflow B — SSH + WP-CLI, staging first, then production. No code to push,
no GitHub Actions involved.

**Staging cadence:** Staging gets updated far more than production. Every code
push auto-deploys to staging. Every plugin op runs on staging first. Production
is touched deliberately and rarely.

See `docs/how-changes-are-made.md` for the full reference.

---

## 2026-04-18 — Child theme: defer creation until theme-level code is needed

**Decision:** Do not create a `dt-the7-child` child theme yet.

**Rationale:**
A WordPress child theme is only necessary when you need to:
1. Override theme template files (header.php, footer.php, single.php, etc.)
2. Add custom PHP functions (functions.php)
3. Add custom CSS outside of what The7's own options provide

The thefivestar.com site currently stores all its configuration in the database:
- Page layouts → WPBakery shortcodes in post_content (DB)
- Design settings → The7 Theme Options / Customizer (DB)
- Custom post types → The7 Core plugin and Toolset Types (plugin-managed)

None of that lives in theme files. The7 updates don't touch the DB. So the site
has operated safely without a child theme since launch and will continue to do so
for any plugin-level or content-level work.

**When to revisit:** Create the child theme immediately before writing any custom
PHP, overriding any template file, or adding CSS that can't be handled by
The7's built-in options. Do not create it speculatively.

**Consequences:** Removed from 🔴 High priority in site-profile.md. Will be added
back if theme-level code work is planned.

**Alternatives considered:** Create it now "just in case" — rejected because it
adds a file to manage/deploy with no immediate benefit and creates confusion about
where theme customizations live.

---

## 2026-04-18 — WPBakery as primary page builder (not Elementor)

**Decision:** Keep WPBakery Page Builder as the primary builder for thefivestar.com.
Do not migrate to Elementor even though Elementor Pro is now active.

**Rationale:**
All existing page layouts are built in WPBakery shortcodes stored in post_content.
Migrating to Elementor would require rebuilding every page manually — there is no
automated migration path from WPBakery shortcodes to Elementor widgets.

Elementor Pro being active (per the live audit) needs investigation: confirm which
pages (if any) use Elementor, then decide whether to keep it for those pages or
rebuild them in WPBakery and remove it.

**Consequences:** Elementor Pro stays installed pending audit. Classic Editor and
Classic Widgets must remain active. The7 Theme Settings must stay in WPBakery mode.

---

## 2026-04-18 — AIOSEO Pro as sole SEO plugin (remove Yoast)

**Decision:** Remove Yoast SEO. AIOSEO Pro is the single SEO plugin.

**Rationale:**
Both plugins were active simultaneously. This causes:
- Duplicate meta tags in the page <head>
- Competing XML sitemaps
- Redundant structured data output
- Performance overhead (two plugins doing the same job)

AIOSEO Pro is the paid investment with the fuller add-on suite. Yoast is inactive
(confirmed in live audit) but still installed — remove it entirely.

**Process:** Deactivate on staging → confirm no SEO regressions → delete on prod.

---

## 2026-04-18 — thefivestar-wp is the reference implementation

**Decision:** Build and prove the complete deployment pattern on thefivestar-wp
before scaffolding amaaonline-wp or themortgagepoint-wp.

**Rationale:**
Each site has a different theme, page builder, and plugin stack. The deployment
pipeline (GitHub → GitHub Actions → WP Engine) needs to be validated end-to-end
on one site before replicating. FSI is the primary operational focus and the
best-understood site.

**Consequences:** amaaonline-wp and themortgagepoint-wp are stubs. Brand files for
AMAA and MortgagePoint are stubs. No work begins on those until FSI is confirmed.

---

## 2026-04-18 — SSH config: explicit per-install entries (not wildcard User %h)

**Decision:** Use individual Host entries in ~/.ssh/config with hardcoded User values
for each WP Engine install.

**Rationale:**
A wildcard approach using `User %h` was attempted. OpenSSH expands `%h` in the User
directive to the final HostName value (e.g., `thefivestar.ssh.wpengine.net`) rather
than the original host alias (`thefivestar`). WP Engine rejected the connection with
"Cannot access install" because it couldn't find an install matching the full
hostname as a username. Explicit entries are unambiguous and correct.

**Lesson:** In SSH config, `%h` in HostName expands from the alias; `%h` in User
expands from the final hostname. They are not the same token in practice.
