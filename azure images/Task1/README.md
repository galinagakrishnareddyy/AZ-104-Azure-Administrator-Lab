# AZ-104 Task 1 – Azure Managed Disk

## Objective
Use Azure Cloud Shell with PowerShell to create a Resource Group and an Azure-managed disk, then configure the disk by increasing its size and adding tags.

## Environment
- Subscription: Azure for Students
- Region used: Central India (`centralindia`)
- Resource Group: `rg-az104-task1`
- Managed Disk: `disk-az104-task1`

## Execution Summary
1. Opened Azure Cloud Shell with PowerShell.
2. Verified the Azure context with `Get-AzContext`.
3. Created Resource Group `rg-az104-task1` in Central India.
4. Created `disk-az104-task1` as a 32-GB Standard_LRS managed disk.
5. Resized the disk from 32 GB to 64 GB.
6. Added tags:
   - `Environment = Training`
   - `Task = AZ104-Task1`
7. Performed final PowerShell verification.

## Commands Executed
```powershell
Get-AzContext

New-AzResourceGroup -Name "rg-az104-task1" -Location "centralindia"

$diskConfig = New-AzDiskConfig `
    -Location "centralindia" `
    -CreateOption Empty `
    -DiskSizeGB 32 `
    -SkuName Standard_LRS

New-AzDisk `
    -ResourceGroupName "rg-az104-task1" `
    -DiskName "disk-az104-task1" `
    -Disk $diskConfig

$disk = Get-AzDisk `
    -ResourceGroupName "rg-az104-task1" `
    -DiskName "disk-az104-task1"

$disk.DiskSizeGB = 64

# Tags were applied separately after the first Update-AzDisk attempt
$tags = @{
    Environment = "Training"
    Task = "AZ104-Task1"
}

Update-AzTag `
    -ResourceId "/subscriptions/<subscription-id>/resourceGroups/rg-az104-task1/providers/Microsoft.Compute/disks/disk-az104-task1" `
    -Tag $tags `
    -Operation Merge

Get-AzDisk `
    -ResourceGroupName "rg-az104-task1" `
    -DiskName "disk-az104-task1" |
    Select-Object Name, DiskSizeGB, Tags
```

## Final Result
`disk-az104-task1` was verified with:
- Disk size: **64 GB**
- `Environment=Training`
- `Task=AZ104-Task1`

## Evidence
| Screenshot | Evidence |
|---|---|
| T1-01 | Azure context / subscription verified |
| T1-02 | Resource Group created successfully |
| T1-03 | Managed disk created successfully at 32 GB |
| T1-04 | Initial tag command issue shown before correction |
| T1-05 | Disk resize to 64 GB succeeded |
| T1-06 | Final size and tags verified |

## Note
Secrets such as passwords, storage keys, SAS tokens, access tokens, and private keys must not be committed to Git.
