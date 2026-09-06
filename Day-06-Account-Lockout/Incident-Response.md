# Incident Response – Account Lockout

## Validate First

Verify whether the lockout is legitimate before taking disruptive action. Confirm the affected account, threshold, timing, source IP, previous history, user activity, and any successful authentication after the failures.

A lockout may be caused by a password typo, forgotten password, stored old credentials, a misconfigured application, brute-force activity, password spraying, or coordinated attempts from multiple sources.

## Response Procedure When Malicious Activity Is Confirmed

1. Lock or disable the affected account if necessary.
2. Force a password reset.
3. Review active sessions.
4. Review authentication history.
5. Investigate the source IP.
6. Block the source if appropriate.
7. Search for other affected accounts.
8. Check for successful authentication.
9. Review post-login activity.
10. Escalate according to incident severity.

## Lab Commands

Check account state:

```bash
sudo faillock --user remoteuser
```

Lock the account when justified by the lab response plan:

```bash
sudo passwd -l remoteuser
```

Review active and historical sessions:

```bash
who
w
last remoteuser
```

Review authentication events:

```bash
sudo grep -a "remoteuser" /var/log/auth.log
```

Review the source IP and other accounts in Splunk using the searches in [Splunk Queries](Splunk-Queries.md).

## Response Considerations

Account disabling, password resets, and source-IP blocking can interrupt legitimate users or services. In real environments, perform them only after appropriate validation, authorization, and change control. Preserve relevant logs before making changes, document the action and time from actual evidence, and confirm recovery after containment.

If the evidence supports only a benign lockout, avoid unnecessary blocking. Document the cause, help the user or application correct the credential problem, and consider tuning alerting or the policy if repeated false positives occur.

## Closure Criteria

Close or escalate the case after documenting:

- Evidence that the threshold was reached
- Source and timing analysis
- Account and session review
- Whether a successful authentication followed the failures
- User or application validation
- Containment actions, if any
- The evidence-based final classification
