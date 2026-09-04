# Day 04 – Impossible Travel Login Detection

## Overview

This controlled SOC investigation lab demonstrates how to identify a potential Impossible Travel login pattern using Ubuntu SSH authentication logs and Splunk. The activity is a personal lab simulation, not a real-world compromise.

## Environment

- Kali Linux: source and activity simulation
- Ubuntu Linux: victim/target system
- Splunk: SIEM and investigation platform
- SSH: authentication protocol
- `/var/log/auth.log`: Ubuntu authentication log source

## Scenario

The `remoteuser` account successfully authenticated from one private source address and then from a different private source address within a short interval. This creates the following behavioral pattern:

> Same account + different source IP + short time interval = potential Impossible Travel indicator

## Detection Result

Two successful SSH authentications were observed for `remoteuser`:

| Approximate timestamp | Source IP | Authentication |
|---|---|---|
| 2026-09-04 23:47:42 | `192.168.175.200` | Accepted password |
| 2026-09-04 23:48:53 | `192.168.175.130` | Accepted password |

The interval was approximately **1 minute and 11 seconds**.

## Important Limitation

Both addresses are private RFC1918 lab addresses. They do not establish geographic locations, so this lab demonstrates the behavioral detection pattern only. It does not prove real geographic travel or a confirmed compromise.

## MITRE ATT&CK

- **T1078 – Valid Accounts**: the activity concerns successful authentication using a valid account. Impossible Travel is a behavioral detection pattern, not a separate ATT&CK technique.

## Documentation

- [Attack Simulation](Attack-Simulation.md)
- [Detection and Investigation](Detection-and-Investigation.md)
- [Splunk Queries](Splunk-Queries.md)
- [Investigation Workflow](Investigation-Workflow.md)
- [Prevention and Response](Prevention-and-Response.md)
- [Incident Report](Incident-Report.md)
- [Screenshot Evidence](Screenshots/README.md)
