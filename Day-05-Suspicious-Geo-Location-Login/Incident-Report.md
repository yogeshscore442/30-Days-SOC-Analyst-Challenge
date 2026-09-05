# Security Incident Report

## 1. Incident Summary

**Incident Type:**  
Suspicious Geo-Location / Untrusted Source Login

**Severity:**  
Medium-High

**Status:**  
Investigated

**Detection Source:**  
Splunk

**Log Source:**  
Ubuntu `/var/log/auth.log`

**Affected Account:**  
`remoteuser`

**MITRE ATT&CK:**  
T1078 – Valid Accounts

**Analyst Verdict:**  
True Positive

## 2. Detection

A successful SSH login was observed from a source IP outside the established trusted baseline.

**Trusted:** `192.168.175.130`  
**Suspicious:** `192.168.175.200`

The suspicious source is an untrusted or unrecognized private lab address. It is not evidence of a real country, city, ISP, or physical geographic location. In a real SOC, GeoIP and threat-intelligence enrichment would provide additional public-IP context.

## 3. Attack Simulation

- Kali acted as the controlled source.
- Secondary IP `192.168.175.200` was configured.
- The SSH connection was bound to that source IP.
- Ubuntu at `192.168.175.134` was the victim.
- Valid credentials for `remoteuser` were used.
- Authentication logs were generated in Ubuntu `/var/log/auth.log`.

Command:

```bash
ssh -b 192.168.175.200 remoteuser@192.168.175.134
```

This was a controlled lab simulation and not an attack against a real system.

## 4. Detection Evidence

Splunk query:

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| where NOT src_ip="192.168.175.130"
| table _time, remoteuser, src_ip
```

If the standard Ubuntu raw event does not include a closing parenthesis after the IP, use the same query with `\d+\.\d+\.\d+\.\d+` as the final extraction pattern.

Confirmed events:

```text
2026-09-05 20:28:29 | remoteuser | 192.168.175.200
2026-09-04 23:48:53 | remoteuser | 192.168.175.200
```

## 5. Investigation

The investigation included:

- **Baseline comparison:** compared observed source IPs with trusted `192.168.175.130`.
- **Source IP analysis:** identified `192.168.175.200` as outside the baseline.
- **Repetition check:** confirmed two successful events on different dates.
- **Raw log verification:** validated the expected `Accepted password for remoteuser` pattern in `/var/log/auth.log`.
- **User/account validation:** identified `remoteuser` as the affected account and recommended user confirmation.
- **GeoIP and threat-intelligence enrichment:** identified these as required real-world follow-up checks; no real-world enrichment result is claimed here.
- **Post-login activity review:** identified commands, privilege changes, sessions, MFA, device context, and other authentication events as follow-up areas.

## 6. Indicators of Compromise

**Account:**  
`remoteuser`

**Suspicious Source:**  
`192.168.175.200`

**Trusted Source:**  
`192.168.175.130`

**Timestamps:**

- `2026-09-04 23:48:53`
- `2026-09-05 20:28:29`

These indicators are valid for this isolated lab exercise. The private source IP is not treated as a real-world geographic indicator.

## 7. MITRE ATT&CK

**T1078 – Valid Accounts**

This technique is relevant because valid credentials for `remoteuser` were used to complete a successful SSH authentication. The suspicious-source behavior is the detection context; T1078 describes the use of valid account credentials.

## 8. Response

Recommended response actions:

- Validate the account activity.
- Contact and verify the account owner.
- Force a password reset.
- Lock the account if the activity is unauthorized.
- Review active and recent sessions.
- Investigate post-login activity.
- Block the source when appropriate and after considering VPN, proxy, NAT, and mobile-network context.

## 9. Prevention

Recommended preventive controls include:

- MFA
- SSH keys
- Disabling password authentication where appropriate
- Trusted source-baseline monitoring
- GeoIP enrichment for public addresses
- Conditional Access
- Threat intelligence
- UEBA and anomalous-source alerting
- Account and session monitoring

A simple IP anomaly is not automatically malicious. It requires investigation and context.

## 10. Final Verdict

**TRUE POSITIVE**

The lab demonstrated successful authentication for `remoteuser` from an untrusted source outside the established baseline. The repeated source-baseline deviation supports the detection verdict within this controlled exercise.

The conclusion does not claim that `192.168.175.200` was physically located in another country, and it does not claim a real-world compromise. It is a private RFC1918 lab address.
