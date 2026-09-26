# AZ-104 Task 2 – Manage Microsoft Entra ID Identities

## Objective
Demonstrate Microsoft Entra ID user management, Assigned/Dynamic security groups, tenant creation, and B2B guest-user management.

## Execution Summary

### 1. Cloud-only user
Required by the lab:
- User: `az104-user1`
- Display name: `AZ104 User 1`
- Configure Job Title and Department.

**Status:** Blocked in the current K L University tenant because the required internal-user creation permission was not available.

### 2. Assigned security group
Required configuration:
- Group type: Security
- Group name: `AZ104-Assigned-Group`
- Membership type: Assigned
- Owner: self
- Intended member: the Task 1 cloud-only user.

**Status:** Created successfully. The member could not be added because the required Task 1 cloud-only user was not available.

### 3. Dynamic security group
Required configuration:
- Group type: Security
- Membership type: Dynamic User
- Dynamic rule: `jobTitle` equals the exact Job Title of the Task 1 user.

**Status:** Blocked. Opening the Dynamic User rule builder returned a `401 – You do not have access` error.

### 4. Microsoft Entra tenant
Required configuration:
- Workforce/organizational tenant
- Unique organization/domain name
- Country/Region

**Status:** Blocked. The Azure for Students subscription did not appear as an available subscription in the tenant-creation flow used in this environment.

### 5. Guest user
Created an external B2B guest user:
- Display name: `AZ104 Guest User`
- User type: Guest
- Creation type: Invitation
- Invitation state: Accepted
- Account status: Enabled

**Status:** Completed.

## Evidence

| Screenshot | Evidence |
|---|---|
| T2-01-Groups-All-Groups.png | Microsoft Entra Groups → All groups |
| T2-02-Dynamic-Group-Form.png | Dynamic User group configuration attempt |
| T2-03-Guest-Invitation-Basics.png | Guest invitation details |
| T2-04-Guest-Invitation-Assignments.png | Guest invitation assignments step |
| T2-05-Guest-Invitation-Review.png | Review + invite confirmation |
| T2-06-Guest-User-Invited.png | Guest user appears in All users |
| T2-07-Invitation-Accepted.png | Guest account signed in after invitation redemption |
| T2-08-Guest-User-Overview.png | Guest user overview showing guest/B2B state |
| T2-09-Guest-User-Properties.png | Guest properties and Invitation State = Accepted |

## Notes
The screenshots in this folder are actual execution evidence from the lab session. Blocked activities are documented as blocked rather than represented as successful.

To submit through the existing Task 1 Git repository, copy the `Task2` folder into:

`D:\Azure\Task1\AZ104_Task1_Git\`

Then run:

```cmd
git add Task2
git commit -m "Add AZ-104 Task 2 documentation and screenshots"
git push
```
