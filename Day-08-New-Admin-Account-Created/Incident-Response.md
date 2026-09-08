# Incident Response

## Response Objective

The incident response objective is to contain and remediate any unsupported creation of a new local user account and the assignment of that account to the local `Administrators` group. The response must preserve the evidence used to identify unauthorized persistence, isolate affected systems where necessary, and coordinate with IT or change-management teams.

## Response Workflow

### Step 1 — Contain the Account

If the newly created account is unsupported, disable or remove the account from the local system. The account should be quarantined before further impact occurs.

Recommended containment actions:

- Disable the new account: `[INSERT ACCOUNT NAME]`
- Remove it from the `Administrators` group: `Administrators`
- Remove the account object from the host: `[INSERT ACCOUNT NAME]`
- Preserve logs and evidence before remediation

### Step 2 — Validate the Scope

Review the host and the event stream for any further signs of privilege assignment or unauthorized access. Confirm whether any additional accounts have been created on the same host or across the environment.

Recommended items to verify:

- Additional new local accounts: `[INSERT EVIDENCE]`
- Additional admin group changes: `[INSERT EVIDENCE]`
- Source host or SSH access path: `[KALI_IP]`
- Caller account: `itadmin` or `[INSERT SUBJECT ACCOUNT]`

### Step 3 — Communicate with Stakeholders

Notify the incident owner, system owner, and change-management team that a high-risk detection has been identified. The communication should reference the evidence without claiming malicious intent prematurely.

### Step 4 — Recover and Remediate

After containment, perform recovery by:

- Removing unauthorized account objects
- Reviewing group membership changes
- Verifying the approved IT record or identifying gaps
- Resetting and monitoring any credential or service account used to create the new object

### Step 5 — Post-Incident Review

A post-incident review should assess:

- Why the account was created
- Whether the automated detection caught the event
- Whether the Windows Security logs were present and normalized correctly in Splunk
- Whether the credential owner `itadmin` was approved and monitored
- Whether the change-management process had a request on file

## Severity and Risk

This scenario represents a high-risk pattern because it involves:

- A new account creation
- A local administrator group membership change
- A privileged local group that can persist access or provide long-term control

The severity remains dependent on the evidence. Severity is not assigned based on the event code alone.

## Response Priorities

1. Contain and disable unauthorized account.
2. Preserve event evidence.
3. Identify who initiated the account creation.
4. Validate any approved request.
5. Review account activity and confirm whether any post-creation actions occurred.
