# Scripts

The Terraform files in the project are the primary deployment method.

The optional Azure CLI commands below can be used for quick verification after deployment:

```bash
az group show --name RG-AzureNetworking-Lab
az network vnet show --resource-group RG-AzureNetworking-Lab --name VNet-Lab
az vm list --resource-group RG-AzureNetworking-Lab --output table
az network public-ip list --resource-group RG-AzureNetworking-Lab --output table
```
