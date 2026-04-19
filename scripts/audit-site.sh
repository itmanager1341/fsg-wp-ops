#!/usr/bin/env bash
# audit-site.sh — Snapshot audit of a WPE install via SSH + WP-CLI
# Usage: ./scripts/audit-site.sh <install_name> [output_dir]
# Output: dated markdown file in output_dir (default: sites/<install>/audits/)

set -euo pipefail

INSTALL="${1:-}"
[[ -z "$INSTALL" ]] && { echo "Usage: audit-site.sh <install_name> [output_dir]"; exit 1; }

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_DIR="${2:-$REPO_ROOT/sites/$INSTALL/audits}"
DATE=$(date +%Y-%m-%d)
TIME=$(date '+%Y-%m-%d %H:%M CST')
OUTPUT="$OUTPUT_DIR/${DATE}-audit-${INSTALL}.md"
SSH_HOST="${INSTALL}@${INSTALL}.ssh.wpengine.net"

mkdir -p "$OUTPUT_DIR"
echo "🔍 Auditing $INSTALL via $SSH_HOST"

wp_cmd() { ssh -o ConnectTimeout=15 -o BatchMode=yes "$SSH_HOST" "wp $*" 2>/dev/null || echo "(unavailable)"; }

WP_VER=$(wp_cmd "core version")
PLUGINS=$(wp_cmd "plugin list --fields=name,status,version,update --format=csv")
UPDATES=$(wp_cmd "plugin list --update=available --fields=name,version,update_version --format=csv")
THEME=$(wp_cmd "theme list --status=active --fields=name,version --format=csv")
ADMINS=$(wp_cmd "user list --role=administrator --fields=user_login,user_email --format=csv")
POSTS=$(wp_cmd "post list --post_type=post --post_status=publish --format=count")
PAGES=$(wp_cmd "post list --post_type=page --post_status=publish --format=count")

cat > "$OUTPUT" <<REPORT
# Site Audit: ${INSTALL}

Generated: ${TIME}

## Summary

| Field | Value |
|-------|-------|
| WordPress | ${WP_VER} |
| Published posts | ${POSTS} |
| Published pages | ${PAGES} |

## Active theme

\`\`\`
${THEME}
\`\`\`

## Admin users

\`\`\`
${ADMINS}
\`\`\`

## Plugin updates available

\`\`\`
${UPDATES}
\`\`\`

## All plugins

\`\`\`
${PLUGINS}
\`\`\`

## Manual checks

- [ ] PHP error log: WPE portal → ${INSTALL} → Logs → PHP Errors
- [ ] PageSpeed: https://pagespeed.web.dev/?url=https://${INSTALL}.com
- [ ] Google Search Console: crawl errors, Core Web Vitals
- [ ] WP Rocket cache warming
- [ ] HubSpot form submissions reaching CRM
- [ ] Advanced Ads fill rate (if applicable)
REPORT

echo "✅ Audit written: $OUTPUT"
