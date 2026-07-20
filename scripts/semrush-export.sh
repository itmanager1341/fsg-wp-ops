#!/usr/bin/env bash
# semrush-export.sh — Semrush Analytics API export (organic SEO baseline)
# Usage: ./scripts/semrush-export.sh <command> [domain] [database] [limit]
#
# Commands:
#   overview [domain] [db]            Domain summary (rank, # organic kw, traffic) → CSV  (~10 units)
#   keywords [domain] [db] [limit]    Organic keywords + ranking URL, by traffic   → CSV  (10 units/row)
#   pages    [domain] [db]            Top pages aggregated from the keywords pull   → CSV  (free; local)
#
# Units: keyword reports cost 10 API units PER ROW. Default limit is 1000
# (=10,000 units). Raise deliberately. `overview` is ~10 units flat.
# `pages` is a local aggregate of the keywords CSV (no extra API units).
#
# Pagination: Semrush returns at most 100,000 rows per request. For larger
# limits the keywords command pages via display_offset. Semrush quirk:
# display_limit is an end-index (offset + page_size), not the page size.
# Absolute ceiling: display_limit must not exceed 4,000,000.
#
# Auth:
#   SEMRUSH_API_KEY   Semrush API key (Standard API; gitignored via .env)
#
# Output: sites/thefivestar/audits/<date>-semrush-<report>.csv

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API="https://api.semrush.com/"
KEY="${SEMRUSH_API_KEY:-}"
DEF_DOMAIN="thefivestar.com"
DEF_DB="us"
# Max rows returned per Semrush request (see domain reports API docs).
PAGE_MAX=100000
# Absolute ceiling for display_limit (offset + page size).
ABS_MAX=4000000

[[ -z "$KEY" ]] && { echo "ERROR: set SEMRUSH_API_KEY (see .env)" >&2; exit 1; }

# Convert Semrush ';'-delimited output → proper quoted CSV (handles commas in keywords)
to_csv() { awk -F';' 'BEGIN{OFS=""}{out="";for(i=1;i<=NF;i++){g=$i;gsub(/"/,"\"\"",g);out=out (i>1?",":"") "\"" g "\""}print out}'; }

# Fetch one report; Semrush returns plain-text "ERROR ## :: msg" on failure
fetch() {
  local resp; resp=$(curl -sf "$API?$1") || { echo "ERROR: HTTP request to Semrush failed" >&2; exit 1; }
  if [[ "$resp" == ERROR\ * ]]; then echo "Semrush API: $resp" >&2; exit 1; fi
  # Exactly one trailing newline so line counts (wc -l) are accurate
  printf '%s\n' "${resp%$'\n'}"
}

# Fetch domain_organic in PAGE_MAX-sized pages until `limit` rows or exhaustion.
# Writes a single CSV to $4. Echoes the data-row count to stdout.
fetch_keywords_paginated() {
  local domain="$1" db="$2" limit="$3" out="$4"
  local cols="Ph,Po,Pp,Nq,Cp,Ur,Tr,Tc,Co,Nr"
  local offset=0 remaining="$limit" total=0 header_done=0
  local page_size page_end tmp chunk_rows

  : > "$out"

  while (( remaining > 0 )); do
    page_size=$remaining
    (( page_size > PAGE_MAX )) && page_size=$PAGE_MAX
    page_end=$((offset + page_size))
    if (( page_end > ABS_MAX )); then
      echo "⚠️  Semrush hard ceiling is ${ABS_MAX} rows — clamping this page." >&2
      page_end=$ABS_MAX
      page_size=$((page_end - offset))
      (( page_size <= 0 )) && break
    fi

    if (( limit > PAGE_MAX )); then
      echo "  … page offset=${offset} display_limit=${page_end} (up to ${page_size} rows)" >&2
    fi

    tmp=$(mktemp)
    # Semrush: display_limit = end index; display_offset skips prior rows.
    fetch "type=domain_organic&key=$KEY&domain=$domain&database=$db&display_limit=${page_end}&display_offset=${offset}&display_sort=tr_desc&export_columns=$cols" \
      > "$tmp"

    chunk_rows=$(($(wc -l < "$tmp") - 1))
    (( chunk_rows < 0 )) && chunk_rows=0

    if (( header_done == 0 )); then
      to_csv < "$tmp" > "$out"
      header_done=1
    elif (( chunk_rows > 0 )); then
      # Skip Semrush header on subsequent pages
      tail -n +2 "$tmp" | to_csv >> "$out"
    fi
    rm -f "$tmp"

    total=$((total + chunk_rows))

    # Short page → no more data at this sort/filter.
    if (( chunk_rows < page_size )); then
      break
    fi

    offset=$((offset + chunk_rows))
    remaining=$((remaining - chunk_rows))

    if (( offset >= ABS_MAX )); then
      echo "⚠️  Hit Semrush absolute ceiling (${ABS_MAX} rows)." >&2
      break
    fi
  done

  echo "$total"
}

CMD="${1:-help}"; shift || true
DOMAIN="${1:-$DEF_DOMAIN}"
DB="${2:-$DEF_DB}"
LIMIT="${3:-1000}"
DATE=$(date +%Y-%m-%d)
OUTDIR="$REPO_ROOT/sites/thefivestar/audits"
mkdir -p "$OUTDIR"

case "$CMD" in
  overview)
    OUT="$OUTDIR/${DATE}-semrush-overview.csv"
    echo "📊 Semrush domain overview — $DOMAIN ($DB)"
    fetch "type=domain_ranks&key=$KEY&domain=$DOMAIN&database=$DB&export_columns=Db,Dn,Rk,Or,Ot,Oc,Ad,At,Ac" \
      | to_csv > "$OUT"
    echo "✅ $OUT"
    cat "$OUT"
    ;;

  keywords)
    if ! [[ "$LIMIT" =~ ^[1-9][0-9]*$ ]]; then
      echo "ERROR: limit must be a positive integer (got: $LIMIT)" >&2
      exit 1
    fi
    if (( LIMIT > ABS_MAX )); then
      echo "⚠️  Requested limit ${LIMIT} exceeds Semrush ceiling ${ABS_MAX}; clamping." >&2
      LIMIT=$ABS_MAX
    fi
    OUT="$OUTDIR/${DATE}-semrush-keywords.csv"
    pages_needed=$(( (LIMIT + PAGE_MAX - 1) / PAGE_MAX ))
    echo "🔑 Semrush organic keywords — $DOMAIN ($DB), top $LIMIT by traffic  (~$((LIMIT*10)) units, ${pages_needed} request(s))"
    got=$(fetch_keywords_paginated "$DOMAIN" "$DB" "$LIMIT" "$OUT")
    echo "✅ ${got} keywords → ${OUT#$REPO_ROOT/}"
    if (( got < LIMIT )); then
      echo "ℹ️  Returned ${got} of ${LIMIT} requested — domain has fewer matching keywords (or end of results)." >&2
    fi
    ;;

  pages)
    # Derive top pages from the keyword pull (aggregate by ranking URL).
    # Completeness depends entirely on a full keywords export for this date.
    KW="$OUTDIR/${DATE}-semrush-keywords.csv"
    OUT="$OUTDIR/${DATE}-semrush-pages.csv"
    [[ -f "$KW" ]] || { echo "Run 'keywords' first (pages aggregates that file): $KW" >&2; exit 1; }
    kw_count=$(($(wc -l < "$KW") - 1))
    (( kw_count < 0 )) && kw_count=0
    echo "📄 Aggregating top pages from $KW (${kw_count} keywords)"
    if (( kw_count == 0 )); then
      echo "ERROR: keywords file is empty — re-run 'keywords' first." >&2
      exit 1
    fi
    # keyword CSV cols: 1=Ph 2=Po 3=Pp 4=Nq 5=Cp 6=Ur 7=Tr 8=Tc 9=Co 10=Nr
    {
      echo "url,ranking_keywords,sum_traffic_share_pct,top_keyword,top_keyword_position"
      tail -n +2 "$KW" | python3 -c '
import sys, csv
from collections import defaultdict
agg=defaultdict(lambda:[0,0.0,None,None,1e9])
for r in csv.reader(sys.stdin):
    if len(r)<7: continue
    url=r[5];
    try: tr=float(r[6] or 0)
    except: tr=0.0
    try: po=float(r[1] or 9999)
    except: po=9999
    a=agg[url]; a[0]+=1; a[1]+=tr
    if po<a[4]: a[4]=po; a[2]=r[0]; a[3]=r[1]
w=csv.writer(sys.stdout)
for url,a in sorted(agg.items(), key=lambda x:-x[1][1]):
    w.writerow([url,a[0],round(a[1],2),a[2],a[3]])
'
    } > "$OUT"
    echo "✅ $(($(wc -l < "$OUT")-1)) pages → ${OUT#$REPO_ROOT/}"
    echo "ℹ️  pages reflects only keywords present in today's keywords CSV — re-run keywords with a higher limit if that export was partial." >&2
    ;;

  help|*)
    cat <<HELP
Semrush organic SEO baseline export — FSG Media

Commands:
  overview [domain] [db]          Domain summary           (~10 units)
  keywords [domain] [db] [limit]  Organic keywords + URLs  (10 units/row, default 1000)
  pages    [domain] [db]          Top pages (from keywords file; local, free)

Defaults: domain=$DEF_DOMAIN  db=$DEF_DB  limit=1000
Env:      SEMRUSH_API_KEY  (in .env)
Output:   sites/thefivestar/audits/<date>-semrush-<report>.csv

Pagination: keywords auto-pages at ${PAGE_MAX} rows/request (Semrush max).
Ceiling:    ${ABS_MAX} rows total per domain_organic export.

Typical baseline run:
  scripts/semrush-export.sh overview
  scripts/semrush-export.sh keywords thefivestar.com us 2000
  scripts/semrush-export.sh pages
HELP
    ;;
esac
