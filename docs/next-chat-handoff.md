# Next Chat Handoff

Use this as the opening message in the next Claude Desktop project chat.
Updated at the end of each session with what was completed and what's next.

Last updated: 2026-05-21

Last completed:
- FSI Offers Free tier content fix LIVE on prod (page 5127). Hosted Page benefit card removed from Start Free section — it is an Alliance-tier benefit, not a free one. Description updated to absorb Cash Offers copy inline; 2-col grid dropped entirely. Backup `_elementor_data_backup_2026_05_21_105506`.
- Five Star Alliance membership page LIVE on prod at https://thefivestar.com/memberships/alliance/ (page 5128, parent 5113). 9 sections. Phase 4a first instance. FSI Membership Page template established.
- Template pattern locked: white centered hero (gold eyebrow + H1 + italic tagline + gold border-bottom divider), H2 borders gold, inline Path A styles, no background image. Visually distinct from Community Page template (navy full-bleed hero).
- Copy decisions: FORCE card links to fivestarforce.com; NMSA/MSEA combined card with two outbound links; AMDC = "Complimentary for Alliance members."; benefit labels uppercase gold.
- Charter Member section (Section 05) is time-sensitive: Velocity 2026 offer (May 20-21, New Orleans). Remove or replace after event closes.
- Staging page: 5146 (parent 5138 on staging). Prod page: 5128 (parent 5113 on prod). Both live and verified HTTP 200.

Next phase: Phase 4a, 6 remaining Membership pages (FORCE, Legal League firms, NMSA, MSEA, PPEF, AMDC). Alliance template is the proven pattern. Each page goes in its own subdirectory under `sites/thefivestar/elementor-templates/membership-pages/`.

---

## PROMPT TO PASTE INTO NEXT CHAT

---

Continuing FSG Media WP ops. Before responding, read these files in order:

1. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/CLAUDE.md`
2. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/brands/fsi/CLAUDE.md`
3. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/how-we-update-the-site.md`
4. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/decisions.md` (top 2 entries: 2026-05-18 Alliance ship + 2026-05-16 FSI Offers ship)
5. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/site-profile.md` ("Production page ID map" section)
6. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/sites/thefivestar/wpbakery-migration.md` ("Current state" section at top)
7. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/ssh-session-startup.md`
8. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/elementor-json-authoring.md`
9. `/Users/jonathanhughes/Development/itmanager1341/fsg-wp-ops/docs/sops/fsi-production-promotion.md`

Reference (read on demand):
- `sites/thefivestar/elementor-templates/membership-pages/alliance/` (9 sections, proven Membership Page template — primary reference for next 6 membership pages)
- `sites/thefivestar/elementor-templates/community-pages/real-estate-professionals/` (8 sections, Community Page template)
- `sites/thefivestar/elementor-templates/resource-pages/offers/` (8 sections, Resource Page template)

Then confirm you've read them and summarize:

- Current prod state: all Wave 1 hubs + Velocity + RE Pros + FSI Offers + Five Star Alliance are Elementor and LIVE. LLSS staging-only pending Template A revision + Phase 1.11. 6 Membership pages (FORCE, Legal League, NMSA, MSEA, PPEF, AMDC) and 3 Community siblings (Mortgage Finance, Legal, Prop Pres) pending greenfield builds.
- Standing rules:
  - Em-dash rule: NEVER use em-dashes in FSI copy. Strict. Brand-wide.
  - Production approval gate: explicit per-stage approval in chat. No exceptions.
  - Nav-wiring rule: new pages publish freely; new nav entries require explicit per-entry approval.
  - Doc sync rule: prod ships update decisions.md + site-profile.md + wpbakery-migration.md + next-chat-handoff.md in same commit.
  - Compose-from-disk discipline (SOP Lesson #25): glob section files from disk and re-compose for every push.
- Membership Page template pattern (Alliance, proven 2026-05-18):
  - White centered hero: gold eyebrow, H1 `color:#1f365c`, italic tagline, `border-bottom:3px solid #c9a040`
  - H2 sections: `border-bottom:2px solid #c9a040` (gold, not gray)
  - Benefit labels: uppercase 14px gold with `letter-spacing:1px`
  - Path A inline styles. No `fsi-grid-2` class (inline grid styles only).
  - Element ID prefix matches page slug (e.g. `force-`, `ll-`, `nmsa-`)
  - 8-9 sections typical
- Compose-and-push pipeline:
  - Python: glob `[0-9]*.json`, strip authoring keys, `json.dumps` compact, base64 encode
  - PHP via `cat | ssh wpe-alias "wp eval-file -"`: decode base64, backup current meta, `update_post_meta` with `wp_slash()`, `Elementor\Plugin::$instance->files_manager->clear_cache()`
  - Cache flush: `wp cache flush` + `WpeCommon::purge_varnish_cache_all()` + `WpeCommon::purge_memcached()`

Then read these for the next-step plan:
- `sites/thefivestar/elementor-templates/membership-pages/alliance/` (full template reference)
- `sites/thefivestar/elementor-templates/membership-pages/_hub/03-specialty-grid.json` (hub tile copy for each membership — source of existing brand-canonical descriptions)

Next-step plan: Jonathan will provide direction on which of the 6 remaining Membership pages to build next (FORCE, Legal League, NMSA, MSEA, PPEF, or AMDC). Each follows the Alliance template. Repo path: `sites/thefivestar/elementor-templates/membership-pages/{slug}/`. Production parent: 5113.

Do not proceed until that summary is confirmed and Jonathan has provided next-page direction.

---

## Production state (verified 2026-05-18)

Authoritative source: `sites/thefivestar/site-profile.md`. This block is a snapshot.

### Live on production (Elementor)

| URL | Prod ID | Template | Last touched |
|---|---|---|---|
| /events/ | 5089 | event-pages/_hub | 2026-05-01 |
| /events/velocity/ | 5110 | event-pages/velocity | 2026-04-30 |
| /memberships/ | 5113 | membership-pages/_hub | 2026-04-30 |
| /communities/ | 5114 | community-pages/_hub | 2026-04-30 |
| /communities/real-estate-professionals/ | 5115 | community-pages/real-estate-professionals | 2026-05-16 (content update) |
| /resources/offers/ | 5127 | resource-pages/offers | 2026-05-16 |
| /memberships/alliance/ | 5128 | membership-pages/alliance | 2026-05-18 (new) |

### Staging IDs (for reference)

| URL | Staging ID |
|---|---|
| /memberships/ (hub) | 5138 |
| /memberships/alliance/ | 5146 |

### Pending production promotion

| Page | Phase | Blocker |
|---|---|---|
| LLSS | Phase 1.11 | Template A revision + image content gathering |
| FORCE, Legal League, NMSA, MSEA, PPEF, AMDC (6 pages) | Phase 4a | Authoring |
| Mortgage Finance, Legal, Prop Pres (3 pages) | Phase 4b | After Alliance ships (now done); will trigger Path B CSS extraction |

---

## Standing rules (LOCKED, strict, no exceptions)

- Em-dash rule: Never use em-dashes (—, &mdash;) in FSI copy.
- Production approval gate: explicit per-stage approval in chat. Staging approval is not production approval.
- Nav-wiring rule: new pages publish freely; new nav entries require explicit per-entry approval.
- Doc sync rule: prod ships update decisions.md + site-profile.md + wpbakery-migration.md + next-chat-handoff.md in same commit.
- Compose-from-disk discipline: glob section files fresh for every push.

---

## Open questions / pending items

1. Charter Member section on /memberships/alliance/ — remove or replace after Velocity 2026 (May 20-21). Simple in-place section removal.
2. Phase 1.11 LLSS — staging-ready but pending Template A revision and image content. Independent of Membership page work.
3. Which of the 6 remaining Membership pages to build next — Jonathan's call.
4. Cross-links to /memberships/alliance/ — Memberships hub Alliance foundation strip could gain a "Learn more" link; FSI Offers Alliance tier sub-card could gain a "What else Alliance includes" link. Pending Jonathan's direction.
5. 5087 rollback retention — RE Pros old WPBakery preserved at /memberships-old/real-estate-professionals/. ~2 weeks confidence window past 2026-05-01 = eligible for deletion now.
6. /conferences/ retirement — still WPBakery, out of scope until LLSS and other children migrate.
