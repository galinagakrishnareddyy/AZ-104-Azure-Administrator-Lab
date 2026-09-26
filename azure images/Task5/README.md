# AZ-104 Session 5 – Azure VM, Storage, Blob & Azure Files Lab

A GitHub-ready Terraform project based on **Microsoft Azure Administrator Associate (AZ-104) Session 5**.

## Lab objectives

- Deploy an Azure Virtual Machine
- Create and configure an Azure Storage Account
- Manage Blob Storage
- Configure authentication and authorization for Azure Storage
- Create and configure an Azure Files share

These objectives and the lab terminology are taken from the uploaded AZ-104 Session 5 material. fileciteturn1file0L31-L35

## Architecture

```text
                         Azure Resource Group
                       RG-AZ104-Storage-Lab
                                |
              +-----------------+-----------------+
              |                                   |
        Storage Account                         VM01
              |                                   |
       +------+-------+                       NIC + Public IP
       |              |
   Blob Container   Azure File Share
   labcontainer       labshare
       |
    sample blob

Storage security:
- Microsoft Entra/RBAC-ready role assignment
- Storage account key authentication
- Optional SAS generation through Azure CLI
- HTTPS-only transfer
```

## Resources created

### Compute
- Linux VM: `VM01`
- Ubuntu 24.04 LTS
- Standard B1s by default
- SSH authentication
- Public IP
- Network interface
- Virtual network and subnet
- NSG allowing SSH and HTTP

### Storage
- General-purpose v2 Storage Account
- Standard performance
- LRS redundancy
- Private blob container: `labcontainer`
- Azure Files share: `labshare`
- HTTPS-only traffic
- Minimum TLS 1.2
- Storage account public network access enabled for this lab

The source material specifies Standard performance and LRS redundancy for the storage account. fileciteturn1file0L79-L100

The source material uses `labcontainer` as the example blob container. fileciteturn1file0L113-L133

The source material uses `labshare` as the example Azure Files share. fileciteturn1file0L179-L196

## Prerequisites

Install:

- Azure CLI
- Terraform >= 1.6
- Git
- An Azure subscription

Login:

```bash
az login
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

Create an SSH key if you do not already have one:

```bash
ssh-keygen -t ed25519 -C "az104-lab"
```

## Configure the project

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
subscription_id    = "YOUR-SUBSCRIPTION-ID"
admin_username     = "azureuser"
ssh_public_key     = "YOUR-SSH-PUBLIC-KEY"
allowed_ssh_source = "YOUR.PUBLIC.IP/32"
```

`terraform.tfvars` is ignored by Git so secrets/environment-specific values are not committed.

## Deploy

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

After deployment:

```bash
terraform output
```

## Upload a blob

The container is created automatically.

Upload a local file:

```bash
az storage blob upload \
  --account-name <STORAGE_ACCOUNT_NAME> \
  --container-name labcontainer \
  --name sample.txt \
  --file ./sample.txt \
  --auth-mode login
```

The source lab asks students to create a container, upload a sample file, verify the blob, inspect properties, download, rename/delete, and explore access tiers. fileciteturn1file0L113-L133

## Storage authorization

The project creates the storage account with RBAC-compatible configuration.

To assign the Blob Data Contributor role to your signed-in Azure identity:

```bash
STORAGE_ID=$(terraform output -raw storage_account_id)

az role assignment create \
  --assignee "$(az ad signed-in-user show --query id -o tsv)" \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_ID"
```

The source material lists Storage Blob Data Reader, Contributor, and Owner as example storage roles. fileciteturn1file0L146-L155

## SAS

A SAS can be generated for controlled temporary access. The source material covers allowed services, resource types, permissions, start/expiry time, and testing SAS access. fileciteturn1file0L156-L165

Example:

```bash
az storage container generate-sas \
  --account-name <STORAGE_ACCOUNT_NAME> \
  --name labcontainer \
  --permissions rl \
  --expiry 2026-12-31T23:59Z \
  --auth-mode login \
  --as-user \
  --https-only \
  --output tsv
```

Do not commit SAS tokens to GitHub.

## Azure Files

The `labshare` file share is created automatically.

List files:

```bash
az storage file list \
  --account-name <STORAGE_ACCOUNT_NAME> \
  --share-name labshare \
  --auth-mode login
```

The source lab asks students to upload a sample document, use Connect to obtain a Windows/Linux mount command, execute it, and verify file/folder changes. fileciteturn1file0L179-L196

## VM connection

Get the public IP:

```bash
terraform output vm_public_ip
```

Connect:

```bash
ssh azureuser@<VM_PUBLIC_IP>
```

## Verification

Run:

```bash
az vm list -g RG-AZ104-Storage-Lab -o table
az storage account show -g RG-AZ104-Storage-Lab -n <STORAGE_ACCOUNT_NAME> -o table
az storage container list --account-name <STORAGE_ACCOUNT_NAME> --auth-mode login
az storage share-rm list -g RG-AZ104-Storage-Lab --storage-account <STORAGE_ACCOUNT_NAME>
```

## Destroy the lab

Azure resources can generate charges. Destroy the lab when finished:

```bash
terraform destroy
```

## GitHub

```bash
git init
git add .
git commit -m "Add AZ-104 Session 5 Azure storage lab"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/az104-session5-storage-lab.git
git push -u origin main
```

## Project structure

```text
azure-storage-vm-lab/
├── .github/
│   └── workflows/
│       └── terraform.yml
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── .gitignore
├── LICENSE
└── README.md
```
