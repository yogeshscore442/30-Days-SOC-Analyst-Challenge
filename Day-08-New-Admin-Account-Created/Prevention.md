# Prevention

## Preventive Measures

Prevention focuses on the following areas:

- Privileged access management
- Windows local group auditing
- Change-management discipline
- Credential hygiene
- Account lifecycle enforcement

## Recommended Controls

### 1. Privileged Access Controls

Use approved privileged accounts only. Monitor and review `itadmin` and other privileged account activity. Separate administrative roles from service or shared-use accounts and avoid direct local administrative access from uncontrolled source systems.

### 2. Local Account Creation Monitoring

Create detections for Event ID 4720 and Event ID 4732, specifically when the target group is `Administrators`. Monitor suspicious account names and group changes and correlate them with the subject account and logon ID.

### 3. Least Privilege Model

Privileged accounts should have the minimum level of access needed. The `Administrators` group membership should be reviewed regularly, and temporary or maintenance accounts should be disabled when not in use.

### 4. Change-Management Approval

All account creation and privileged group membership changes should require an approved ticket or documented change record. If an account is created outside an approved window or without a ticket, the event should be treated as suspicious until proven otherwise.

### 5. Service Naming Discipline

Avoid creating service naming patterns that hide the intent of accounts. Names such as `svc_update`, `helpdesk_temp`, or `sql_admin` can be neutral or suspicious depending on context. Analysts should use event behavior, request records, and source evidence rather than name alone.

### 6. Log Collection and Correlation

Ensure the Windows security log stream reaches Splunk and preserves fields such as:

- `EventCode`
- `Target Account Name`
- `Subject Account Name`
- `Subject Logon ID`
- `Group Name`
- `Member Name`
- `Source_Network_Address`

This improves the ability of the SOC to detect and validate account creation and group membership changes.

## Prevention Reminders

The investigation must avoid making a conclusion solely because the event occurred. The controlled-lab documentation purposely uses placeholders and `INSERT` fields so that real evidence, not assumptions, drives the final incident assessment.
