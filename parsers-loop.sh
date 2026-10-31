#!/bin/sh
# Daily: run each parser (idempotent, downloads only new items), then rebuild items.json.
while true; do
  for mod in mvw_parser_awesome_opus55 mvw_parser_skillry_opus55 mvw_parser_higgsfield; do
    dir=$(ls -d /src/mvw-parser-*/ | while read d; do [ -d "$d$mod" ] && echo "$d"; done)
    echo "$(date -u +%FT%TZ) run $mod"
    (cd "$dir" && PYTHONPATH=/src/mvw-core python -m "$mod") || echo "$mod failed"
  done
  python -m mvw_viewer --index /warehouse/items.json || echo "index failed"
  echo "$(date -u +%FT%TZ) done, sleeping ${INTERVAL_SECONDS}s"
  sleep "${INTERVAL_SECONDS:-86400}"
done
