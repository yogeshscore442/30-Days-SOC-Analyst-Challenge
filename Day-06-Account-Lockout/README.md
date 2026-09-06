# Day 06 – Account Lockout Investigation

## Objective

Investigate an SSH account lockout in an isolated Linux lab and determine whether repeated authentication failures are consistent with legitimate user error, brute-force activity, password spraying, or coordinated attempts from multiple sources.

Learning objectives:

1. Understand how account lockout works.
2. Configure a controlled Linux lockout policy.
3. Generate failed SSH authentication attempts.
4. Detect failed authentication in Splunk.
5. Analyze authentication timing.
6. Identify source IPs.
7. Investigate repeated lockouts.
8. Check for successful authentication after failures.
9. Distinguish benign lockouts from suspicious activity.
10. Produce a SOC-style incident report.

## What is Account Lockout?

Account lockout occurs when repeated authentication failures trigger a configured security policy. In this lab, `pam_faillock` is configured for the `remoteuser` account with `deny=3` and `unlock_time=300` seconds. Three failed attempts trigger the lockout condition, and the account is automatically eligible to unlock after five minutes.

Account lockout is a defensive control and an observable result. It is not an attack by itself. A lockout can be caused by:

- A password typo
- A forgotten password
- Brute-force activity
- Password spraying
- Credential-stuffing-like behavior
- Automated authentication attempts

The important SOC skill is determining the cause from authentication logs and surrounding context.

## Why SOC Analysts Care About It

A lockout may protect an account while also providing an investigation signal. The analyst should confirm the threshold, count attempts, review timing, extract source IPs, check previous lockouts, and look for successful authentication after the failures. Every lockout must be assessed on evidence rather than automatically classified as malicious.

## Lab Architecture

| Component | Role | Address or detail |
|---|---|---|
| Kali Linux | Controlled source for SSH authentication attempts | `192.168.175.130` |
| Ubuntu Linux | Victim system receiving SSH authentication | `192.168.175.134` |
| Splunk Enterprise | SIEM receiving and searching Ubuntu authentication logs | Splunk Enterprise |
| Test account | Account under investigation | `remoteuser` |
| Authentication | Remote access protocol | SSH |
| Log source | Ubuntu authentication records | `/var/log/auth.log` |
| Security control | Linux account lockout module | `pam_faillock` |
| Policy | Threshold and unlock period | `deny=3`, `unlock_time=300` seconds |

```text
Kali Linux
192.168.175.130
      |
      | SSH authentication attempts
      v
Ubuntu Victim
192.168.175.134
      |
      | /var/log/auth.log
      v
Splunk Enterprise
      |
      v
Detection → Investigation → Verdict → Response
```

Kali generates controlled authentication activity. Ubuntu applies the PAM policy and writes authentication events. Splunk receives `/var/log/auth.log` for search and correlation.

## Attack Simulation

The lab uses Kali to submit intentionally incorrect passwords for `remoteuser` over SSH. After three failed attempts, Ubuntu should record the failures and `pam_faillock` should report the account state. The procedure is documented in [Attack Simulation](Attack-Simulation.md).

Use only the isolated lab environment. Do not automate attacks against real systems, accounts, or third-party infrastructure.

## Detection

Splunk searches Ubuntu `auth.log` for failed authentication events, counts failures, extracts source IPs, builds a timeline, and checks for successful authentication after the failures. See [Splunk Detection](Splunk-Detection.md) and [Splunk Queries](Splunk-Queries.md).

## Investigation

The investigation compares the observed evidence with the configured threshold of three failed attempts. It considers attempt timing, source count, source trust, previous lockouts, account activity, successful authentication, and user or application context. See [Investigation](Investigation.md).

## Response

Response begins by verifying whether the lockout is legitimate. When malicious activity is supported by evidence, the analyst may validate or disable the account, force a password reset, review sessions and history, investigate the source, search for other affected accounts, and escalate according to severity. See [Incident Response](Incident-Response.md).

## MITRE ATT&CK

- **T1110 – Brute Force:** repeated authentication attempts may be associated with this technique when evidence supports guessing or automated credential attempts.
- **Account lockout:** defensive control and observable result, not an attack technique by itself.

A lockout must not automatically be labeled T1110. The final classification depends on timing, source behavior, affected accounts, and other evidence.

## Key Findings

This repository page documents the investigation method. Lab-specific timestamps, `faillock` output, Splunk results, and final classification are **to be populated from lab evidence**. No attack result, successful login, timestamp, or verdict is fabricated here.

## Lessons Learned

- Lockout is a security control, not proof of compromise.
- Authentication timing helps distinguish rapid automation from occasional user mistakes, but timing alone is not proof.
- Source-IP analysis can reveal a single source, multiple sources, or a trusted versus unknown origin.
- A successful login after repeated failures increases investigation priority.
- Repeated lockouts may result from users, old stored credentials, misconfigured applications, automation, or brute force.
- Evidence correlation is required before response actions are taken.

## Screenshots

No screenshots are invented or included. Capture only evidence produced by your own lab and use the checklist in [Screenshots/README.md](Screenshots/README.md).

## Conclusion

This exercise follows a practical SOC workflow:

**Attack Simulation → Log Generation → Splunk Detection → Investigation → Evidence Correlation → Verdict → Response → Prevention**

The analyst's objective is not simply to find a lockout. It is to explain why it occurred and respond proportionally to the evidence.

## Lab Disclaimer

This exercise was performed entirely in an isolated lab environment for cybersecurity learning and SOC investigation practice. No real systems, accounts, or third-party infrastructure were targeted.
