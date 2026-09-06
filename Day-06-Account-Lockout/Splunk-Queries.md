# Splunk Queries – Account Lockout Investigation

These searches are reference queries for Ubuntu `/var/log/auth.log` events in Splunk. Replace `index=*` with the approved lab index when known. Results, timestamps, source IPs, and verdicts must come from actual lab evidence.

## 1. Failed Login Detection

**Purpose:** Display failed password authentication events for the affected account.

```spl
index=* source="/var/log/auth.log" "Failed password" remoteuser
| table _time, _raw
| sort _time
```

**What to look for:** Failed SSH events, event times, account name, and the source IP in the raw message.

**SOC interpretation:** Establishes the initial failure timeline. It supports an authentication-failure investigation but does not alone prove an attack.

## 2. Failed Attempt Count

**Purpose:** Count failed password events for `remoteuser`.

```spl
index=* source="/var/log/auth.log" "Failed password" remoteuser
| stats count as failed_attempts
```

**What to look for:** Whether `failed_attempts` reached or exceeded the configured threshold of `3`.

**SOC interpretation:** A count at or above three supports that the lockout condition may have been reached. Confirm against `faillock` output and the event time window.

## 3. Source IP Analysis

**Purpose:** Group failed attempts by source IP.

```spl
index=* source="/var/log/auth.log" "Failed password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| stats count by src_ip
| sort - count
```

**What to look for:** One dominant source, multiple sources, and whether each source is known or trusted in the lab.

**SOC interpretation:** Rapid failures from one suspicious source can support a brute-force hypothesis. Multiple sources may indicate distributed activity, NAT, or a shared environment and require validation.

## 4. Authentication Timeline

**Purpose:** Display all events for the account in chronological order.

```spl
index=* source="/var/log/auth.log" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| table _time, remoteuser, src_ip, _raw
| sort _time
```

**What to look for:** Failed and accepted events, intervals between attempts, source changes, and activity after the lockout condition.

**SOC interpretation:** Rapid repeated failures may indicate automation; slow occasional failures may be consistent with user mistakes. Timing alone is not proof.

## 5. Successful Login After Failures

**Purpose:** Find successful password authentication for the account.

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| table _time, remoteuser, src_ip
| sort _time
```

**What to look for:** A successful login after the failed attempts, its source, and its timing.

**SOC interpretation:** A post-failure success increases priority because it may reflect legitimate recovery or successful credential use by an attacker. Validate the user, source, session, and post-login actions.

## 6. Account History

**Purpose:** Search the account's historical authentication activity.

```spl
index=* source="/var/log/auth.log" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| eval event_type=if(match(_raw, "Failed password"), "failed", "accepted")
| stats count by host, src_ip, event_type
| sort - count
```

**What to look for:** Repeated events, recurring source IPs, different hosts, and patterns across the selected time range.

**SOC interpretation:** Repeated lockouts may reflect user behavior, stored old credentials, a misconfigured application, automated authentication, or brute force. Set an appropriate time range before interpreting this search.

## 7. Multiple-Source Analysis

**Purpose:** Identify accounts that receive failures from the same source and look for password spraying patterns.

```spl
index=* source="/var/log/auth.log" "Failed password"
| rex field=_raw "Failed password for (?:invalid user )?(?<target_user>\S+) from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| stats dc(target_user) as affected_accounts, count as failed_attempts, values(target_user) as accounts by src_ip
| where affected_accounts > 1
| sort - affected_accounts, - failed_attempts
```

**What to look for:** One source attempting authentication against multiple accounts and the number of affected accounts.

**SOC interpretation:** Multiple accounts failing from one source can support a password-spraying hypothesis. Confirm the time window, source ownership, and whether the accounts are in the same lab or approved test scope.

## Query Notes

- `rex` extraction depends on the standard Ubuntu SSH log format; validate against `_raw`.
- `source_ip` values are evidence for correlation, not proof of a person's identity.
- Do not report a successful login, timestamp, or malicious classification unless the search returns supporting evidence.
