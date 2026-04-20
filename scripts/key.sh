#!/bin/bash
set -e

KEYVAULT_NAME=$1
RESOURCE_GROUP=$2
LOCATION=$3
WEBAPP_NAME=$4
SQL_SERVER=$5
DB_NAME=$6
DB_ADMIN=$7
SUBSCRIPTION_ID=$8

if [ -z "$KEYVAULT_NAME" ] || [ -z "$RESOURCE_GROUP" ] || [ -z "$LOCATION" ] || [ -z "$WEBAPP_NAME" ] || [ -z "$SQL_SERVER" ] || [ -z "$DB_NAME" ] || [ -z "$DB_ADMIN" ] || [ -z "$SUBSCRIPTION_ID" ]; then
  echo "Usage: ./key.sh <keyvault-name> <resource-group> <location> <webapp-name> <sql-server> <db-name> <db-admin> <subscription-id>"
  exit 1
fi

echo "Setting subscription..."
az account set --subscription "$SUBSCRIPTION_ID"

echo "Enter SQL admin password:"
read -s DB_PASSWORD
echo ""

echo "Creating Key Vault..."
az keyvault create \
  --name "$KEYVAULT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --enable-rbac-authorization false

# 🔐 Ge DIG access
echo "Setting Key Vault access policy for current user..."
az keyvault set-policy \
  --name "$KEYVAULT_NAME" \
  --upn $(az account show --query user.name -o tsv) \
  --secret-permissions get list set

# 🔐 Skapa connection string
CONN_STR="Server=tcp:${SQL_SERVER}.database.windows.net,1433;Initial Catalog=${DB_NAME};User ID=${DB_ADMIN};Password=${DB_PASSWORD};Encrypt=True;Connection Timeout=30;"

echo "Saving connection string in Key Vault..."
az keyvault secret set \
  --vault-name "$KEYVAULT_NAME" \
  --name "ConnectionStrings--DefaultConnection" \
  --value "$CONN_STR"

# 🔐 Aktivera Managed Identity
echo "Enabling Managed Identity on Web App..."
PRINCIPAL_ID=$(az webapp identity assign \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --query principalId \
  -o tsv)

# 🔐 Ge App Service access (ACCESS POLICY – INTE RBAC)
echo "Giving Web App access via Key Vault access policy..."
az keyvault set-policy \
  --name "$KEYVAULT_NAME" \
  --object-id "$PRINCIPAL_ID" \
  --secret-permissions get list

echo "Waiting for permissions..."
sleep 20

# 🔗 Hämta secret URI
SECRET_URI=$(az keyvault secret show \
  --vault-name "$KEYVAULT_NAME" \
  --name "ConnectionStrings--DefaultConnection" \
  --query id \
  -o tsv)

# 🔗 Koppla till App Service
echo "Connecting Key Vault to Web App..."
az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --settings ConnectionStrings__DefaultConnection="@Microsoft.KeyVault(SecretUri=$SECRET_URI)"

echo "Done! Key Vault configured successfully 🎉"