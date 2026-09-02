# Day 02 - SSH Brute Force Investigation

## Objective

This controlled lab investigation demonstrates how a SOC analyst detects, investigates, validates, and contains SSH brute-force/password-guessing activity.

## Lab Environment

| Component | Role |
|---|---|
| Kali Linux | Attacker simulation machine |
| Ubuntu Linux | Target/victim lab machine |
| Wazuh | SIEM and security monitoring |
| Hydra | Controlled password-guessing simulation tool |
| SSH | Target service |
| UFW | Firewall used for lab containment |

All activity was performed in an isolated personal lab. No real-world systems were targeted.

## Attack Simulation

Nmap confirmed that the Ubuntu lab host was reachable and that TCP port 22 was open for SSH. Hydra then tested **6 passwords** against the dedicated `testuser` account over SSH.

Result: **0 valid passwords found**. The controlled test was therefore an unsuccessful password-guessing attempt.

## Detection

Wazuh detected authentication failures through:

- Rule `5503`: `PAM: User login failed.`
- Rule `5760`: `sshd: authentication failed.`

Both rules were level 5 alerts associated with SSH/PAM authentication failure activity.

## Investigation

Wazuh event details identified the target account as `testuser`, the SSH decoder as `sshd`, and the source as the identified lab source system. Ubuntu `/var/log/auth.log` entries independently validated the failed SSH authentication events. Authentication-success events were reviewed separately; dashboard successes were not assumed to be related to Hydra without timestamp, source, account, and SSH-context correlation.

Wazuh search counts are time-range results, not Hydra-attempt counts. The combined rule query returned 27 hits and the source/target pivot returned 69 hits in their selected ranges. The Hydra test itself generated 6 attempts.

## Evidence

| Screenshot | What it proves |
|---|---|
| [01-nmap-ssh-open.png](Screenshots/01-nmap-ssh-open.png) | The Ubuntu lab host was reachable and TCP 22/SSH was open, establishing the lab attack surface. |
| [02-hydra-bruteforce.png](Screenshots/02-hydra-bruteforce.png) | Hydra tested 6 passwords against `testuser` and found 0 valid passwords. |
| [03-wazuh-dashboard.png](Screenshots/03-wazuh-dashboard.png) | Wazuh Threat Hunting showed authentication-failure activity. |
| [04-wazuh-rule-5503.png](Screenshots/04-wazuh-rule-5503.png) | Rule `5503` returned `PAM: User login failed.` at level 5; 4 hits were visible in that query result. |
| [05-wazuh-rule-5760.png](Screenshots/05-wazuh-rule-5760.png) | Rule `5760` returned `sshd: authentication failed.` at level 5 with multiple events. |
| [06-wazuh-combined.png](Screenshots/06-wazuh-combined.png) | Rules `5760` and `5503` were correlated; 27 hits were visible in the selected time range, not 27 Hydra attempts. |
| [07-wazuh-document-details.png](Screenshots/07-wazuh-document-details.png) | Event details connected failed SSH authentication for `testuser` to the identified lab source through `sshd`, journald, and rule metadata. |
| [08-wazuh-source-search.png](Screenshots/08-wazuh-source-search.png) | A source/target pivot returned 69 hits in the selected range; this is correlation evidence, not an exact Hydra-attempt count. |
| [09-wazuh-authentication-success.png](Screenshots/09-wazuh-authentication-success.png) | Authentication-success events were reviewed separately to assess possible compromise. |
| [10-auth-log.png](Screenshots/10-auth-log.png) | Ubuntu raw authentication logs validated repeated failed SSH authentication for `testuser`. |
| [11-ufw-block.png](Screenshots/11-ufw-block.png) | UFW was active and denied inbound traffic from the identified lab source as controlled-lab containment. |
| [12-password-status.png](Screenshots/12-password-status.png) | `testuser` password status was checked without exposing any password value. |

## Containment

UFW was enabled on Ubuntu and a deny rule was added for the identified lab source. The firewall status was then verified. This was containment performed only within the controlled lab.

## MITRE ATT&CK

**T1110.001 - Password Guessing**

## Final Verdict

**True Positive - Unsuccessful Password Guessing Attempt**

- Incident type: SSH Brute Force / Password Guessing Attempt
- Severity: Medium
- Status: Closed
- Target: SSH service and `testuser` account
- Detection: Wazuh

## Key Learning

- SSH authentication logging
- Wazuh rule analysis
- Source and target identification
- Event correlation
- Success-versus-failure validation
- Firewall containment
