# Prevention

## Recommended Controls

- **Multi-factor authentication (MFA):** require a second factor so a password alone is not sufficient.
- **Strong unique passwords:** prevent password reuse and reduce credential-stuffing risk.
- **SSH keys:** prefer managed, protected keys for administrative access.
- **Disable password authentication where appropriate:** reduce password-based SSH exposure after confirming key-based access works.
- **Conditional Access:** require additional verification or deny access based on risk, device, network, or policy.
- **Geo-fencing where appropriate:** restrict access from regions that are genuinely out of scope, while accounting for business travel and remote work.
- **Trusted IP and network baselines:** compare current source behavior with known account and environment patterns.
- **GeoIP enrichment:** add country and region context for public addresses in a real SOC.
- **Threat intelligence:** check ownership, reputation, and known abuse indicators.
- **User and Entity Behavior Analytics (UEBA):** combine source, time, device, account, and activity context.
- **Alerting on anomalous source locations:** create investigation alerts for logins outside a trusted baseline.
- **Account monitoring:** watch for unusual authentication, password changes, lockouts, or privilege changes.
- **Session monitoring:** review active sessions and post-login behavior when a login is suspicious.

## Why Simple IP Detection Is Limited

An IP address is only one signal. A VPN, corporate proxy, cloud proxy, NAT gateway, or mobile network may make a legitimate user appear to originate from an unusual address. Shared infrastructure can also make multiple users appear to use the same source.

Therefore:

> **Suspicious login != automatically malicious login.**

It requires investigation and context. Analysts should correlate the source with the user's confirmation, approved travel, VPN records, MFA events, device information, source ownership, GeoIP data, threat intelligence, and post-login activity.

## Baseline Maintenance

Baselines should be reviewed when users change location, begin using a corporate VPN, change devices, or adopt a new access method. A rigid baseline can create false positives, while an overly broad baseline can hide genuinely unusual behavior.

For this lab, `192.168.175.130` is the trusted baseline and `192.168.175.200` is the untrusted or unrecognized source. These are private lab addresses and should not be treated as real geographic indicators.
