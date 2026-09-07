# Prevention

- Apply least privilege and grant only the permissions required for the task.
- Use separate administrative and normal user accounts.
- Require strong, unique passwords and protect them from reuse.
- Enable MFA where supported.
- Use Privileged Access Management for elevated credentials.
- Restrict remote administration to approved hosts, networks, and protocols.
- Segment administrative networks from ordinary user networks.
- Use hardened administrative workstations for privileged tasks.
- Alert on privileged logons and special-privilege assignments.
- Monitor activity outside expected administrative hours.
- Baseline normal source IPs and administrative workflows.
- Review privileged accounts, group membership, and unused credentials regularly.
- Remove or disable temporary lab accounts after testing.
- Forward Windows Security logs reliably and protect their integrity.
- Correlate authentication with endpoint and network telemetry.

Controls should support investigation rather than generate an assumption that every privileged login is malicious. Authorization, source, time, and follow-on activity remain important context.
