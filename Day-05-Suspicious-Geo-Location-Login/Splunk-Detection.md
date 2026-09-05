# Splunk Detection

## Log Ingestion

Ubuntu SSH authentication activity is written to `/var/log/auth.log`. The file is forwarded to Splunk Enterprise, where it can be searched using the configured index and source fields. The examples below use `index=*` so they remain adaptable to the lab's index configuration.

## Primary Detection Query

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| where NOT src_ip="192.168.175.130"
| table _time, remoteuser, src_ip
```

### Line-by-Line Explanation

1. `index=*` searches all indexes available to the user. In production, use the approved authentication-log index.
2. `source="/var/log/auth.log"` limits results to the Ubuntu authentication log source.
3. `"Accepted password"` selects successful password-based SSH authentication events.
4. `remoteuser` limits the search to the affected lab account.
5. `rex field=_raw ...` extracts the source address into a field named `src_ip`.
6. `where NOT src_ip="192.168.175.130"` removes the established trusted baseline and leaves untrusted or unrecognized sources.
7. `table _time, remoteuser, src_ip` displays the fields needed for triage.

> Query compatibility note: the requested pattern includes `\)` after the IP. Standard Ubuntu `sshd` records commonly show the IP followed by a port, without a closing parenthesis. If the extraction returns no `src_ip` values in your Splunk data, use this operational variant:
>
> ```spl
> | rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
> ```
>
> The detection logic is unchanged; only the raw-log parsing pattern is adjusted to match the observed event format.

## Broader Successful-Login Query

```spl
index=* source="/var/log/auth.log" "Accepted password"
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| table _time, user, src_ip
| sort - _time
```

This provides a broader view of successful password logins. It is useful for discovering affected accounts and source addresses before narrowing the search. If `user` is not a field in the parsed data, inspect `_raw` or extract the account explicitly for your sourcetype.

## Baseline Query

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| stats count by src_ip
| sort - count
```

This counts successful `remoteuser` logins by source. The result helps establish which sources are common and which are unusual. In this exercise, compare the result with the trusted baseline `192.168.175.130`.

## Suspicious-Source Query

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+\)"
| search src_ip!="192.168.175.130"
| table _time remoteuser src_ip
| sort - _time
```

This returns successful logins for `remoteuser` whose extracted source does not match the trusted baseline. The confirmed suspicious source in this lab is `192.168.175.200`.

## Why Baseline Comparison Matters

A successful login is not automatically malicious. Comparing the source with the account's established behavior makes the event more meaningful. The baseline turns `remoteuser` authenticating from `192.168.175.130` into expected activity and highlights `192.168.175.200` as an untrusted or unrecognized source.

This is still an investigation trigger, not proof of a real geographic compromise. VPNs, corporate proxies, cloud proxies, NAT gateways, and mobile networks can make legitimate users appear to originate from unusual addresses. In a real SOC, analyst validation plus GeoIP and threat-intelligence enrichment is required.
