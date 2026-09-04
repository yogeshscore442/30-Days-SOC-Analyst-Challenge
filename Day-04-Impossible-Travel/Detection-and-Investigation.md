# Detection and Investigation

## Why Successful Authentication Matters

A successful SSH authentication shows that valid credentials were accepted. When the same account authenticates successfully from different source addresses in a short interval, the sequence deserves investigation. It may indicate credential misuse, but it may also be explained by expected network behavior.

## Source IP and Timestamp Analysis

Splunk extracted `remoteuser`, `src_ip`, and `_time` from the raw Ubuntu SSH events. The observed events were:

| Time | Account | Source IP | Result |
|---|---|---|---|
| 2026-09-04 23:47:42 | `remoteuser` | `192.168.175.200` | Accepted password |
| 2026-09-04 23:48:53 | `remoteuser` | `192.168.175.130` | Accepted password |

The difference is approximately 1 minute and 11 seconds. The addresses are private lab addresses, so they cannot provide meaningful geographic evidence.

## Chronological Ordering

The investigation initially showed a current source of `192.168.175.130`, previous source of `192.168.175.200`, and approximately `-1.18` minutes in a reverse-ordered `streamstats` result. This is not negative travel time. It is an event-ordering artifact. Events must be sorted chronologically before calculating the interval.

The corrected search uses `sort 0 _time` before `streamstats`, producing a positive chronological interval.

## Detection Logic

1. Identify successful authentication events.
2. Investigate the same user account.
3. Extract source IP addresses.
4. Sort events chronologically.
5. Compare each source IP with the previous source IP.
6. Calculate the time difference.
7. Flag the sequence when authentication succeeded, the source changed, and the interval was unusually short.
8. In a real SOC, perform IP geolocation and additional validation.

This lab demonstrates a **Potential Impossible Travel login pattern**. It does not confirm real-world travel.

## Investigation Questions

- Which account authenticated?
- Was the authentication successful?
- What was the first source IP?
- What was the second source IP?
- How much time passed between authentications?
- Are the source IPs public or private?
- What is the geographic location of each source IP?
- Is the account normally used from those locations?
- Was MFA used?
- What device was involved?
- What happened immediately after authentication?
- Were suspicious commands or other activity observed?
- Could VPN use, roaming, a proxy, corporate NAT, or travel explain the change?

For this lab, the source addresses are private, so real-world geographic validation cannot be performed from the evidence.

## False Positives

Possible explanations include corporate VPN use, a legitimate remote worker, cloud proxy routing, mobile network changes, NAT or shared public IP space, travel, remote desktop infrastructure, authorized security testing, and this lab simulation itself. Impossible Travel is an indicator for investigation, not automatic proof of account compromise.

## Limitations

The evidence proves a successful login for the same account from two different private source addresses within a short interval. It does not identify cities or countries, prove physical movement, establish malicious intent, or prove compromise.
