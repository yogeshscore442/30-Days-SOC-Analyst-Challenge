# Splunk Queries

Field names and source values vary by Windows TA/add-on and ingestion format. Confirm the local field names before relying on a query. Replace `index=*` with the confirmed index where possible.

## Successful Logons

```spl
index=* source="WinEventLog:Security" EventCode=4624
| table _time, Account_Name, Logon_Type, Source_Network_Address
```

## Privileged Activity

```spl
index=* source="WinEventLog:Security" EventCode=4672
| table _time, Account_Name, Privilege_List
```

## Specific Test Account

```spl
index=* source="WinEventLog:Security" EventCode=4624 Account_Name="itadmin"
| table _time, Account_Name, Logon_Type, Source_Network_Address
```

## Correlate 4624 and 4672

A simple time-window search can place both event types in the same result set. Use the account, host, timestamp, and Logon ID to determine whether individual events belong to the same logon. The exact field names may need adjustment.

```spl
index=* source="WinEventLog:Security" (EventCode=4624 OR EventCode=4672) Account_Name="itadmin"
| sort 0 _time
| table _time, host, EventCode, Account_Name, Account_Domain, Logon_ID, Logon_Type, Source_Network_Address, Privilege_List
```

Where the environment exposes a consistent Logon ID, a join or transaction can support correlation. Avoid treating proximity in time alone as proof of a match.

```spl
index=* source="WinEventLog:Security" (EventCode=4624 OR EventCode=4672) Account_Name="itadmin"
| stats values(EventCode) as EventCodes values(Logon_Type) as LogonTypes values(Source_Network_Address) as SourceAddresses values(Privilege_List) as Privileges earliest(_time) as first_seen latest(_time) as last_seen by host, Logon_ID, Account_Name
```

## Source IP Investigation

```spl
index=* source="WinEventLog:Security" EventCode=4624 Account_Name="itadmin"
| eval source_ip=coalesce(Source_Network_Address, src_ip, src)
| table _time, source_ip, Account_Name, Logon_Type, host
| sort 0 _time
```

If the Windows add-on uses different field names, substitute the fields shown in the raw event. Record the final query and returned result in the incident report.

## Evidence to Preserve

- Search time range: `[INSERT TIME RANGE]`
- Index/source used: `[INSERT INDEX AND SOURCE]`
- Query used: `[INSERT FINAL QUERY]`
- Returned 4624 result: `[INSERT SPLUNK RESULT]`
- Returned 4672 result: `[INSERT SPLUNK RESULT]`
- Source IP: `[INSERT SOURCE IP]`
- Account: `[INSERT ACCOUNT]`
- Timestamp: `[INSERT TIMESTAMP]`
- Logon Type: `[INSERT LOGON TYPE]`
