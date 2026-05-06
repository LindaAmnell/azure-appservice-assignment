#!/bin/bash
set -e

KEYVAULT_NAME=$1
RESOURCE_GROUP=$2
LOCATION=$3
WEBAPP_NAME=$4
SQL_SERVER=$5
DB_NAME=$6
DB_ADMIN=$7
DB_PASSWORD=$8

az keyvault create \
  --name "$KEYVAULT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --enable-rbac-authorization false

CURRENT_USER=$(az account show --query user.name -o tsv)

az keyvault set-policy \
  --name "$KEYVAULT_NAME" \
  --upn "$CURRENT_USER" \
  --secret-permissions get list set

CONN_STR="Server=tcp:${SQL_SERVER}.database.windows.net,1433;Initial Catalog=${DB_NAME};User ID=${DB_ADMIN};Password=${DB_PASSWORD};Encrypt=True;Connection Timeout=30;"

az keyvault secret set \
  --vault-name "$KEYVAULT_NAME" \
  --name "ConnectionStrings--DefaultConnection" \
  --value "$CONN_STR"

PRINCIPAL_ID=$(az webapp identity assign \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --query principalId \
  -o tsv)

az keyvault set-policy \
  --name "$KEYVAULT_NAME" \
  --object-id "$PRINCIPAL_ID" \
  --secret-permissions get list

sleep 20

SECRET_URI=$(az keyvault secret show \
  --vault-name "$KEYVAULT_NAME" \
  --name "ConnectionStrings--DefaultConnection" \
  --query id \
  -o tsv)

az webapp config appsettings set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEBAPP_NAME" \
  --settings ConnectionStrings__DefaultConnection="@Microsoft.KeyVault(SecretUri=$SECRET_URI)"