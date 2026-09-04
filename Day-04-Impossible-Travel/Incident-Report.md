# Incident Report

## 1. Incident Title

Potential Impossible Travel Login Pattern – Controlled Lab Simulation

## 2. Incident Type

Suspicious successful SSH authentication sequence

## 3. Severity

Low for this controlled lab. Severity in production would depend on identity, device, location, MFA, and post-login evidence.

## 4. Status

Closed as a controlled lab simulation; no real-world compromise is claimed.

## 5. Detection Source

Splunk searches against Ubuntu `/var/log/auth.log`.

## 6. Affected Account

`remoteuser`

## 7. Source IP 1

`192.168.175.200` – successful SSH authentication at `2026-09-04 23:47:42`.

## 8. Source IP 2

`192.168.175.130` – successful SSH authentication at `2026-09-04 23:48:53`.

## 9. Timeline

| Time | Event |
|---|---|
| 2026-09-04 23:47:42 | Accepted password for `remoteuser` from `192.168.175.200`. |
| 2026-09-04 23:48:53 | Accepted password for `remoteuser` from `192.168.175.130`. |
| Interval | Approximately 1 minute and 11 seconds. |

## 10. Detection Logic

The detection identified successful authentication for the same account, extracted both source IPs, sorted events chronologically, compared the current source with the previous source, and filtered for a changed source with a time interval under 60 minutes.

## 11. Investigation

Splunk extracted `remoteuser`, `src_ip`, `_time`, the previous source IP, and the time difference. A reverse-ordered investigation displayed approximately `-1.18` minutes; this was an event-ordering artifact, not negative travel time. Chronological ordering is required.

## 12. Evidence

- Successful SSH login from `192.168.175.130`.
- Successful SSH login from `192.168.175.200`.
- Splunk source-IP extraction.
- Splunk correlation showing the changed source and short interval.
- Ubuntu `/var/log/auth.log` verification.

### Screenshot Placeholders

![Evidence 01 - First Successful Login](Screenshots/01-first-login.png)

![Evidence 02 - Second Successful Login](Screenshots/02-second-login.png)

![Evidence 03 - Splunk Source IP Extraction](Screenshots/03-splunk-source-ip.png)

![Evidence 04 - Impossible Travel Correlation](Screenshots/04-impossible-travel-detection.png)

![Evidence 05 - Ubuntu Auth Log](Screenshots/05-auth-log.png)

See [Screenshots/README.md](Screenshots/README.md) for capture instructions.

## 13. Analysis

The events show the same valid account authenticating successfully from two different private source addresses within approximately 1 minute and 11 seconds. This is a potential Impossible Travel login pattern simulation. Private RFC1918 addresses cannot establish actual geographic travel.

## 14. MITRE ATT&CK Mapping

**T1078 – Valid Accounts.** The observed activity concerns successful authentication using a valid account. The Impossible Travel condition is a behavioral detection pattern rather than a separate MITRE technique.

## 15. False Positive Considerations

Possible explanations include corporate VPN use, legitimate remote work, cloud proxies, mobile network changes, NAT, travel, remote desktop infrastructure, authorized security testing, or this lab simulation. Impossible Travel is an indicator, not automatic proof of account compromise.

## 16. Response Recommendations

Validate the user, review authentication and MFA history, identify the device, investigate post-login activity, restrict or disable the account if compromise is confirmed, revoke sessions where appropriate, reset credentials if necessary, block malicious infrastructure when appropriate, and document the case.

## 17. Limitations

The IPs are private lab addresses. No city, country, geographic route, MFA result, device identity, or post-login activity was provided. Geographic travel and compromise cannot be established from this evidence alone.

## 18. Final Verdict

**Potential Impossible Travel login pattern detected in a controlled lab environment.**

Two successful SSH authentications were observed for the same account, `remoteuser`, from different private source IP addresses within a short time interval. The activity demonstrates the behavioral pattern that a SOC could investigate as a potential Impossible Travel event. Because the addresses are private lab IPs, actual geographic travel cannot be established from this evidence alone.
