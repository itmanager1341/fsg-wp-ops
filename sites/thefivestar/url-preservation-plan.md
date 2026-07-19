# URL Preservation & Redirect Plan: thefivestar.com rebuild

Site: thefivestar.com
Created: 2026-06-17
Status: **Planning** — feeds the clone-and-cutover rebuild and the The7 → Hello
Elementor theme migration. Not yet approved for execution.

## Purpose

The rebuild must not lose search rankings or create 404s at cutover. This plan defines
which URLs are preserved, which are retired (with redirects), and which media assets
come across. It is the SEO gate for the cutover.

## Sources of truth

| Input | File |
|-------|------|
| Organic traffic baseline (what actually ranks) | `sites/thefivestar/seo-baseline.md` |
| Full live URL inventory (277 URLs, 15 sitemaps) | `audits/2026-06-16-url-inventory.csv` |
| Semrush keyword → URL map | `audits/2026-06-16-semrush-keywords.csv` |
| Semrush pages by traffic share | `audits/2026-06-16-semrush-pages.csv` |
| Refresh tooling | `scripts/semrush-export.sh`, `scripts/gsc-export.sh` |

## Redirect tooling (verified on prod 2026-07-11, R0)

The redirect landscape is messier than assumed — audited state:

- `eps-301-redirects` — **active**, but its rules option (`eps_redirects_redirects`) is **empty `[]`**.
- `aioseo-redirects` — **INACTIVE plugin**, yet its table holds **2 enabled 301s**
  (`/memberships/real-estate-professionals/` → `/communities/real-estate-professionals/`;
  `/conferences/` → `/events/`). Because the plugin is off, **whether these actually fire is
  unverified** — test on the clone (R1).
- `wp_…_redirects` (plain table) — **2 active rules, being hit**: `network-groups` → post 2597
  (301, 5,489 hits) and `reif` → fivestarconference.com/2025/REIF (**302 temp**, 498 hits).

Full dump: `audits/2026-07-11-redirects.csv`.

**Action (R2):** pick ONE active redirect manager, verify which of the 4 existing rules truly
fire (curl on the clone), migrate all live redirects into it, and put the Tier 3 LMS redirects
there too. `eps-301-redirects` is the sensible target (already active) — but confirm the 2
AIOSEO-table redirects still fire first, or they'll be silently lost at cutover. All new rules
are **301 (permanent)** except the intentionally-temporary `reif` 302.

---

## Tier 1 — Must-preserve URLs (carry identical slugs)

These drive ~100% of organic traffic. Slugs must be **byte-for-byte identical** after
cutover; any change requires a 301 from old → new. Verify each ranks the same post-cutover.

| URL | Traffic share | Top keyword (pos) |
|-----|---------------|-------------------|
| `/` | 80.69% | the five star (1) |
| `/five-star-conference/` | 6.30% | five star conferencing (2) |
| `/careers/` | 3.92% | five star careers (4) |
| `/contact/` | 1.67% | five star institute dallas tx (5) |
| `/five-star-academy/` | 0.96% | five star training (7) |
| `/events/` | 0.85% | five star conference (4) |
| `/conferences/` | 0.65% | fivestar conference (3) |
| `/events/velocity/` | 0.53% | velocity conference (7) |
| `/certifications/` | 0.53% | five star certified (2) |
| `/media/` | 0.32% | ds news (5) |
| `/courses/` | 0.10% | five star institute dallas tx (2) |
| `/education/` | 0.00% | (long-tail spread) |

## Tier 2 — Preserve all other active pages & posts

The remaining real `page` (67) and `post` (107) URLs in the inventory carry little/no
organic traffic but may hold inbound links. **Default = preserve the slug.** If a page is
intentionally dropped in the rebuild, add a 301 to the closest live equivalent — never let
it 404. Reconcile the rebuilt sitemap against `audits/2026-06-16-url-inventory.csv` before
cutover; every Tier 1/Tier 2 URL must resolve 200 or 301, none 404.

## Tier 3 — Retire + 301 (Academy LMS post types)

Per decision 2026-06-16, the ~75 Academy LMS URLs are **not** rebuilt (static image pages,
~zero traffic, being set inactive + media deleted). Redirect their URL bases so they 301
instead of 404. Confirm exact taxonomy bases via WP-CLI before adding rules.

| Old URL pattern | 301 target |
|-----------------|-----------|
| `/blog/course/*` | `/courses/` |
| `/blog/seminar/*` | `/events/` |
| `/blog/certification/*` | `/certifications/` |
| `/blog/topic/*`, `/blog/profession/*`, `/blog/access/*` (taxonomies) | `/five-star-academy/` |

Low SEO stakes, but avoids dead links and crawl errors. `jobs.thefivestar.com` (Talent
Hub) is a separate app — out of scope, no redirects from this site.

---

## Asset migration rule

**Only migrate media assets that are referenced by an active (preserved) page or post.
Do NOT carry over assets used solely by the retired LMS pages.**

A clone-and-cutover copies the entire `wp-content/uploads` library by default — that would
drag the LMS images along. Prune them. Determination procedure (run before deleting):

1. Build the set of LMS-only attachments — featured images + inline images referenced by
   the Tier 3 CPTs (e.g. `/wp-content/uploads/2024/06/Default-Servicer-Certification-Level-1.jpg`).
2. For each candidate, confirm **no active page/post references it** before deleting —
   scan `post_content` and postmeta of kept content for the attachment URL/ID:

   ```bash
   ssh thefivestar wp eval '
   $att = "Default-Servicer-Certification-Level-1";   // filename stem to test
   $hits = get_posts([
       "post_type"   => ["page","post"],
       "post_status" => "publish",
       "numberposts" => -1,
       "fields"      => "ids",
       "s"           => $att,
   ]);
   echo $hits ? "REFERENCED by active content: ".implode(",", $hits)."\n"
              : "safe to delete (no active references)\n";
   '
   ```

3. Only assets that come back "safe to delete" (LMS-only) are excluded/removed.
4. Deleting media is **destructive** — back up `uploads` (or take a WPE backup) first, and
   get explicit approval before any production deletion.

Net: the rebuilt media library contains only assets tied to live pages — no LMS orphans.

---

## Cutover verification (SEO gate)

Run after staging build, before production cutover, and again after:

- [ ] Crawl the rebuilt site; every URL in `audits/2026-06-16-url-inventory.csv` returns
      200 or 301 — zero 404s on Tier 1/Tier 2.
- [ ] Spot-check each Tier 1 URL loads with correct title/H1 and content parity.
- [ ] Tier 3 patterns 301 to their targets (test one URL per pattern).
- [ ] AIOSEO sitemap regenerates and excludes retired LMS CPTs.
- [ ] Re-run `scripts/semrush-export.sh` (overview + keywords + pages); diff new
      `*-semrush-pages.csv` against `seo-baseline.md` — any Tier 1 URL dropping out of the
      keyword set, or a material fall in top-keyword position, is a regression to fix.
- [ ] Submit updated sitemap in the new `sc-domain:thefivestar.com` GSC property; watch
      Coverage for new 404/redirect errors for 2 weeks.

## Integration points

- **Rebuild model = clone-and-cutover** (decisions 14032 / 14045, 2026-06-16): production is
  cloned to `thefivestardev` via WPE Copy Environment, so all URLs, redirects, media, post/
  attachment IDs, and AIOSEO config are **inherited** — this plan governs what we *preserve,
  retire, and prune* on top of that clone, not a from-scratch URL rebuild. **No in-place The7
  theme swap on production** — The7 is removed inside the sandbox before promote-back.
- **New design direction:** kept page layouts are re-authored as **native Elementor widgets
  styled via Global Kit `__globals__`** (decision 14036), not the old HTML-embed JSON. Slugs/
  URLs are preserved from the clone independent of the new layout — changing a page's design
  does not change its URL.
- Tier 3 redirects go in **before** the LMS pages are set inactive, so there is no 404 window.
- Decision records: `docs/decisions.md` 2026-06-16 (Academy LMS exclusion); full R0–R7 rebuild
  plan: `docs/fivestar/development/rebuild-plan.md`.
