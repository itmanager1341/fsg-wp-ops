# The7 + Elementor CSS Specificity Notes

**Date observed:** 2026-04-23
**Context:** Phase 1.3 global kit verification on thefivestar.com staging
**Elementor version:** 4.0.x
**Theme:** The7 14.3.0

## Finding

The7 targets Elementor widget classes directly (e.g.,
`.elementor-heading-title`) rather than bare element selectors. Custom CSS
using plain `h1, h2, h3 { color: #1f365c; }` is overridden by The7's
higher-specificity rules even though the CSS is syntactically correct.

## Evidence

Verification page `/kit-test/` built with Heading widgets rendered H1/H2 as
body-text size and color instead of the spec values. Chrome DevTools inspect
showed:

```html
<h1 class="elementor-heading-title elementor-size-default">Test Headline</h1>
```

The tag is correct. The styling loss was from The7 overriding the color and
size via `.elementor-heading-title` selectors that out-specify our plain
`h1` rule.

## Fix

Target Elementor's widget class in Custom CSS, not the bare element:

```css
.elementor-heading-title { color: #1f365c !important; }

h1.elementor-heading-title { font-size: 42px; line-height: 1.2; font-weight: 700; }
h2.elementor-heading-title { font-size: 26px; line-height: 1.3; font-weight: 700; }
h3.elementor-heading-title { font-size: 20px; line-height: 1.35; font-weight: 700; }
h4.elementor-heading-title { font-size: 18px; line-height: 1.4; font-weight: 700; }
```

The `!important` is scoped to `.elementor-heading-title` only — it doesn't
affect non-Elementor headings elsewhere on the site during the transition.

## Implications for Phase 1-5

This isn't a one-off. The7 likely overrides Elementor widget styling across
more than just headings. Expect similar specificity fights on:

- **Body text / paragraphs** — may need `.elementor-widget-text-editor p` selectors
- **Links** — The7 brand blue almost certainly overrides Elementor link colors
- **Lists (ul, ol)** — The7 has list styling
- **Buttons** — Phase 1.4 should assume The7 button CSS needs to be beaten
- **Images** — less likely (images aren't typography), but verify

## Revised approach for Phase 1.4 onward

**During LLSS build:**

1. Build each section
2. Before saving as a template, inspect the rendered output in DevTools
3. For any element that doesn't match the visual target, add a
   `.elementor-widget-{type}` scoped rule to Custom CSS
4. Re-verify
5. Only then save the section as a template

This adds ~15 minutes per section but catches specificity issues at the
template authoring step, not at page rollout.

**For the decision log:** this is early Phase 1 evidence for the
"keep The7 vs swap to Hello Elementor" question open from the 2026-04-22
decision.

- **Keeps The7 scenario costlier** — every new Elementor widget type needs
  CSS overrides. Cost grows with template breadth (Phase 4-5 membership
  and community templates will be wider than event pages).
- **Hello Elementor scenario** — ships with near-zero opinions on
  typography, so Elementor's global kit actually takes effect without
  fighting the theme.

Revisit at Phase 4 kickoff as planned in the-dependency-audit. If CSS
overrides become a significant chunk of Phase 1-3 effort, the case for
Hello Elementor strengthens meaningfully.

## Future audits to close out this question

1. **Comprehensive specificity audit** — build a test page with every
   Elementor widget type used in our templates (Heading, Text Editor,
   Button, Image, Icon Box, Image Box). For each, note which properties
   The7 overrides and which it leaves alone. ~30 min. Saves iteration time
   across Phase 1-5.
2. **The7 Theme Options → Typography panel inspection** — see what the
   theme *thinks* it's styling. The aggressive overrides likely come from
   there. May be possible to neuter specific overrides without swapping
   themes.

## Related

- `sites/thefivestar/the7-dependency-audit.md` — original theme-direction audit
- `docs/decisions.md` 2026-04-22 — portfolio standardization; theme direction deferred
- `sites/thefivestar/elementor-global-kit-spec.md` — kit spec (updated with this CSS)
