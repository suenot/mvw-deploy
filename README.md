# mvw-deploy

Docker compose for Server 1 (`/home/suenot/production-warehouse`): nginx media host `media.production-warehouse.suenot.com` (Traefik) + daily parsers loop that also rebuilds `items.json`.

```bash
./deploy.sh   # rsync code + compose up -d
```

Data lives in `warehouse/` on the server and is never overwritten.

## Parsers that Server 1 cannot reach

`skillry` and `higgsfield` time out on TLS from Server 1. `mac-sync.sh` runs them on the Mac, rsyncs the warehouse to the server and rebuilds `items.json`. Schedule it daily with the launchd agent in `com.suenot.mvw-mac-sync.plist` (04:30):

```bash
cp com.suenot.mvw-mac-sync.plist ~/Library/LaunchAgents/ && launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.suenot.mvw-mac-sync.plist
```

Log: `~/Library/Logs/mvw-mac-sync.log`. The Mac must be on.
