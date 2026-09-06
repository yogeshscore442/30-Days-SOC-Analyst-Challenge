# Screenshot Checklist – Account Lockout Investigation

Capture screenshots only from the isolated lab. Do not include real passwords, tokens, unrelated personal data, or evidence from external systems. If a screenshot has not been captured, leave it absent rather than creating a fake image.

| Filename | What it proves | Where to use it | Why it matters to a SOC analyst |
|---|---|---|---|
| `01-pam-faillock-config.png` | The active `pam_faillock` configuration, including `deny=3` and `unlock_time=300` | Attack Simulation and Incident Report evidence | Establishes the policy that produced the lockout condition |
| `02-kali-ssh-failed-login.png` | Controlled failed SSH attempts from Kali | Attack Simulation | Shows how the authentication events were generated in the lab |
| `03-faillock-status.png` | `faillock --user remoteuser` output and failure state | Attack Simulation and Incident Report evidence | Correlates the PAM state with the authentication failures |
| `04-ubuntu-auth-log.png` | Relevant failed or accepted `auth.log` entries | Attack Simulation and Incident Report evidence | Preserves the host-side authentication timeline |
| `05-splunk-failed-login-detection.png` | Splunk results for failed `remoteuser` authentication | Splunk Detection | Demonstrates SIEM detection of the event sequence |
| `06-splunk-source-ip-analysis.png` | Source-IP counts extracted from failed events | Splunk Detection and Investigation | Helps distinguish one source from multiple sources |
| `07-splunk-authentication-timeline.png` | Ordered failed and accepted authentication events | Investigation | Supports timing and post-failure correlation |
| `08-post-lockout-analysis.png` | Search results for successful authentication after failures | Investigation and Incident Report | Raises or lowers priority based on evidence of subsequent access |
| `09-response-evidence.png` | Authorized response checks such as sessions, history, or account state | Incident Response | Documents containment and validation steps |

## Capture Notes

For every screenshot, verify that the visible account, source, victim, command or query, and relevant result are readable. Record the actual timestamp from the lab in the incident report only when it is visible in the captured evidence. Do not claim that a screenshot proves an event that it does not show.
