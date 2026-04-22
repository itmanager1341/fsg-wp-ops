# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-04-22
Last completed: Portfolio-wide page-builder decision (Elementor standardization),
                MortgagePoint + AMAA audits, three site profiles written,
                6 docs updated to reflect new direction

---

## PROMPT TO PASTE INTO NEXT CHAT

---

Continuing FSG Media WP ops. Before responding, read these files in order:

1. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/CLAUDE.md`
2. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/brands/fsi/CLAUDE.md`
3. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/how-we-update-the-site.md`
4. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/decisions.md`
5. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/site-profile.md`
6. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/plugin-inventory.md`
7. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/wpbakery-migration.md`
8. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/mortgagepoint/site-profile.md`
9. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/amaaonline/site-profile.md`
10. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/ssh-session-startup.md`

Then confirm you've read them and summarize:

- The 2026-04-22 portfolio standardization decision (what builder, what it
  supersedes, what the first migration wave is)
- Current state of thefivestar.com, amaaonline.com, themortgagepoint.com
  (theme, builder, content volume at a glance)
- The three deployment workflows (A/B/C) and when each applies
- The production approval gate rule (verbatim from CLAUDE.md)
- Current staging-only changes not yet promoted to production

Do not proceed until that summary is confirmed.

---

## Completed this session (2026-04-22)

### MortgagePoint audit ✅

- Full stack audit via SSH + WP-CLI read-only queries
- Hello Elementor 3.4.6 + Elementor 4.0.1 + Elementor Pro 3.35.1
- Content: 3,351 posts, 102 pages, 41 publications, 31 podcasts, 85 people (guest-author)
- 36 Elementor Pro theme-builder templates
- 4 ad placements + 5 house ads (all cross-promoting FSI events)
- Publishing cadence ~100/month consistent since 2025
- Notable: DB prefix is `wp_lkihb5gwg6_` (non-default)
- Written to `sites/mortgagepoint/site-profile.md` (267 lines)
- Plugin inventory at `sites/mortgagepoint/plugin-inventory.md` (151 lines)

### AMAA audit ✅

- Theme: The7 14.3.1, same family as FSI
- Hybrid state: WPBakery + Elementor Pro both active (22 pages + 23 posts on Elementor)
- Content: 688 posts, 115 pages, 545 events, 178 deals, 127 tombstones, 24 podcasts
- `wild-apricot-login` for SSO (being deprecated by FSG, not a constraint)
- Full Toolset stack (Types, Views, Access, CRED, Layouts)
- 85-item main menu — IA cleanup candidate
- Written to `sites/amaaonline/site-profile.md` (247 lines)
- Plugin inventory at `sites/amaaonline/plugin-inventory.md` (181 lines)

### Portfolio standardization decision ✅

**Decision:** Elementor + Elementor Pro is the sole page builder across
thefivestar.com, amaaonline.com, and themortgagepoint.com. All new pages
built in Elementor. WPBakery in maintenance-only mode; retires as migration
completes. Written to `docs/decisions.md` 2026-04-22 entry.

**Supersedes:** 2026-04-19 "WPBakery only going forward" decision.
Original entries preserved with supersede annotations.

### Docs updated to reflect new direction ✅

Six files updated/created:

1. `docs/decisions.md` — new 2026-04-22 entry at top; 2026-04-19 and earlier
   2026-04-18 WPBakery decisions marked superseded (original text preserved)
2. `brands/fsi/CLAUDE.md` — rewrote "WPBakery is the page builder" guidance
   to reflect Elementor-forward direction; noted Classic Editor/Widgets are
   retained only while WPBakery pages exist
3. `docs/how-we-update-the-site.md` — Workflow C page-builder section rewritten;
   WPBakery chain section reframed as maintenance-only; Elementor chain section
   added; event page SOP marked transitional
4. `sites/thefivestar/wpbakery-migration.md` — new tracker for WPBakery → Elementor
   direction (replaces the superseded elementor-migration.md which was renamed
   to `.superseded-2026-04-22`)
5. `sites/thefivestar/site-profile.md` — open-issues table updated: Elementor
   "phased out" → "on-standard"; WPBakery chain update 🔴 → 🟡 maintenance-only
6. `sites/thefivestar/plugin-inventory.md` — WPBakery chain relabeled
   maintenance-only; new Elementor chain section; Elementor plugins relabeled
   from "Legacy" to "Forward builder"

### Files written this session

- `sites/mortgagepoint/site-profile.md` (new)
- `sites/mortgagepoint/plugin-inventory.md` (new)
- `sites/amaaonline/site-profile.md` (new, then amended for Wild Apricot / EventON framing)
- `sites/amaaonline/plugin-inventory.md` (new, then amended)
- `sites/thefivestar/wpbakery-migration.md` (new — replaces elementor-migration.md)

---

## Current staging-only changes (not yet on production)

Unchanged from last session — these are all WPBakery-era changes and still
need to go out:

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

**Decision implication:** These staging changes are worth promoting to
production as-is. They don't block the Elementor migration. The event pages
will get rebuilt in Elementor in Phase 1 anyway, but shipping the current
plain-HTML versions gives real users a working Events section now. The CSS
mu-plugin continues to matter during transition.

Priority order unchanged:
1. `fsi-event-styles.php` — must go first
2. Plugin deletions — low risk
3. LLSS page
4. Nav changes
5. Events hub rebuild

---

## Next session goals (suggested order)

### 1. Phase 1 — Establish FSI Elementor event-page template (🟡 Medium)

First concrete action under the new standardization decision. Build the FSI
Event Page template in Elementor using the three existing event pages
(Events hub 5089, Velocity 5088, LLSS 5094) as reference content.

Subtasks:
- Populate Elementor Pro global kit with FSI brand tokens (Navy #1f365c,
  Gold #c9a040, Offwhite #f7f7f5 + typography scale)
- Build the LLSS page in Elementor on staging as the template source
- Save reusable sections as Elementor Pro templates (hero, callout, photo
  strip, membership cards, event details, CTA)
- Write `docs/sops/new-event-page-elementor.md` replacing the plain-HTML SOP
- Verify Advanced Ads, HubSpot, AIOSEO, Site Kit all still function on the
  Elementor version of the page
- Then promote to production alongside the current staging queue

### 2. Promote staging changes to production (🔴 per-item approval)

See table above. Can proceed in parallel with Phase 1 work. Priority order:
CSS mu-plugin, plugin deletions, LLSS page, nav changes, events hub.

### 3. FSI deprecation pass (🟡 Medium)

Identify the ~200 legacy pages that should be trashed rather than migrated.
Will need GA4 / Site Kit access to filter by traffic. Reduces migration scope.

### 4. Elementor Pro license cleanup (🟢 Low)

Prune defunct activations from the 20-of-25-used license. Candidates from
Jonathan's list: `themsea.com`, `themplaunch.com`, `themp.flywheelsites.com`,
`thefsiad.flywheelsites.com`, `localhost:10004`, `thefivestar.wpenginepowered.com/mediakit`,
any other dormant sites. Verify with Jonathan which are truly inactive before
removing activations.

### 5. Elementor Pro update on MortgagePoint (🟡 Medium)

MP is on Elementor Pro 3.35.1 while Elementor core is on 4.0.1 — there's a
Pro 4.0.3 update available. Test on a staging/dev environment before doing
this; version compatibility in the Elementor stack is tight. Needs to happen
before MP is promoted as "the reference pattern" for FSI migration.

### 6. AMAA — defer until FSI Phase 1 is proven

Per sequencing in the decision: FSI migration proves the pattern, AMAA follows.
AMAA work picks up once the FSI Elementor template library is mature.

### 7. WPBakery chain update (now 🟡, was 🔴)

Downgraded under 2026-04-22 decision. Only needed if a critical update ships
before the chain retires. Still: if it becomes unavoidable, write
`docs/sops/wpbakery-chain-update.md` first.

---

## Key facts

**Portfolio standardization decision (2026-04-22):**
- Forward builder: Elementor + Elementor Pro across all 3 WP sites
- WPBakery on FSI + AMAA: maintenance-only, retires as migration completes
- Theme direction: The7 stays on FSI and AMAA for now (Hello Elementor swap
  is a separate later decision). MortgagePoint stays on Hello Elementor.
- Elementor Pro license: Expert tier, 25 seats, subscription 13620718

**Environments (FSI):**
- Production: `thefivestar` / PHP 8.2 / WP-CLI works ✅
- Staging: `thefivestarstg` / PHP 8.4 / WP-CLI works ✅
- Dev: `thefivestardev` / PHP 8.4 / WP-CLI works ✅

**WP core on staging SSH container:** Disappears when WPE recycles the
container. Fix: `wp core download --skip-content`. Doesn't affect the live
site. Run at start of every SSH session.

**Deploy key:** `id_ed25519_itmanager` (SSH Gateway / WP-CLI)
**GitHub Actions key:** `wpengine_ed25519` → secret `WPE_SSHG_KEY_PRIVATE`

**Event pages (staging):**
- Events hub: page ID 5089, `/events/`
- Velocity: page ID 5088, `/events/velocity/`
- Legal League Servicer Summit: page ID 5094, `/events/legal-league-servicer-summit/`

**fsi-event-styles.php:** v1.1 on staging. NOT on production.
Repo: `thefivestar-wp/wp-content/mu-plugins/fsi-event-styles.php`.
Role: transitional — Elementor Pro global kit will own brand tokens after
Phase 1.

**WPBakery content pages during transition:** Do NOT use `vc_raw_html`
encoding for pages we control. Push plain HTML via `wp eval-file -`.
(Still applies to the remaining WPBakery-era staging work; after Phase 1,
Elementor replaces this pattern.)

**Production approval gate (from CLAUDE.md):**
Run on staging → verify → STOP → report → ask "Approve?" → wait → then production.
No exceptions. Blanket task approval ≠ production approval.

**Staging content loss — root cause identified:**
Not a WPE platform issue. Claude sessions starting fresh have historically
pulled production → staging to "baseline" a page, silently overwriting staging-only
work. Fix: staging is authoritative for unreleased work. Read staging state
before any write. Track page-level staging-only state in this handoff file.

**Local WP setup:** Pending separate deliverable. Will enable faster code
iteration and eliminate "SSH container recycled" delays for development work.

---

## Open questions carried forward

1. Theme direction — keep The7 on FSI and AMAA, or swap to Hello Elementor?
   (Separate later decision; not a blocker for Phase 1)
2. Design direction for the Phase 1 Elementor event-page template — reuse
   existing FSI visual language or introduce redesign concurrent with builder
   migration? (Recommend: reuse existing tokens to de-risk Phase 1; visual
   redesign is a separate pass)
3. Elementor Pro 3.x → 4.x upgrade path on MortgagePoint — needs proven path
   before MP is promoted as reference
4. FSI deprecation pass — which pages truly dead? Needs GA4 / Site Kit data
