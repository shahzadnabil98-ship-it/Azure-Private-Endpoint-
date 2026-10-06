# Azure Zero-Trust Storage Architecture with Terraform

This repository contains a modular Terraform architecture designed to deploy a highly secure, isolated storage environment in Microsoft Azure using a Zero-Trust approach.

## Architecture Overview

- **Virtual Network (VNet):** Separated into a workload subnet (`sn-workloads`) and a dedicated Bastion subnet (`AzureBastionSubnet`).
- **Zone-Redundant Storage (ZRS):** An Azure Storage Account hosting Blob and File shares, mirrored across 3 availability zones.
- **Private Endpoints:** Public internet access is completely disabled. Dedicated virtual NICs attach the storage services directly to the internal subnet.
- **Azure Bastion:** A secure, managed HTTPS proxy providing secure browser-based access to internal resources without exposing public IPs or open management ports (like SSH/22).

## File Structure

- `providers.tf`: Configures the AzureRM and Random providers.
- `network.tf`: Defines the VNet, Subnets, Public IP, and Azure Bastion Host.
- `storage.tf`: Provisions the ZRS Storage Account, File Share, and Private Endpoints.
- `compute.tf`: Contains the blueprint for an isolated Ubuntu Linux VM.
- `outputs.tf`: Outputs the private IPs and infrastructure details upon deployment.

## Deployment

1. Login to your Azure account:
   ```bash
   az login
   ```
2. Initialize Terraform and upgrade providers:
   ```bash
   terraform init -upgrade
   ```
3. Deploy the architecture:
   ```bash
   terraform apply -auto-approve
   ```
4. Clean up and destroy resources to avoid ongoing costs:
   ```bash
   terraform destroy -auto-approve
   ```
