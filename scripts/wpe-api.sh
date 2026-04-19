#!/usr/bin/env bash
# wpe-api.sh — WP Engine API v1 wrapper
# Usage: ./scripts/wpe-api.sh <command> [args]
# Requires: WPE_CREDS in env (base64 of "user_id:password")
#           or WPE_USER_ID + WPE_PASSWORD

set -euo pipefail

API="https://api.wpengineapi.com/v1"

# ── Auth ──────────────────────────────────────────────────────
if [[ -z "${WPE_CREDS:-}" ]]; then
  if [[ -n "${WPE_USER_ID:-}" && -n "${WPE_PASSWORD:-}" ]]; then
    WPE_CREDS=$(echo -n "$WPE_USER_ID:$WPE_PASSWORD" | base64)
  else
    echo "ERROR: Set WPE_CREDS or WPE_USER_ID + WPE_PASSWORD" >&2
    exit 1
  fi
fi
AUTH="Authorization: Basic $WPE_CREDS"

# ── Helpers ───────────────────────────────────────────────────
get()  { curl -sf -H "$AUTH" "$API/$1"; }
post() { curl -sf -X POST -H "$AUTH" -H "Content-Type: application/json" \
           -d "${2:-{\}}" "$API/$1"; }

install_id() {
  get "installs" | jq -r ".results[] | select(.name==\"$1\") | .id"
}

# ── Commands ──────────────────────────────────────────────────
CMD="${1:-help}"
shift || true

case "$CMD" in
  installs)
    get "installs" \
      | jq '.results[] | {name:.name, id:.id, status:.status, php:.php_version}'
    ;;

  install)
    [[ -z "${1:-}" ]] && { echo "Usage: wpe-api.sh install <name>"; exit 1; }
    ID=$(install_id "$1")
    [[ -z "$ID" ]] && { echo "Not found: $1"; exit 1; }
    get "installs/$ID" | jq .
    ;;

  purge)
    [[ -z "${1:-}" ]] && { echo "Usage: wpe-api.sh purge <install_name>"; exit 1; }
    ID=$(install_id "$1")
    [[ -z "$ID" ]] && { echo "Not found: $1"; exit 1; }
    echo "Purging cache: $1"
    post "installs/$ID/purge_cache" | jq .
    echo "✅ Cache purge triggered."
    ;;

  backup)
    [[ -z "${1:-}" ]] && { echo "Usage: wpe-api.sh backup <install_name> [desc]"; exit 1; }
    ID=$(install_id "$1")
    [[ -z "$ID" ]] && { echo "Not found: $1"; exit 1; }
    DESC="${2:-Manual backup $(date +%Y-%m-%d)}"
    echo "Triggering backup: $1"
    post "installs/$ID/backups" "{\"description\":\"$DESC\"}" | jq .
    ;;

  backups)
    [[ -z "${1:-}" ]] && { echo "Usage: wpe-api.sh backups <install_name>"; exit 1; }
    ID=$(install_id "$1")
    [[ -z "$ID" ]] && { echo "Not found: $1"; exit 1; }
    get "installs/$ID/backups" \
      | jq '.results[] | {id:.id, status:.status, created_at:.created_at, description:.description}'
    ;;

  domains)
    [[ -z "${1:-}" ]] && { echo "Usage: wpe-api.sh domains <install_name>"; exit 1; }
    ID=$(install_id "$1")
    [[ -z "$ID" ]] && { echo "Not found: $1"; exit 1; }
    get "installs/$ID/domains" | jq '.results[] | {name:.name, primary:.primary}'
    ;;

  help|*)
    cat <<HELP
WP Engine API Wrapper — FSG Media

Commands:
  installs                     List all installs
  install <name>               Details for one install
  purge   <name>               Purge cache
  backup  <name> [desc]        Trigger backup
  backups <name>               List backups
  domains <name>               List domains

FSG install names: thefivestar, thefivestarstg, thefivestardev,
  mortgagepoint, mortgageptstg, mpdev0, amaaonline, ppeforum, tfsiforce

Env: WPE_CREDS=base64(user_id:password)  — or WPE_USER_ID + WPE_PASSWORD
HELP
    ;;
esac
