# 🚀 Azure App Service Deployment

This project automates the deployment of a complete Azure environment using **Bash scripts** and **Azure CLI** ☁️

Perfect for learning Azure infrastructure automation, scripting, and secure cloud deployments.

## ✨ Features

The deployment includes:

* Azure App Service
* Azure SQL Database
* Azure Storage Account
* Azure Key Vault
* Application Insights
* Automated Backups
* Security and Firewall Rules

---

# 🛠️ Prerequisites

Make sure you have:

* Azure CLI installed
* Bash terminal
* An active Azure subscription

Login to Azure:

```bash
az login
```

---

# 🚀 Deployment

## ⚡ Run Everything Automatically

The easiest way to deploy the environment:

```bash
bash runall.sh
```

---

## 🔧 Manual Deployment

If you want to run the scripts manually, use this order:

```bash
bash appservice.sh
bash sqldb-fierwall.sh
bash storage.sh
bash appinsights.sh
bash key.sh
bash backup.sh
```

---

# 📜 Scripts

## 🌐 appservice.sh

Creates:

* App Service Plan
* Azure Web App
* HTTPS enforcement
* IP restrictions

Example:

```bash
bash appservice.sh myapp my-rg westeurope
```

---

## 🗄️ sqldb-fierwall.sh

Creates:

* Azure SQL Server
* SQL Database
* Firewall rules

Example:

```bash
bash sqldb-fierwall.sh myserver mydb my-rg westeurope sqladmin password
```

---

## 📦 storage.sh

Creates:

* Storage Account
* Blob container
* Uploads a test file

Example:

```bash
bash storage.sh mystorage my-rg westeurope
```

---

## 📊 appinsights.sh

Creates and connects:

* Application Insights
* Monitoring configuration

Example:

```bash
bash appinsights.sh myinsights my-rg westeurope myapp
```

---

## 🔐 key.sh

Creates and configures:

* Azure Key Vault
* Database connection secret
* Managed Identity access

Example:

```bash
bash key.sh myvault my-rg westeurope myapp myserver mydb sqladmin password
```

---

## 💾 backup.sh

Configures:

* Daily backups
* Backup container
* Retention policy

Example:

```bash
bash backup.sh myapp my-rg mystorage
```

---

# 🔒 Security Features

* HTTPS enabled
* IP restrictions
* Azure Key Vault secrets
* Managed Identity authentication
* SQL Firewall rules

---

# 🚧 Future Improvements

* GitHub Actions CI/CD
* Terraform or Bicep
* Private Endpoints
* Monitoring Alerts

---

# 👨‍💻 Author

Created as an Azure infrastructure automation project using Azure CLI and Bash scripting.

---

⭐ Feel free to fork the project, improve it, or use it as inspiration for your own Azure deployments.
