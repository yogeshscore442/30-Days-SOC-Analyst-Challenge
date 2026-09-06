# Attack Simulation – Account Lockout Investigation

This procedure intentionally generates failed SSH authentication attempts in an isolated lab. Use only the specified Kali and Ubuntu systems. Do not run these commands against production systems, real accounts, or external targets.

## Lab Values

| Item | Value |
|---|---|
| Source system | Kali Linux |
| Source IP | `192.168.175.130` |
| Victim system | Ubuntu Linux |
| Victim IP | `192.168.175.134` |
| Account | `remoteuser` |
| Protocol | SSH |
| Log source | `/var/log/auth.log` |
| Lockout module | `pam_faillock` |
| Policy | `deny=3`, `unlock_time=300` seconds |

## Step 1 – Install the Required PAM Module

On Ubuntu, install the package that provides the PAM modules:

```bash
sudo apt update
sudo apt install libpam-modules -y
```

`pam_faillock` tracks failed authentication attempts and applies the configured lockout behavior. Package contents and PAM defaults can vary by Ubuntu release, so review the local configuration before changing it.

## Step 2 – Configure Account Lockout

Back up the PAM file before editing it:

```bash
sudo cp /etc/pam.d/common-auth /etc/pam.d/common-auth.bak
```

Open the file:

```bash
sudo nano /etc/pam.d/common-auth
```

Apply the lab configuration carefully and preserve the surrounding PAM ordering:

```text
auth required pam_faillock.so preauth silent deny=3 unlock_time=300
auth [default=die] pam_faillock.so authfail deny=3 unlock_time=300
```

Meaning:

- `deny=3`: three failed authentication attempts trigger the lockout condition.
- `unlock_time=300`: the automatic unlock period is 300 seconds, or five minutes.
- `preauth`: checks the account state before authentication proceeds.
- `authfail`: records or processes a failed authentication result.

PAM configuration directly affects authentication behavior. Incorrect ordering or syntax can prevent legitimate users from logging in. Keep the backup, test from an existing administrative session, and know how to restore the original file:

```bash
sudo cp /etc/pam.d/common-auth.bak /etc/pam.d/common-auth
```

Do not modify production systems for this exercise.

## Step 3 – Verify the Test Account

Confirm that the test account exists:

```bash
id remoteuser
```

If a lab password must be set, use a password known only within the lab and never document it:

```bash
sudo passwd remoteuser
```

Use `<LAB_PASSWORD>` when describing the password in notes. Do not expose real passwords or secrets in screenshots, reports, or Git history.

## Step 4 – Verify SSH Connectivity

From Kali, confirm that a normal login works before generating intentional failures:

```bash
ssh remoteuser@192.168.175.134
```

Enter the valid lab password, confirm access, then exit:

```bash
exit
```

If normal access does not work, troubleshoot the lab before continuing. A failed baseline login is not evidence of the intended lockout test.

## Step 5 – Generate Failed Authentication Attempts

From Kali, start an SSH connection:

```bash
ssh remoteuser@192.168.175.134
```

Enter an intentionally incorrect lab password three or more times. Repeat the command only as needed to generate the controlled events. Do not automate attacks against real systems.

The purpose is to simulate repeated authentication failures and produce observable Ubuntu authentication events. Stop after the controlled test and record the time shown by the lab output or logs.

## Step 6 – Verify Lockout Status

On Ubuntu, inspect the failure record for the account:

```bash
sudo faillock --user remoteuser
```

Review the output for:

- Failed attempt count
- Timestamp information
- The current lockout state, if displayed by the installed version

The actual output is evidence and must be captured from the lab. Do not invent or copy example timestamps into the incident report.

After the five-minute `unlock_time` period, verify the account behavior again if required by the exercise. Follow the local `faillock` implementation and preserve any relevant output.

## Step 7 – Review Ubuntu Authentication Logs

Search for failed passwords:

```bash
sudo grep -a "Failed password" /var/log/auth.log
```

Search for all records involving the test account:

```bash
sudo grep -a "remoteuser" /var/log/auth.log
```

Compare failed and accepted authentication events:

```bash
sudo grep -aE "Failed password|Accepted password" /var/log/auth.log
```

These records establish the authentication timeline, including event times, account name, SSH context, and the source IP recorded by Ubuntu. Preserve the relevant lines as lab evidence, removing or masking secrets if any appear in local command output.

## Expected Evidence

The following items should be collected from the lab rather than fabricated:

- The backed-up and active `pam_faillock` configuration
- `faillock --user remoteuser` output
- Failed authentication entries in `/var/log/auth.log`
- Any accepted authentication after the failures
- Source-IP and timing results from Splunk

Continue with [Splunk Detection](Splunk-Detection.md) after the log source is available in Splunk.
