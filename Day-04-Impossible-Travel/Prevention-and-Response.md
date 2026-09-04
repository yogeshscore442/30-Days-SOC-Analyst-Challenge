# Prevention and Response

## Preventive Controls

- **MFA:** Require an additional factor for SSH and other sensitive access.
- **Strong authentication:** Prefer strong credentials and key-based SSH authentication where appropriate.
- **Conditional access:** Apply access policies based on user, device, network, and risk.
- **VPN monitoring:** Track approved VPN gateways and unexpected source changes.
- **Login anomaly detection:** Correlate account, source, time, and authentication result.
- **UEBA:** Compare activity with the user's normal behavior.
- **Session monitoring:** Review active sessions and post-login activity.
- **Account protection:** Use least privilege, lockout controls, credential rotation, and administrative review.
- **SIEM correlation:** Centralize authentication logs and alert on meaningful combinations of signals.
- **User verification:** Confirm whether the login was expected with the account owner or service owner.

Controls depend on the environment, identity architecture, network design, and business requirements.

## SOC Response

If the activity were confirmed suspicious in a real environment, an analyst could:

1. Validate the user's identity and expected location.
2. Review authentication history.
3. Check MFA events.
4. Review endpoint and device information.
5. Investigate post-login activity.
6. Temporarily disable or restrict the account if compromise is confirmed.
7. Revoke active sessions where appropriate.
8. Reset credentials if compromise is confirmed.
9. Block malicious infrastructure when appropriate.
10. Document the incident and supporting evidence.

These are response recommendations only. They are not claims that the actions were performed in this lab.
