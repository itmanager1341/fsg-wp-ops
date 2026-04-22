# Decision Log

Architectural and operational decisions for the FSG Media WordPress portfolio.
Format: date, decision, rationale, alternatives considered, consequences.

New decisions go at the top.

---

## 2026-04-22 — Portfolio standardization: Elementor + Elementor Pro everywhere (supersedes 2026-04-19)

**Decision:** All FSG Media WordPress sites standardize on Elementor + Elementor Pro
as the sole page builder. Every new page across thefivestar.com, amaaonline.com, and
themortgagepoint.com is built in Elementor. Every updated page moves to Elementor as
it's touched. WPBakery goes into maintenance-only mode on FSI and AMAA and is retired
site-by-site as migration completes.

**This supersedes the 2026-04-19 decision (WPBakery-only-forward, Elementor phase-out).
That earlier decision rested on incorrect assumptions about the direction of FSI page
development and the long-term viability of WPBakery.**

**Rationale:**

1. **WPBakery is upstream-stagnant.** Maintenance-mode releases, no theme builder
   equivalent, shrinking developer ecosystem. Elementor has ~15M installs,
   active feature development (Theme Builder, Flexbox containers, Loop Builder),
   and a much deeper hiring pool.

2. **MortgagePoint is the working reference.** 3,351 posts, 41 magazine issues,
   31 podcasts, cross-site house ads, Advanced Ads + GAM, AIOSEO Pro, HubSpot,
   Site Kit — all production-proven on Hello Elementor + Elementor Pro
   (audit 2026-04-22). Nothing in the FSG stack requires WPBakery specifically.

3. **Cross-site content syndication becomes native.** Importing MortgagePoint
   posts into thefivestar.com is a real editorial intent. Between two Elementor
   sites the post meta and block structure are schema-compatible. Between
   Elementor (MP) and WPBakery (FSI) each imported post requires a manual
   layout rebuild. That tax would accumulate forever.

4. **Elementor Pro Theme Builder is a capability WPBakery lacks.** MortgagePoint
   renders thousands of posts consistently via 36 published
   `elementor_library` templates (Single Post, Archive Blog, Search Results, etc).
   FSI needs this for event pages, and AMAA needs it for deal/tombstone CPTs.

5. **WPBakery chain update is currently 🔴 High risk with no SOP on FSI.**
   Eliminating the WPBakery stack retires this risk permanently. Replaced by
   the Elementor + Elementor Pro + ElementsKit update chain, which is more
   granular and lower-risk.

6. **License supports it.** Elementor Pro Expert tier, 25 seats, 20 currently
   assigned. Priority sites (thefivestar, amaaonline, mortgagepoint + their
   staging/dev) need 6–9 seats. Defunct activations can be pruned; no license
   purchase required.

7. **AMAA already runs both builders.** 22 pages + 23 posts on Elementor today.
   Picking one ends a hybrid state that currently loads both builder CSS/JS
   sitewide. Picking Elementor aligns with portfolio direction.

**Scope (all three WordPress sites):**

| Site | Current | Target | Migration shape |
|------|---------|--------|-----------------|
| thefivestar.com | The7 + WPBakery (dominant) | Elementor + Elementor Pro | Build new pages in Elementor; rebuild the LLSS, Velocity, and Events hub pages first to establish templates; migrate remaining live pages as they're touched |
| amaaonline.com | The7 + WPBakery + Elementor (hybrid) | Elementor + Elementor Pro | End the hybrid; migrate WPBakery pages; retain Toolset Views for deal/tombstone until Elementor Pro loop templates replace them |
| themortgagepoint.com | Hello Elementor + Elementor Pro | No change | Reference implementation |

**Theme direction — deferred as separate decision:** Hello Elementor is
MortgagePoint's current theme and the obvious portfolio default. However:
- The7 is fully compatible with Elementor Pro (both sites already run it alongside WPBakery).
- The7 ships mega-menu, portfolio, testimonials, team CPTs out of the box that
  Hello Elementor doesn't.
- Swapping The7 → Hello Elementor on FSI/AMAA is a separate, larger effort
  that includes rebuilding those theme-level features in Elementor Pro templates.

**For now:** keep The7 on FSI and AMAA as the theme. Build new pages with
Elementor (Elementor works fine inside The7). Evaluate Hello Elementor on a
dev environment later, and commit to theme swap as a separate decision when
the pattern is proven.

**Migration approach for FSI (immediate):**

1. Rebuild the three already-built event pages (Events hub, Velocity, LLSS) in
   Elementor to establish the FSI event-page template pattern. These are the
   pages where the shared stylesheet system (`fsi-event-styles.php`) is currently
   backing plain-HTML content — they're the ideal first migration target because
   the content is fresh, the structure is documented in `docs/sops/new-event-page.md`,
   and the CSS token work is already done.
2. As the template matures, convert it into an Elementor Pro saved template
   or section library so subsequent event pages are created from the pattern,
   not from scratch.
3. Deprecate dead FSI pages (many of the ~200 are legacy per Jonathan's note).
   Active-page count for migration is significantly lower than the raw count.
4. Migrate live WPBakery pages as they're touched for editorial or structural
   updates — no forced mass migration.
5. Once all active FSI pages are Elementor-native and WPBakery page count is
   zero, deactivate WPBakery chain on staging → verify → production.

**Migration approach for AMAA (sequenced after FSI):**

1. Apply FSI-proven Elementor patterns to AMAA's page types.
2. Build Elementor Pro loop templates for `deal` and `tombstone` CPTs to
   replace Toolset Views as they're touched.
3. Event integration: replace EventON with ReMembers AMS event integration
   (planned, external to this decision). EventON is not a portfolio-standard
   plugin long-term.
4. Wild Apricot SSO (`wild-apricot-login`) is being deprecated for all
   memberships (planned, external to this decision). Not a constraint.
5. After migration: deactivate WPBakery chain on AMAA. Resolve hybrid state.

**Alternatives considered and rejected:**

- **Stay on WPBakery portfolio-wide (2026-04-19 decision):** Rejected.
  Blocks cross-site syndication, keeps 🔴 WPBakery chain risk, bets on a
  maintenance-mode builder.
- **Hybrid: Elementor on MP + AMAA, WPBakery on FSI:** Rejected. FSI's
  intent to syndicate MP content makes a shared builder necessary.
- **Move the portfolio to Gutenberg / Full Site Editing:** Rejected for now.
  Editorial team is page-builder-oriented; Elementor Pro is already paid and
  proven. Revisit in 2027+.
- **Migrate to a different page builder (Bricks, Breakdance):** Rejected.
  License already purchased on Elementor Pro; MortgagePoint already proves
  the stack; no compelling case to re-platform twice.

**Consequences:**

- `docs/decisions.md` 2026-04-19 "WPBakery is the sole forward-going builder"
  decision is superseded. Original text preserved below with supersede note
  for log integrity.
- `sites/thefivestar/elementor-migration.md` is retired — it tracked an
  Elementor phase-out that is no longer policy. Replaced by
  `sites/thefivestar/wpbakery-migration.md` (tracks WPBakery → Elementor).
- `brands/fsi/CLAUDE.md` and `docs/how-we-update-the-site.md` updated to
  reflect Elementor as the forward builder.
- `docs/sops/wpbakery-chain-update.md` remains on the backlog but is lower
  priority — the chain is now maintenance-only. If a critical update ships,
  we still need the SOP; if not, the chain retires before the SOP is needed.
- New SOPs needed: Elementor chain update (Elementor + Pro + ElementsKit + add-ons),
  Elementor Pro license management, Elementor Pro Theme Builder template
  pattern for event pages.
- FSI's event-page CSS system (`fsi-event-styles.php`) persists but its role
  changes: shared tokens live in the Elementor Pro kit (global styles); the
  mu-plugin retains only CSS that Elementor's kit cannot express, or is
  retired entirely if the kit covers everything.
- Cross-site content syndication (FSI ← MP) becomes native capability after
  FSI migration completes.

**Open items pending Jonathan's input (not blockers to starting):**

1. Theme direction (The7 kept vs Hello Elementor swap) — separate later decision
2. Elementor Pro license cleanup — ~10 defunct site activations to prune before
   adding FSI to the license
3. Elementor Pro 3.35.1 → 4.0.3 update on MortgagePoint — needs proven path
   before MP is promoted as "the pattern" for other sites

---

## 2026-04-19 — [SUPERSEDED 2026-04-22] WPBakery is the sole forward-going page builder; Elementor to be phased out

**⚠️ Superseded by 2026-04-22 portfolio standardization decision (above).
The stance below no longer reflects current direction. Retained for decision-log integrity.**

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

**Supersede note 2026-04-22:** The "Elementor is legacy" framing was wrong —
Elementor is the portfolio-standard builder and the active direction for new
FSI page development. See 2026-04-22 entry.

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

See `docs/how-we-update-the-site.md` for the full reference.

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

**Note 2026-04-22:** Under the Elementor standardization decision, The7 is retained
for now. A child theme may still be unnecessary — Elementor Pro provides custom
CSS per-section, per-page, and via the global kit. Revisit if/when Hello Elementor
migration becomes active.

---

## 2026-04-18 — [SUPERSEDED 2026-04-22] WPBakery as primary page builder (not Elementor)

**⚠️ Superseded by 2026-04-22 portfolio standardization decision.**

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

**Supersede note 2026-04-22:** The manual-rebuild concern still applies —
there's no automated WPBakery → Elementor converter. But rebuilding is now
the accepted cost to get the portfolio onto one maintained builder. See
2026-04-22 entry.

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
