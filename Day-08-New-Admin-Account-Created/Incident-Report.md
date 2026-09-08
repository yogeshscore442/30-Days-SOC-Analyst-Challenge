# Incident Report

## Incident Title

Day 08 — New Admin Account Created

## Executive Summary

This report documents a controlled lab scenario involving unauthorized or unsupported creation of a local Windows account followed by membership in the local `Administrators` group. The scenario begins with a privileged access account named `itadmin`, used from a Kali Linux SSH session to access the Windows victim and create a new local account. The event stream is collected through the Windows Security log and investigated using Splunk.

The investigation must determine whether the newly created account was legitimate, approved, and monitored. The final assessment should only be marked `True Positive` if the collected evidence supports that conclusion.

## Scope

- Windows Victim: `[WINDOWS_IP]`
- Kali Source: `[KALI_IP]`
- Splunk Source: `WinEventLog:Security`
- Existing privileged account: `itadmin`
- Target group: `Administrators`
- Example new account: `backdooruser` or `[INSERT ACCOUNT NAME]`

## Timeline

| Time | Activity | Evidence |
|---|---|---|
| `[TIMESTAMP]` | SSH access from Kali to Windows using `itadmin` | `[INSERT EVIDENCE]` |
| `[TIMESTAMP]` | Local account creation for `backdooruser` or `[INSERT ACCOUNT]` | Event ID `4720` |
| `[TIMESTAMP]` | Account added to local `Administrators` group | Event ID `4732` |
| `[TIMESTAMP]` | Follow-on user activity if available | `[INSERT EVIDENCE]` |

## Evidence Collected

The incident evidence should include any assigned evidence source and screenshot placeholders if no artifacts were provided.

- Event ID `4720`: `[INSERT SPLUNK RESULT]`
- Event ID `4732`: `[INSERT SPLUNK RESULT]`
- Subject account: `[INSERT SUBJECT ACCOUNT]`
- Subject logon ID: `[INSERT SUBJECT LOGON ID]`
- Member/target account: `[INSERT ACCOUNT NAME]`
- Group name: `Administrators`
- Source host/network: `[INSERT EVIDENCE]`
- Approved change request: `[INSERT EVIDENCE]`
- New account list screenshot: `[INSERT SCREENSHOT — NEW ACCOUNT LIST]`

## Findings

### Finding 1 — Account Creation

Evidence shows a new local account was created on the Windows host. This is recorded as Event ID `4720` in the Windows Security log.

Evidence:

```text
[INSERT EVIDENCE]
```

### Finding 2 — Group Membership Change

Evidence shows a new local account was added to the local `Administrators` group. This is recorded as Event ID `4732` in the Windows Security log.

Evidence:

```text
[INSERT EVIDENCE]
```

### Finding 3 — Caller Attribution

The selected evidence must determine whether the event was initiated by `itadmin` or by another user context. If the `Subject Account Name` and `Subject Logon ID` do not match a legitimate approved account, the activity is a stronger candidate for unauthorized creation.

### Finding 4 — Post-Creation Activity

The investigation must review whether the newly created account performed any logon or activity after creation. If no post-creation activity exists, record the absence as evidence and do not infer that the account was used.

## Assessment

The assessment should be based on the full event chain, not event code alone. The following must be verified before any conclusion:

- Did the new account creation occur within an approved change window?
- Did the account creation originate from a legitimate administrative path?
- Did the account join `Administrators` with a supporting justification?
- Did the account perform activity after creation?
- Does the evidence support unauthorized persistence?

## Final Verdict

The final verdict must be marked `True Positive` only when evidence supports the scenario as an unauthorized or unsupported local account creation and administrator group assignment.

```text
Final Verdict: [True Positive / False Positive / Inconclusive]
```

If evidence has not been collected or verified, use `Inconclusive` and document `[INSERT EVIDENCE]` rather than fabricating a result.

## Recommendations

- Remove unsupported accounts.
- Review privileged group membership changes.
- Enforce approval records for account creation.
- Monitor Windows Security events 4720 and 4732.
- Correlate account creation events with specific activity windows.
- Require documented change-control records for service accounts and local admin changes.
