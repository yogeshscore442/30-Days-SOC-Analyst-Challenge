# Detection and Investigation

## 1. Wazuh Monitoring
Wazuh monitors Ubuntu SSH authentication logs and analyzes authentication events with SSH/PAM rules. The investigation begins with authentication failure events.

## 2. Initial Failure Detection
Use this Wazuh filter to focus on authentication failures from the suspected source:

```text
rule.groups:authentication_failed AND data.srcip:"<ATTACKER_IP>"
```

Inspect:

- `data.srcip`
- `data.srcuser`
- `rule.id`
- `rule.description`
- `rule.level`
- `timestamp`
- Authentication result

A single failed login may be normal. The suspicious pattern is the correlation of one source with multiple usernames within a short time window and a low number of attempts against each account.

## 3. Source and Username Correlation
Investigate all events from the source:

```text
data.srcip:"<ATTACKER_IP>"
```

Review `data.srcuser` and identify the distinct usernames. The controlled target list is `user1`, `user2`, `user3`, `user4`, `testuser`, and `admin`. Count the distinct usernames represented by the available events rather than assuming every list entry generated an event.

## 4. Timestamp Analysis
Compare event timestamps to determine whether the attempts occurred within a short time window. Same source plus multiple usernames plus a short time window is suspicious because it indicates one actor testing a common credential across accounts instead of repeatedly targeting one account.

## 5. Successful Authentication Check
Check Wazuh events for an authentication success and identify the affected account. For this controlled lab, the expected successful account is `user3`. Do not claim that Wazuh generated a dedicated password-spraying alert unless the actual evidence confirms it; describe the finding as correlation of authentication events.

## 6. Raw Log Verification
Use Ubuntu's authentication log to cross-check Wazuh:

```bash
sudo grep "Failed password\|Accepted password" /var/log/auth.log | tail -30
```

Identify distinct usernames from failed SSH attempts:

```bash
sudo grep "Failed password" /var/log/auth.log | awk '{print $9}' | sort -u
```

Investigate the controlled affected account:

```bash
sudo grep "user3" /var/log/auth.log
```

Verify successful SSH authentication:

```bash
sudo grep "Accepted password for user3" /var/log/auth.log
```

If `auth.log` is detected as binary, use:

```bash
sudo grep -a "Accepted password for user3" /var/log/auth.log
```

The SSH `Accepted password` entry and Wazuh correlation are the primary evidence of successful authentication. Do not use `last user3` alone as proof of authentication success.

## 7. Account and Privilege Review
Review login history:

```bash
last user3
```

Review sudo activity:

```bash
sudo grep user3 /var/log/auth.log | grep sudo
```

These checks provide context about the affected account and possible privileged activity; conclusions must be based on the output actually observed.

## 8. Investigation Workflow
1. Identify the suspicious source IP.
2. Review authentication failures.
3. Identify all targeted usernames.
4. Count distinct usernames.
5. Check whether attempts occurred within a short time window.
6. Determine whether the same source targeted multiple accounts.
7. Check for successful authentication.
8. Identify the affected account.
9. Cross-check Wazuh with Ubuntu `/var/log/auth.log`.
10. Determine whether the activity matches Password Spraying.
11. Classify the incident as a True Positive only when the evidence supports it.

## Final Verdict
For this controlled lab, the investigation conclusion is **Confirmed Password Spraying activity with successful authentication for the controlled test account `user3`**. The activity maps to **MITRE ATT&CK T1110.003 - Password Spraying**.
