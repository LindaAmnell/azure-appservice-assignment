#!/bin/bash
set -e

# Resource Group
RG="<Enter Resource Group name here>"
LOCATION="westeurope"

# App Service / Application
APP_NAME="<Enter app name here>"
SQL_SERVER="<Enter SQL Server name here>"
DB_NAME="<Enter database name here>"
DB_ADMIN="<Enter database admin username here>"

# Storage / Monitoring / Secrets
STORAGE_NAME="<Enter storage account name here>"
APPINSIGHTS_NAME="<Enter Application Insights name here>"
KEYVAULT_NAME="<Enter Key Vault name here>"

read -s -p "Enter SQL password: " DB_PASSWORD
echo ""

echo "Starting Azure deployment..."

echo "1. Creating App Service..."
bash appservice.sh "$APP_NAME" "$RG" "$LOCATION"

echo "2. Creating SQL Server and Database..."
bash sqldb-fierwall.sh \
"$SQL_SERVER" \
"$DB_NAME" \
"$RG" \
"$LOCATION" \
"$DB_ADMIN" \
"$DB_PASSWORD"

echo "3. Creating Storage Account..."
bash storage.sh \
"$STORAGE_NAME" \
"$RG" \
"$LOCATION"

echo "4. Creating Application Insights..."
bash appinsights.sh \
"$APPINSIGHTS_NAME" \
"$RG" \
"$LOCATION" \
"$APP_NAME"

echo "5. Configuring Key Vault..."
bash key.sh \
"$KEYVAULT_NAME" \
"$RG" \
"$LOCATION" \
"$APP_NAME" \
"$SQL_SERVER" \
"$DB_NAME" \
"$DB_ADMIN" \
"$DB_PASSWORD"

echo "7. Configuring Backup..."
bash backup.sh \
"$APP_NAME" \
"$RG" \
"$STORAGE_NAME"

echo "Deployment completed successfully!"