# mvw-deploy

Docker compose for Server 1 (`/home/suenot/production-warehouse`): nginx media host `media.production-warehouse.suenot.com` (Traefik) + daily parsers loop that also rebuilds `items.json`.

```bash
./deploy.sh   # rsync code + compose up -d
```

Data lives in `warehouse/` on the server and is never overwritten.
