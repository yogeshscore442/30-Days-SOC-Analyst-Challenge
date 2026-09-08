# Investigation

## Investigation Objective

The objective of the investigation is to determine whether a new local Windows account was created by a privileged account, whether that account was added to the local `Administrators` group, and whether the evidence supports that the account creation and group assignment were unauthorized or otherwise unsupported by documented change control.

The investigation must answer the following questions:

1. Was a new account created?
2. Who created it?
3. Was it added to `Administrators`?
4. Was the caller account legitimate?
5. Was there an approved IT or change-management request?
6. Did the newly created account perform any activity?
7. Does the evidence support unauthorized persistence?

## Evidence Collection Plan

The analyst should preserve the following evidence:

- Windows IP: `[WINDOWS_IP]`
- Kali Linux IP: `[KALI_IP]`
- Source host/system: `[KALI_IP]`
- Destination host/system: `[WINDOWS_IP]`
- Accounts involved: `itadmin`, `backdooruser`, `svc_update`, or `[INSERT ACCOUNT]`
- Subject account for creation action: `[INSERT SUBJECT ACCOUNT]`
- Subject logon ID: `[INSERT SUBJECT LOGON ID]`
- Group target: `Administrators`
- Screenshots: `[INSERT SCREENSHOT — NEW ACCOUNT LIST]`
- Splunk event results: `[INSERT EVIDENCE]`

## Step 1 — Confirm Account Creation

Use Splunk to verify Event ID 4720 and examine fields such as:

- `Target Account Name`
- `Target Domain`
- `Subject Account Name`
- `Subject Domain`
- `Subject Logon ID`

The event confirms that a new local account was created. The analyst must verify that the account in question matches the account introduced during the simulation.

## Step 2 — Confirm Administrator Membership

Use Splunk and the Windows event stream to verify Event ID 4732. Confirm that the user was added to the local `Administrators` group.

Important fields:

- `Member Name` (the account added)
- `Group Name` (`Administrators`)
- `Subject Account Name`
- `Subject Logon ID`

This event confirms whether a newly created account is part of a privileged local group and may represent a persistence path.

## Step 3 — Determine Caller Account

The event attribute `Subject Account Name` is an important field. It identifies the account used to perform the change. The investigation must determine whether the caller was the known privileged lab account `itadmin` or a different account. This information is required to determine whether the creation activity was performed by a legitimate account and whether that account should be considered authorized in context.

## Step 4 — Determine Change Request Context

It is not enough to know that an account was created and placed into `Administrators`. The SOC must verify whether an approved change-management or IT request exists.

Examples of evidence to request:

- Approved ticket or change request number: `[INSERT TICKET]`
- Change window/timestamp: `[INSERT TIMESTAMP]`
- Approval owner: `[INSERT APPROVAL OWNER]`
- Business justification: `[INSERT JUSTIFICATION]`

If no approval record is found, the event remains suspicious until stronger evidence identifies legitimate context.

## Step 5 — Investigate Post-Creation Activity

The next phase is to determine whether the newly created account performed any activity after creation.

The following evidence sources should be checked:

- Logon events (4624)
- Group membership events (4732)
- Any account-usage pattern spanning the account’s first logon
- Raw Windows event payload and Splunk alert context

A new account may exist without being used. The absence of follow-on activity does not prove innocence, but it does reduce the strength of the evidence for persistence.

## Step 6 — Negotiate Assessment

The analyst should produce an evidence-backed assessment using the following logic:

- If Event ID 4720 and Event ID 4732 are present and the subject account is unapproved, the account is a strong indicator of unauthorized admin account creation.
- If an official change record and business justification exist, and the creation is tied to a legitimate service workflow, the behavior may be considered authorized even though unusual.
- If there is no supporting evidence and no post-creation activity, the investigation should preserve the event as possible suspicious account creation and continue gathering context.

## Final Judgment

A final verdict should never be marked `True Positive` by default. The verdict should be:

- `True Positive` only when the evidence supports unauthorized account creation and privileged group membership.
- `False Positive` if the evidence shows approved administrative account creation.
- `Inconclusive` if the evidence is incomplete or lacks context.

This documentation uses placeholders and `[INSERT EVIDENCE]` where actual evidence has not been provided. No fabricated results should be recorded.
