# Next Chat Handoff Prompt

Use this as the opening message in the next Claude Desktop project chat.
Update this file at the end of each session with what was completed and what's next.

Last updated: 2026-04-18
Last completed: Repo build, SSH setup, live site audit, workflow documentation

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

Then confirm you've read them and summarize:
- Current state of thefivestar.com (theme, PHP, key plugins)
- The two deployment workflows and when each applies
- What was decided about the child theme and why

Do not proceed until that summary is confirmed.

---

**Session goals (in order):**

**1. GitHub setup** — `docs/github-setup.md` has the full instructions.
Neither repo is a git repo yet. No changes to thefivestar.com are involved.
Breakage risk: 🟢 purely additive.

Walk me through each step. I am not a coder — explain what each command does
before running it, and wait for me to confirm before proceeding to the next step.

**2. Plugin cleanup — Phase 1 (inactive plugins, safe removals)**
These four plugins are already deactivated on the live site. Goal is to delete them.

| Plugin | Slug | Reason to remove |
|--------|------|-----------------|
| Yoast SEO | `wordpress-seo` | Redundant with AIOSEO Pro |
| Blocksy Companion Pro | `blocksy-companion-pro` | Wrong theme; companion for Blocksy not The7 |
| matchheight | `matchheight` | Legacy jQuery; nothing uses it |
| Safe SVG | `safe-svg` | SVG Support plugin already handles this |

Before touching anything: run a live check to confirm all four are still inactive.
State the risk level for each action before executing. Use Workflow B (SSH → WP-CLI):
staging first, then production. Wait for my go-ahead at each stage.

**3. Plugin cleanup — Phase 2 (active plugins to deactivate)**
Two AIOSEO add-ons are active but shouldn't be:
- `aioseo-local-business` — FSI is not a local business; this adds inapplicable schema
- `aioseo-rest-api` — only needed for headless WordPress; thefivestar.com is not headless

Same process: staging first, verify SEO meta is unaffected, then production.

**4. AIOSEO redirects PHP warning**
There is an active PHP warning in `aioseo-redirects`:
`Attempt to read property "hasMinimumVersion" on array` at line 73.
Check for an available update, apply on staging, confirm warning clears, then production.

---

**Rules for this session:**
- State risk level (🟢/🟡/🔴) before every operation
- Wait for explicit go-ahead before any change on production
- If anything looks different from what the plugin-inventory.md says, stop and flag it
- Log any new decisions or learnings to `docs/decisions.md`
