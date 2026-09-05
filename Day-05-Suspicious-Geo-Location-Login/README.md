# Day 05 – Suspicious Geo-Location Login Detection

## Objective

Detect and investigate a successful SSH login from an unfamiliar or untrusted source IP when the account normally authenticates from an established trusted baseline.

This exercise demonstrates baseline-based suspicious login detection in an isolated lab. A single anomalous login can be enough to trigger investigation; repetition adds useful context but is not required to create the alert.

## Scenario

The `remoteuser` account normally authenticates from the trusted source IP `192.168.175.130`. Successful authentication from `192.168.175.200` is outside that established baseline and is therefore treated as suspicious for investigation.

Both addresses are private RFC1918 lab addresses. `192.168.175.200` is described only as an untrusted or unrecognized source IP outside the trusted baseline. It is not evidence of a real country, city, ISP, or physical geographic location.

In a real SOC, GeoIP and threat-intelligence enrichment would help determine the actual country, region, ownership, and reputation associated with a public source IP.

> This is suspicious geo-location or source-baseline activity, not Impossible Travel.

### Day 04 versus Day 05

- **Day 04 – Impossible Travel:** a relationship between geographically distant logins occurring within an unrealistic time interval.
- **Day 05 – Suspicious Geo-Location Login:** a login from an unfamiliar or untrusted source or location compared with the account's normal baseline.

Day 05 does not claim geographic travel, and it does not require two logins in different locations. One anomalous successful login can trigger investigation.

## Lab Architecture

| Component | Role | Address or detail |
|---|---|---|
| Kali Linux | Controlled source and SSH activity simulation | `192.168.175.130` and secondary lab IP `192.168.175.200` |
| Ubuntu Linux | Victim system receiving SSH authentication | `192.168.175.134` |
| Splunk Enterprise | SIEM and detection platform | Receives Ubuntu authentication logs |
| Account | Valid lab account | `remoteuser` |
| Log source | Ubuntu SSH authentication records | `/var/log/auth.log` |
| Trusted baseline | Normal source IP | `192.168.175.130` |
| Suspicious source | Untrusted or unrecognized source IP | `192.168.175.200` |

```text
Kali Linux
   |
   | SSH authentication
   | Source: 192.168.175.200
   v
Ubuntu Victim
192.168.175.134
   |
   | /var/log/auth.log
   v
Splunk Enterprise
   |
   v
Detection → Investigation → Response
```

## Attack Simulation

The lab uses Kali to make a normal SSH login and a controlled login bound to the secondary source address. Ubuntu records the successful authentication in `/var/log/auth.log`, and the log is forwarded to Splunk.

See [Attack Simulation](Attack-Simulation.md) for the step-by-step procedure. No real systems or accounts are targeted.

## Detection

Splunk searches successful SSH authentication events for `remoteuser`, extracts the source IP, and compares it with the trusted baseline. Source `192.168.175.200` is returned because it does not match `192.168.175.130`.

See [Splunk Detection](Splunk-Detection.md) and [Splunk Queries](Splunk-Queries.md).

## Investigation

The investigation identifies the affected account, establishes the baseline, finds logins outside that baseline, verifies the repeated confirmed events, and validates the raw Ubuntu records. A real SOC analyst would also check user confirmation, VPN or proxy use, approved travel, device and MFA context, source ownership, GeoIP data, threat intelligence, and post-login behavior.

See [Investigation](Investigation.md).

## Response

Response starts with validating the login and contacting the account owner. If unauthorized, the analyst can lock the account, force a password reset, review sessions and recent authentication activity, investigate post-login actions, and block the source when appropriate.

See [Incident Response](Incident-Response.md) and [Prevention](Prevention.md).

## MITRE ATT&CK

- **T1078 – Valid Accounts:** valid credentials for `remoteuser` were used to authenticate successfully over SSH. The suspicious-source pattern is a detection behavior; T1078 describes the account-use technique.

## Key Findings

- The trusted baseline source was `192.168.175.130`.
- Two confirmed successful logins for `remoteuser` came from untrusted source `192.168.175.200`.
- Confirmed events occurred at `2026-09-04 23:48:53` and `2026-09-05 20:28:29`.
- The private lab IP does not establish a real geographic location or real-world compromise.
- For this controlled exercise, the activity is classified as a **TRUE POSITIVE** for the suspicious-source detection.

## Lessons Learned

- Baselines make an otherwise successful login meaningfully detectable.
- One anomalous source can justify investigation even without a travel calculation.
- IP-only detection needs context because VPNs, proxies, NAT, and mobile networks can change the apparent source.
- GeoIP and threat-intelligence enrichment are useful in production, but private lab addresses cannot provide that real-world context.

## Screenshots

No screenshots are invented or included by this documentation. Capture only the evidence produced in your own lab and follow the checklist in [Screenshots/README.md](Screenshots/README.md).

## Conclusion

This lab demonstrates a complete **Attack → Detection → Investigation → Response** workflow for a successful SSH login outside an account's trusted source baseline. The evidence supports suspicious untrusted-source activity in the lab, while the private RFC1918 addresses prevent any claim about actual geographic origin.

## Lab Disclaimer

This exercise was performed entirely in an isolated lab environment for cybersecurity learning and SOC investigation practice. No real systems or accounts were targeted.
