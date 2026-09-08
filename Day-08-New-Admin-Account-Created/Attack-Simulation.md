# Attack Simulation — Unauthorized Admin Account Creation

## Controlled Simulation Notice

This lab is a controlled cybersecurity simulation. The goal is to demonstrate how unauthorized account creation and privileged group membership changes can be investigated in a Windows environment. The scenario does not represent a real production environment and must be treated as a demonstration of security event generation, evidence correlation, and SOC investigation practice.

In the scenario, the attacker has already obtained access to a Windows machine via the privileged account `itadmin` from the previous lab day. The attacker then creates a new local account and adds that account to the local `Administrators` group.

## Step 1 — SSH Access

Use the following SSH command from the Kali Linux attacker/source system to reach the Windows victim through an SSH session:

```bash
ssh itadmin@[WINDOWS_IP]
```

Do not include the actual password in the documentation. Replace it with a placeholder such as `[LAB_PASSWORD]` in the commands or notes. The point of the simulation is that the attacker is using previously obtained privileged credentials, represented in this lab by the `itadmin` account.

The account `itadmin` is a privileged account. Its use should be investigated in context. An SSH login using the account does not, by itself, prove malicious activity. It is the subsequent account creation and group changes that must be examined with supporting evidence.

## Step 2 — Method A: Command Line

The attacker may create a local user account and assign that account to the local `Administrators` group by using the command line. This is a common path when an attacker already has a Windows session with privileged rights.

```powershell
net user backdooruser <LAB_PASSWORD> /add
net localgroup Administrators backdooruser /add
```

The command `net user backdooruser <LAB_PASSWORD> /add` creates a new local account named `backdooruser` with a password represented by the placeholder `<LAB_PASSWORD>`. The command `net localgroup Administrators backdooruser /add` adds that newly created account to the local `Administrators` group.

The account name `backdooruser` is deliberately recognizable as a suspicious example. In a real investigation, the account may use a misleading name such as `svc_update`, `svc_backup`, or `sql_admin`, and the analyst must avoid concluding malicious intent based on naming alone.

## Step 3 — Method B: PowerShell

PowerShell can also be used to create the account and grant local administrator group membership. The following structure is an alternative documentation example:

```powershell
New-LocalUser -Name "svc_update" -Password (ConvertTo-SecureString "<LAB_PASSWORD>" -AsPlainText -Force) -PasswordNeverExpires
Add-LocalGroupMember -Group "Administrators" -Member "svc_update"
```

This technique creates a new local user named `svc_update` and adds it to the `Administrators` group. The account name is intentionally chosen so that it may appear service-like or legitimate in context. Attackers can choose such names to blend in with expected administrative or IT operations. However, naming alone is not sufficient evidence of malicious activity.

Other example names that may be used in this lab or discussed in detection contexts include:

```text
svc_update
svc_backup
sql_admin
helpdesk_temp
```

These names should only be used as examples of attacker creativity or naming conventions. They do not indicate malicious activity without additional evidence such as event correlation, an approval mismatch, unusual timing, or post-creation activity.

## Step 4 — Verify Account Creation

After the account is created, verify the account is visible locally:

```powershell
net user
```

Observe the new local account in the account list and confirm that it appears as a newly created identity on the Windows host.

```text
[INSERT SCREENSHOT — NEW ACCOUNT LIST]
```

## Evidence Considerations

The lab must document what event IDs were generated for:

- Account creation (`Event ID 4720`)
- Local group membership change (`Event ID 4732`)
- Potential security group changes (`Event ID 4728` if global groups are relevant)

The final determination of unauthorized persistence must be based on evidence such as the `Subject Account Name`, `Subject Logon ID`, `Target Account Name`, `Member Name`, relevant timestamps, and the presence or absence of an approved IT change request.
