# Azure App Service Deployment

## Overview

The purpose of this project was to create and configure a complete Azure environment using Azure CLI scripts. The goal was to build a web application environment with monitoring, security, storage, and database support.

This document explains how each Azure resource was created and configured using scripts.

All resources were created using scripts to ensure repeatability and automation.

---

## Execution Order

The scripts should be executed in the following order:

1. appservice.sh
2. storage.sh
3. sqldb-firewall.sh
4. key.sh
5. appinsightconnection.sh
6. security.sh
7. backup.sh

---

## Creating the App Service

To host the application, an Azure App Service was created.

Script:

- `scripts/appservice.sh`

Run the script:

```bash
./scripts/appservice.sh myapp mygroup westeurope
```

Parameters:

- `myapp` – name of the Web App (must be unique)
- `mygroup` – Resource Group name
- `westeurope` – Azure region

The script performs the following:

- Creates an App Service Plan
- Creates a Web App
- Enables HTTPS
- Sets a startup command

The App Service is the main component where the application runs.

---

## Monitoring with Application Insights

Application Insights was configured to monitor the application.

Script:

- `scripts/appinsightconnection.sh`

Run the script:

```bash
./scripts/appinsightconnection.sh appinsights mygroup westeurope myapp
```

Parameters:

- `appinsights` – name of Application Insights resource
- `mygroup` – Resource Group name
- `westeurope` – Azure region
- `myapp` – Web App name

The script performs the following:

- Creates Application Insights
- Retrieves the connection string
- Connects it to the Web App

This allows monitoring of logs, performance, and errors.

---

## Storage Account

A Storage Account was created to store files and logs.

Script:

- `scripts/storage.sh`

Run the script:

```bash
./scripts/storage.sh mystorage mygroup westeurope
```

Parameters:

- `mystorage` – Storage Account name (must be globally unique)
- `mygroup` – Resource Group name
- `westeurope` – Azure region

The script performs the following:

- Creates a Storage Account
- Retrieves access keys
- Creates a container for static files

---

## Database and Firewall

A SQL database was created to store application data.

Script:

- `scripts/sqldb-firewall.sh`

Run the script:

```bash
./scripts/sqldb-firewall.sh myserver mydb mygroup westeurope adminuser
```

Parameters:

- `myserver` – SQL Server name
- `mydb` – Database name
- `mygroup` – Resource Group name
- `westeurope` – Azure region
- `adminuser` – SQL admin username

The script performs the following:

- Creates a SQL Server
- Creates a database
- Configures firewall rules for Azure services and the current IP

---

## Key Vault and Secrets Management

Azure Key Vault was used to store sensitive information securely.

Script:

- `scripts/key.sh`

Run the script:

```bash
./scripts/key.sh myvault mygroup westeurope myapp myserver mydb adminuser subscription-id
```

Parameters:

- `myvault` – Key Vault name
- `mygroup` – Resource Group name
- `westeurope` – Azure region
- `myapp` – Web App name
- `myserver` – SQL Server name
- `mydb` – Database name
- `adminuser` – SQL admin username
- `subscription-id` – Azure subscription ID

The script performs the following:

- Creates a Key Vault
- Stores the database connection string
- Enables Managed Identity
- Grants access to Key Vault
- Connects the secret to the Web App

---

## Security Configuration

Access restrictions were configured to improve security.

Script:

- `scripts/security.sh`

Run the script:

```bash
./scripts/security.sh myapp mygroup
```

Parameters:

- `myapp` – Web App name
- `mygroup` – Resource Group name

The script performs the following:

- Retrieves your public IP address
- Allows access only from that IP
- Blocks all other traffic

---

## Backup Configuration

Daily backups were configured for the Web App.

Script:

- `scripts/backup.sh`

Run the script:

```bash
./scripts/backup.sh myapp mygroup mystorage
```

Parameters:

- `myapp` – Web App name
- `mygroup` – Resource Group name
- `mystorage` – Storage Account name

The script performs the following:

- Creates a backup container
- Generates a SAS token
- Configures daily backups
- Sets retention rules

---

## Verification

The resources were tested after creation to ensure they work correctly.

- The App Service was successfully created and accessible
- Application Insights collects logs
- Database connection was configured
- Security rules were applied correctly

This confirms that the environment is functioning as expected.

---

## Conclusion

This project demonstrates how to build a complete Azure environment using CLI scripts.

The solution includes:

- App Service for hosting
- Application Insights for monitoring
- Storage Account for files
- SQL Database for data
- Key Vault for secrets
- Security configurations
- Backup system

All components are connected to create a secure and maintainable cloud solution.

## Deployment (Not Implemented Yet)

Deployment using GitHub Actions is planned but not yet implemented.

---
