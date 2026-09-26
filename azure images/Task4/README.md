# Azure Networking Lab – VNet, VMs, NSG & DNS

This project implements the Azure networking lab from **AZ-104 Session 4** using Terraform.

## What this project creates

- Resource Group: `RG-AzureNetworking-Lab`
- Virtual Network: `VNet-Lab`
- VNet address space: `10.10.0.0/16`
- `WebSubnet`: `10.10.1.0/24`
- `DBSubnet`: `10.10.2.0/24`
- Two Linux VMs:
  - `VM01` in WebSubnet
  - `VM02` in DBSubnet
- Private and public IP configuration
- Network Security Group with SSH and HTTP rules
- Azure Private DNS Zone for internal name resolution
- DNS links to the VNet
- Optional Azure Public DNS Zone for external name resolution

The resource names and network ranges follow the uploaded AZ-104 Session 4 lab material. fileciteturn0file0L76-L85 fileciteturn0file0L92-L125

## Architecture

```text
                    Internet
                       |
                 Public IPs
                  /       \
               VM01       VM02
                |           |
          WebSubnet      DBSubnet
        10.10.1.0/24   10.10.2.0/24
                \         /
                 VNet-Lab
                10.10.0.0/16
                       |
              Private DNS Zone
```

## Prerequisites

1. Azure subscription
2. Azure CLI
3. Terraform >= 1.6
4. An SSH key pair

Login:

```bash
az login
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

## Configure variables

Copy the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and provide your subscription ID, admin username, SSH public key, and region.

> Do not commit `terraform.tfvars` because it may contain environment-specific values.

## Deploy

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Type `yes` when prompted.

## Get VM details

```bash
terraform output
```

The outputs include the VM private/public IP addresses and DNS names.

## Test connectivity

SSH to VM01:

```bash
ssh <admin_username>@<VM01_PUBLIC_IP>
```

SSH to VM02:

```bash
ssh <admin_username>@<VM02_PUBLIC_IP>
```

Internal DNS names are:

```text
vm01.internal.example
vm02.internal.example
```

The exact FQDNs are also available through Terraform outputs.

## Optional public DNS

If you own a domain, set:

```hcl
enable_public_dns = true
public_dns_zone   = "example.com"
```

Then apply:

```bash
terraform apply
```

You must delegate the domain's name servers to the Azure DNS name servers shown in:

```bash
terraform output public_dns_name_servers
```

Do not use a domain you do not control.

## Destroy resources

When finished with the lab:

```bash
terraform destroy
```

## GitHub

Recommended commands:

```bash
git init
git add .
git commit -m "Add Azure networking lab with Terraform"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/azure-networking-lab.git
git push -u origin main
```
