# SOC Incident Report: Password Spraying

## 1. Incident Summary
A controlled password-spraying simulation tested multiple SSH usernames with one lab-only password. Wazuh authentication-event correlation and Ubuntu authentication logs support successful authentication for the controlled `user3` account.

## 2. Incident Classification
True Positive - Password Spraying in a controlled lab.

## 3. Severity
Low. The activity occurred in an isolated learning lab and is not a real-world breach or real credential compromise.

## 4. Detection Source
Wazuh authentication event correlation using Ubuntu SSH/PAM authentication events.

## 5. Attack Source
`<ATTACKER_IP>`

## 6. Target System
`<TARGET_IP>` (Ubuntu Linux SSH target)

## 7. Target Accounts
`user1`, `user2`, `user3`, `user4`, `testuser`, `admin`

**Affected account:** `user3`

## 8. Attack Technique
Password Spraying

## 9. Timeline
The supplied workflow establishes this sequence; no timestamps are provided:

1. Controlled test users were created on Ubuntu.
2. A lab-only password was configured for `user3`.
3. A username list and single-password file were prepared on Kali.
4. CrackMapExec tested SSH authentication against the target.
5. Wazuh authentication events were correlated by source and username.
6. Ubuntu `/var/log/auth.log` was used for verification.
7. The affected account and source were contained.
8. Password reset and account-security review were identified as recovery actions.

## 10. Detection
The detection approach correlates authentication failures from the same source IP across multiple distinct usernames within a short time window. A dedicated Wazuh password-spraying alert is not claimed.

## 11. Investigation
The investigation reviewed Wazuh fields including `data.srcip`, `data.srcuser`, `rule.id`, `rule.description`, `rule.level`, `timestamp`, and authentication result. It then checked for successful authentication, cross-verified Wazuh with Ubuntu authentication logs, reviewed `last user3`, and checked sudo activity.

## 12. Evidence
- Wazuh authentication failure events associated with `<ATTACKER_IP>`.
- Correlation of the same source with multiple usernames.
- SSH `Accepted password` evidence for `user3`, when present in the supplied lab evidence.
- Ubuntu `/var/log/auth.log` verification.
- Login-history and sudo-activity review commands.
- CrackMapExec simulation output, when captured during lab execution.

Evidence statements must be limited to output actually captured from the lab.

## 13. Impact
The observed impact is limited to the controlled test account in an isolated lab. No production impact, real-world breach, or real credential compromise is claimed.

## 14. Containment
```bash
sudo passwd -l user3
sudo ufw deny from <ATTACKER_IP>
sudo pkill -u user3
```

These actions lock the affected account, block the controlled attack source with UFW, and terminate the affected user's session.

## 15. Eradication
Remove the controlled test access condition by resetting the affected account password and reviewing account security. No malware or persistence is claimed by this exercise.

## 16. Recovery
- Reset the `user3` password.
- Review login history with `last user3`.
- Review sudo activity in `/var/log/auth.log`.
- Recommend stronger authentication controls.
- Continue monitoring authentication events.

## 17. MITRE ATT&CK Mapping
**T1110.003 - Password Spraying**

## 18. Root Cause
The controlled account `user3` was configured with the lab-only test password, allowing the simulation to demonstrate a successful authentication while the same password was tested against multiple usernames.

## 19. Recommendations
- Enforce strong passwords and block common passwords.
- Enable MFA where possible.
- Prefer SSH keys and disable password-based SSH authentication where appropriate.
- Apply rate limiting, account protection, and fail2ban or equivalent controls.
- Create a custom Wazuh correlation rule for the same-source, multiple-user, short-window pattern.

## 20. Final Verdict
**True Positive - Password Spraying in a controlled lab with successful authentication for `user3`.**
