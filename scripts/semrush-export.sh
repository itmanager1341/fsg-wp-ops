#!/usr/bin/env bash
# semrush-export.sh — Semrush Analytics API export (organic SEO baseline)
# Usage: ./scripts/semrush-export.sh <command> [domain] [database] [limit]
#
# Commands:
#   overview [domain] [db]            Domain summary (rank, # organic kw, traffic) → CSV  (~10 units)
#   keywords [domain] [db] [limit]    Organic keywords + ranking URL, by traffic   → CSV  (10 units/row)
#   pages    [domain] [db] [limit]    Top pages aggregated from the keywords pull   → CSV  (10 units/row)
#
# Units: keyword/pages reports cost 10 API units PER ROW. Default limit is 1000
# (=10,000 units). Raise deliberately. `overview` is ~10 units flat.
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

[[ -z "$KEY" ]] && { echo "ERROR: set SEMRUSH_API_KEY (see .env)" >&2; exit 1; }

# Convert Semrush ';'-delimited output → proper quoted CSV (handles commas in keywords)
to_csv() { awk -F';' 'BEGIN{OFS=""}{out="";for(i=1;i<=NF;i++){g=$i;gsub(/"/,"\"\"",g);out=out (i>1?",":"") "\"" g "\""}print out}'; }

# Fetch one report; Semrush returns plain-text "ERROR ## :: msg" on failure
fetch() {
  local resp; resp=$(curl -sf "$API?$1") || { echo "ERROR: HTTP request to Semrush failed" >&2; exit 1; }
  if [[ "$resp" == ERROR\ * ]]; then echo "Semrush API: $resp" >&2; exit 1; fi
  printf '%s' "$resp"
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
    OUT="$OUTDIR/${DATE}-semrush-keywords.csv"
    echo "🔑 Semrush organic keywords — $DOMAIN ($DB), top $LIMIT by traffic  (~$((LIMIT*10)) units)"
    fetch "type=domain_organic&key=$KEY&domain=$DOMAIN&database=$DB&display_limit=$LIMIT&display_sort=tr_desc&export_columns=Ph,Po,Pp,Nq,Cp,Ur,Tr,Tc,Co,Nr" \
      | to_csv > "$OUT"
    echo "✅ $(($(wc -l < "$OUT")-1)) keywords → ${OUT#$REPO_ROOT/}"
    ;;

  pages)
    # Derive top pages from the keyword pull (aggregate by ranking URL).
    KW="$OUTDIR/${DATE}-semrush-keywords.csv"
    OUT="$OUTDIR/${DATE}-semrush-pages.csv"
    [[ -f "$KW" ]] || { echo "Run 'keywords' first (pages aggregates that file): $KW" >&2; exit 1; }
    echo "📄 Aggregating top pages from $KW"
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
    ;;

  help|*)
    cat <<HELP
Semrush organic SEO baseline export — FSG Media

Commands:
  overview [domain] [db]          Domain summary           (~10 units)
  keywords [domain] [db] [limit]  Organic keywords + URLs  (10 units/row, default 1000)
  pages    [domain] [db] [limit]  Top pages (from keywords file)

Defaults: domain=$DEF_DOMAIN  db=$DEF_DB  limit=1000
Env:      SEMRUSH_API_KEY  (in .env)
Output:   sites/thefivestar/audits/<date>-semrush-<report>.csv

Typical baseline run:
  scripts/semrush-export.sh overview
  scripts/semrush-export.sh keywords thefivestar.com us 2000
  scripts/semrush-export.sh pages
HELP
    ;;
esac
