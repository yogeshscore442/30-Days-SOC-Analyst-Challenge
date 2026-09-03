# Day 03 - Password Spraying Investigation

## Objective
Investigate a controlled password-spraying simulation against an Ubuntu SSH target, correlate authentication events in Wazuh, validate the findings with Ubuntu authentication logs, and document containment and recovery actions.

## Lab Architecture

| Component | Role |
|---|---|
| Kali Linux | Attack simulation machine |
| Ubuntu Linux | Target machine |
| Wazuh | SIEM, detection, and investigation layer |
| CrackMapExec | Attack simulation tool |
| UFW | Firewall and containment control |

## Technique
**MITRE ATT&CK:** [T1110.003 - Password Spraying](https://attack.mitre.org/techniques/T1110/003/)

The simulation tests multiple usernames with the same lab-only password. It uses `<ATTACKER_IP>` as the source placeholder and `<TARGET_IP>` as the target placeholder in public documentation.

## Detection and Investigation
Wazuh monitors Ubuntu SSH/PAM authentication events. The investigation correlates authentication failures by source IP, distinct usernames, and time window, then checks for successful authentication and validates the result against `/var/log/auth.log`.

## Response
The documented response locks the affected test account, blocks the attack source with UFW, terminates the affected user's session, resets the password, and reviews login and sudo activity.

## Documentation
- [Attack Simulation](Attack-Simulation.md)
- [Detection and Investigation](Detection-and-Investigation.md)
- [Prevention](Prevention.md)
- [Incident Report](Incident-Report.md)
- [Screenshot Documentation](Screenshots/README.md)

## Key Learning
A single failed login may be normal. The combination of one source targeting multiple usernames in a short time window, using the same password, is the investigative pattern that supports password-spraying classification.

This is an isolated, authorized cybersecurity lab. The test password is lab-only and must not be treated as a real credential.
