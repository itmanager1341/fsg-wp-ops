# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-04-21
Last completed: Elementor audit, plugin cleanup phase 3, event pages system,
                Legal League Servicer Summit page, nav menu updates, docs overhaul

---

## PROMPT TO PASTE INTO NEXT CHAT:

---

Continuing FSG Media WP ops. Before responding, read these files in order:

1. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/CLAUDE.md`
2. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/brands/fsi/CLAUDE.md`
3. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/how-we-update-the-site.md`
4. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/decisions.md`
5. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/site-profile.md`
6. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/plugin-inventory.md`
7. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/ssh-session-startup.md`

Then confirm you've read them and summarize:
- Current state of thefivestar.com (theme, PHP, environments, WP-CLI status)
- The three deployment workflows and when each applies
- The production approval gate rule (verbatim from CLAUDE.md)
- What plugin cleanup has been completed and what remains
- Current staging-only changes not yet promoted to production

Do not proceed until that summary is confirmed.

---

## Completed this session (2026-04-21)

### Elementor audit ✅
- Confirmed 18 pages use Elementor (`_elementor_edit_mode = builder`)
- 3 drafts, 1 private, 14 published
- Decision logged: WPBakery only going forward, Elementor phased out
- Migration tracker created: `sites/thefivestar/elementor-migration.md`
- Original audit query was wrong (`--post_type` defaulted to posts, not pages)
  Correct query: `wp post list --post_type=any --meta_key=_elementor_edit_mode --meta_value=builder`

### Plugin cleanup phase 3 ✅ (staging only)
Deleted from staging (not yet on production):
- MonsterInsights (`google-analytics-for-wordpress`) — overlapped Site Kit
- Image Optimizer (`image-optimization`) — inactive, unused
- OptiMonster (`optinmonster`) — inactive, no active campaigns
- EventON Lite (`eventon-lite`) — inactive, not used

### Event pages system built ✅
- Shared CSS mu-plugin: `fsi-event-styles.php` (v1.1) — deployed to staging via GitHub Actions
  - v1.0: base layout, event cards, hero, grids, cards, buttons, features
  - v1.1: image blocks, photo strip, gold callout, membership cards, muted section, program-full
- Events hub (`/events/`, page ID 5089) — rebuilt with `fsi-*` classes, plain HTML (not WPBakery)
- Velocity page (`/events/velocity/`, page ID 5088) — content synced from production to staging
- Legal League Servicer Summit (`/events/legal-league-servicer-summit/`, page ID 5094) — fully built
  - Evergreen structure, prescribed image placeholders throughout
  - Hero, intro, Who Belongs, What Happens, Next Summit (gold callout), Recent Summit (photo strip),
    Join the Community (membership cards), Event Details, Final CTA

### Navigation updated (staging) ✅
- Main nav "Events" (item 2723) → `/events/`
- Main nav "Events > Live" (item 2724) → `/events/`
- Footer "Conferences" (item 2775) → `/events/`
- Footer "Events" (item 2777) → `/events/`
- Bug learned: `wp_update_nav_menu_item` clears title if all fields not passed.
  Use `wp_update_post` on the nav item post ID to change title only.

### Documentation overhauled ✅
- `docs/how-changes-are-made.md` — Workflow C added (page/content creation)
- `docs/sops/new-event-page.md` — new SOP with full HTML template and v1.1 class reference
- `docs/sops/deployment.md` — removed incorrect git.wpengine.com remote references
- `brands/fsi/design-system.md` — real brand tokens documented
- `docs/decisions.md` — Elementor/WPBakery decision logged
- `sites/thefivestar/elementor-migration.md` — page-by-page tracker created
- `sites/thefivestar/plugin-inventory.md` — removal history table, backlog updated
- `docs/wpengine-gotchas.md` — 3 new gotchas added
- `docs/next-chat-handoff.md` — this file (updated)
- `docs/session-plan.md` — retired, replaced by next-chat-handoff.md

---

## Current staging-only changes (not yet on production)

These are on staging but have NOT been promoted to production. Jonathan must approve
each before it goes live.

| Change | Type | Staging | Production |
|--------|------|---------|------------|
| MonsterInsights deleted | Plugin | ✅ deleted | ❌ still exists |
| Image Optimizer deleted | Plugin | ✅ deleted | ❌ still exists |
| OptiMonster deleted | Plugin | ✅ deleted | ❌ still exists |
| EventON Lite deleted | Plugin | ✅ deleted | ❌ still exists |
| fsi-event-styles.php (v1.1) | mu-plugin (code) | ✅ deployed | ❌ not deployed |
| Events hub rebuilt | Content | ✅ live | ✅ live (old version) |
| Velocity page content | Content | ✅ synced | ✅ live (source) |
| LLSS page | Content | ✅ live (new) | ❌ doesn't exist |
| Nav: Events → /events/ | Menu | ✅ updated | ❌ still → /conferences/ |
| Nav: Live → /events/ | Menu | ✅ updated | ❌ still → /conferences/ |

**Priority order for production promotion:**
1. `fsi-event-styles.php` — must go first (CSS required for all event pages)
2. Plugin deletions — low risk, all were inactive
3. LLSS page — after CSS is on production
4. Nav changes — after LLSS page is on production
5. Events hub rebuild — after nav is confirmed

---

## Next session goals (suggested order)

### 1. Velocity page refactor (🟡 Medium)
Velocity is still using inline styles from original build. Refactor to `fsi-*` classes
to match the system. Do on staging, verify, then carry to production with the rest.

### 2. Promote staging changes to production (🔴 requires explicit approval per item)
See table above. Promote in priority order. `fsi-event-styles.php` must go first.

### 3. WPBakery chain update (🔴 High — create SOP first)
No SOP exists yet. Create `docs/sops/wpbakery-chain-update.md` before touching anything.
Update order: WPBakery → Ultimate Addons → Ads for WPBakery → The7 Core → The7 theme.
Current versions (verify before starting — may have auto-updated):
- WPBakery: 8.7.2
- Ultimate Addons: 3.21.3
- Ads for WPBakery: 2.0.0
- The7 Core: 2.7.12

### 4. LLSS image population
Photos from Dallas 2026 needed for:
- Hero background (1900×600px)
- Community photo block (1100×440px)
- 3-photo strip in Recent Summit section (360×240px each)
- Firm membership card image (480×220px)

### 5. amaaonline-wp scaffolding (when ready)
Pipeline proven on FSI. Can begin whenever Jonathan confirms.

---

## Key facts

**Environments:**
- Production: `thefivestar` / PHP 8.2 / WP-CLI works ✅
- Staging: `thefivestarstg` / PHP 8.4 / WP-CLI works ✅
- Dev: `thefivestardev` / PHP 8.4 / WP-CLI works ✅ / active dev environment

**WP core on staging SSH container:** Disappears when WPE recycles the container (idle environments).
Fix: `wp core download --skip-content`. Doesn't affect the live site. Run at start of every SSH session.

**Deploy key:** `id_ed25519_itmanager` (SSH Gateway / WP-CLI)
**GitHub Actions key:** `wpengine_ed25519` → secret `WPE_SSHG_KEY_PRIVATE`

**Event pages (staging):**
- Events hub: page ID 5089, `/events/`
- Velocity: page ID 5088, `/events/velocity/`
- Legal League Servicer Summit: page ID 5094, `/events/legal-league-servicer-summit/`

**fsi-event-styles.php:** v1.1 on staging. NOT on production.
Repo: `thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php`

**WPBakery content pages:** Do NOT use `vc_raw_html` encoding for pages we control.
Push plain HTML via `wp eval-file -`. WPBakery encoding (base64 + URL-encode) is fragile
and breaks on re-encode. Classic Editor renders plain HTML directly.

**Production approval gate (from CLAUDE.md):**
Run on staging → verify → STOP → report → ask "Approve?" → wait → then production.
No exceptions. Blanket task approval ≠ production approval.
