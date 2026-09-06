# Investigation – Account Lockout

This workflow determines why the `remoteuser` account entered a lockout condition. The analyst must base the verdict on evidence, not simply on the existence of a lockout.

## Step 1 – Identify the Affected Account

**Account:** `remoteuser`

Confirm the account in the `auth.log` records, Splunk events, and `faillock` output. Record any additional affected accounts only when evidence shows them.

## Step 2 – Count Failed Attempts

The configured threshold is **3 failed attempts**. Count the matching failed authentication events and determine whether the threshold was crossed in the relevant time period.

Useful evidence:

```bash
sudo faillock --user remoteuser
```

```spl
index=* source="/var/log/auth.log" "Failed password" remoteuser
| stats count as failed_attempts
```

Record the observed count as **To be populated from lab evidence** until the actual output is available. A threshold match confirms the policy condition, not attacker intent.

## Step 3 – Analyze Timing

Review the interval between failed authentication attempts using the raw log timestamps or the Splunk timeline.

- Rapid repeated failures may indicate automated authentication activity.
- Slow, occasional failures may be more consistent with legitimate user mistakes.

Timing alone is not proof. Consider network latency, retries by applications, user behavior, and the selected time range.

## Step 4 – Analyze Source IP

Extract the source IP from `auth.log` and determine whether the activity came from:

- A single source
- Multiple sources
- A known or trusted source
- An unknown or suspicious source

The controlled source in this lab is Kali at `192.168.175.130`, and the Ubuntu victim is `192.168.175.134`. These are lab indicators, not evidence of an external attack. Compare observed Splunk values with the known lab topology and do not invent additional addresses.

## Step 5 – Check Previous Lockouts

Search the available historical time range for earlier events involving `remoteuser`:

```spl
index=* source="/var/log/auth.log" remoteuser
| timechart span=1d count
```

Frequent lockouts may indicate:

- User behavior
- Misconfigured applications
- Stored old credentials
- Automated authentication
- Brute-force activity

Review the account's legitimate usage and scheduled jobs before assigning intent.

## Step 6 – Review Post-Lockout Activity

Search for successful authentication after the failed attempts:

```spl
index=* source="/var/log/auth.log" "Accepted password" remoteuser
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| table _time, remoteuser, src_ip
| sort _time
```

A successful authentication after repeated failures increases investigation priority. It may represent a legitimate user who remembered the password, a service retry, or use of valid credentials by an attacker. Validate the source, user, session, and post-login activity before concluding.

## Step 7 – Check Account Activity

Review current and historical sessions on Ubuntu:

```bash
who
w
last remoteuser
```

Review authentication records:

```bash
sudo grep -a "remoteuser" /var/log/auth.log
```

Check whether there are suspicious privilege-related events, such as unexpected administrative activity after a successful login. Do not claim suspicious activity unless actual evidence exists. The available evidence for these checks is **to be populated from lab evidence**.

## Step 8 – Determine the Verdict

### Case A – Rapid Repeated Failures From One Suspicious Source

**Verdict:** Potential or Confirmed Brute Force, depending on evidence.

Support this classification with rapid timing, source reputation or trust context, repeated attempts, account impact, and any post-authentication activity. Do not rely on the lockout alone.

### Case B – Few Spaced-Out Failures From a Known User Source

**Verdict:** Likely Benign / False Positive.

This is more consistent with a user mistake when there is no suspicious activity, no unusual source, and the user or application explains the attempts.

### Case C – Multiple Accounts Experiencing Failures From the Same Source

**Verdict:** Potential Password Spraying.

Correlate the source and time window across accounts. Confirm that the events are real lab evidence and not an indexing or parsing artifact.

## Evidence Worksheet

| Field | Result |
|---|---|
| Failed attempt count | To be populated from lab evidence |
| Threshold | `3` |
| Failure timing | To be populated from lab evidence |
| Source IP(s) | To be populated from lab evidence |
| Previous lockouts | To be populated from lab evidence |
| Successful login after failures | To be populated from lab evidence |
| Active sessions | To be populated from lab evidence |
| User or application validation | To be populated from lab evidence |
| Final verdict | Evidence-dependent; do not fabricate |
