# Splunk Queries

These searches use Ubuntu `/var/log/auth.log` events ingested into Splunk. Field extraction is performed from `_raw` where needed.

## 1. Find Successful Logins

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| table _time, host, _raw
```

**Purpose:** Finds successful SSH password authentications for `remoteuser`.

**Important fields:** `_time` is the event time, `host` identifies the reporting host, and `_raw` contains the original authentication message.

**Expected result:** The two raw events containing source ports `60199` and `34898`.

**SOC relevance:** Establishes that the account authenticated successfully and preserves the source log message for verification.

## 2. Extract the Source IP

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| table _time, remoteuser, src_ip
```

**Purpose:** Extracts the source address from each raw SSH event.

**Important fields:** `remoteuser`, `_time`, and the new `src_ip` field.

**Expected result:** Source addresses `192.168.175.200` and `192.168.175.130`.

**SOC relevance:** Makes the source comparison explicit and suitable for correlation.

## 3. Chronological Correlation

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| sort 0 _time
| streamstats current=f last(src_ip) as prev_ip last(_time) as prev_time
| eval time_diff_minutes=round((_time-prev_time)/60,2)
| where src_ip != prev_ip AND time_diff_minutes < 60
| table _time, remoteuser, src_ip, prev_ip, time_diff_minutes
```

**Purpose:** Correlates consecutive successful authentications after sorting them chronologically.

**Command explanation:**

- `rex` extracts `src_ip` from the raw SSH authentication log.
- `sort` orders events chronologically so the time calculation is meaningful.
- `streamstats` compares the current event with the previous event in the investigation stream.
- `eval` calculates the time difference in minutes.
- `where` filters for a changed source IP and an interval under 60 minutes.
- `table` displays the fields needed for investigation.

**Important fields:** `_time`, `remoteuser`, `src_ip`, `prev_ip`, and `time_diff_minutes`.

**Expected result:** A row showing the later login from `192.168.175.130`, previous source `192.168.175.200`, and an interval of approximately `1.18` minutes.

**SOC relevance:** Demonstrates the behavioral correlation used to identify a potential Impossible Travel login pattern. Because both addresses are private lab IPs, the result is not proof of geographic travel.

## Ordering Note

A reverse-ordered streamstats result showed approximately `-1.18` minutes. That negative value is an artifact of processing the later event before the earlier event. It must not be interpreted as negative travel time. Chronological sorting resolves the issue.
