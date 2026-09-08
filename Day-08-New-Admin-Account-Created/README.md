# Day 08 — New Admin Account Created

## Overview

A local user account is an identity stored directly on a Windows host. It can be used to log on to that system and may be assigned rights and permissions according to the role or access model defined by the administrator. A privileged account is an account that belongs to, or can receive, elevated rights such as local Administrators, Domain Admins, or another security group with special control over devices, applications, services, and data.

In this lab, the scenario begins with a previously obtained privileged account named `itadmin` on a Windows victim. The attacker uses that privileged access to create an additional local account and then places that new account into the local Administrators group. This is a direct example of an account-creation and privilege-escalation pattern that can be used for persistence. Attackers may create new accounts to maintain access after a credential or session is removed, to blend in with legitimate activity, or to provide a foothold for repeated use. For a SOC, a newly created administrator account is important because it may represent an unauthorized persistence mechanism or an unapproved change.

The documentation in this day must be interpreted carefully. A new account is not inherently malicious simply because it was created. The investigation must determine whether the creation was expected, whether the caller account was legitimate, whether an approved change request existed, and whether the account performed actions that support the assessed risk.

## Objectives

- Simulate attacker access through SSH
- Create a new local Windows account
- Add the account to the local Administrators group
- Generate Windows Security Events
- Detect account creation using Splunk
- Detect administrator group membership changes
- Correlate Event ID 4720 and Event ID 4732
- Identify the account responsible for the change
- Investigate post-creation activity
- Map the behavior to MITRE ATT&CK
- Produce a SOC-style incident report

## Lab Architecture

```text
Kali Linux
    |
    | SSH
    v
Windows Victim
    |
    | Windows Security Logs
    v
Splunk
```

The architecture shows a controlled path from a source system, Kali Linux, to the Windows victim through an SSH session using the previously obtained privileged account `itadmin`. Windows Security logs record the event stream, and Splunk is used to collect, search, and correlate the evidence.

## Key Events

| Event ID | Description |
|---|---|
| 4720 | A user account was created |
| 4732 | A member was added to a security-enabled local group |
| 4728 | A member was added to a security-enabled global group |

Event ID 4732 is especially important when the target group is the `Administrators` group because it shows an account being added to a high-impact local group. Event 4720 describes the creation of the new account, while Event 4732 documents the addition of that account to the local group. When correlated, these events form an important account-creation and privilege-escalation pattern. However, SOC analysts must validate context such as the calling account, source host, approval records, and post-creation activity before deciding whether the behavior is truly unauthorized.

## Investigation Workflow

The investigation should collect evidence in the following order:

1. Confirm the newly created account.
2. Confirm who created it by reviewing the `Subject Account Name` and `Subject Logon ID` fields.
3. Confirm whether the account was added to `Administrators` through Event ID 4732.
4. Determine whether the caller account was legitimate and whether the action aligns with an approved change-management record.
5. Review any activity performed by the newly created account.
6. Record the final assessment and verdict with supporting evidence.

The final verdict must be marked `True Positive` only if the collected evidence supports that conclusion.

## Evidence Expectations

The lab documentation intentionally uses placeholders for IPs, passwords, timestamps, and Splunk results. Do not publish or fabricate sensitive values. For missing evidence, use `[INSERT EVIDENCE]` rather than inventing event details.

## Documentation

- [Lab Setup](Lab-Setup.md)
- [Attack Simulation](Attack-Simulation.md)
- [Detection](Detection.md)
- [Splunk Queries](Splunk-Queries.md)
- [Investigation](Investigation.md)
- [MITRE Mapping](MITRE-Mapping.md)
- [Incident Response](Incident-Response.md)
- [Prevention](Prevention.md)
- [Real-World Detection](Real-World-Detection.md)
- [Incident Report](Incident-Report.md)
- [Screenshot Checklist](Screenshots/README.md)
