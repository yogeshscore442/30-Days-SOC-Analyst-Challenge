# Security Incident Report

## 1. Incident Summary

| Field | Value |
|---|---|
| Incident Type | SSH Brute Force / Password Guessing Attempt |
| Severity | Medium |
| Status | Closed |
| Detection Source | Wazuh |
| Log Source | Ubuntu SSH authentication logs / journald |
| Target Service | SSH |
| Target Account | `testuser` |
| MITRE ATT&CK | T1110.001 - Password Guessing |

This investigation was performed only in an isolated lab using Kali Linux as the attacker simulation machine and Ubuntu Linux as the target machine. The actual source IP is intentionally omitted.

## 2. Detection

Wazuh detected repeated SSH and PAM authentication failures. Rule `5503` identified `PAM: User login failed.` events, while rule `5760` identified `sshd: authentication failed.` events. Both rules were level 5 and included authentication-failure context.

## 3. Investigation

1. Nmap confirmed that the Ubuntu lab host was reachable and TCP port 22 was open.
2. A controlled Hydra simulation tested 6 passwords against the `testuser` SSH account.
3. Ubuntu authentication logs were reviewed to validate the activity at the raw log source.
4. Wazuh authentication-failure alerts were searched using rules `5503` and `5760`.
5. Event details identified `testuser`, the identified lab source, the `sshd` decoder, journald, and the failed-password message.
6. Rule correlation and source/target pivots were used to connect related events.
7. Authentication-success events were checked separately. They were not attributed to Hydra without matching timestamp, source, target account, and SSH context.
8. UFW containment was applied and verified.

## 4. Evidence

- `01-nmap-ssh-open.png`: Reachable Ubuntu lab host with TCP 22/SSH open.
- `02-hydra-bruteforce.png`: 6 password tests against `testuser`; 0 valid passwords found.
- `03-wazuh-dashboard.png`: Wazuh authentication-failure activity.
- `04-wazuh-rule-5503.png`: Rule `5503`; 4 visible hits in that query result.
- `05-wazuh-rule-5760.png`: Rule `5760`; multiple SSH authentication-failure events.
- `06-wazuh-combined.png`: Combined rule query; 27 hits in the selected time range, not the Hydra count.
- `07-wazuh-document-details.png`: Event fields linking the failed SSH authentication to the identified lab source and `testuser`.
- `08-wazuh-source-search.png`: Source/target pivot; 69 hits in the selected time range, not the Hydra count.
- `09-wazuh-authentication-success.png`: Authentication-success events reviewed for possible compromise.
- `10-auth-log.png`: Ubuntu raw `auth.log` validation.
- `11-ufw-block.png`: UFW enabled with a deny rule for the identified lab source.
- `12-password-status.png`: Supporting password-status evidence without exposing credentials.

## 5. Analysis

Repeated failed SSH authentications were observed for `testuser`. Wazuh event details and Ubuntu raw logs correlated the target account, SSH service, and identified lab source. The Hydra test generated exactly 6 password attempts and found 0 valid passwords. Wazuh result counts of 27 and 69 represent events returned within selected search ranges and must not be treated as the number of Hydra attempts.

There is no evidence in the controlled Hydra result that a valid password was discovered. Authentication-success events were reviewed separately and were not assumed to belong to this activity. This report makes no claim that the account was compromised.

## 6. Containment

UFW was enabled on Ubuntu, a deny rule was added for the identified lab source, and numbered firewall status was checked to verify the rule. This containment action was performed in the controlled lab.

## 7. Final Verdict

**True Positive - Unsuccessful Password Guessing Attempt**

## 8. Recommendations

- Prefer SSH keys and disable password authentication where operationally appropriate.
- Restrict SSH exposure to trusted networks and enforce firewall controls.
- Use strong authentication, account protections, and rate limiting.
- Deploy Fail2ban or an equivalent control where appropriate.
- Monitor repeated SSH failures, source IP, target username, and success after failures in Wazuh.
