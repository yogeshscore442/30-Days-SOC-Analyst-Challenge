# Screenshot Checklist

Do not create fake screenshots. Capture only evidence produced by the isolated lab, and redact passwords, secrets, unrelated users, and unrelated network details before committing images.

| Screenshot | What it proves | Where it should appear |
|---|---|---|
| `01-kali-ip-configuration.png` | Kali's primary lab IP and interface configuration | [Attack Simulation](../Attack-Simulation.md), Steps 1–2 |
| `02-secondary-ip.png` | Secondary source IP `192.168.175.200/24` is configured on Kali | [Attack Simulation](../Attack-Simulation.md), Step 2 |
| `03-normal-ssh-login.png` | The normal SSH login from the trusted baseline was performed | [Attack Simulation](../Attack-Simulation.md), Step 4 |
| `04-suspicious-source-ssh-login.png` | SSH was bound to the secondary source with `ssh -b` | [Attack Simulation](../Attack-Simulation.md), Step 5 |
| `05-ubuntu-auth-log.png` | Ubuntu `/var/log/auth.log` contains the relevant authentication record | [Attack Simulation](../Attack-Simulation.md), Steps 6–7; [Investigation](../Investigation.md), Step 5 |
| `06-splunk-detection-query.png` | The suspicious-source detection query was entered in Splunk | [Splunk Detection](../Splunk-Detection.md), Primary Detection Query |
| `07-splunk-suspicious-login-results.png` | Splunk returned the untrusted-source login results | [Splunk Detection](../Splunk-Detection.md), Suspicious-Source Query |
| `08-splunk-baseline-analysis.png` | Source counts support comparison with the trusted baseline | [Splunk Detection](../Splunk-Detection.md), Baseline Query |
| `09-investigation-evidence.png` | The analyst's evidence review and confirmed events | [Investigation](../Investigation.md), Steps 3–5 |
| `10-response-evidence.png` | Response-related evidence actually collected in the lab | [Incident Response](../Incident-Response.md), Response Evidence |

Screenshots are optional portfolio evidence. Their absence does not change the confirmed text evidence documented in this challenge.
