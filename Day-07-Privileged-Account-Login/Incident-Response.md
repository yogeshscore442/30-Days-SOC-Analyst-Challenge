# Incident Response

Response must be proportional to the evidence and the account's business or lab role. Validate the event before taking disruptive action.

## If Unauthorized Privileged Access Is Confirmed

1. Validate the event and preserve the relevant Windows and Splunk evidence.
2. Identify the affected account, host, source, and time range.
3. Disable or restrict the account if appropriate under the local response procedure.
4. Reset the credentials through an approved administrative process.
5. Review active sessions and terminate unauthorized sessions when justified.
6. Investigate related authentication events before and after the observed login.
7. Review process, command, and endpoint activity associated with the session.
8. Investigate the source IP and its ownership or network context.
9. Check for persistence, additional accounts, group changes, and other affected hosts.
10. Document the incident, decisions, evidence, and escalation path.

## Lab/Administrative Examples

The following are examples only. Confirm authorization, account ownership, and operational impact before using them. Do not run them against production systems as part of this exercise.

```cmd
net user itadmin /active:no
net user itadmin *
```

Do not blindly block an internal IP. Validate the source, identify legitimate dependencies, and follow the organization's containment process first.

## When Activity Is Expected

If the account and source are confirmed as authorized lab activity, document the validation, retain the evidence, and close or tune the detection according to the lab objective. Do not suppress all privileged authentication alerts merely because one login was benign.
