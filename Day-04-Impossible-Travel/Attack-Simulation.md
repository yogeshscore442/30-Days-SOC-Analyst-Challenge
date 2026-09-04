# Attack Simulation

## 1. Lab Architecture

| Role | System | Details |
|---|---|---|
| Source simulation | Kali Linux | Generates the SSH authentication activity |
| Victim/target | Ubuntu Linux | Runs SSH and records `/var/log/auth.log` |
| SIEM | Splunk | Searches and correlates Ubuntu authentication events |

This is a controlled suspicious-login simulation inside a personal lab. It is not a real-world compromise.

## 2. Ubuntu Target Setup

The Ubuntu target runs SSH and writes authentication events to:

```text
/var/log/auth.log
```

The target account used in this exercise is `remoteuser`.

## 3. First SSH Authentication

From Kali, connect normally to the Ubuntu target:

```bash
ssh remoteuser@192.168.175.134
```

After successful authentication, close the session:

```bash
exit
```

This produced a successful login from source IP `192.168.175.130`.

## 4. Second Source IP Simulation

The secondary private address `192.168.175.200` was used to simulate a different source inside the lab. Adding a secondary private IP is only a source-address simulation; it is not a VPN or geographic location.

## 5. Second SSH Authentication

Bind the SSH connection to the secondary source address:

```bash
ssh -b 192.168.175.200 remoteuser@192.168.175.134
```

After successful authentication, close the session:

```bash
exit
```

This produced a second successful login from source IP `192.168.175.200`.

## 6. Raw Log Verification

Verify successful password authentications on Ubuntu:

```bash
sudo grep -a "Accepted password" /var/log/auth.log
```

Filter for the lab account:

```bash
sudo grep -a "Accepted password for remoteuser" /var/log/auth.log
```

Display successful and failed password events for review:

```bash
sudo grep -aE "Accepted password|Failed password" /var/log/auth.log
```

The relevant raw events were:

```text
Accepted password for remoteuser from 192.168.175.200 port 60199 ssh2
Accepted password for remoteuser from 192.168.175.130 port 34898 ssh2
```

## 7. Evidence Collection

Capture the Ubuntu log output and Splunk searches listed in [Splunk Queries](Splunk-Queries.md). Use the filenames in [Screenshots/README.md](Screenshots/README.md) for the evidence set.

## 8. Cleanup

After collecting evidence, close active SSH sessions with `exit` and remove any temporary secondary source-IP configuration according to the lab's normal network configuration procedure. No cleanup action is claimed as completed unless recorded separately.
