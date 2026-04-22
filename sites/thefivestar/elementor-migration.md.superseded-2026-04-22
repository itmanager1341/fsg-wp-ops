# Elementor → WPBakery Migration Tracker: thefivestar.com

Audited: 2026-04-19 via WP-CLI on production
Decision: WPBakery is the sole forward-going builder. See `docs/decisions.md`.

**Migration status:** 🔴 Not started

---

## Summary

| Category | Count |
|---|---|
| Published (live) | 14 |
| Draft | 3 |
| Private | 1 |
| **Total Elementor pages** | **18** |

All drafts and the private page can be trashed without review.
Focus is on the 14 published pages below.

---

## Draft pages — trash without review

| ID | Title | Action |
|----|-------|--------|
| 4973 | Elementor #4973 | Trash |
| 4834 | Elementor Page #4834 | Trash |
| 4828 | Elementor #4828 | Trash |

## Private pages — trash without review

| ID | Title | Action |
|----|-------|--------|
| 4909 | Home (private) | Trash |

---

## Published pages — requires review before action

Legend: 🔴 Rebuild needed | 🟡 Review first | ✅ Trash / already inactive | ⬜ Not yet reviewed

| ID | Title | Status | Decision | Notes |
|----|-------|--------|----------|-------|
| 5051 | Member Benefits | publish | ⬜ | Core program page — likely needs rebuild |
| 4993 | Five Star Access | publish | ⬜ | Review traffic/relevance |
| 4970 | Real Estate Investment Forum Deal Room | publish | ⬜ | REIF-related — may be outdated |
| 4965 | Real Estate Investment Forum Deal Room | publish | ⬜ | Duplicate of 4970? Check |
| 4912 | FSC2025 Assets | publish | ⬜ | Event assets — likely low-traffic after event |
| 4860 | Velocity- Stay Informed: Sign Up for Exclusive Updates and Offers | publish | ⬜ | Lander — review if active campaign |
| 4829 | FSC&Me 2024 | publish | ⬜ | 2024 event — likely dead |
| 4757 | FSC2024 Asset | publish | ⬜ | 2024 event assets — likely dead |
| 4560 | Education | publish | ⬜ | Core section page — likely needs rebuild |
| 4558 | Seminars | publish | ⬜ | Core section page — likely needs rebuild |
| 4556 | Courses | publish | ⬜ | Core section page — likely needs rebuild |
| 4550 | Certifications | publish | ⬜ | Core section page — likely needs rebuild |
| 4436 | Velocity | publish | ⬜ | Review — possible duplicate/variant |
| 4407 | Realtor Lead Gen - Key Concepts | publish | ⬜ | Lander — review if active |
| 3471 | contact update | publish | ⬜ | Likely outdated utility page |

---

## Migration process (when ready)

1. **Review phase** — go through the 14 published pages above, mark each as Trash or Rebuild
2. **Trash dead pages** — deactivate/trash confirmed-dead pages on production (no staging needed for trash)
3. **Rebuild** — for each Rebuild page: build WPBakery version on staging → verify → promote to production → trash Elementor original
4. **Verify zero Elementor pages** — run: `wp post list --post_type=any --meta_key=_elementor_edit_mode --meta_value=builder --format=table`
5. **Deactivate** — deactivate `elementor` and `elementor-pro` on staging → verify → production
6. **Delete** — delete both plugins from production

Risk level for deactivation step: 🟡 Moderate (staging first required)
Risk level for deletion step: 🔴 High (backup required)

---

## Notes

- My original WP-CLI audit (`wp post list --meta_key=_elementor_edit_mode --meta_value=builder`) returned empty
  because it defaulted to `post_type=post`. All Elementor content is on `post_type=page`.
  Correct query requires `--post_type=any`.
- Elementor CSS is loading on every page sitewide while both plugins remain active —
  this is a performance cost even on WPBakery-built pages.
- The7 theme is set to WPBakery mode. Elementor Theme Style is NOT enabled (confirmed in Theme Settings).
