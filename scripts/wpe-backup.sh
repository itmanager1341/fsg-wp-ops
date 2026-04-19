#!/usr/bin/env bash
# wpe-backup.sh — Trigger a WPE backup and poll until confirmed complete
# Usage: ./scripts/wpe-backup.sh <install_name> [description]
# Exit 0 = backup confirmed. Exit 1 = failed or timed out.
# Gate risky operations on this script's exit code.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL="${1:-}"
DESC="${2:-Pre-operation backup $(date '+%Y-%m-%d %H:%M CST')}"
MAX_WAIT=300
POLL=15

[[ -z "$INSTALL" ]] && { echo "Usage: wpe-backup.sh <install_name> [description]"; exit 1; }

echo "🔒 Triggering backup: $INSTALL"
echo "   Description: $DESC"

RESPONSE=$("$SCRIPT_DIR/wpe-api.sh" backup "$INSTALL" "$DESC")
BACKUP_ID=$(echo "$RESPONSE" | jq -r '.id // empty')

[[ -z "$BACKUP_ID" ]] && { echo "❌ Could not get backup ID from API."; echo "$RESPONSE"; exit 1; }
echo "   Backup ID: $BACKUP_ID"

ELAPSED=0
while [[ $ELAPSED -lt $MAX_WAIT ]]; do
  sleep "$POLL"
  ELAPSED=$((ELAPSED + POLL))
  STATUS=$("$SCRIPT_DIR/wpe-api.sh" backups "$INSTALL" \
    | jq -r --arg id "$BACKUP_ID" '.[] | select(.id==$id) | .status // "pending"' 2>/dev/null \
    || echo "pending")
  echo "   [${ELAPSED}s] $STATUS"
  [[ "$STATUS" == "complete" || "$STATUS" == "completed" ]] && { echo "✅ Backup complete."; exit 0; }
  [[ "$STATUS" == "error" || "$STATUS" == "failed" ]] && { echo "❌ Backup failed."; exit 1; }
done

echo "⏱️  Timeout after ${MAX_WAIT}s. Check WPE portal before proceeding."
exit 1
