# Detection

## Windows Security Events

### Event ID 4624 - Successful Logon

Event ID 4624 records a successful logon. Review the event fields to determine which account authenticated, when the authentication occurred, how it occurred, and whether a network source was recorded.

### Event ID 4672 - Special Privileges Assigned to New Logon

Event ID 4672 indicates that special privileges were assigned to a new logon. It should be correlated with the related authentication event and other evidence. It is not, by itself, proof of malicious activity.

The event may be expected when a privileged local account authenticates. The analyst must still verify authorization, source, timing, and activity after logon.

## Useful Fields

- Account Name
- Account Domain
- Logon Type
- Source Network Address
- Authentication Package
- Logon ID
- Privilege List

Do not claim a specific Logon Type until it is confirmed in the actual event. SSH-generated Windows events can vary depending on the Windows OpenSSH implementation, configuration, audit policy, and Splunk parsing.

## Detection Workflow

1. Search for Event ID 4624 around the observed login time.
2. Filter or inspect the account name `itadmin`.
3. Record the source network address and logon type exactly as observed.
4. Search for Event ID 4672 around the same time.
5. Correlate events using timestamp, account, host, and Logon ID where available.
6. Determine whether the source and time were expected.
7. Preserve the raw event and Splunk search result as evidence.

## Evidence Record

- Event ID 4624 result: `[INSERT SPLUNK RESULT]`
- Event ID 4672 result: `[INSERT SPLUNK RESULT]`
- Account Name: `[INSERT ACCOUNT NAME]`
- Account Domain: `[INSERT ACCOUNT DOMAIN]`
- Logon Type: `[INSERT LOGON TYPE]`
- Source Network Address: `[INSERT SOURCE NETWORK ADDRESS]`
- Authentication Package: `[INSERT AUTHENTICATION PACKAGE]`
- Logon ID: `[INSERT LOGON ID]`
- Privilege List: `[INSERT PRIVILEGE LIST]`
