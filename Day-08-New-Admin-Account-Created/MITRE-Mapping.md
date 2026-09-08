# MITRE Mapping

## MITRE ATT&CK Mapping

This lab demonstrates behavior relevant to MITRE ATT&CK enterprise tactics and techniques for account manipulation, persistence, privilege escalation, and defense evasion. The key objective is to connect event evidence to operational behavior rather than to make unsupported claims.

## Technique Mapping

### T1136 — Create Account

The creation of a new local Windows user account represents a form of account creation. In this scenario, a new local account such as `backdooruser` or `svc_update` is created on the Windows host.

Evidence pattern:

- Event ID `4720` — A user account was created.
- `Target Account Name` = newly created local account.
- `Subject Account Name` = account that initiated creation.

### T1098 — Account Manipulation

The creation of the account and subsequent placement of that account into a privileged group is consistent with account manipulation. Attackers may create account objects or alter group membership to preserve access.

Evidence pattern:

- Event ID `4720`
- Event ID `4732`
- `Member Name` and `Group Name` fields identify the relationship.

### T1078 — Valid Accounts

The attacker scenario begins with the use of an existing privileged account named `itadmin`. The account is an example of a legitimate yet powerful credential that can be abused. Valid accounts are a recognized ATT&CK technique because compromised accounts can be used for access.

Evidence pattern:

- SSH session from `Kali Linux` to `Windows Victim`
- `itadmin` account used as subject account in event logs
- Potential use of remote administrative protocol

### T1098.003 — Additional Cloud Roles / Local Account

In a Windows local environment, the administrative group change is the relevant local-account persistence technique pattern. The attacker creates a new account and adds it to a privileged local group, which can enable long-term unauthorized access.

Evidence pattern:

- Event ID `4720` and `4732`
- `Member Name` appearing in `Administrators`

### T1543.003 — Windows Service Creation

Although this lab scenario does not create a service directly, service-like names such as `svc_update` are included as examples of naming patterns that may blend into legitimate maintenance. Attackers may choose service-like names to mask activity. The SOC should avoid assuming malicious intent from the name alone.

## Tactic Mapping

| ATT&CK Tactic | Event or Behavior |
|---|---|
| Persistence | New local account and membership in `Administrators` |
| Privilege Escalation | Local `Administrators` group membership |
| Defense Evasion | Naming of new user object to blend in with legitimate activity |
| Credential Access | Existing privileged account used to create a new account |
| Initial Access or Valid Accounts | Use of `itadmin` to access the Windows machine |

## Important Clarification

MITRE ATT&CK mapping is a modeling framework. It does not replace investigative evidence. The analyst must verify that the account created and the group membership change correspond to the actual environment and are supported by event logs, host evidence, privilege context, and organizational records.
