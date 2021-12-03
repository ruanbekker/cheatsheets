#!/usr/bin/env sh
set -x
terraform init \
  -backend-config access_key=$AWS_ACCESS_KEY_ID \
  -backend-config secret_key=$AWS_SECRET_ACCESS_KEY \
  -backend-config region=$AWS_DEFAULT_REGION \
  -backend-config "bucket=terraform-remote-state" \
  -backend-config "key=$CI_REPO_NAME/$CI_COMMIT_BRANCH" \
  -backend-config "endpoint=https://minio.domain.com" \
  -backend-config "force_path_style=true" \
  -backend-config "skip_credentials_validation=true" \
  -backend-config "skip_metadata_api_check=true" \
  -backend-config "skip_region_validation=true"
