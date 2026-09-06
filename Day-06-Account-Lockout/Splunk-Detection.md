# Splunk Detection – Account Lockout Investigation

Splunk should receive Ubuntu authentication records from `/var/log/auth.log`. The exact index, sourcetype, and forwarder configuration may vary by lab. The searches below intentionally use `index=*` and the requested source path so they can be adapted to the local deployment.

## Detection Workflow

1. Find failed SSH authentication events for `remoteuser`.
2. Count the failed attempts and compare the result with the threshold of three.
3. Extract source IPs and identify single-source or multiple-source behavior.
4. Build an ordered authentication timeline.
5. Search for successful authentication after the failures.
6. Correlate results with `faillock` and Ubuntu evidence before assigning a verdict.

## Failed Login Timeline

```spl
index=* source="/var/log/auth.log" "Failed password" remoteuser
| table _time, _raw
| sort _time
```

Explanation:

- `index=*` searches all accessible indexes. Replace it with the lab's known index when available.
- `source="/var/log/auth.log"` limits results to the Ubuntu authentication log source.
- `"Failed password"` finds failed password authentication messages.
- `remoteuser` limits the search to the affected account.
- `table _time, _raw` displays the event time and raw log message.
- `sort _time` orders the events chronologically.

Use this search to establish what happened and when. The returned timestamps and raw entries are evidence; record only values actually returned by Splunk.

## Failed-Attempt Count

```spl
index=* source="/var/log/auth.log" "Failed password" remoteuser
| stats count as failed_attempts
```

The search counts matching failed-password events and labels the result `failed_attempts`. Compare the observed count with the configured threshold of three. A count at or above the threshold supports that the policy condition was reached, but it does not by itself establish malicious intent.

## Source-IP Analysis

```spl
index=* source="/var/log/auth.log" "Failed password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| stats count by src_ip
| sort - count
```

- `rex` extracts the IPv4 address following `from` into `src_ip`.
- `stats count by src_ip` counts failures per source.
- `sort - count` places the highest-volume source first.

Look for one source producing rapid failures, several sources sharing the same target account, and whether the source is known or trusted in the lab. Extraction quality should be verified against the raw events.

## Authentication Timeline

```spl
index=* source="/var/log/auth.log" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| table _time, remoteuser, src_ip, _raw
| sort _time
```

This search includes all matching account events, not only failures. It creates an ordered view of failed and accepted authentication, the account, extracted source IP, and original log text. Use it to compare intervals between failures and identify what happened after the lockout condition.

## Successful Login After Failures

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| table _time, remoteuser, src_ip
| sort _time
```

A successful authentication after repeated failures is important because it may indicate that a legitimate user recovered, that a valid password was eventually used, or that an attacker obtained usable credentials. The result requires context: source, timing, user validation, session activity, and any post-login actions. Do not claim that a successful login occurred until Splunk or Ubuntu evidence shows it.

## Interpretation Guardrails

- A lockout is the result of a defensive policy, not proof of T1110.
- Rapid failures may suggest automation, but timing alone is not proof.
- Spaced-out failures may be legitimate user error, stored credentials, or a slow automated process.
- Multiple accounts failing from one source can support a password-spraying hypothesis.
- A source IP is an indicator for correlation, not identity proof.
- Populate incident fields from actual lab results only.

See [Splunk Queries](Splunk-Queries.md) for a clean reference page and [Investigation](Investigation.md) for the decision workflow.
