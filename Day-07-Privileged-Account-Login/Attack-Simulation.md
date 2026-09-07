# Privileged Account Login Simulation

## Purpose

This is a controlled simulation, not exploitation of a real system. It represents a situation in which an attacker has obtained valid privileged credentials and attempts remote access. The lab uses a dedicated test account and an isolated Windows victim.

## Procedure

From Kali Linux, connect to the authorized Windows lab host:

```bash
ssh itadmin@<WINDOWS_IP>
```

Enter the lab password locally. Do not record or publish it.

After login, verify the account context using appropriate Windows commands. For example:

```cmd
whoami
hostname
```

If the environment supports it, verify the account's local group context without exposing credentials:

```cmd
net user itadmin
```

Exit the session:

```cmd
exit
```

## Activity Record

| Field | Value |
|---|---|
| Source system | Kali Linux |
| Source IP | `[INSERT KALI IP]` |
| Destination system | Windows victim |
| Destination IP | `[INSERT WINDOWS IP]` |
| Account used | `itadmin` |
| Authentication method | SSH |
| Login timestamp | `[INSERT TIMESTAMP]` |
| Result | `[INSERT SUCCESS/FAILURE]` |

## Evidence

[INSERT SCREENSHOT - SSH LOGIN]

The screenshot must show only the authorized lab activity and must not reveal the password or other secrets.
