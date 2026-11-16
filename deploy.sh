#!/bin/sh
# Sync code to Server 1 and (re)start the stack. Data in warehouse/ is never touched.
set -e
cd "$(dirname "$0")/.."
[ -f ~/.config/mvw/env ] && . ~/.config/mvw/env   # MVW_DEPLOY_HOST=user@host (kept out of git)
H=${MVW_DEPLOY_HOST:?set MVW_DEPLOY_HOST=user@host}; D=/home/suenot/production-warehouse
S="ssh -p 4242"
$S $H "mkdir -p $D/src $D/deploy $D/warehouse"
for r in mvw-core mvw-viewer mvw-parser-awesome-opus55 mvw-parser-skillry-opus55 mvw-parser-higgsfield-content-factory; do
  rsync -a --delete --exclude .git --exclude node_modules --exclude web --exclude __pycache__ -e "$S" $r/ $H:$D/src/$r/
done
rsync -a -e "$S" mvw-deploy/compose.yaml mvw-deploy/nginx.conf mvw-deploy/parsers-loop.sh $H:$D/deploy/
$S $H "cd $D/deploy && docker compose -p production-warehouse up -d --force-recreate"
