# Investigation

## Investigation Objective

Determine whether successful authentication for `remoteuser` from an untrusted or unrecognized source represents suspicious activity when compared with the established account baseline.

## Step 1 – Identify the Affected Account

**Account:** `remoteuser`

The investigation is scoped to successful SSH authentication events for this lab account.

## Step 2 – Establish the Trusted Baseline

**Trusted source:** `192.168.175.130`

This is the source IP established as normal for the exercise. It is a private lab address, not a geographic identity.

## Step 3 – Find Successful Logins Outside the Baseline

**Suspicious source:** `192.168.175.200`

The source is considered untrusted or unrecognized because it does not match the established baseline. This is a source-baseline finding, not proof that the address belongs to a different country or city.

## Step 4 – Verify Repetition

Two confirmed successful logins were observed:

| Timestamp | Account | Source |
|---|---|---|
| `2026-09-04 23:48:53` | `remoteuser` | `192.168.175.200` |
| `2026-09-05 20:28:29` | `remoteuser` | `192.168.175.200` |

Both events show the same account authenticating successfully from outside the established baseline. Repetition strengthens the investigation context, but a single anomalous login would also justify review.

## Step 5 – Validate Raw Logs

Ubuntu authentication logs are stored at:

```text
/var/log/auth.log
```

Search for the relevant event pattern:

```bash
sudo grep -a "Accepted password for remoteuser" /var/log/auth.log
```

Look for the `Accepted password for remoteuser` message, its timestamp, the observed source IP, and the SSH service fields. Raw-log validation confirms that the Splunk result corresponds to an authentication record rather than an unsupported assumption.

## Step 6 – Determine Whether the Activity Is Legitimate

A real SOC analyst would check:

- User confirmation
- VPN usage
- Approved travel
- Source IP ownership
- GeoIP information
- Threat-intelligence reputation
- MFA events
- Device information
- Post-login commands
- Privilege changes
- Other authentication events

The private RFC1918 address `192.168.175.200` cannot provide real country, city, ISP, or reputation evidence by itself. Those fields would require production enrichment and corroborating data.

## Step 7 – Determine the Verdict

**TRUE POSITIVE** for the controlled suspicious-source detection.

The account authenticated successfully from a source outside the established trusted baseline on multiple occasions, and no legitimate justification was identified within this exercise.

This verdict means the lab detection correctly identified the behavior it was designed to find. It does not claim a real-world compromise or actual geographic compromise.

## Investigation Summary

The workflow was:

1. Identify `remoteuser`.
2. Compare observed sources with trusted baseline `192.168.175.130`.
3. Find suspicious source `192.168.175.200`.
4. Confirm the two supplied events.
5. Validate the Ubuntu `/var/log/auth.log` record pattern.
6. Identify the real-world context an analyst would need.
7. Classify the controlled detection as a true positive.
