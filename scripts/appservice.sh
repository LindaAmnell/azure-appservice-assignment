#!/bin/bash
set -e

APP_NAME=$1
RESOURCE_GROUP=$2
LOCATION=$3
ALLOWED_IP=$(curl -4 -s ifconfig.me)

PLAN_NAME="${APP_NAME}-plan"

echo "Creating App Service Plan..."
az appservice plan create \
  --name "$PLAN_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku B1 \
  --is-linux

echo "Creating Web App..."
az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --plan "$PLAN_NAME" \
  --name "$APP_NAME" \
  --runtime "DOTNETCORE:10.0"

echo "Enforcing HTTPS..."
az webapp update \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --https-only true

echo "Adding IP restriction..."
az webapp config access-restriction add \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --rule-name AllowMyIP \
  --action Allow \
  --ip-address "$ALLOWED_IP/32" \
  --priority 100

az webapp config access-restriction set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --default-action Deny

echo "Done! App Service created with HTTPS and IP restriction."