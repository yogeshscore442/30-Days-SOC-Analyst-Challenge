# Detection

## Overview

Windows Security Events are the primary evidence for security monitoring and investigation in this lab. The key event types for this scenario are Event ID 4720 and Event ID 4732. These events demonstrate the creation of a new account and the addition of that account to the local `Administrators` group. Event ID 4728 may also be relevant if the account is placed into a global group rather than a local group.

In a SOC workflow, the detection process should examine whether the new user object and group membership change align with normal administrative activity. Analysts should not automatically classify a new account as malicious simply because it was created. It must be investigated in context.

## Event ID 4720 — A User Account Was Created

Event ID 4720 records a Windows security event in which a user account is created successfully. This is the event that documents the account creation action. Important fields include:

- `Target Account Name` — the account that was created, such as `backdooruser` or `svc_update`
- `Target Domain` — the domain or local security authority in which the account was created
- `Subject Account Name` — the account that performed the change
- `Subject Domain` — the domain or local context of the caller
- `Subject Logon ID` — the logon/session identifier associated with the administrative action

In Splunk, these fields may appear under different names depending on the Windows add-on and event normalization. In all cases, the analyst should capture the account that performed the change and the account that was created.

## Event ID 4732 — A Member Was Added to a Security-Enabled Local Group

Event ID 4732 records the addition of a member to a security-enabled local group. In this lab, the key target group is the local `Administrators` group. Important fields include:

- `Member Name` — the account added to the group
- `Group Name` — the group that received the member, such as `Administrators`
- `Subject Account Name` — the account that initiated the group change
- `Subject Logon ID` — the logon/session identifier associated with the caller

This event is particularly important when the target group is `Administrators`, because a new account added to the local `Administrators` group can enable privileged access. Analysts must correlate the group membership change with the preceding account creation event.

## Correlation Pattern

The correlation pattern is:

1. Event ID 4720 → A user account was created.
2. Event ID 4732 → A member was added to a security-enabled local group.

This pair is important because it shows an initial user object creation followed by a high-risk group assignment. The SOC must evaluate whether the creation and group assignment were expected. In a legitimate environment, a system administrator may create a service account, add it to the local Administrators group, or else create a user account for an approved maintenance workflow. The legitimate or malicious nature depends on evidence beyond the raw event code.

## Detection Guidance

An effective detection strategy in Splunk should:

- Search for Event ID 4720 over a defined time range.
- Search for Event ID 4732 where `Group Name` is `Administrators`.
- Correlate the `Target Account Name` and `Member Name` fields from the events.
- Compare `Subject Account Name` and `Subject Logon ID` fields to known legitimate administrator activity.
- Review the host and source network address associated with the event.
- Correlate related events such as logon events and post-account activity events.

## Important Caution

Do not automatically conclude malicious behavior merely because an Event ID 4720 and Event ID 4732 correlation has occurred. The context must be assessed. A legitimate administrator or change-management process may create a temporary account and assign it to an appropriate group. The final verdict must depend on the overall evidence, including any approved request, expected timing, source host, and post-creation activity.
