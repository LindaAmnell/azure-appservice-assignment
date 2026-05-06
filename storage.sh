#!/bin/bash
set -e

STORAGE_NAME=$1
RESOURCE_GROUP=$2
LOCATION=$3

echo "Creating Storage Account..."
az storage account create \
  --name "$STORAGE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2

echo "Getting storage key..."
STORAGE_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_NAME" \
  --query "[0].value" \
  -o tsv)

if [ -z "$STORAGE_KEY" ]; then
  echo "Failed to get storage key"
  exit 1
fi

echo "Creating static-files container..."
az storage container create \
  --name static-files \
  --account-name "$STORAGE_NAME" \
  --account-key "$STORAGE_KEY"

echo "Creating test file..."
echo "This file is stored in Azure Storage" > testfile.txt

echo "Uploading test file..."
az storage blob upload \
  --account-name "$STORAGE_NAME" \
  --account-key "$STORAGE_KEY" \
  --container-name static-files \
  --name testfile.txt \
  --file testfile.txt \
  --overwrite true

echo "Done! Storage Account created and test file uploaded."