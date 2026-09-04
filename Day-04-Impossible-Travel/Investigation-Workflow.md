# Investigation Workflow

```text
Authentication Event
        ↓
Identify User
        ↓
Extract Source IP
        ↓
Sort Events by Time
        ↓
Compare Previous Login
        ↓
Calculate Time Difference
        ↓
Different Source IP?
        ↓
Short Time Interval?
        ↓
Potential Impossible Travel
        ↓
Validate Location / User / Device / MFA
        ↓
Determine True Positive or False Positive
        ↓
Respond and Document
```

In this lab, the workflow ended with a potential behavioral indicator because the source addresses are private RFC1918 lab addresses. Geographic validation is therefore unavailable.
