# Azure App Service Deployment

## Overview

The purpose of this project was to create and configure a complete Azure environment using Azure CLI scripts. The goal was to deploy a web application with monitoring, security, storage, and database support.

All resources were created using scripts to ensure repeatability and automation.

---

## Creating the App Service

To host the application, an Azure App Service was created.

This was done using a script that:

- Created an App Service Plan
- Created a Web App
- Enabled HTTPS to secure communication

The App Service is the central component where the application runs.

---

## Monitoring with Application Insights

To monitor the application, Application Insights was configured.

This allows:

- Viewing logs in real time
- Monitoring performance
- Detecting errors

The script creates the resource and connects it to the Web App by adding a connection string.

---

## Storage Account

A Storage Account was created to store files and logs.

This is useful for:

- Backups
- Static files
- Log storage

The script creates the storage account and a container for storing data.

---

## Database and Firewall

A SQL database was created to store application data.

To make it secure:

- Firewall rules were added to allow only trusted access
- Access was restricted to Azure services and the current IP address

This ensures that the database is protected from unauthorized access.

---

## Key Vault and Secrets Management

To securely manage sensitive data, Azure Key Vault was used.

Instead of storing connection strings in code:

- The connection string is stored as a secret in Key Vault
- The Web App accesses it using Managed Identity

This improves security and prevents exposure of sensitive information.

---

## Security Configuration

Additional security was implemented for the Web App.

Access restrictions were configured so that:

- Only the current IP address is allowed
- All other traffic is denied

This reduces the attack surface of the application.

---

## Backup Configuration

To ensure reliability, daily backups were configured.

The backup process:

- Stores backups in a Storage Account
- Runs automatically every day
- Keeps backups for a limited time

This allows recovery in case of failure.

---

## Scaling

Scaling was not implemented.

This is because the selected pricing tier did not support autoscaling, or issues occurred during configuration.

---

## Deployment (Not Implemented Yet)

Deployment using GitHub Actions will be implemented later.

The goal is to automate deployment so that changes are automatically published when code is pushed to GitHub.

---

## Conclusion

This project demonstrates how to build a complete Azure environment using scripts.

The solution includes:

- Hosting (App Service)
- Monitoring (Application Insights)
- Security (IP restrictions, HTTPS, Key Vault)
- Data storage (SQL Database and Storage Account)
- Backup and recovery

All components are connected to create a secure and maintainable cloud solution.
