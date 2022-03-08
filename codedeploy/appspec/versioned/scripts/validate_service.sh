#!/usr/bin/env bash
set -ex
DATESTAMP="$(date +%FT%H:%m)"

# Verify if the service is healthy
while ! curl -sf http://localhost:8000/health; do sleep 5; done

# log
echo "[${DATESTAMP}] application passing health checks"

# write current version to disk
echo "${DEPLOYMENT_ID}" > /opt/codedeploy-agent/deployment-root/${DEPLOYMENT_GROUP_ID}/.version
