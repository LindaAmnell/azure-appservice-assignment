#!/bin/bash
set -e

WEBAPP_NAME=$1
RESOURCE_GROUP=$2
STORAGE_NAME=$3


CONTAINER_NAME="appservicebackup"

echo "Getting storage key..."
STORAGE_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_NAME" \
  --query "[0].value" \
  -o tsv)

echo "Creating backup container..."
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_NAME" \
  --account-key "$STORAGE_KEY"

echo "Generating SAS token..."
EXPIRY=$(date -u -d "+1 year" '+%Y-%m-%dT%H:%MZ')

SAS_TOKEN=$(az storage container generate-sas \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_NAME" \
  --account-key "$STORAGE_KEY" \
  --permissions dlrw \
  --expiry "$EXPIRY" \
  --https-only \
  -o tsv)

CONTAINER_URL="https://${STORAGE_NAME}.blob.core.windows.net/${CONTAINER_NAME}?${SAS_TOKEN}"

echo "Configuring daily backup..."
az webapp config backup update \
  --resource-group "$RESOURCE_GROUP" \
  --webapp-name "$WEBAPP_NAME" \
  --container-url "$CONTAINER_URL" \
  --frequency 1d \
  --retention 7 \
  --retain-one true

echo "Done! Daily backup configured."