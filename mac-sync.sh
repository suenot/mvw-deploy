#!/bin/sh
# Run the parsers that Server 1 cannot reach (skillry, higgsfield) from this Mac, then push new files to Server 1
# and rebuild its items.json. Scheduled daily by launchd (see com.suenot.mvw-mac-sync.plist).
set -u
WS="$(cd "$(dirname "$0")/.." && pwd)"
export MVW_DATA="$WS/warehouse" PYTHONPATH="$WS/mvw-core:$WS/mvw-viewer"
H=root@89.179.247.80; D=/home/suenot/production-warehouse
SSH="ssh -p 4242 -o ConnectTimeout=20 -o ServerAliveInterval=15"
log() { echo "$(date -u +%FT%TZ) $*"; }

for p in mvw-parser-skillry-opus55:mvw_parser_skillry_opus55 mvw-parser-higgsfield-content-factory:mvw_parser_higgsfield; do
  dir=${p%%:*}; mod=${p##*:}
  log "run $mod"; (cd "$WS/$dir" && python3 -m "$mod") || log "$mod failed"
done

n=0
until rsync -a --exclude '*.part' --exclude items.json -e "$SSH" "$MVW_DATA/" "$H:$D/warehouse/"; do
  n=$((n+1)); [ $n -ge 5 ] && { log "rsync failed"; exit 1; }; sleep 30
done
$SSH $H "docker exec production-warehouse-parsers-1 python -m mvw_viewer --index /warehouse/items.json"
log "synced"
