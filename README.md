# fsg-wp-ops

Operations hub for the FSG Media WordPress portfolio: brand guides, SOPs,
site metadata, audit history, and helper scripts.

**Scope:** amaaonline.com (AMAA), thefivestar.com (FSI), themortgagepoint.com (MortgagePoint).
Plus scaffolded brand guides for REIF (pre-launch, not WordPress).

**Site code is not here** — see sibling repos:
- `../thefivestar-wp/` (live reference)
- `../amaaonline-wp/`, `../themortgagepoint-wp/` (not yet scaffolded)

## Quick start

1. `cd` into this folder — direnv loads `.env` via `.envrc`.
2. If you don't have a `.env`, copy `.env.example` and fill in WP Engine API creds.
3. Open in Cursor or start Claude Code — it auto-loads `CLAUDE.md` for context.
4. Scripts live in `scripts/`. Run them from the repo root.

## Folder map

```
docs/              Portfolio docs, SOPs, cheatsheets
brands/            Brand guides per brand (amaa, fsi, mortgagepoint, reif)
sites/             Per-site metadata, plugin inventory, baselines, audit results
scripts/           WP Engine API + WP-CLI helper scripts
audits/            Dated outputs from portfolio-wide audit runs
```

## Related docs

- `CLAUDE.md` — system instructions for AI assistants working in this repo
- `docs/architecture.md` — full tooling + workflow map
- `docs/wpengine-gotchas.md` — WPE-specific rules and known issues
