# How We Update thefivestar.com

**The single reference for making any change to the site.**
Start here. Follow the decision tree. Don't improvise.

Last updated: 2026-04-21

---

## The mental model

Every change to the site falls into one of three categories. The category
determines the tool. Using the wrong tool for the category creates problems
that are hard to diagnose and sometimes hard to reverse.

```
┌─────────────────────────────────────────────────────────────┐
│  What are you changing?                                     │
│                                                             │
│  A FILE on the server (PHP, CSS, JS)                        │
│    └─▶ Workflow A: Git → GitHub → GitHub Actions            │
│                                                             │
│  SERVER STATE (plugins, DB, cache, settings)                │
│    └─▶ Workflow B: SSH → WP-CLI on WP Engine                │
│                                                             │
│  CONTENT (pages, posts, nav, text, images)                  │
│    └─▶ Workflow C: WP Admin in the browser                  │
└─────────────────────────────────────────────────────────────┘
```

The key distinction: **files go through git**, **server state goes through SSH**,
**content goes through WP Admin**. These are three completely separate systems.
Never route a plugin operation through GitHub. Never commit post content to git.
Never SFTP a file when git exists.

---

## The non-negotiable rule before we get into workflows

**Nothing goes to production without explicit approval. Every time. No exceptions.**

The required sequence for any change that touches production:

1. Make the change on staging
2. Verify it works (HTTP 200, no PHP errors, feature behaves correctly)
3. STOP. Report what was verified.
4. Ask: "Staging confirmed — ready for production. Approve?"
5. Wait for explicit "yes" in chat
6. Only then touch production

Blanket approval to work on a task is NOT production approval.
Approval to run something on staging is NOT production approval.
This rule applies to every workflow below.


---

## Workflow A — File changes via Git and GitHub Actions

### What this is

Custom PHP files, CSS, JavaScript, and mu-plugins that we own and version-control.
These live in the `thefivestar-wp` repo on GitHub and are deployed automatically
to staging (and manually to production) via GitHub Actions.

### Why we use this instead of SFTP or direct server edits

- **Version control:** every change is tracked, attributable, and reversible
- **Staging gate built in:** every push auto-deploys to staging only; production
  requires a deliberate manual trigger
- **No drift:** the repo is the source of truth; what's in git is what's on the server
- **Consistency:** the same file goes to staging and production — no manual copy errors

### What belongs in the repo

```
thefivestar-wp/
  wp-content/
    mu-plugins/          ← shared stylesheets, custom suppression plugins
    plugins/fsg-*/       ← custom FSI plugins only (not third-party)
    themes/dt-the7-child/ ← child theme (create before any theme code)
```

Third-party plugins, WP core, and uploads are NEVER tracked in git.
They live on the server and are managed via WP Admin or WP-CLI.

### How to deploy a file change

```bash
# 1. Edit the file locally in thefivestar-wp/
# 2. Commit
git add wp-content/mu-plugins/fsi-event-styles.php
git commit -m "feat: add gold callout CSS class"

# 3. Push to main — GitHub Actions auto-deploys to staging
git push origin main

# 4. Watch the Actions tab on GitHub to confirm staging deploy succeeded

# 5. Verify on staging: https://thefivestarstg.wpenginepowered.com

# 6. When approved: GitHub Actions → Deploy to WP Engine → Run workflow → production
```

### What's currently deployed this way

- `wp-content/mu-plugins/fsi-event-styles.php` — shared CSS for all event pages (v1.1)
- `wp-content/mu-plugins/fsg-suppress-aioseo-warning.php` — suppresses upstream AIOSEO bug

### Key constraints

- Do NOT push directly to production. GitHub Actions is the only path.
- Do NOT use WP Engine's Git Push feature (`git.wpengine.com`). We use the
  official WPE GitHub Action (SSH rsync) instead. See `docs/decisions.md`.
- `.deployignore` protects WPE-managed files from being deleted by rsync.
  Never remove entries from that file without understanding the consequences.


---

## Workflow B — Server state changes via SSH and WP-CLI

### What this is

Plugin installs, updates, deactivations, and deletions. Database operations.
Cache purges. Any change to server-side state that isn't a file we own.
These happen directly on the WP Engine server via SSH and WP-CLI.
GitHub is not involved. Plugins are not tracked in git — they live on the server.

### Why we use SSH and WP-CLI instead of WP Admin for this

- **Auditability:** WP-CLI output is explicit — you see exactly what changed
- **Staging first enforcement:** running commands manually on staging before production
  is a deliberate gate; WP Admin doesn't enforce sequencing
- **Bulk operations:** WP-CLI handles batch operations cleanly
- **No UI ambiguity:** WP-CLI results are unambiguous; WP Admin confirmation dialogs
  sometimes mislead about what actually happened

### Why plugins are NOT in git

Third-party plugins are managed by their vendors, update independently, and are
already on the WP Engine server. Committing plugin zips to git creates:
- Massive repo bloat
- Version conflicts when WPE auto-updates
- A false sense that git is the source of truth for plugins (it isn't)

The server is the source of truth for plugin state. Git is the source of truth
for our custom code.

### SSH session setup (run at the start of every SSH session)

WP Engine recycles SSH containers on idle staging environments, which wipes WP core
from the SSH filesystem. WP-CLI then fails with "not a WordPress installation."
This is a WPE architectural quirk — it does not affect the live site.

```bash
# Initialize SSH agent (required — agent doesn't persist between tool calls)
eval "$(ssh-agent -s)" && ssh-add /Users/jonathanhughes/.ssh/id_ed25519_itmanager

# If WP-CLI fails on staging with "not a WordPress installation":
ssh thefivestarstg 'wp core download --skip-content'
# Takes ~30 seconds. Run every session on staging. Normal.

# Verify connections
ssh thefivestar 'wp option get siteurl'
ssh thefivestarstg 'wp option get siteurl'
```

SSH aliases (from `~/.ssh/config`):

| Alias | Environment | PHP |
|-------|-------------|-----|
| `thefivestar` | Production | 8.2 |
| `thefivestarstg` | Staging | 8.4 |
| `thefivestardev` | Dev | 8.4 |

Key file: `/Users/jonathanhughes/.ssh/id_ed25519_itmanager`


### Standard Workflow B sequence

```bash
# Step 1: Run on staging
ssh thefivestarstg 'wp plugin delete google-analytics-for-wordpress'

# Step 2: Verify staging
# - Does the site load? (visit URL or curl)
# - Any PHP errors? (wp option get siteurl will surface fatal errors)
# - Does the feature/page that relied on the plugin still work?

# Step 3: STOP. Report results. Ask for production approval.
# "Staging confirmed — deleted MonsterInsights, site loads clean. Approve production?"

# Step 4: After explicit approval only
ssh thefivestar 'wp plugin delete google-analytics-for-wordpress'
```

### Writing files to WPE via WP-CLI (no SFTP)

WPE SSH Gateway does not support SCP. To push a PHP file to the server:

```bash
cat /path/to/local/file.php | ssh thefivestarstg 'wp eval-file -'
```

For pages and content: use plain HTML pushed via `wp_update_post()` in an
eval-file script. Do NOT attempt to reconstruct or re-encode WPBakery
`vc_raw_html` shortcodes programmatically — it breaks. Classic Editor renders
plain HTML directly in the content area.

### Risk levels for Workflow B operations

Every Workflow B operation is classified before execution:

🟢 **Safe** — Reversible instantly, no user impact
Examples: deleting an inactive plugin, cache purge, read-only WP-CLI queries

🟡 **Moderate** — Staging required, minor user impact possible
Examples: deactivating an active plugin, updating a non-critical plugin, adding a mu-plugin

🔴 **High** — Backup required before proceeding, explicit approval required
Examples: deleting any plugin, updating the WPBakery chain, any production DB write

Before any 🔴 operation, trigger a WPE backup and confirm it completes
before touching anything.

### WPBakery update chain — maintenance-only (transitional)

WPBakery, Ultimate Addons, Ads for WPBakery, The7 Core, and The7 theme are
tightly coupled. A version mismatch between any of them can break every page
built in WPBakery. They must be updated together in this order:

1. WPBakery Page Builder
2. Ultimate Addons for WPBakery
3. Ads for WPBakery
4. The7 Core
5. The7 theme (via Appearance → Themes, not WP-CLI)

**Under the 2026-04-22 portfolio standardization decision, WPBakery is in
maintenance-only mode on FSI and AMAA. Prefer to defer chain updates when
possible and focus effort on Elementor migration.** If a critical security
update to the WPBakery chain ships, follow the SOP (still 🔴 High risk until
chain retires). No new pages are built on WPBakery regardless of chain state.

No SOP exists yet. If a chain update becomes unavoidable, write
`docs/sops/wpbakery-chain-update.md` before touching anything.

### Elementor update chain

Elementor + Elementor Pro + ElementsKit + any add-ons also form a chain,
though more loosely coupled than WPBakery's. Update order:

1. Elementor core
2. Elementor Pro
3. ElementsKit Lite (if installed)
4. Other Elementor add-ons (Envato Elements, Essential Addons)
5. Hello Elementor theme (MortgagePoint only, for now)

Staging first. 🟡 Moderate risk. SOP pending.


---

## Workflow C — Content and page changes via WP Admin

### What this is

Creating or editing pages, posts, navigation, and any content managed through
the WordPress admin interface. No git, no SSH, no WP-CLI involved.

### Why WP Admin for content (not git or SSH)

Content lives in the database, not in files. There is no meaningful way to
version-control page content in git — WPBakery shortcodes and post content are
DB records, not source files. WP Admin is the correct tool for the DB.

### Page builder: Elementor + Elementor Pro (forward) / WPBakery (legacy, in migration)

**Per the 2026-04-22 portfolio standardization decision, Elementor + Elementor
Pro is the forward builder for all FSG Media WordPress sites.** All new pages
are built in Elementor. Existing WPBakery pages migrate to Elementor as they
are touched for editorial or structural updates.

**For new pages:**
- Edit via WP Admin → Pages → Add New → switch to Elementor
- Use the Elementor Pro global kit for colors, typography, spacing
- Save reusable sections as Elementor Pro templates for cross-page use
- Event pages: build from the FSI Event Page Elementor template (established
  during the first migration wave — Events hub, Velocity, LLSS)

**Elementor v4 global kit reality (confirmed 2026-04-23 on staging,
Elementor + Elementor Pro 4.0.2):**

Elementor v4 removed the Theme Style, Typography (H1–H6 color panel), and
Buttons panels that existed in v3.x. Site Settings in v4 is a short list:
Global Colors, Global Fonts, Site Identity, Background, Layout, Lightbox,
Page Transitions, Custom CSS, Additional Settings.

- **Global colors** → Site Settings → Global Colors (4 standard + custom)
- **Fonts** → Site Settings → Global Fonts (4 typography tokens)
- **Breakpoints + content width** → Site Settings → Layout
- **Heading color/size** → Site Settings → Custom CSS, scoped to Elementor
  widget classes (see below)
- **Buttons** → per-widget, saved as Global Widget — NOT a Site Settings
  panel in v4
- **Export the kit** → `Templates → Kits & Templates` (not `Elementor →
  Tools → Export Kit` — that path is stale; v4 moved it)

Kit artifact: `sites/thefivestar/elementor-global-kit-v1.zip` is the
canonical export (5.4KB, 4 JSON files). Re-export and overwrite after any
kit change.

**The7 + Elementor CSS specificity rule** (confirmed 2026-04-23, FSI
staging): The7's CSS targets Elementor widget classes directly
(`.elementor-heading-title`, etc.) and out-specifies plain element
selectors. Custom CSS like `h1, h2, h3 { color: ... }` will NOT take
effect. Scope every rule to the Elementor widget class:

```css
.elementor-widget-heading .elementor-heading-title { color: #1f365c; }
.elementor-widget-heading h2.elementor-heading-title { font-size: 26px; }
```

See `sites/thefivestar/the7-elementor-specificity-notes.md` for the full
finding. Expect similar fights on body text, links, lists, buttons, and
images. Each widget type used in templates likely needs matching override
rules.

**For existing WPBakery pages:**
- Edit via WP Admin → Pages → Backend Editor (WPBakery)
- Do NOT switch a WPBakery page to Gutenberg or Elementor without doing the
  full rebuild — switching builders mid-page renders broken content
- If the page needs more than trivial content edits, rebuild it in Elementor
  on staging as part of the migration

**Plugin state during transition:**
- Classic Editor and Classic Widgets remain active while WPBakery pages exist
- Elementor + Elementor Pro are active everywhere (`docs/sops` for update chain)
- See `sites/thefivestar/wpbakery-migration.md` for per-page migration status

### The shared stylesheet system — fsi-event-styles.php (transitional)

Custom CSS for FSI event pages is centralized in a mu-plugin (`fsi-event-styles.php`).
Brand tokens: Navy `#1f365c` | Gold `#c9a040` | Offwhite `#f7f7f5`.

**Transitional role during Elementor migration:**
- Today: backs plain-HTML content on the Events hub, Velocity, and LLSS pages
- Near-term: Elementor Pro global kit will own the brand tokens (colors, typography,
  spacing). The mu-plugin's role shrinks to CSS the Elementor kit can't express
- Long-term: may retire entirely once Elementor templates cover the patterns

**While the mu-plugin still matters:**

**Rule: never paste HTML with inline `style="..."` attributes.** Use class names.

Available classes are documented in `docs/sops/new-event-page.md`. New event
pages built in Elementor use the Elementor Pro global kit directly and should
not depend on these classes unless referenced inline in an HTML widget.

### Image dimensions are mandatory (CLS prevention)

Every image on every page — Elementor, transitional WPBakery, or inline HTML —
has explicit width and height dimensions. No exceptions.

**Why:** browsers reserve space for images based on declared dimensions
before the image loads. Without dimensions, content shifts down the page
as each image loads (Cumulative Layout Shift / CLS). This is both a
Core Web Vital (affects SEO ranking) and a visible UX defect.

**How, by context:**

| Context | How to set dimensions |
|---------|----------------------|
| Elementor Image widget | Width and Height fields (px, not "auto") |
| Elementor section with background image | Min Height in px on the section |
| `<img>` in inline HTML (transitional) | `width` and `height` HTML attributes |
| `fsi-event-styles.php` `.fsi-img-placeholder` | Already sized via class — keep using |

**Acceptance criterion for every migrated or new page:** Lighthouse / PageSpeed
CLS score < 0.1, verified in Chrome DevTools with Slow 4G throttle so the
test reflects a real-world slow connection.

The mu-plugin must be deployed (Workflow A) to an environment before its classes
render. Check before building a page on production:
```bash
ssh thefivestar 'ls /sites/thefivestar/wp-content/mu-plugins/fsi-event-styles.php'
```

### When staging is required for content

**Staging first required:**
- New pages with structural layout (new sections, new CSS patterns)
- Navigation changes
- Any page that relies on a mu-plugin or code not yet on production

**Production direct — no staging gate:**
- Text edits, date changes, link updates on existing pages
- Standard blog posts and news articles
- Featured image swaps

### Creating a new event page

**Current transitional SOP uses plain-HTML-in-WPBakery with the
`fsi-event-styles.php` class system.** See `docs/sops/new-event-page.md`.

**This SOP is being replaced.** The first migration wave rebuilds the
Events hub (5089), Velocity (5088), and Legal League Servicer Summit (5094)
pages in Elementor to establish the FSI event-page Elementor template.
Once that template is saved as an Elementor Pro section/template, new event
pages are created from it — not from the HTML SOP.

**Transitional summary (until Elementor template is established):**

1. WP Admin → Pages → Add New → set parent to Events (ID 5089)
2. Set slug: `event-name` (lowercase, hyphenated)
3. Build content using `fsi-*` classes — no inline styles
4. Use image placeholders (`.fsi-img-placeholder`) until real photos are ready
5. Verify URL resolves as `/events/{slug}/`
6. Add hub card to `/events/` page (ID 5089)
7. Verify on staging before touching production

**After Elementor template is established:** new event pages are created
directly in Elementor from the saved template. The plain-HTML SOP retires.

### Navigation changes

Nav items are managed in WP Admin → Appearance → Menus.
The main menu is the **TFSI** menu. Footer is the **Footer Menu**.

**Critical gotcha:** when updating nav items programmatically via WP-CLI,
`wp_update_nav_menu_item` clears the item title if all fields are not passed.
Use `wp_update_post` on the nav item post ID to update title only, and
`update_post_meta` to update URL only. Never use `wp_update_nav_menu_item`
for partial updates.

### Cache after any significant content change

WP Rocket handles automatic purge on publish for standard posts.
For nav changes, homepage edits, or new pages — manual purge required:

```bash
# Clear WP object cache
ssh thefivestarstg 'wp cache flush'

# Clear WP Rocket file cache
ssh thefivestarstg 'rm -rf /sites/thefivestarstg/wp-content/cache/wp-rocket/*'
```


---

## Quick reference — which workflow for which task

| Task | Workflow | Tool | Staging first? |
|------|----------|------|---------------|
| Add or update shared CSS (fsi-event-styles.php) | A | git push | Auto via Actions |
| Add a mu-plugin | A | git push | Auto via Actions |
| Add a custom FSI plugin | A | git push | Auto via Actions |
| Edit child theme CSS or PHP | A | git push | Auto via Actions |
| Install a third-party plugin | B | WP-CLI | Yes |
| Update a plugin | B | WP-CLI | Yes |
| Deactivate a plugin | B | WP-CLI | Yes |
| Delete a plugin | B | WP-CLI | Yes — 🔴 backup first |
| Update the WPBakery chain | B | WP-CLI | Yes — 🔴 backup + SOP first |
| Purge cache | B | WP-CLI | No — prod direct OK |
| DB search-replace | B | WP-CLI | Yes — always |
| Write a file directly to server | B | wp eval-file | Yes |
| Create a new event page (new layout) | C | WP Admin | Yes |
| Edit existing page content | C | WP Admin | No — prod direct OK |
| Update nav links | C | WP Admin | Yes |
| Update event dates, locations, links | C | WP Admin | No — prod direct OK |
| Publish a blog post or news article | C | WP Admin | No — prod direct OK |

---

## Environments

| Environment | Install | URL | PHP | WP-CLI |
|-------------|---------|-----|-----|--------|
| Production | `thefivestar` | https://thefivestar.com | 8.2 | ✅ |
| Staging | `thefivestarstg` | https://thefivestarstg.wpenginepowered.com | 8.4 | ✅ * |
| Dev | `thefivestardev` | https://thefivestardev.wpenginepowered.com | 8.4 | ✅ |

*Staging SSH container is idle-recycled by WPE. If WP-CLI fails on staging,
run `ssh thefivestarstg 'wp core download --skip-content'` and proceed.
This is expected behavior, not a problem we caused.

---

## What's in git vs. what's on the server

| Item | Where it lives | How it gets there |
|------|---------------|-------------------|
| fsi-event-styles.php | Git + server | git push → GitHub Actions |
| fsg-suppress-aioseo-warning.php | Git + server | git push → GitHub Actions |
| Third-party plugins | Server only | WP Admin or WP-CLI |
| WP core | Server only | Managed by WP Engine |
| Page content / post content | Database only | WP Admin or wp eval-file |
| Theme options / Customizer | Database only | WP Admin |
| Media / uploads | Server only | WP Admin media library |
| Nav menus | Database only | WP Admin |

---

## Related documents

| Document | What it covers |
|----------|---------------|
| `docs/sops/new-event-page.md` | Full SOP for creating event pages, all CSS classes |
| `docs/sops/plugin-update.md` | Step-by-step plugin update procedure |
| `docs/sops/deployment.md` | GitHub Actions deployment detail |
| `docs/sops/ssh-session-startup.md` | SSH agent setup for any SSH-heavy session |
| `docs/wpengine-gotchas.md` | WPE-specific quirks and workarounds |
| `docs/decisions.md` | Why we made architectural choices |
| `sites/thefivestar/plugin-inventory.md` | Current plugin state and removal history |
| `sites/thefivestar/wpbakery-migration.md` | WPBakery → Elementor page migration tracker |
| `docs/next-chat-handoff.md` | What's done, what's staging-only, what's next |
