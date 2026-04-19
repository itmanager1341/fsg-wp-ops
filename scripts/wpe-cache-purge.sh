#!/usr/bin/env bash
# wpe-cache-purge.sh — Purge WP Engine server cache, optionally WP Rocket too
# Usage: ./scripts/wpe-cache-purge.sh <install_name> [--rocket]
#
# --rocket: also SSH in and run `wp rocket clean --confirm`

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL="${1:-}"
[[ -z "$INSTALL" ]] && { echo "Usage: wpe-cache-purge.sh <install_name> [--rocket]"; exit 1; }
ROCKET=false
[[ "${2:-}" == "--rocket" ]] && ROCKET=true

echo "🔄 Purging WPE server cache: $INSTALL"
"$SCRIPT_DIR/wpe-api.sh" purge "$INSTALL"

if [[ "$ROCKET" == true ]]; then
  echo "🔄 Purging WP Rocket via SSH..."
  SSH_HOST="${INSTALL}@${INSTALL}.ssh.wpengine.net"
  if ssh -o ConnectTimeout=10 "$SSH_HOST" "wp rocket clean --confirm"; then
    echo "✅ WP Rocket cache purged."
  else
    echo "⚠️  WP Rocket SSH purge failed. Purge manually in WP Admin → WP Rocket → Purge All."
  fi
fi

echo "✅ Done. CDN propagation may take 1–5 minutes."
