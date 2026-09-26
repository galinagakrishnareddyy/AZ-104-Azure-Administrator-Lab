# AZ-104 Session 3 – Task 3

## Title
Deploy Resource to Existing Resource Group, Move Resource Between Resource Groups, and Implement/Test a Resource Lock.

## Objectives
1. Deploy a resource to an existing Resource Group.
2. Move the resource between Resource Groups.
3. Implement and test a Delete resource lock.

## Environment
- Platform: Microsoft Azure
- Subscription: Azure for Students
- Resource type: Storage Account
- Source Resource Group: `az104-rg-demo`
- Destination Resource Group: `az104-rg-target`
- Example storage account: `az104storagedemo`
- Region in the PPT: East US
- Lock name: `PreventDelete-Demo`
- Lock type: Delete

## Task 1 – Deploy a resource to an existing Resource Group
A Storage Account is deployed by selecting the already-created `az104-rg-demo` under Project details instead of creating a new Resource Group. After deployment, the resource's Overview page is checked to confirm the Resource Group.

**Expected verification:** the Storage Account appears in `az104-rg-demo`.

## Task 2 – Move the resource between Resource Groups
The Storage Account is selected from `az104-rg-demo` and moved using:
**Move → Move to another resource group**.

The destination Resource Group is `az104-rg-target`. After validation and the move, the resource is checked in the destination group and confirmed to be absent from the source group.

## Task 3 – Implement and test a resource lock
A Delete lock named `PreventDelete-Demo` is created on the Storage Account.

The lock is tested by attempting to delete the Storage Account. The deletion is blocked while the lock is present. The lock can then be removed when cleanup is required.

## Screenshot Evidence
- `T3-01-Resource-Deployment.png` – resource deployment evidence.
- `T3-02-Resource-Moved.png` – resource move evidence.
- `T3-03-Delete-Lock-Created.png` – Delete lock creation evidence.
- `T3-04-Delete-Blocked.png` – deletion blocked by the lock.

## Result
The Task 3 workflow covers deployment to an existing Resource Group, moving a supported resource to another Resource Group, and protecting a resource with a Delete lock.

## Cleanup
If the resources are no longer needed, remove the lab resources/resource groups according to the course instructions to avoid ongoing charges.
