# Incident Response

## Response Objective

Validate the suspicious authentication, protect the account if the activity is unauthorized, and preserve enough context for investigation. Actions should be proportionate to the evidence and approved by the organization's response process.

## Immediate Response

1. Validate the login and confirm the account, time, source, and authentication result.
2. Contact or verify the account owner.
3. Lock the affected account if the activity is unauthorized.
4. Force a password reset.
5. Review active sessions.
6. Review recent authentication activity.
7. Investigate post-login activity.
8. Block the suspicious source if appropriate.

## Example Lab Commands

### Lock the Account

Only perform this action when the response decision calls for containment:

```bash
sudo passwd -l remoteuser
```

### Review Current and Recent Sessions

```bash
who
w
last
```

These commands help identify current sessions and recent login history. They do not replace a complete audit of the relevant authentication and endpoint data.

### Inspect Authentication Logs

```bash
sudo grep -a "remoteuser" /var/log/auth.log
```

Use the raw records to validate the Splunk findings and look for related successful or failed authentication activity.

## Production Considerations

Blocking an IP should be done carefully. A legitimate VPN, corporate proxy, cloud proxy, NAT gateway, or mobile network may cause a valid user to appear from an unusual source. Confirm ownership and business context before blocking where possible.

The private lab address `192.168.175.200` is an untrusted or unrecognized source for this exercise only. It does not represent a real external attacker or a geographic origin.

## Response Evidence to Record

- Affected account: `remoteuser`
- Trusted baseline: `192.168.175.130`
- Suspicious source: `192.168.175.200`
- Confirmed event: `2026-09-04 23:48:53`
- Confirmed event: `2026-09-05 20:28:29`
- Ubuntu log source: `/var/log/auth.log`
- Detection platform: Splunk
- Decision: true positive for the controlled suspicious-source detection

Do not add response results that were not actually performed in the lab.
