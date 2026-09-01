# Day 01 - Failed Login Attempts

## 30 Days SOC Analyst Practical Investigation Challenge

This is Day 01 of my 30-day practical challenge to strengthen my
SOC Analyst and Blue Team skills through hands-on security investigations.

During this challenge, I will simulate different security scenarios
in my controlled lab environment, collect and analyze security logs,
identify suspicious activity, map the activity to MITRE ATT&CK where
applicable, and document my findings like a SOC Analyst.

---

## Day 01: Failed Login Attempts

### Objective

The objective of this investigation is to understand how failed login
attempts are recorded in Windows Security Logs and how a SOC Analyst
can investigate this activity using Splunk.

---

## Lab Environment

- Operating System: Windows
- SIEM: Splunk
- Log Source: Windows Security Logs
- Test Account: Dedicated lab test user
- Environment: Controlled personal lab

---

## Scenario

I created a separate test user in my Windows lab environment.

I intentionally entered an incorrect password multiple times to
generate failed login events.

The generated Windows Security Logs were then collected and analyzed
in Splunk.

This was a controlled lab simulation performed for learning and
security monitoring practice.

---

## Detection

The failed login activity was identified using:

**Windows Security Event ID: 4625 - Failed Logon**

I searched for Event ID 4625 in Splunk and reviewed the generated
events.

### Detection Query

```spl
index=main EventCode=4625
```
This query was used to identify failed login events in the Splunk
index.

---

## Investigation Process
The investigation followed these steps:

1. Created a dedicated test user.
2. Set a password for the test user.
3. Performed multiple incorrect password attempts.
4. Generated Windows Security Event ID 4625.
5. Opened Splunk from the main account.
6. Searched for Event ID 4625.
7. Reviewed the generated events.
8. Analyzed important event fields.
9. Counted the failed login attempts.
10. Reviewed the activity timeline.
11. Evaluated the activity from a SOC Analyst perspective.

---

## Key Fields Reviewed
During the investigation, I reviewed fields such as:

- Account Name
- Account Domain
- Host Name
- Source
- Authentication Information
- Caller Process Name
- Logon Information
- Failure Information
- Timestamp

These fields can help a SOC Analyst understand who was targeted,
where the activity occurred, and when the activity happened.

---

# Evidence

## 1. Failed Login Detection
The first screenshot shows the failed login events detected in Splunk.

**Figure 1 - Detection of Windows Event ID 4625 in Splunk**

![Failed Login Detection](Screenshots/01-detection-proof.png)

This evidence confirms that Windows Security Event ID 4625 events
were detected in Splunk.

---

## 2. Event Field Analysis
The second screenshot shows the important fields available in the
failed login event.

**Figure 2 - Analysis of Failed Login Event Fields**

![Event Field Analysis](Screenshots/02-event-field-analysis.png)

The fields were reviewed to understand the account, host,
authentication information, and other details related to the event.

---

## 3. Failed Login Count
The third screenshot shows the number of failed login events
identified during the investigation.

**Figure 3 - Failed Login Attempt Count**

![Failed Login Count](Screenshots/03-failed-login-count.png)

### Verified Result
The test user generated **6 failed login events** during the
controlled lab simulation.

---

## 4. Login Activity Timeline
The fourth screenshot shows the timeline of the detected failed
login activity.

**Figure 4 - Failed Login Activity Timeline**

![Login Timeline](Screenshots/04-login-timeline.png)

The timeline helps an analyst understand when the failed login
activity occurred and identify possible patterns.

---

# Investigation Findings
The investigation identified:

- Multiple failed login events.
- Windows Security Event ID 4625.
- The test user was the target account.
- A total of 6 failed login events were observed for the test user.
- The events were successfully investigated using Splunk.
- The activity was intentionally generated in a controlled lab.

---

# SOC Analyst Perspective
A failed login does not automatically mean that an attack is taking
place.

A SOC Analyst should investigate the context of the activity.

Important questions include:

- Which account was targeted?
- How many failed attempts occurred?
- When did the attempts occur?
- Which host was involved?
- What was the source of the activity?
- What was the logon type?
- What was the failure reason?
- Was there a successful login after the failed attempts?
- Is the activity normal user behavior?
- Does the activity indicate possible credential abuse?

The goal is to determine whether the activity is **benign or suspicious**
based on the available evidence.

---

# MITRE ATT&CK Mapping
**Technique:** T1110 - Brute Force

The investigation is related to the Brute Force technique because
repeated authentication attempts can be associated with attempts to
gain access using credentials.

This particular activity was intentionally generated in a controlled
lab environment and was not a real-world attack.

---

# Defensive Perspective
In a real environment, a SOC Analyst could investigate repeated
failed login activity by:

- Reviewing the affected account.
- Checking the source of the login attempts.
- Looking for repeated attempts within a short period.
- Checking for successful login activity after failed attempts.
- Reviewing whether privileged accounts were targeted.
- Correlating the activity with other security alerts.
- Escalating suspicious activity for further investigation.

Possible defensive controls include:

- Strong password policies
- Multi-factor authentication (MFA)
- Account lockout policies
- Monitoring repeated authentication failures
- SIEM-based detection rules
- User and entity behavior monitoring

---

# Analyst Verdict
**Verdict: Benign / Controlled Lab Simulation**

The failed login events were intentionally generated using a dedicated
test account in my personal lab environment.

No real user or external system was targeted.

The purpose of this exercise was to understand how failed login
activity appears in Windows Security Logs and how it can be investigated
using Splunk.

---

# Key Learning
From this investigation, I learned:

- How failed login activity appears in Windows Security Logs.
- The importance of Windows Event ID 4625.
- How to search and investigate authentication events in Splunk.
- How to review important event fields.
- How to count and analyze repeated login failures.
- Why context is important when investigating authentication alerts.
- How to document evidence and reach an analyst verdict.

---

# Tools Used

- Windows
- Windows Security Logs
- Splunk
- MITRE ATT&CK

---

# Related Files

- [Detailed Investigation Report](Report.md)
- [Splunk Queries](Splunk-Queries.md)

---

# Conclusion
This investigation helped me understand the complete basic workflow
of handling a failed login alert as a SOC Analyst:

**Detect → Collect Evidence → Investigate → Analyze → Determine Verdict → Document**

Day 01 completed.

**29 more days of practical SOC investigations to go. 🚀**
=======
# 30-Days-SOC-Analyst-Challenge_2026
>>>>>>> ddd140224c95723b48524e39b12c98b2029ffde1
