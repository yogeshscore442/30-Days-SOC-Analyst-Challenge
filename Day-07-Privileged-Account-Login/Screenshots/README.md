# Screenshot Checklist

Capture only screenshots produced by the authorized lab. Redact passwords, tokens, personal data, and unrelated host information.

| # | Screenshot | What it proves | Why it matters | Report location |
|---|---|---|---|---|
| 1 | Windows IP configuration | The victim's observed network address | Identifies the destination used by the lab | Lab Setup, Incident Report |
| 2 | Privileged test account creation | `itadmin` was created for the exercise | Establishes the account's lab origin | Lab Setup |
| 3 | Administrators group membership | `itadmin` belongs to the local Administrators group | Confirms the account's privileged status | Lab Setup, Incident Report |
| 4 | Kali SSH connection | Kali initiated the authorized SSH connection | Shows the simulated access path | Attack Simulation |
| 5 | Successful privileged login | The SSH login result and account context | Establishes whether authentication succeeded | Attack Simulation, Incident Report |
| 6 | Windows Event ID 4624 | A successful logon event and its fields | Provides authentication, source, and timing evidence | Detection, Incident Report |
| 7 | Windows Event ID 4672 | Special privileges assigned to the logon | Supports privileged-token analysis | Detection, Incident Report |
| 8 | Splunk 4624 search | The SIEM search and returned successful-logon result | Demonstrates detection workflow | Splunk Queries, Incident Report |
| 9 | Splunk 4672 search | The SIEM search and returned privilege event | Demonstrates privileged-event investigation | Splunk Queries, Incident Report |
| 10 | Source IP evidence | The observed source address in context | Supports source verification | Investigation, Incident Report |
| 11 | Investigation timeline | Events ordered by confirmed timestamps | Shows correlation and reasoning | Investigation, Incident Report |
| 12 | Final incident report | The completed evidence-based assessment | Records the final SOC conclusion | Incident Report |

Do not create fake screenshots. If evidence was not collected, retain the relevant placeholder in the report.
