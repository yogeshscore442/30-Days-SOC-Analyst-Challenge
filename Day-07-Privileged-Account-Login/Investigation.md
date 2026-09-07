# Investigation

## 1. Alert/Detection

The investigation begins when a privileged account authentication event is observed in Windows Security logs or a SIEM detection. The event should not automatically be called malicious.

- Detection source: `[INSERT DETECTION SOURCE]`
- Detection time: `[INSERT TIMESTAMP]`
- Triggering event: `[INSERT EVENT ID AND RESULT]`

## 2. Authentication Verification

Check:

- Was the account expected to log in?
- Was the login successful?
- What was the source IP?
- What was the timestamp?
- What Logon Type was recorded?
- Which authentication package was used?
- Is the Logon ID available for correlation?

Record the result:

`[INSERT AUTHENTICATION ANALYSIS]`

## 3. Privilege Verification

Review Event ID 4672 and determine whether special privileges were assigned to the new logon. Correlate the event with Event ID 4624 using account, host, timestamp, and Logon ID where available.

`[INSERT PRIVILEGE ANALYSIS]`

## 4. Source Verification

Determine:

- Is the source IP known?
- Is it an approved administrative workstation?
- Is it part of the expected lab network?
- Is the login time expected?
- Is the source a private RFC1918 address?

Private lab IP addresses should not be treated as public threat-intelligence indicators or geolocated. Record the network context instead:

`[INSERT SOURCE VERIFICATION]`

## 5. Timeline

| Time | Event | Account | Source IP | Event ID | Interpretation |
|---|---|---|---|---|---|
| `[INSERT TIME]` | `[INSERT EVENT]` | `itadmin` | `[INSERT IP]` | `[INSERT ID]` | `[INSERT INTERPRETATION]` |
| `[INSERT TIME]` | `[INSERT EVENT]` | `itadmin` | `[INSERT IP]` | `[INSERT ID]` | `[INSERT INTERPRETATION]` |

## 6. Verdict

Possible outcomes:

- **Benign / Expected:** The account, source, time, and activity are authorized and consistent with the lab or approved administration.
- **Suspicious:** The activity is unusual or insufficiently authorized, but evidence does not yet prove unauthorized access.
- **Confirmed Unauthorized Access:** Evidence supports access that was not authorized, or related malicious activity is confirmed.

Final assessment:

`[ANALYST VERDICT - COMPLETE AFTER INVESTIGATION]`

Do not label this event as unauthorized privileged access unless the collected evidence supports that conclusion.
