# Decision Log

Architectural and operational decisions for the FSG Media WordPress portfolio.
Format: date, decision, rationale, alternatives considered, consequences.

New decisions go at the top.

---

## 2026-04-18 — Two separate deployment workflows, not one pipeline

**Decision:** Maintain a strict mental separation between code deployment (git-based)
and plugin/operational changes (WP-CLI-based). Never route plugin operations through
GitHub Actions. Never track third-party plugins in git.

**Rationale:**
These are fundamentally different classes of work:

- Code changes (custom theme, custom plugins) are version-controlled in git and
  deployed via GitHub Actions → WP Engine Git remote. Staging auto-deploys on
  every push to main; production is a manual trigger with an approval gate.

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
