#!/bin/bash
set -e

APP_NAME=$1
RESOURCE_GROUP=$2
LOCATION=$3

if [ -z "$APP_NAME" ] || [ -z "$RESOURCE_GROUP" ] || [ -z "$LOCATION" ]; then
  echo "Usage: ./appservice.sh <app-name> <resource-group> <location>"
  exit 1
fi

PLAN_NAME="${APP_NAME}-plan"

echo "Creating App Service Plan..."
az appservice plan create \
  --name "$PLAN_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku F1

echo "Creating Web App..."
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --plan "$PLAN_NAME" \
  --name "$APP_NAME" \
  --runtime "NODE:20-lts"

echo "Enforcing HTTPS..."
az webapp update \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --https-only true

echo "Setting startup command..."
az webapp config set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --startup-file "npx serve -s"

echo "Done! App Service created 🚀"

