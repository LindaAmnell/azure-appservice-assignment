# Azure App Service Deployment

This document describes the setup and configuration of Azure resources using Azure CLI scripts.

## 1. Create App Service

An Azure App Service was created using Azure CLI.

**Script:**

- `scripts/appservice.sh`

**Description:**
This script creates the required resources for hosting the application:

- Resource Group
- App Service Plan
- Web App

**Example command:**

```bash
az group create --name myResourceGroup --location westeurope
```

---

## 2. Application Insights

Application Insights was enabled to collect logs and monitor the application.

**Script:**

- `scripts/appinsightconnection.sh`

**Usage:**

- Logs can be viewed in Azure Portal
- Live Metrics can be used to monitor performance
- Log queries (KQL) can be used to analyze errors

This allows monitoring of application health and performance.

---

## 3. Security

Basic security measures were implemented.

**Scripts:**

- `scripts/security.sh`
- `scripts/backup.sh`

**Implemented security:**

- HTTPS is enabled
- IP restrictions are configured
- Daily backups are scheduled

These measures help secure the application and ensure recovery if needed.

---

## 4. Storage Account

A Storage Account was created to manage files and logs.

**Script:**

- `scripts/storage.sh`

This allows storage of static resources and log data.

---

## 5. Key Vault

Azure Key Vault was used to store sensitive information securely.

**Script:**

- `scripts/key.sh`

**Implementation:**

- Secrets such as connection strings are stored in Key Vault
- Managed Identity is used for secure access

This prevents sensitive data from being exposed in code.

---

## 6. Database & Firewall

An Azure SQL Database and firewall rules were configured.

**Script:**

- `scripts/sqldb-firewall.sh`

**Description:**

- A SQL database was created
- Firewall rules were configured to allow secure access

---

## 7. Scaling

Scaling was not implemented.

**Reason:**
The selected pricing tier did not support autoscaling, or issues occurred during configuration.

---

## 8. Deployment (Not Implemented Yet)

Deployment using GitHub Actions will be implemented later.

This step is required to automate deployment to Azure App Service.

## Execution Order

The scripts should be executed in the following order:

1. appservice.sh
2. storage.sh
3. sqldb-firewall.sh
4. key.sh
5. appinsightconnection.sh
6. security.sh
7. backup.sh
