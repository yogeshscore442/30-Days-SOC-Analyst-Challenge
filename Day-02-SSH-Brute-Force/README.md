# Day 02 - SSH Brute Force Investigation

## Objective

Understand how a SOC analyst detects, investigates, validates, and contains an SSH brute-force/password-guessing attempt using endpoint logs, Wazuh alerts, and firewall controls.

All activity was performed in an isolated personal lab. No real-world systems were targeted.

## Lab Environment

| Component | Role |
|---|---|
| Kali Linux | Attack simulation machine |
| Ubuntu Linux | Target lab machine |
| Wazuh | SIEM and security monitoring |
| Hydra | Controlled password-guessing simulation tool |
| SSH | Target service |
| UFW | Firewall used for lab containment |

## Attack Simulation

Nmap confirmed that the Ubuntu lab host was reachable and that TCP port 22 was open for SSH. Hydra then tested **6 passwords** against the dedicated `testuser` account over SSH.

**Result:** `0 valid passwords found`

The controlled test was therefore classified as an unsuccessful SSH password-guessing attempt. No password values are documented.

## Detection

Wazuh detected the activity through two relevant level 5 rules:

- Rule `5503`: `PAM: User login failed.`
- Rule `5760`: `sshd: authentication failed.`

The alerts were grouped with SSH, syslog, and authentication-failure context.

## Investigation

The investigation followed a standard SOC workflow:

1. Confirm the exposed SSH service in the lab.
2. Generate controlled authentication failures with Hydra.
3. Validate the activity in Ubuntu `/var/log/auth.log` and journald.
4. Review Wazuh authentication-failure alerts.
5. Identify the target account as `testuser`.
6. Correlate the source system, target account, SSH decoder, and event details.
7. Check authentication-success events separately.
8. Determine whether the controlled password-guessing test succeeded.
9. Apply and verify firewall containment.

Wazuh event details and Ubuntu raw logs confirmed repeated failed SSH authentication for `testuser`. Successful authentication events were not attributed to this activity without matching timestamp, source, target account, and SSH context.

The combined Wazuh rule search returned 27 hits, while the source-and-target pivot returned 69 hits in their selected time ranges. These are search-result counts, not the number of Hydra attempts. The controlled Hydra test generated exactly 6 attempts.

## Containment

UFW was enabled on Ubuntu, and inbound traffic from the identified lab source was denied. Firewall status was then verified. This containment action was performed only within the controlled lab.

## MITRE ATT&CK

**T1110.001 - Password Guessing**

## Incident Classification

| Field | Value |
|---|---|
| Incident Type | SSH Brute Force / Password Guessing Attempt |
| Severity | Medium |
| Status | Closed |
| Detection | Wazuh |
| Target | SSH service and `testuser` account |

## Final Verdict

**True Positive - Unsuccessful Password Guessing Attempt**

The Hydra test found no valid password. This documentation does not claim that the account was compromised.

## Key Learning

- SSH authentication logging and raw log validation
- Wazuh rule and alert analysis
- Source and target identification
- Correlation of SSH and PAM events
- Validation of authentication success versus failure
- Firewall-based incident containment
