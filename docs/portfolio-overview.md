# FSG Media WordPress Portfolio Overview

Last updated: 2026-04-18

## Site inventory

| Brand | Site | WPE Install | PHP | Storage | Est. daily visits | Status |
|-------|------|-------------|-----|---------|-------------------|--------|
| FSI | thefivestar.com | `thefivestar` | 8.2 | 1.78 GB | ~171 | ✅ Active |
| MortgagePoint | themortgagepoint.com | `mortgagepoint` | 8.2 | 8.48 GB | ~4,300 | ✅ Active |
| AMAA | amaaonline.com | `amaaonline` | 8.2 | 3.64 GB | ~674 | ✅ Active |
| — | propertypresforum.com | `ppeforum` | 8.2 | 494 MB | ~16 | ✅ Active |
| — | fivestarforce.com | `tfsiforce` | **7.4 ⚠️** | 1.91 GB | ~74 | EOL PHP |
| — | thereport.wpenginepowered.com | `thereport` | 8.2 | 90 MB | — | Active |

All installs: WordPress 6.9.4.

## Environment map

| Install | Type | URL | PHP |
|---------|------|-----|-----|
| `thefivestar` | Production | https://thefivestar.com | 8.2 |
| `thefivestarstg` | Staging | https://thefivestarstg.wpenginepowered.com | 8.4 |
| `thefivestardev` | Dev | https://thefivestardev.wpenginepowered.com | 8.4 |
| `mortgagepoint` | Production | https://themortgagepoint.com | 8.2 |
| `mortgageptstg` | Staging | https://mortgageptstg.wpenginepowered.com | 8.2 |
| `mpdev0` | Dev | https://mpdev0.wpenginepowered.com | 8.2 |
| `amaaonline` | Production | https://amaaonline.com | 8.2 |
| `amaastag` | Staging | https://amaastag.wpenginepowered.com | 8.2 |
| `amaadev` | Dev | https://amaadev.wpenginepowered.com | 8.2 |
| `mpappdev` | Dev/sandbox | https://mpappdev.wpenginepowered.com | 8.2 |
| `memberpres2dev` | Sandbox | https://memberpres2dev.wpenginepowered.com | 8.2 |
| `ppeforum` | Production | https://propertypresforum.com | 8.2 |
| `ppeforumdev` | Dev | https://ppeforumdev.wpenginepowered.com | 8.2 |
| `thereport` | Production | https://thereport.wpenginepowered.com | 8.2 |
| `marketrepstg` | Staging | https://marketrepstg.wpenginepowered.com | 8.2 |
| `tfsiforce` | Production | https://fivestarforce.com | **7.4 ⚠️** |
| `tfsiforcedev` | Dev | https://tfsiforcedev.wpenginepowered.com | **7.4 ⚠️** |


## Open issues (as of 2026-04-18)

| Priority | Install | Issue |
|----------|---------|-------|
| 🔴 High | `tfsiforce` | PHP 7.4 — EOL Dec 2022. No plugin or WP updates until resolved. |
| 🟡 Med | `thefivestar` | WP Rocket v2.6.1 is outdated. Update on staging first. |
| 🟡 Med | `thefivestar` | Ultimate Addons for WPBakery flagged for update in WP admin. |
| 🟡 Med | `thefivestar` | Yoast SEO active alongside AIOSEO Pro — redundant, creates duplicate meta. |
| 🟡 Med | `thefivestar` | Blocksy Companion Premium installed but deactivated — wrong theme companion. |
| 🟡 Med | `thefivestar` | Elementor Pro deactivated — decide: keep or remove. |
| 🟡 Med | `thefivestar` | Slider Revolution license may need renewal for v6.7.3+ features. |
| 🟢 Low | `thefivestar` | Several AIOSEO add-ons deactivated — audit which are actually needed. |

## Reference implementation

`thefivestar-wp` is the reference implementation for the GitHub → WP Engine
deployment pipeline. AMAA and MortgagePoint repos will be scaffolded after the
FSI pattern is proven.

## Repo status

| Site repo | Status |
|-----------|--------|
| `thefivestar-wp` | In progress — primary build |
| `amaaonline-wp` | Not yet scaffolded |
| `themortgagepoint-wp` | Not yet scaffolded |
