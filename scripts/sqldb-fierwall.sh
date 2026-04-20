#!/bin/bash
set -e

SQLSERVER_NAME=$1
DB_NAME=$2
RESOURCE_GROUP=$3
LOCATION=$4
DB_ADMIN=$5
ALLOWED_IP=$(curl -4 -s ifconfig.me)

if [ -z "$SQLSERVER_NAME" ] || [ -z "$DB_NAME" ] || [ -z "$RESOURCE_GROUP" ] || [ -z "$LOCATION" ] || [ -z "$DB_ADMIN" ]; then
  echo "Usage: ./create-sql.sh <sql-server-name> <db-name> <resource-group> <location> <db-admin> [allowed-ip]"
  exit 1
fi

# Om IP inte anges → hämta automatiskt
if [ -z "$ALLOWED_IP" ]; then
  echo "No IP provided, fetching your public IP..."
  ALLOWED_IP=$(curl -4 -s ifconfig.me)
fi

echo "Enter SQL admin password:"
read -s DB_PASSWORD
echo ""

echo "Creating SQL Server..."
az sql server create \
  --name "$SQLSERVER_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --admin-user "$DB_ADMIN" \
  --admin-password "$DB_PASSWORD"

echo "Creating firewall rule for Azure services..."
az sql server firewall-rule create \
  --resource-group "$RESOURCE_GROUP" \
  --server "$SQLSERVER_NAME" \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

echo "Creating firewall rule for your IP..."
az sql server firewall-rule create \
  --resource-group "$RESOURCE_GROUP" \
  --server "$SQLSERVER_NAME" \
  --name AllowMyIP \
  --start-ip-address "$ALLOWED_IP" \
  --end-ip-address "$ALLOWED_IP"

echo "Creating SQL Database..."
az sql db create \
  --resource-group "$RESOURCE_GROUP" \
  --server "$SQLSERVER_NAME" \
  --name "$DB_NAME" \
  --service-objective Basic

echo "Done! SQL Server and database created."