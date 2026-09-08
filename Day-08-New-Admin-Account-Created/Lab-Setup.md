# Lab Setup

## Purpose

This lab demonstrates the detection and investigation of a controlled scenario where an attacker uses a previously obtained privileged Windows account and creates a local account on the Windows victim, then adds that account to the local `Administrators` group. The scenario is designed to generate Windows Security events that can be investigated with Splunk.

## Windows Victim

The Windows victim is the destination system where the new local account is created and inserted into the local `Administrators` group.

To identify the Windows host IP address, use:

```powershell
ipconfig
```

Example placeholder:

```text
Windows IP: [WINDOWS_IP]
```

The host must be verified against the lab environment before using the IP in queries or screenshots.

## Existing Privileged Account

The lab already contains an existing highly privileged local account named `itadmin`. This account represents the previously obtained privileged access from Day 07. It is the account used in this exercise to simulate SSH access from Kali Linux.

The use of `itadmin` is part of this controlled lab and should be treated as a privileged account that requires careful investigation and correlation with change-management records.

## Kali Linux Attacker Source System

Kali Linux acts as the attacker/source system in the scenario. The attacker has already obtained access through the privileged `itadmin` account and is simulating a follow-on persistence technique by creating another local account and adding it to the local administrators group.

Kali IP:

```text
[KALI_IP]
```

## Splunk

Splunk receives the Windows Security event stream from the Windows victim through the `WinEventLog:Security` Windows security log data source.

The core data source used for analysis is:

```text
WinEventLog:Security
```

Ensure that the Splunk data source is the configured Windows Security log source in the lab environment. The data stream should include Event IDs such as 4720 (user account created), 4732 (member added to a local group), and related authentication and account-management events. In a real environment, field names and source naming may differ depending on the Splunk add-on configuration.

## Lab Assets

| Asset | Role | Value |
|---|---|---|
| Windows Victim | Destination host | `[WINDOWS_IP]` |
| Kali Linux | Attacker/source system | `[KALI_IP]` |
| Splunk | SIEM | `WinEventLog:Security` |
| Privileged Account | Initial access account | `itadmin` |
| New local user | Created by simulated attacker | `backdooruser` or `svc_update` |
| Local group | Elevated membership target | `Administrators` |

## Evidence Handling

All sensitive values—including passwords, hosts, account names that are not part of the approved lab, and results—must be replaced with placeholders or `[INSERT EVIDENCE]` where no real evidence is available. Security-relevant fields that are not known must not be fabricated.
