# Security Incident Report

## 1. Incident Summary

| Field | Value |
|---|---|
| Incident Type | Account Lockout Investigation |
| Severity | Medium |
| Status | Investigated |
| Detection Source | Splunk |
| Log Source | Ubuntu `/var/log/auth.log` |
| Affected Account | `remoteuser` |
| Security Control | `pam_faillock` |
| MITRE ATT&CK | T1110 – Brute Force |
| Analyst Verdict | To be populated from lab evidence; do not automatically classify as malicious |

## 2. Detection

Repeated failed SSH authentication attempts were intended to reach the configured `pam_faillock` threshold of three failures. Splunk searches Ubuntu `/var/log/auth.log` for failed password events involving `remoteuser`, counts the events, extracts source IPs, and builds an authentication timeline.

The observed count, timestamps, raw events, and final classification must be populated from the actual lab. A lockout is a defensive control result and is not, by itself, proof of an attack.

## 3. Attack Simulation

- Kali acted as the controlled authentication source at `192.168.175.130`.
- Ubuntu was the victim at `192.168.175.134`.
- SSH was used for authentication.
- Multiple incorrect passwords were intentionally entered for `remoteuser`.
- `pam_faillock` was configured with `deny=3` and `unlock_time=300` seconds.
- Ubuntu generated authentication records in `/var/log/auth.log`.
- Splunk received the Ubuntu authentication logs for detection and investigation.

No real credentials are included in this report. Use `<LAB_PASSWORD>` when referring to the lab password in notes.

## 4. Evidence

| Evidence item | Result |
|---|---|
| `pam_faillock` configuration | To be populated from lab evidence |
| `faillock --user remoteuser` output | To be populated from lab evidence |
| Failed `/var/log/auth.log` entries | To be populated from lab evidence |
| Splunk failed-login query result | To be populated from lab evidence |
| Source IP | Expected lab source is `192.168.175.130`; confirm from actual log evidence |
| Authentication timeline | To be populated from lab evidence |
| Successful login after failures | To be populated from lab evidence; do not assume one occurred |

Do not invent timestamps, log output, successful logins, or attack results.

## 5. Investigation

The analyst should document:

- Attempt count compared with the threshold of three
- Timing between failed attempts
- Source IP and whether it is known or trusted
- Previous lockouts for `remoteuser`
- Any successful authentication after the failures
- User or application validation
- Active sessions and post-login activity
- Context from other affected accounts

Rapid repeated failures from one suspicious source may support a brute-force classification. A few spaced-out failures from a known user source with no suspicious activity may be benign. Failures against multiple accounts from the same source may support a password-spraying hypothesis. The classification must be evidence-based.

## 6. Indicators

| Indicator | Value |
|---|---|
| Account | `remoteuser` |
| Source | `192.168.175.130` as the controlled Kali lab source; verify observed source in evidence |
| Victim | `192.168.175.134` |
| Timestamps | To be populated from lab evidence |
| Additional source IPs | To be populated from lab evidence, if any |

The private lab IPs do not establish a real-world geographic location, identity, or compromise.

## 7. Response

Document the actions supported by the evidence:

- Validate the account activity with the user or responsible application.
- Force a password reset when appropriate.
- Lock the account if malicious activity is supported.
- Review active sessions with `who`, `w`, and `last remoteuser`.
- Review authentication history in `/var/log/auth.log` and Splunk.
- Investigate and block the source IP if appropriate and authorized.
- Search for other affected accounts.
- Check for successful authentication and post-login activity.
- Escalate according to incident severity.

Example lab commands:

```bash
sudo faillock --user remoteuser
sudo passwd -l remoteuser
who
w
last remoteuser
sudo grep -a "remoteuser" /var/log/auth.log
```

Use account disabling and source blocking only after appropriate validation in real environments.

## 8. Prevention

Recommended controls include MFA, managed SSH keys, disabling password authentication where appropriate, rate limiting, Fail2ban, a properly tuned lockout threshold, and SIEM alerting. Monitor both lockout events and the context around them so the control does not create unnecessary disruption.

## 9. Final Verdict

Select exactly one classification after reviewing the lab evidence:

- Benign / False Positive
- Suspicious Activity
- True Positive – Brute Force
- True Positive – Password Spraying

**Final classification:** To be populated from lab evidence.

Do not mark this incident as a True Positive without supporting evidence from the authentication timeline, source analysis, account context, or related activity.

## Lab Disclaimer

This exercise was performed entirely in an isolated lab environment for cybersecurity learning and SOC investigation practice. No real systems, accounts, or third-party infrastructure were targeted.
