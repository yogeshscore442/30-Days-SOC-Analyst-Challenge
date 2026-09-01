# Security Incident Report

## 1. Incident Summary

**Incident Type:** Failed Login Attempts  
**Severity:** Low  
**Status:** Closed  
**Detection Source:** Splunk  
**Log Source:** Windows Security Logs  
**Event ID:** 4625  
**MITRE ATT&CK:** T1110 - Brute Force

---

## 2. Detection

Multiple failed login attempts were detected in Splunk from
Windows Security Event ID 4625.

## 3. Affected Account

**Account:** Test User

## 4. Investigation

The Windows Security logs were reviewed in Splunk to identify:

- Target account
- Host
- Source
- Logon information
- Failure information
- Timestamp
- Number of failed attempts

A total of **6 failed login events** were identified for the test account.

## 5. Evidence

The following evidence was collected from Splunk:

- Failed login event detection
- Event details and relevant fields
- Failed login count
- Login activity timeline

## 6. Analysis

The activity was reviewed to determine whether the failed login
attempts represented normal user activity or suspicious authentication
activity.

The events were intentionally generated using a dedicated test
account in a controlled lab environment.

## 7. Response

No production response was required because this was a controlled
lab simulation.

## 8. Final Verdict

**Classification:** Benign / Controlled Lab Activity

The activity was intentionally generated for security monitoring and
SOC investigation practice.

## 9. Evidence References

- `01-detection-proof.png`
- `02-event-field-analysis.png`
- `03-failed-login-count.png`
- `04-login-timeline.png`
