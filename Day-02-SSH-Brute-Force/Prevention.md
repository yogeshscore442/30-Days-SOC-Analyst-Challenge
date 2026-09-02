# SSH Brute Force Prevention

## 1. Disable Password Authentication

Use SSH keys where appropriate and disable password authentication after confirming that approved administrative access remains available. Apply the change through controlled configuration management and retain a recovery path.

## 2. Use Strong Authentication

Require strong, unique passwords where passwords remain enabled. Prefer SSH keys protected with passphrases and add multi-factor authentication where supported.

## 3. Restrict SSH Access

Limit SSH exposure to trusted networks, VPN address ranges, or approved administrative hosts where possible. Avoid exposing management services more broadly than required.

## 4. Firewall Controls

Use UFW or an equivalent firewall to allow SSH only from approved sources and deny unnecessary inbound traffic. Review and verify firewall rules after changes.

## 5. Fail2ban

Fail2ban can monitor repeated authentication failures and temporarily block sources that exceed a configured threshold. Tune exclusions, thresholds, and ban durations to avoid disrupting legitimate administrators.

## 6. Account Protection

Use account lockout or rate-limiting controls where appropriate, especially for sensitive accounts. Protect privileged accounts, remove unused accounts, and review account status during investigations.

## 7. Wazuh Monitoring

Monitor Wazuh for:

- `authentication_failed` events
- Repeated SSH failures
- Source IP and target username
- Authentication success after failures
- Changes in failure volume or source distribution

Correlate alerts with timestamps, account context, SSH metadata, and raw Ubuntu authentication logs.

## 8. SOC Detection Logic

Multiple authentication failures from one source against one account within a short time window should increase suspicion. Detection logic should consider attempt frequency, account sensitivity, source reputation, successful authentication after failures, and whether the activity matches expected administration.

Prevention and detection controls should be tested in an isolated lab before production rollout.
