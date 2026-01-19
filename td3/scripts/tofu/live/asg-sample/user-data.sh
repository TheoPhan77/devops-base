#!/usr/bin/env bash
set -euo pipefail

sudo -iu app-user bash -lc '
cd /home/app-user
pm2 start app.config.js || true
pm2 save
'