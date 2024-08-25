# Aztek_Terraform
Terraform Project For Job Interview at Aztek Tec
[pdf image of architecture](aztek.drawio.pdf)

# Python Web Application on Azure

This repository contains the infrastructure setup and deployment scripts for a Python web application hosted on Azure. The architecture leverages various Azure services to ensure minimal latency, scalability, and security.

## Architecture Overview

The architecture is designed to host a simple Python web application with the following Azure services:

### 1. **Azure Front Door**
**Purpose**: Azure Front Door provides global traffic management and load balancing for the application. It optimizes the delivery of content to users by routing requests to the nearest or best-performing backend based on real-time latency.

### 2. **Azure Virtual Network (VNet)**
**Purpose**: The Azure Virtual Network (VNet) is a logical network in Azure that allows resources to securely communicate with each other. The VNet is divided into public and private subnets to isolate different components of the application.

### 3. **Azure Application Gateway with WAF**
**Purpose**: Azure Application Gateway acts as a layer 7 load balancer that manages incoming HTTP(S) requests. It includes a Web Application Firewall (WAF) to protect the application from common web vulnerabilities like SQL injection and cross-site scripting (XSS).

### 4. **Azure App Service**
**Purpose**: Azure App Service is a fully managed platform for building, deploying, and scaling web applications. The Python web application is hosted here, benefiting from features like auto-scaling, SSL support, and continuous deployment capabilities.

### 5. **Azure Monitor & Application Insights**
**Purpose**: Azure Monitor and Application Insights provide monitoring, logging, and analytics capabilities. They help track the performance of the application, diagnose issues, and set up alerts for critical metrics.

## Deployment

To deploy the infrastructure and the Python web application, follow these steps:

1. Clone this repository.
2. Update the configuration files with your specific details (e.g., resource names, region).
3. Use Azure CLI or Azure PowerShell to deploy the resources.
