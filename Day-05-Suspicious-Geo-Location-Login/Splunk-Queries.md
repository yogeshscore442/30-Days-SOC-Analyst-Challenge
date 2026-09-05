# Splunk Queries

These queries use the Ubuntu `/var/log/auth.log` source and successful SSH password authentication events. Replace `index=*` with the lab's approved index when known.

> The queries below reproduce the requested pattern. If standard Ubuntu records do not contain a closing parenthesis after the source IP, replace `\d+\.\d+\.\d+\.\d+\)` with `\d+\.\d+\.\d+\.\d+` in the `rex` expression.

## 1. All Successful SSH Logins

**Purpose:** List successful password-based SSH logins across the available authentication logs.

```spl
index=* source="/var/log/auth.log" "Accepted password"
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| table _time, user, src_ip
| sort - _time
```

**Expected interpretation:** Review the account and source IP for each successful login. Use this query to discover activity before narrowing to `remoteuser`.

## 2. Login Activity for `remoteuser`

**Purpose:** Focus successful SSH login activity on the affected lab account.

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| table _time, remoteuser, src_ip
| sort - _time
```

**Expected interpretation:** The results show when `remoteuser` authenticated and which source IP was observed.

## 3. Extract Source IP

**Purpose:** Parse the client address from the raw SSH authentication message.

```spl
index=* source="/var/log/auth.log" "Accepted password"
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| table _time, _raw, src_ip
```

**Expected interpretation:** `src_ip` should contain the source address. If it is empty, inspect `_raw` and use the operational variant without `\)` described in [Splunk Detection](Splunk-Detection.md).

## 4. Trusted Baseline Comparison

**Purpose:** Count successful `remoteuser` logins by source so normal and unusual sources can be compared.

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| stats count by src_ip
| sort - count
```

**Expected interpretation:** Compare the returned sources with the trusted baseline `192.168.175.130`. A different source is an investigation trigger.

## 5. Suspicious Source Detection

**Purpose:** Return successful `remoteuser` logins that are not from the trusted baseline.

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| search src_ip!="192.168.175.130"
| table _time remoteuser src_ip
| sort - _time
```

**Expected interpretation:** The confirmed suspicious source for this exercise is `192.168.175.200`. The result indicates source-baseline deviation; it does not identify a real country or prove compromise.

## 6. Count Logins by Source IP

**Purpose:** Summarize how often each source authenticated as `remoteuser`.

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| stats count as login_count by src_ip
| sort - login_count
```

**Expected interpretation:** Frequent sources may be part of the baseline, while a low-frequency or new source may deserve review. Frequency alone does not determine legitimacy.

## 7. Timeline of Suspicious Login Activity

**Purpose:** Display suspicious successful logins in reverse chronological order for timeline analysis.

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| search src_ip!="192.168.175.130"
| eval event_time=strftime(_time, "%Y-%m-%d %H:%M:%S")
| table event_time remoteuser src_ip
| sort - event_time
```

**Expected interpretation:** The confirmed evidence contains these two suspicious-source events:

```text
2026-09-05 20:28:29 | remoteuser | 192.168.175.200
2026-09-04 23:48:53 | remoteuser | 192.168.175.200
```

These timestamps are supplied lab evidence. Do not add other events unless they are observed in the environment.
