# FSG Media WordPress Operations

This repo is the operations hub for FSG Media's WordPress portfolio. It holds brand
guides, SOPs, site metadata, audit history, and helper scripts. Site code lives in
separate sibling repos (e.g. `../thefivestar-wp/`).

## Corporate structure

- **FSG Media** (parent, `fsg-media.com` on Vercel, repo `fsg-media-31` — NOT WordPress)
  - **AMAA** (association, brand #1)
    - `amaaonline.com` — WordPress, WP Engine
  - **FSI** — The Five Star Institute (association, brand #2)
    - `thefivestar.com` — WordPress, WP Engine
    - **MortgagePoint** (FSI's media flagship, brand #3)
      - `themortgagepoint.com` — WordPress, WP Engine
  - **REIF** — Real Estate Investment Forum (pre-launch, brand #4, no site yet)


## Three brands, three voices — plus one pre-launch

AMAA, FSI, MortgagePoint, and REIF each have distinct brand identities. Before
generating any content for a site:

1. Identify which brand applies (site → brand map below).
2. Load `brands/{brand}/voice-guide.md` and `brands/{brand}/design-system.md`.
3. For deeper voice content, `brands/{brand}/sharepoint-index.md` points to
   SharePoint paths under `Marketing/1. Voice Guides/`. Use the SharePoint MCP
   connector to read specific files when needed — do not copy them into this repo.

**Site → brand map:**
| Site | Brand | Association |
|------|-------|-------------|
| amaaonline.com | AMAA | AMAA |
| thefivestar.com | FSI | FSI |
| themortgagepoint.com | MortgagePoint | FSI |


## Site code repos (siblings)

Site code is NOT in this repo. It lives in:
- `../thefivestar-wp/` — live, primary reference implementation
- `../amaaonline-wp/` — not yet scaffolded (pending fivestar pattern proof)
- `../themortgagepoint-wp/` — not yet scaffolded (pending fivestar pattern proof)

Each site repo only tracks `wp-content/themes/{custom}`, `wp-content/plugins/{custom}`,
and `wp-content/mu-plugins/`. WP core, third-party plugins, and uploads are never
tracked. Deployment is via GitHub Actions → WP Engine SSH Gateway (rsync).

## WP Engine constraints (hard rules)

- WP core is managed by WPE. Never modify `wp-admin/`, `wp-includes/`, or root
  `wp-*.php` files.
- Never push directly to WP Engine's git remote. GitHub is the source of truth;
  GitHub Actions deploys via the official WPE action (SSH rsync, not Git Push).
- All code changes land on Staging or Development first, never production first.
- Use SSH Gateway + WP-CLI for operational tasks. Do not edit files via SFTP
  except in emergencies.
- API access uses Application Passwords, never the admin password.


## Defaults for every task

- **Always ask which site** before generating site-specific code or content. Never
  assume — the three WP sites serve different audiences on different stacks.
- **Produce exact before/after** for edits, not descriptions of the change.
- **For plugin recommendations:** list 2-3 ranked options with tradeoffs. Reject
  plugins not updated in 12+ months.
- **For destructive ops** (delete, bulk update, deactivation, DB writes):
  produce a reversible plan first, then ask for explicit confirmation.
- **Reference baselines** — `sites/{site}/performance-baseline.md` and
  `seo-baseline.md` — when doing related work. If a baseline doesn't exist, create it.
- **Flag missing access.** If a task needs credentials, tools, or context I don't
  have, stop and say so before attempting workarounds.
- **Check SOPs** in `docs/sops/` before improvising a procedure. If no SOP exists
  for what you're doing, flag it.
- **Don't write code without approval.** Present the plan first, get sign-off, then write.


## ⛔ Production approval gate — non-negotiable

**Never run any operation on production without explicit per-stage approval from Jonathan.**

Blanket session approval for a task does NOT constitute production approval.
Approval to run something on staging does NOT constitute production approval.

The required flow for every Workflow B operation:

```
1. State the operation and risk level (🟢/🟡/🔴)
2. Run on staging
3. Verify: confirm HTTP 200, no PHP errors, feature behaves correctly
4. STOP. Report what was verified.
5. Ask: "Staging confirmed ✅ — ready to run on production. Approve?"
6. Wait for explicit "yes" / "go ahead" / "approved" in chat
7. Only then run on production
```

There are no exceptions to steps 5 and 6. "Staging verified" is never permission
to proceed to production. The user must confirm in chat every time.


## Communication style

- Lead with the answer. Then reasoning. Then caveats.
- If the user's plan has a flaw, say so before executing.
- Direct, practical, actionable. No theoretical frameworks or filler.
- Challenge assumptions when there's a gap. Don't just agree.
- When something doesn't work, check the simplest explanation first before
  escalating to "platform issue" or "support ticket."


## Security

- Never store admin credentials, DB passwords, API keys, or SSH private keys in
  files, chat history, or git. All are gitignored via `.gitignore`.
- Secrets live in `.env` (gitignored) and are loaded via direnv through `.envrc`.
- `.env.example` lists required variable names only — no values.
- For GitHub Actions deploys, secrets live in repo-level GitHub Secrets, not in code.

## Tools available

| Tool | Purpose |
|------|---------|
| Filesystem / Desktop Commander | Read/write in this folder and sibling site repos |
| GitHub (itmanager1341) | Repo access for this and site repos |
| SharePoint connector | Voice guides at `Marketing/1. Voice Guides/{AMAA\|FSI\|REIF} Library` |
| WordPress MCP (AI Engine plugin) | Per-site direct ops (content, media) once installed |
| WP Engine Hosting API | Infrastructure ops — backups, cache, domains, SSL |
| Supabase MCP (itmanager1341) | For related projects (mpdash, seed-connect, etc.) |

See `docs/architecture.md` for the full tooling/workflow map.
See `docs/sops/ssh-session-startup.md` before any SSH-heavy session.

---
