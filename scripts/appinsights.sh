#!/bin/bash
set -e

APPINSIGHTS_NAME=$1
RESOURCE_GROUP=$2
LOCATION=$3
WEBAPP_NAME=$4



echo "Creating Application Insights..."
az monitor app-insights component create \
  --app "$APPINSIGHTS_NAME" \
  --location "$LOCATION" \
  --resource-group "$RESOURCE_GROUP" \
  --kind web \
  --application-type web

echo "Getting connection string..."
APPINSIGHTS_CONN=$(az monitor app-insights component show \
  --app "$APPINSIGHTS_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query connectionString \
  -o tsv)

if [ -z "$APPINSIGHTS_CONN" ]; then
  echo "Failed to get Application Insights connection string"
  exit 1
fi

echo "Connecting Application Insights to Web App..."
az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --settings APPLICATIONINSIGHTS_CONNECTION_STRING="$APPINSIGHTS_CONN"

echo "Done! Application Insights configured."