# Splunk Queries for Failed Login Attempts Investigation

This document contains SPL (Splunk Processing Language) queries used and recommended for investigating failed login events. Each query is accompanied by an explanation of its purpose and how it assists in security analysis.

---

## 1. Detect Failed Login Events

### Query

```spl
index=main EventCode=4625
```

### Explanation

This is the foundational search query for identifying failed login events. It searches the main index for all events with EventCode 4625, which is the Windows Security Event ID for failed logon attempts.

**Components:**
- `index=main` - Searches the main Splunk index where Windows events are typically stored
- `EventCode=4625` - Filters for Windows Event ID 4625 (failed logon)

**Use Case:** Initial detection and identification of failed login activity

**Output:** A list of all failed login events with all available fields

**Analyst Value:** This query confirms that failed login events are being captured and allows the analyst to verify that the log source is functioning properly.

---

## 2. Count Failed Login Attempts by Account

### Query

```spl
index=main EventCode=4625
| stats count as failed_attempts by Account_Name
| sort - failed_attempts
```

### Explanation

This query extends the basic detection query to aggregate failed login attempts by user account and rank them by frequency. This helps identify which accounts are experiencing the most failed login activity.

**Components:**
- `index=main EventCode=4625` - Filters for failed login events
- `| stats count as failed_attempts by Account_Name` - Groups events by Account_Name and counts them, creating a column labeled "failed_attempts"
- `| sort - failed_attempts` - Sorts results in descending order (most failures first) using the `-` operator

**Use Case:** Identifying which accounts are being targeted by failed login attempts

**Output:** A table showing Account_Name and the count of failed attempts for each account, sorted from highest to lowest

**Analyst Value:** Quickly reveals which accounts have the most failed login activity, helping prioritize investigation efforts.

---

## 3. Review Important Fields and Timeline

### Query

```spl
index=main EventCode=4625
| table _time, host, Account_Name, Account_Domain, Logon_Type, Failure_Reason
| sort _time
```

### Explanation

This query creates a focused view of the most important fields extracted from failed login events, arranged chronologically. This facilitates field-level analysis and temporal pattern recognition.

**Components:**
- `index=main EventCode=4625` - Filters for failed login events
- `| table _time, host, Account_Name, Account_Domain, Logon_Type, Failure_Reason` - Displays only the specified columns
- `| sort _time` - Sorts events chronologically from earliest to latest

**Field Definitions:**
- `_time` - The timestamp when the event occurred
- `host` - The target system/computer name
- `Account_Name` - The user account targeted by the login attempt
- `Account_Domain` - The domain or system containing the account
- `Logon_Type` - The type of logon attempt (2=Interactive, 3=Network, 4=Batch, 5=Service, 7=Unlock, etc.)
- `Failure_Reason` - Why the login failed (e.g., "Bad Password", "Account Locked", etc.)

**Use Case:** Detailed field analysis and timeline review

**Output:** Chronologically sorted table of failed login events with key context fields

**Analyst Value:** Enables analysts to spot patterns, such as all failures occurring within a specific timeframe or targeting a specific system.

---

## 4. Failed Login Count Over Time

### Query

```spl
index=main EventCode=4625
| timechart count as failed_attempts by Account_Name limit=10
```

### Explanation

This query visualizes the frequency of failed login attempts over time, grouped by account. This helps identify temporal patterns and attack intensity.

**Components:**
- `index=main EventCode=4625` - Filters for failed login events
- `| timechart count as failed_attempts by Account_Name limit=10` - Creates a time-series chart showing count of failures over time for up to 10 accounts
- `limit=10` - Limits results to the top 10 accounts (prevents chart clutter)

**Use Case:** Temporal analysis and visualization

**Output:** A time-series chart showing failed attempts over time, with separate lines for each account

**Analyst Value:** Reveals whether failures are concentrated in a specific time period (suggesting active attack) or spread over longer duration (suggesting sporadic user errors).

---

## 5. Failed and Successful Login Correlation (Recommended Follow-up Investigation)

### Query

```spl
index=main (EventCode=4625 OR EventCode=4624) Account_Name=*
| stats count(eval(EventCode=4625)) as failed_attempts, 
         count(eval(EventCode=4624)) as successful_logins 
         by Account_Name, host
| search failed_attempts > 0
```

### Explanation

**Query Type:** Recommended Investigation Query

This query correlates Event ID 4625 (failed login) with Event ID 4624 (successful login) to identify whether accounts experienced successful access after repeated failed attempts. This pattern may indicate successful credential compromise.

**Components:**
- `index=main (EventCode=4625 OR EventCode=4624) Account_Name=*` - Filters for both failed and successful logins
- `| stats count(eval(...)) ...` - Counts failed and successful attempts separately for each account and host
- `| search failed_attempts > 0` - Filters to only accounts with failed attempts

**Use Case:** Follow-up investigation to determine if failed login attempts were followed by successful compromise

**Output:** Table showing accounts with failed attempts, success counts, and target hosts

**Analyst Value:** Identifies suspicious patterns such as:
- Multiple failed attempts followed immediately by successful login (possible brute force success)
- Multiple failures without any successful login (possible account lockout or unsuccessful attack)
- Failures and successes from different sources (possible lateral movement)

---

## 6. Source System Analysis (Recommended Query)

### Query

```spl
index=main EventCode=4625
| stats count as failed_attempts by src_ip, Account_Name
| sort - failed_attempts
```

### Explanation

**Query Type:** Recommended Investigation Query

This query identifies the source IP addresses or systems from which failed login attempts originated, grouped by target account.

**Components:**
- `index=main EventCode=4625` - Filters for failed login events
- `| stats count as failed_attempts by src_ip, Account_Name` - Groups attempts by source IP and target account
- `| sort - failed_attempts` - Sorts by count descending

**Use Case:** Identifying the origin of attack attempts and detecting distributed attacks

**Output:** Table showing source IPs and target accounts with attempt counts

**Analyst Value:** Reveals:
- Whether attacks come from a single source (focused attack) or multiple sources (distributed attack)
- Whether multiple accounts are being targeted from the same source
- Whether the source IP is expected (internal network) or unexpected (external/suspicious)

---

## 7. Account Lockout Risk Assessment (Recommended Query)

### Query

```spl
index=main EventCode=4625 Failure_Reason="Bad Password"
| stats count as bad_password_failures by Account_Name, _time
| where bad_password_failures >= 5
```

### Explanation

**Query Type:** Recommended Investigation Query

This query identifies accounts that have experienced multiple "Bad Password" failures, which may indicate password guessing attempts or an account approaching lockout threshold.

**Components:**
- `index=main EventCode=4625 Failure_Reason="Bad Password"` - Filters for failed logins specifically due to incorrect password
- `| stats count as bad_password_failures by Account_Name, _time` - Counts failures by account and time
- `| where bad_password_failures >= 5` - Filters to only accounts with 5 or more failures (adjustable threshold)

**Use Case:** Risk assessment and identifying imminent account lockouts

**Output:** Accounts with 5+ bad password failures

**Analyst Value:** Helps prioritize which accounts need proactive protection or investigation.

---

## 8. Administrative Account Monitoring (Recommended Query)

### Query

```spl
index=main EventCode=4625 Account_Name IN ("Administrator", "admin", "root", "service")
| stats count as failed_attempts by Account_Name, host
| where failed_attempts > 2
```

### Explanation

**Query Type:** Recommended Investigation Query

This query specifically monitors high-privilege accounts for suspicious failed login activity. Compromising administrative accounts poses extreme risk.

**Components:**
- `index=main EventCode=4625 Account_Name IN (...)` - Filters for specific administrative account names
- `| stats count as failed_attempts by Account_Name, host` - Aggregates by account and target system
- `| where failed_attempts > 2` - Filters to only those with more than 2 failures (low threshold for admin accounts)

**Use Case:** Early detection of attacks targeting high-value accounts

**Output:** Administrative accounts with failed login attempts

**Analyst Value:** Enables immediate response to threats against privileged accounts before they can be compromised.

---

## Using These Queries

### For Initial Investigation
Start with Query #1 (Detect) and Query #2 (Count by Account) to identify the scope of failed login activity.

### For Detailed Analysis
Use Query #3 (Field Review) and Query #4 (Timeline) to understand the pattern and context of failures.

### For Follow-up Investigation
Use Query #5 (Correlation) to determine if failures led to successful access, indicating possible compromise.

### For Threat Hunting
Use Query #6 (Source Analysis), Query #7 (Lockout Risk), and Query #8 (Admin Monitoring) to proactively search for suspicious patterns.

---

## Field Names Note

**Important:** The exact field names in Splunk may vary depending on how Windows events are parsed and indexed in your environment. Common variations include:

- `EventCode` vs `EventID` vs `event_code`
- `Account_Name` vs `user` vs `account_name`
- `Account_Domain` vs `Domain` vs `domain`
- `Failure_Reason` vs `failure_reason` vs `reason`
- `src_ip` vs `source_ip` vs `SourceIP`

**Recommendation:** Always inspect actual event data in your Splunk instance to verify field names before running production queries. You can do this by:

1. Running: `index=main EventCode=4625 | fields *` (or similar base query)
2. Reviewing the "Interesting Fields" panel to see actual field names present in your data
3. Adjusting query field names to match your environment

---

## Additional Resources

- [Microsoft Event ID 4625 Documentation](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4625)
- [Splunk SPL Command Reference](https://docs.splunk.com/Documentation/Splunk/latest/SearchReference)
- [Splunk stats and timechart Commands](https://docs.splunk.com/Documentation/Splunk/latest/SearchReference/Stats)

---
