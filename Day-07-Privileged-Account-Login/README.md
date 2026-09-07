# Day 07 - Privileged Account Login Monitoring

## Overview

A privileged account has elevated permissions that can change system configuration, access protected data, create or remove users, or administer services. Examples include `Administrator`, `Domain Admin`, and `root`.

Privileged accounts are high-value targets because successful use of their credentials can provide broad access and make destructive or persistent actions possible. SOC teams therefore monitor privileged authentication, review the source and timing of each login, and correlate the activity with authorization and endpoint evidence.

This controlled lab creates a local Windows test account named `itadmin`, adds it to the local `Administrators` group, and uses Kali Linux to initiate an SSH login. Splunk is then used to investigate the resulting Windows Security events.

## Objectives

- Create a controlled privileged test account
- Perform an SSH login from Kali Linux
- Generate Windows authentication and security events
- Investigate the activity using Splunk
- Identify privileged authentication activity
- Analyze source IP and logon information
- Map the activity to MITRE ATT&CK
- Document the investigation and response

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

| Component | Role | Evidence |
|---|---|---|
| Kali Linux | Source system for the controlled SSH login | [INSERT KALI IP] |
| Windows victim | Destination system with the privileged test account | [INSERT WINDOWS IP] |
| Splunk | SIEM used to search Windows Security events | [INSERT SPLUNK INDEX/SOURCE] |
| Test account | Local privileged account | `itadmin` |
| Authentication | Remote access protocol | SSH |

## Key Evidence

Record only values confirmed in the lab:

- Windows IP: `[INSERT WINDOWS IP]`
- Kali IP: `[INSERT KALI IP]`
- Test account: `itadmin`
- Authentication timestamp: `[INSERT TIMESTAMP]`
- Successful logon event: Event ID `4624` / `[INSERT SPLUNK RESULT]`
- Special privileges event: Event ID `4672` / `[INSERT SPLUNK RESULT]`
- Source Network Address: `[INSERT SOURCE NETWORK ADDRESS]`
- Logon Type: `[INSERT LOGON TYPE FROM EVENT]`

## Investigation Workflow

**Simulation -> Detection -> Evidence Correlation -> Assessment -> Response -> Prevention**

The presence of a privileged authentication event does not by itself prove malicious activity. The analyst must verify whether the account, source, time, and action were expected.

## Documentation

- [Lab Setup](Lab-Setup.md)
- [Attack Simulation](Attack-Simulation.md)
- [Detection](Detection.md)
- [Splunk Queries](Splunk-Queries.md)
- [Investigation](Investigation.md)
- [MITRE Mapping](MITRE-Mapping.md)
- [Incident Response](Incident-Response.md)
- [Prevention](Prevention.md)
- [Incident Report](Incident-Report.md)
- [Screenshot Checklist](Screenshots/README.md)

## Lab Limitations

- This is a controlled lab using an intentionally created privileged test account.
- Private IP addresses are not public threat-intelligence indicators.
- External reputation services such as AbuseIPDB should not be expected to provide meaningful results for RFC1918/private lab addresses.
- Geolocation should not be inferred from private IP addresses.
- Event IDs and field names may vary depending on Windows, OpenSSH, Splunk, and the installed Splunk add-ons.
- No passwords, API keys, tokens, screenshots, IP addresses, timestamps, Splunk results, or final findings are fabricated in this documentation.
