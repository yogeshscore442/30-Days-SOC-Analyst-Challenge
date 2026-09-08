# Splunk Queries

## Splunk Collection and Normalization

The lab uses the Splunk Windows Security data source, represented by:

```text
source="WinEventLog:Security"
```

Windows add-ons often expose normalized fields such as `Account_Name`, `Account_Domain`, `Caller_User_Name`, `Host`, or `Subject_Account_Name`. Field names vary by index configuration and data source. Prior to writing the final incident report, confirm the field names visible in the local lab environment.

## New Account Creation

Search for account creation events:

```spl
index=* source="WinEventLog:Security" EventCode=4720
| table _time, Account_Name, Caller_User_Name
```

If the environment uses a different field mapping, replace `Account_Name` and `Caller_User_Name` with the appropriate field names from the raw event or the Windows TA normalization layer.

## Administrators Group Membership Change

Search for membership events targeting the `Administrators` group:

```spl
index=* source="WinEventLog:Security" EventCode=4732 Group_Name="Administrators"
| table _time, host, Member_Name, Group_Name, Subject_Account_Name, Subject_Logon_ID
```

## Correlate 4720 and 4732

The key correlation question is whether the newly created account and the account added to `Administrators` are linked to the same event chain.

```spl
index=* source="WinEventLog:Security" (EventCode=4720 OR EventCode=4732)
| eval target_account=coalesce(Target_Account_Name, Account_Name, Member_Name)
| eval subject_account=coalesce(Subject_Account_Name, Caller_User_Name)
| sort 0 _time
| table _time, host, EventCode, target_account, subject_account, Subject_Logon_ID, Group_Name, Member_Name
```

## Specific Pair Search

Search for a specific target account or new account created by the lab scenario.

```spl
index=* source="WinEventLog:Security" (EventCode=4720 OR EventCode=4732) Member_Name="backdooruser" OR Target_Account_Name="backdooruser"
| sort 0 _time
| table _time, host, EventCode, Target_Account_Name, Member_Name, Subject_Account_Name, Subject_Logon_ID, Group_Name
```

## Post-Creation Activity Search

This search is useful for post-creation activity and proof of follow-on events.

```spl
index=* source="WinEventLog:Security" EventCode=4624 Account_Name="backdooruser"
| table _time, Account_Name, Logon_Type, Source_Network_Address, host
```

If the new account is later used for a logon or access event, correlate event 4624 and the applicable Windows logon events. Do not assume the account was used merely because it was created.

## Useful Field Review

Recommended fields to preserve when documenting the investigation:

- `_time`
- `host`
- `EventCode`
- `Account_Name`
- `Target_Account_Name`
- `Member_Name`
- `Group_Name`
- `Caller_User_Name`
- `Subject_Account_Name`
- `Subject_Logon_ID`
- `Source_Network_Address`

## Evidence to Preserve

- Search time range: `[INSERT TIME RANGE]`
- Index/source used: `[INSERT INDEX AND SOURCE]`
- Event ID 4720 result: `[INSERT SPLUNK RESULT]`
- Event ID 4732 result: `[INSERT SPLUNK RESULT]`
- Correlation result: `[INSERT EVIDENCE]`
- Account created: `backdooruser` or `[INSERT ACCOUNT NAME]`
- Added to group: `Administrators`
- Subject account: `[INSERT SUBJECT ACCOUNT]`
- Subject logon ID: `[INSERT SUBJECT LOGON ID]`
- Screenshot evidence: `[INSERT SCREENSHOT — NEW ACCOUNT LIST]`
