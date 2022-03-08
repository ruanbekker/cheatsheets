#!/usr/bin/env bash
DATESTAMP="$(date +%FT%H:%m)"

sudo systemctl restart python-app
echo "[${DATESTAMP}] application started"
