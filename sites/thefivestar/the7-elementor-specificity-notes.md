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

## Phase 1.4 widget bootstrap audit (2026-04-26)

Captured via Playwright `getComputedStyle` on `/kit-test/` page 5099 after
the post-bootstrap cleanup. All widgets confirmed Elementor-native (no The7
namespace).

| Widget | Title rendering | Body/desc rendering | Need scoped CSS? |
|--------|-----------------|---------------------|------------------|
| `heading` | navy `#1F365C`, Roboto, sized per scoped Custom CSS (H1 42px / H2 26px / H3 20px / H4 18px), weight 700 | n/a | ✅ Already in kit |
| `text-editor` (paragraph) | n/a | `#444444`, Roboto 14px (Text token) | ✅ Default kit binding |
| `button` | white text on navy bg | n/a | Default OK for now; per-section overrides expected |
| `image` (with explicit dims) | n/a | n/a | ✅ Renders at exact width/height when dims set in widget settings |
| `image-box` | H3 `.elementor-image-box-title`, navy `#1F365C`, Roboto **16px weight 400** (default Elementor card-title style) | `#444444` Roboto 14px | ❌ No override needed — card-title sizing is intentional and appropriate. Override per-section if a specific layout calls for larger card titles. |
| `spacer` | n/a | n/a | n/a |
| `divider` | n/a | n/a | Default OK |
| nested `container` (Inner Section) | n/a | renders as v4 Flexbox `e-con-full e-flex e-con e-child`; 2-column layout = 550px columns at 1100px content width; gap 20px; padding 10px | ❌ No override needed |

**Key finding:** `image-box` titles use `.elementor-image-box-title`, NOT
`.elementor-heading-title`. Our kit's heading scope rules don't apply to
image-box titles by design. They render at Elementor's default card-style
(16px / weight 400) — appropriate for membership/event card patterns in
Phase 1.4.

If a future section needs image-box titles styled like H3 section headings,
add this scoped rule to the kit `custom_css`:

```css
.elementor-widget-image-box .elementor-image-box-title {
  font-size: 20px;
  font-weight: 700;
}
```

For Phase 1.4 LLSS, **don't add it yet** — keep image-box at default until
a section actually needs it.

## v4 + The7 button/overlay global-binding finding (2026-04-26)

**Finding:** When an Elementor v4.0.2 widget binds a color via `__globals__`
(e.g., `"__globals__": { "background_color": "globals/colors?id=secondary" }`),
the per-page CSS that Elementor generates contains the correct
`background-color: var(--e-global-color-secondary)` declaration. The CSS
variable resolves correctly on the element (`getComputedStyle().getPropertyValue('--e-global-color-secondary')`
returns `#C9A040`). But the rendered button still shows `#666666` (Accent),
not gold.

**Root cause (verified via Playwright cssRules walk on FSI staging
2026-04-26):** Elementor's per-page CSS rule for the button reads:

```css
.elementor-5106 .elementor-element.elementor-element-hero-cta .elementor-button {
  background-color: var(--e-global-color-secondary);
  background-image: var(--e-global-color-secondary);
  ...
}
```

The `background-image: var(--color)` declaration is invalid (variable
resolves to a color, not a URL/gradient). When the browser parses this
rule, the `background-color` declaration disappears alongside the invalid
`background-image`. The browser's `cssText` of the parsed rule shows ONLY
font-weight, border-radius, padding — no background. This leaves The7's
lower-specificity `.elementor-button { background: var(--the7-btn-bg) }`
rule winning by default.

The same pattern affects `::before` overlay rules. The per-page CSS for
section overlays reads:

```css
.elementor-5106 .elementor-element.elementor-element-hero-section::before, ... {
  background-color: var(--e-global-color-fsi07ho);
  --background-overlay: '';
}
```

The browser drops `background-color` here too. The overlay element is
positioned but has no color, leaving the section transparent over its
background.

**Workaround:** Hardcode brand color hex values directly in the JSON
`settings` object instead of using `__globals__` bindings, for these
specific widgets:

- **Buttons:** `button_text_color`, `background_color`, `hover_color`,
  `button_background_hover_color` — hardcode hex strings, not globals
- **Container overlays:** `background_overlay_color` — hardcode hex string

Other widgets (Heading via Custom CSS, Text Editor `text_color`, etc.)
DO honor `__globals__` correctly because their per-page CSS doesn't have
the conflicting `background-image: var(--color)` companion declaration.

**Verified working pattern (Phase 1.4 mid-checkpoint, 2026-04-26):**

```json
{
  "widgetType": "button",
  "settings": {
    "text": "Join Legal League",
    "button_text_color": "#1F365C",
    "background_color": "#C9A040",
    "hover_color": "#1F365C",
    "button_background_hover_color": "#B8922E"
  }
}
```

```json
{
  "elType": "container",
  "settings": {
    "background_overlay_background": "classic",
    "background_overlay_color": "#1F365CD9"
  }
}
```

**Trade-off:** if brand kit colors change, button + overlay JSON across
all sections needs hex value updates. For Phase 1.4-1.11 with stable
brand colors, this is acceptable. Revisit on Hello Elementor swap — the
issue is specifically The7's `.elementor-button { background: ... }` and
the v4 `background-image: var(--color)` companion. Hello Elementor
doesn't have the The7 override; v4's invalid `background-image` would
still likely cause issues but without an aggressive theme override the
per-element `background-color` might apply.

**Future verification idea:** test if removing `background-image:
var(--color)` from per-page CSS fixes the issue (would need a custom
plugin to filter Elementor's CSS generator). Likely not worth the
maintenance overhead.

## Skipped widget: Icon Box (2026-04-26 decision)

Standard Elementor `icon-box` was NOT bootstrapped. The7 registers two
confusingly-labeled widgets in the panel under "Pro" and basic categories,
both of which turned out to be `the7_icon_box_widget` and
`the7_image_box_widget` respectively (named "Icon Box Pro" but rendered as
The7's image box). Three rounds of UI clicking didn't produce the standard
Elementor `icon-box`.

**Decision:** Skip Icon Box. Phase 1.4 LLSS "What Happens" feature grid
builds icons via **Image (icon, 64×64) + Heading + Text Editor inside a
container** instead. Same visual outcome, theme-agnostic, no widget
dependency. If Phase 4+ needs `icon-box` specifically, bootstrap then.

## Related

- `sites/thefivestar/the7-dependency-audit.md` — original theme-direction audit
- `docs/decisions.md` 2026-04-22 — portfolio standardization; theme direction deferred
- `sites/thefivestar/elementor-global-kit-spec.md` — kit spec (updated with this CSS)
