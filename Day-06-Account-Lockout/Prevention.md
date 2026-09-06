# Prevention – Account Lockout

Account lockout is one layer of an authentication defense strategy. It should be tuned with monitoring and recovery procedures so that it reduces guessing opportunities without creating avoidable denial of service for legitimate users.

## Controls and Practices

- **Strong password policies:** Require passwords that resist guessing and reuse while supporting secure recovery.
- **MFA:** Add another factor so a password alone is insufficient.
- **SSH keys:** Prefer managed SSH keys over password authentication for administrative access.
- **Disable password authentication where appropriate:** After validating key-based access and recovery paths, disable SSH password authentication where the environment permits it.
- **Rate limiting:** Slow repeated authentication attempts and reduce automated guessing opportunities.
- **Fail2ban:** Dynamically restrict sources that repeatedly trigger configured failures, with careful allowlisting and review.
- **Account lockout policies:** Use `pam_faillock` or the approved platform control with documented thresholds and unlock behavior.
- **SIEM monitoring:** Ingest `/var/log/auth.log` and correlate failures, successes, accounts, sources, and timing.
- **Alerting:** Alert on threshold crossings, repeated lockouts, unusual sources, post-failure successes, and multiple affected accounts.
- **Source-IP reputation:** Enrich public sources when appropriate, while remembering that private lab IPs do not establish geographic origin or reputation.
- **Authentication baselines:** Learn normal users, sources, schedules, and application behavior.
- **User behavior analytics:** Correlate authentication patterns with user and service context rather than treating one event as conclusive.

## Lockout Threshold Tradeoff

A threshold that is too low can lock legitimate users out after a few typos or allow an attacker to cause denial of service. A threshold that is too high gives attackers more opportunities to guess passwords before the control acts.

The security team must balance usability and security. The right value depends on account sensitivity, MFA coverage, source controls, recovery capability, and monitoring quality. Review the policy after observing real authentication behavior and document exceptions for services that use managed credentials.

## Monitoring Recommendations

Create detections for:

- Three or more failures for one account in the configured time window
- Rapid failures from one source
- Failures against multiple accounts from one source
- A successful login after repeated failures or a lockout
- Repeated lockouts over time
- New or untrusted source IPs
- Privileged account lockouts

Tune each alert with known service accounts, maintenance windows, trusted administration sources, and user validation. A useful alert should explain the sequence and provide enough context for a SOC analyst to reach an evidence-based verdict.
