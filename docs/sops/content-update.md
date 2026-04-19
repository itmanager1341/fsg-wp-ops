# SOP: Content Updates

Applies to: editorial changes on thefivestar.com via WP Admin.
No git involved for standard content. Git is for code only.

---

## Who can do what

| Change type | Who | Approval needed |
|-------------|-----|-----------------|
| Blog post, news article | Editor | No |
| Event / course detail update | Editor | No |
| Homepage hero or CTA | Editor | Jonathan sign-off |
| Navigation / Mega Menu change | Admin | Jonathan sign-off |
| New page (structural) | Admin | Jonathan sign-off |
| Plugin-driven content (ads, forms) | Admin | No |

---

## Page builder: WPBakery

All page layouts on thefivestar.com use WPBakery Page Builder.
- Edit via WP Admin → Pages/Posts → Backend Editor
- Do NOT switch a WPBakery page to the Gutenberg block editor — it will
  render raw shortcode text on the frontend.
- Classic Editor plugin must remain active.

---

## Standard article flow

1. Draft in WP Admin → Posts → Add New (Classic Editor / WPBakery)
2. Fill in AIOSEO fields: Focus Keyphrase, Meta Title, Meta Description
3. Set Featured Image (1200×630 px minimum)
4. Preview before publish
5. Publish — WP Rocket auto-purges the post URL and category archives
6. Share URL to distribution channels

---

## Cache after content changes

WP Rocket handles automatic purges on publish for standard posts.
For homepage, landing pages, or nav changes — manual purge required:

```bash
# Via WP Admin toolbar: WP Rocket → Purge All Cache
# Or via CLI:
ssh thefivestar@thefivestar.ssh.wpengine.net
wp rocket clean --confirm
```

Then purge WPE server cache: portal → Caching → Clear All
(or `scripts/wpe-cache-purge.sh thefivestar`)

---

## HubSpot forms

Forms are managed in HubSpot portal and embedded via the HubSpot plugin.
To add or change a form:
1. Create/edit the form in HubSpot
2. In WP: use the HubSpot block or shortcode to embed
3. Test on staging (`thefivestarstg`) before production

---

## Image standards

| Context | Size | Format | Max file size |
|---------|------|--------|---------------|
| Featured image | 1200×630 | JPG | 200 KB |
| Hero / slider | 1920×800 | JPG | 400 KB |
| Inline article | 800×450 | JPG | 150 KB |
| Team / headshot | 400×400 | JPG | 80 KB |
| Logo / icon | — | SVG or PNG | 50 KB |
