# Real-World Detection

## Detection Context

In a real enterprise environment, a new local account creation and subsequent addition to the local `Administrators` group is not automatically malicious. Account creation may be appropriate when a legitimate administrator is creating a temporary support or service account for a change, a maintenance window, or a scheduled operational process. However, the event pattern is important because it may represent a high-risk sequence.

The monitoring objective is to detect unusual patterns that may indicate unauthorized or unmanaged account creation. The sequence should be analyzed in context, especially where the subject account is privileged and the timing does not align with an approved change record.

## Use Cases

### Legitimate Activity

A legitimate user with administrative privileges may create a test account for a service, an approved temporary support workflow, or a service account requiring administrator rights. The analyst should inspect:

- The change ticket or request
- The time of creation
- The service or department account reference
- The target host
- Whether the group membership is appropriate

### Suspicious Activity

Indicators that increase suspicion include:

- New account created by a privileged account without an approved ticket
- Account added to `Administrators` without a documented business purpose
- Account created using a service-like or unusual account name
- Use of the account for logon soon after creation
- Attempts to hide the account with a vague or misleading naming pattern

## Detection Rule Example

A simple policy logic can be built in Splunk or a detection platform:

```spl
index=* source="WinEventLog:Security" (EventCode=4720 OR EventCode=4732)
| where Group_Name="Administrators" OR Target_Account_Name!=""
| table _time, host, EventCode, Subject_Account_Name, Target_Account_Name, Member_Name, Group_Name, Subject_Logon_ID
```

This query is an example only and must be adapted to the field mappings of the lab environment.

## Analyst Guidance

The SOC should avoid making conclusions based solely on the fact that a new account was created and linked to `Administrators`. An account can be legitimate, approved, or operationally necessary. The analyst must evaluate the event sequence with evidence such as:

- The subject caller account
- The logon session or logon ID
- Approval records or tickets
- Additional post-creation activity
- Host, source, and schedule context

## Final Evidence Principle

A real-world detection should never be declared a True Positive without supporting evidence. Use the event chain to escalate, then validate through the records of ownership, ticketing, service accounts, and host activity.
