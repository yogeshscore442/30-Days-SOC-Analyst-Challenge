# Prevention and Response Controls

## Immediate Containment
After confirming the controlled attack, perform the following on Ubuntu:

```bash
sudo passwd -l user3
sudo ufw deny from <ATTACKER_IP>
sudo pkill -u user3
last user3
sudo grep user3 /var/log/auth.log | grep sudo
```

- Lock the affected test account.
- Block the controlled attack source with UFW.
- Terminate the affected user's active session.
- Review login history and sudo activity as investigation checks.
- Reset the password as a recovery action.

## Preventive Controls
- Enforce strong password policies.
- Block predictable or common passwords.
- Enable MFA where possible.
- Use SSH key-based authentication.
- Disable password-based SSH authentication where appropriate.
- Apply account protection and rate limiting.
- Use fail2ban or equivalent controls where appropriate.
- Review account security after an authentication incident.

## Detection Controls
- Monitor Ubuntu SSH/PAM authentication events in Wazuh.
- Review authentication failures by `data.srcip` and `data.srcuser`.
- Correlate the same source IP with multiple distinct usernames in a short time window.
- Cross-check Wazuh events against `/var/log/auth.log`.
- Monitor successful authentication following related failures.
- Review login history and sudo activity for affected accounts.

### Custom Wazuh Correlation
A custom Wazuh rule can be designed to identify this pattern and generate a higher-severity alert:

```text
Same source IP
+
Multiple distinct usernames
+
Short time window
+
Multiple authentication failures
=
Potential Password Spraying
```

This is a recommendation for a future detection control. No custom rule is claimed to already exist.

## Response Controls
- Lock the affected account.
- Block the attack source with UFW.
- Terminate active sessions for the affected account.
- Reset the affected account password.
- Review login history and sudo activity.
- Recommend stronger authentication controls and continue monitoring.
