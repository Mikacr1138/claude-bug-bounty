#!/bin/sh
# Refresh nuclei templates into the mounted volume; ignore failures so the
# worker still starts if the update cannot reach the network.
/opt/pdtools/nuclei -update-templates -silent 2>/dev/null || true
exec celery -A worker.main:celery_app worker --loglevel=info
