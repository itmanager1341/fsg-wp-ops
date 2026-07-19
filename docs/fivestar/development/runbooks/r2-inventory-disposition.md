# Runbook: R2 — WPBakery Inventory + Disposition

Phase R2 of `../rebuild-plan.md`. **Analysis-only** on the clone (`thefivestardev`). Produces the
page disposition = the scope contract for the R4 rebuild. Executed 2026-07-11.

## Method

SQL over the clone (WPE gateway needs stdin SQL, not quoted `wp eval`):
- WPBakery flag = `post_content LIKE '%[vc_row%'`; Elementor flag = has `_elementor_data` meta.
- Nav membership = pages referenced by `nav_menu_item` postmeta.
- Front page = `page_on_front` (**363**, still WPBakery — homepage must migrate).
- Cross-referenced against the R0 Semrush must-preserve set (`seo-baseline.md`).
- **Rule order matters:** a page with `[vc_row` markup MUST migrate even if it also has stray
  `_elementor_data` (else it breaks under Hello Elementor). Check WPBakery before Elementor.

Output: `audits/2026-07-11-wpbakery-disposition.csv` (74 pages).

## Result

| Disposition | Count | Meaning |
|-------------|-------|---------|
| MIGRATE | 10 | WPBakery pages with nav/traffic/legal → rebuild native in Elementor (R4) |
| LEAVE | 16 | Already Elementor → re-author to native widgets (R4) |
| TRASH | 39 | Dead landers / old event-asset pages / superseded duplicates |
| VERIFY | 8 | Ambiguous — owner decision required (see below) |

### MIGRATE (10) — the R4 rebuild worklist
363 Home (front page), 3146 Five Star Conference, 2784 Careers, 13 Contact, 4081 Five Star
Academy, 2683 Conferences, 2660 Media, 2725 Virtual Events, 9 Resources, 3283 Privacy.

### VERIFY (8) — pending owner input
| ID | Page | Question | Claude's rec |
|----|------|----------|--------------|
| 5380 | Join Five Star Access (WPB, recent) | active signup flow? | migrate if used |
| 5386 | Join Five Star Alliance (WPB, recent) | active signup flow? | migrate if used |
| 2542 | News (WPB) | still linked / has content? | trash unless used |
| 2916 | AM&AA Directory (WPB) | AMAA is a different brand — belongs here? | trash from FSI |
| 2937 | Confirmation (WPB) | form thank-you page? | keep if a form targets it |
| 5115 | Real Estate Professionals (ELE) | duplicate of 5135 (nav)? | trash dup, keep 5135 |
| 5086 | Who We Are (plain, recent) | used anywhere? | migrate or trash |
| 4436 | Velocity (ELE) | duplicate of 5110 (nav)? | trash dup, keep 5110 |

## Remaining R2 sub-step — redirect consolidation

Not yet done. Pick ONE redirect manager (recommend `eps-301-redirects`, already active), then:
- Verify the 2 AIOSEO-table redirects still fire (their plugin is inactive) and migrate live rules in.
- Add `/mediakit/(.*)` → `/` (subsite retired in R1b).
- Add Tier 3 LMS 301s (`/blog/course|seminar|certification/*`) per `url-preservation-plan.md`.
- TRASH pages: 301 to nearest live equivalent, or intentional 404 for IA-change URLs (Lesson #35).

## Gate R2
- [ ] Every live page classified (done — disposition CSV)
- [ ] VERIFY items resolved by owner
- [ ] Trash list approved
- [ ] Redirect consolidation complete
