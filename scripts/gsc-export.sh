#!/usr/bin/env bash
# gsc-export.sh — Read-only Google Search Console export (service account)
# Usage: ./scripts/gsc-export.sh <command> [args]
#
# Commands:
#   pages   [property] [days]   Per-URL performance → CSV (the migration baseline)
#   queries [property] [days]   Per-query performance → CSV
#   sites                       List properties the service account can read
#
# Auth (read-only, scope: webmasters.readonly):
#   GSC_SA_KEY_FILE  Path to the Google service-account JSON key (gitignored).
#   GSC_PROPERTY     Default property, e.g. "https://thefivestar.com/"
#                    or "sc-domain:thefivestar.com". Overridable per-call.
#
# Setup once: in Search Console → Settings → Users and permissions, add the
# service account's client_email as a user (Restricted is enough — read-only).
#
# Output: sites/thefivestar/audits/<date>-gsc-<dimension>.csv

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KEY_FILE="${GSC_SA_KEY_FILE:-}"
TOKEN_URI="https://oauth2.googleapis.com/token"
API="https://searchconsole.googleapis.com/webmasters/v3"
SCOPE="https://www.googleapis.com/auth/webmasters.readonly"

command -v jq      >/dev/null || { echo "ERROR: jq not installed" >&2; exit 1; }
command -v openssl >/dev/null || { echo "ERROR: openssl not installed" >&2; exit 1; }

[[ -z "$KEY_FILE" ]]      && { echo "ERROR: set GSC_SA_KEY_FILE to the service-account JSON path" >&2; exit 1; }
[[ ! -f "$KEY_FILE" ]]    && { echo "ERROR: key file not found: $KEY_FILE" >&2; exit 1; }

# ── base64url (no padding) ────────────────────────────────────
b64url() { openssl base64 -e -A | tr '+/' '-_' | tr -d '='; }

# ── Mint an access token from the service account (RS256 JWT → OAuth) ──
access_token() {
  local sa_email pkey now exp header claim unsigned sig jwt resp
  sa_email=$(jq -r '.client_email' "$KEY_FILE")
  pkey=$(jq -r '.private_key' "$KEY_FILE")
  now=$(date +%s); exp=$((now + 3600))

  header='{"alg":"RS256","typ":"JWT"}'
  claim=$(jq -nc --arg iss "$sa_email" --arg scope "$SCOPE" \
                 --arg aud "$TOKEN_URI" --argjson iat "$now" --argjson exp "$exp" \
                 '{iss:$iss,scope:$scope,aud:$aud,iat:$iat,exp:$exp}')

  unsigned="$(printf '%s' "$header" | b64url).$(printf '%s' "$claim" | b64url)"
  sig=$(printf '%s' "$unsigned" | openssl dgst -sha256 -sign <(printf '%s' "$pkey") -binary | b64url)
  jwt="$unsigned.$sig"

  resp=$(curl -sf -X POST "$TOKEN_URI" \
    --data-urlencode 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer' \
    --data-urlencode "assertion=$jwt") || { echo "ERROR: token request failed" >&2; exit 1; }
  jq -r '.access_token // empty' <<<"$resp"
}

# ── searchAnalytics.query for one dimension ───────────────────
query() {
  local token="$1" property="$2" dimension="$3" start="$4" end="$5" enc body
  enc=$(jq -rn --arg x "$property" '$x|@uri')
  body=$(jq -nc --arg s "$start" --arg e "$end" --arg d "$dimension" \
            '{startDate:$s,endDate:$e,dimensions:[$d],rowLimit:25000,dataState:"all"}')
  curl -sf -X POST "$API/sites/$enc/searchAnalytics/query" \
    -H "Authorization: Bearer $token" -H "Content-Type: application/json" \
    -d "$body"
}

# ── date helpers (macOS / darwin) ─────────────────────────────
# GSC data lags ~2-3 days; end at today-3 to avoid partial days.
days_ago() { date -v-"$1"d +%Y-%m-%d 2>/dev/null || date -d "-$1 days" +%Y-%m-%d; }

run_export() {
  local dimension="$1" property="$2" days="$3"
  local start end out token resp count
  end=$(days_ago 3)
  start=$(days_ago $((days + 3)))
  out="$REPO_ROOT/sites/thefivestar/audits/$(date +%Y-%m-%d)-gsc-${dimension}.csv"

  echo "🔍 GSC export — $dimension for $property"
  echo "   range: $start → $end ($days days)"
  token=$(access_token)
  [[ -z "$token" ]] && { echo "ERROR: empty access token (is the SA added to the property?)" >&2; exit 1; }

  resp=$(query "$token" "$property" "$dimension" "$start" "$end") \
    || { echo "ERROR: API query failed (check property string & SA permission)" >&2; exit 1; }

  count=$(jq '.rows | length // 0' <<<"$resp")
  {
    echo "${dimension},clicks,impressions,ctr,position"
    jq -r '.rows[]? | [.keys[0], .clicks, .impressions, (.ctr*100|.*100|round/100), (.position|.*100|round/100)] | @csv' <<<"$resp"
  } > "$out"

  echo "✅ ${count} rows → ${out#$REPO_ROOT/}"
  [[ "$count" == "25000" ]] && echo "⚠️  Hit the 25,000-row cap — results may be truncated."
}

# ── Commands ──────────────────────────────────────────────────
CMD="${1:-help}"; shift || true

case "$CMD" in
  pages)
    PROP="${1:-${GSC_PROPERTY:-}}"; DAYS="${2:-90}"
    [[ -z "$PROP" ]] && { echo "Usage: gsc-export.sh pages [property] [days]"; exit 1; }
    run_export page "$PROP" "$DAYS"
    ;;
  queries)
    PROP="${1:-${GSC_PROPERTY:-}}"; DAYS="${2:-90}"
    [[ -z "$PROP" ]] && { echo "Usage: gsc-export.sh queries [property] [days]"; exit 1; }
    run_export query "$PROP" "$DAYS"
    ;;
  sites)
    TOKEN=$(access_token)
    curl -sf "$API/sites" -H "Authorization: Bearer $TOKEN" \
      | jq -r '.siteEntry[]? | "\(.permissionLevel)\t\(.siteUrl)"'
    ;;
  help|*)
    cat <<HELP
Google Search Console export — read-only (service account)

Commands:
  pages   [property] [days]   Per-URL performance → CSV  (default 90 days)
  queries [property] [days]   Per-query performance → CSV
  sites                       List readable properties

Property forms:
  https://thefivestar.com/      (URL-prefix property)
  sc-domain:thefivestar.com     (domain property)

Env:
  GSC_SA_KEY_FILE   path to service-account JSON key (gitignored)
  GSC_PROPERTY      default property if omitted on the command line

Setup: add the SA client_email as a user on the GSC property (Restricted).
Output: sites/thefivestar/audits/<date>-gsc-<dimension>.csv
HELP
    ;;
esac
