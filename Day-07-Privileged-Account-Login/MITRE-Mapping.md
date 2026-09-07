# MITRE ATT&CK Mapping

## T1078.003 - Valid Accounts: Local Accounts

This scenario is relevant to **T1078.003 - Valid Accounts: Local Accounts** because the SSH session uses valid credentials for a local Windows account. An attacker who obtains valid local privileged credentials may use them to access a host without exploiting a vulnerability.

Successful authentication alone does not prove compromise or malicious intent. The account was intentionally created for this controlled exercise, so the observed technique and the investigation hypothesis must remain separate.

| Classification | Assessment |
|---|---|
| Technique observed | Valid Accounts: Local Accounts (T1078.003), if the recorded event confirms valid local-account authentication |
| Investigation hypothesis | Possible unauthorized use of privileged credentials |
| Evidence required | Confirmed account, authentication result, source, timestamp, logon details, authorization context, and related activity |

Do not claim additional techniques unless the evidence supports them. An Event ID 4672 record indicates special privileges assigned to a logon; it does not independently establish another ATT&CK technique.
