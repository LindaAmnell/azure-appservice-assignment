#!/bin/bash
set -e

WEBAPP_NAME=$1
RESOURCE_GROUP=$2
MY_IP=$(curl -4 -s ifconfig.me)

if [ -z "$WEBAPP_NAME" ] || [ -z "$RESOURCE_GROUP" ] || [ -z "$MY_IP" ]; then
  echo "Usage: ./security.sh <webapp-name> <resource-group>"
  exit 1
fi

echo "Allowing your IP: $MY_IP"

az webapp config access-restriction add \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --rule-name "AllowMyIP" \
  --action Allow \
  --ip-address "$MY_IP/32" \
  --priority 100

az webapp config access-restriction set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --default-action Deny

echo "Done! IP restriction configured."

