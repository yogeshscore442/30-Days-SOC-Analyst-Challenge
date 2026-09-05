# Attack Simulation

## Scope and Safety

This is a controlled cybersecurity lab simulation using systems owned and operated for learning. It is not an attack against a real system. Use only the stated lab hosts and account.

## Lab Values

| Item | Value |
|---|---|
| Kali Linux primary source IP | `192.168.175.130` |
| Kali Linux secondary lab IP | `192.168.175.200` |
| Ubuntu victim | `192.168.175.134` |
| Account | `remoteuser` |
| Trusted baseline | `192.168.175.130` |
| Suspicious source | `192.168.175.200` |

## Step 1 – Verify the Kali IP

On Kali, run:

```bash
ip addr
```

Then inspect the Ethernet interface directly:

```bash
ip addr show eth0
```

Confirm the primary lab address `192.168.175.130`. The secondary lab address `192.168.175.200` may already be configured. The two addresses are local lab source addresses on Kali; neither address establishes a real geographic location.

## Step 2 – Add the Secondary Lab IP if Needed

If `192.168.175.200` is not already shown on `eth0`, add it:

```bash
sudo ip addr add 192.168.175.200/24 dev eth0
```

Verify the interface again:

```bash
ip addr show eth0
```

Expected secondary address:

```text
192.168.175.200/24
```

The address added with `ip addr` is normally a runtime lab configuration and may not persist after a reboot.

## Step 3 – Verify the Victim Is Reachable

From Kali, run:

```bash
ping -c 4 192.168.175.134
```

Use the result only to confirm network reachability to the Ubuntu lab host. Do not infer anything about authentication from ping alone.

## Step 4 – Perform the Normal Trusted Login

Make the normal SSH connection first:

```bash
ssh remoteuser@192.168.175.134
```

This represents the account's normal authentication path and establishes the trusted source baseline of `192.168.175.130`. Exit the SSH session when finished:

```bash
exit
```

## Step 5 – Perform the Controlled Suspicious-Source Login

Bind the outgoing SSH connection to the secondary source address:

```bash
ssh -b 192.168.175.200 remoteuser@192.168.175.134
```

The `-b` option binds the outgoing SSH connection to the specified local source address. Ubuntu should see the connection as coming from `192.168.175.200`. Exit the session when finished:

```bash
exit
```

This is only a controlled lab simulation. It must not be described as an attack against a real system.

## Step 6 – Verify Ubuntu Authentication Logs

On Ubuntu, inspect successful password authentications:

```bash
sudo grep -a "Accepted password" /var/log/auth.log
```

Then search for the affected account:

```bash
sudo grep -a "remoteuser" /var/log/auth.log
```

The relevant fields are:

- **Timestamp:** when the authentication event was recorded.
- **Username:** the account used, such as `remoteuser`.
- **Source IP:** the client address observed by Ubuntu.
- **Authentication result:** for example, `Accepted password`.
- **SSH service:** the daemon that processed the connection, normally `sshd`.

## Step 7 – Confirm the Suspicious Source

Search specifically for successful logins for the account:

```bash
sudo grep -a "Accepted password for remoteuser" /var/log/auth.log
```

The expected suspicious source is:

```text
192.168.175.200
```

Do not add timestamps or results to the report unless they are actually observed in the lab evidence.

## Step 8 – Repeat Only if Needed

Repeat the suspicious-source login on another lab occasion if needed to reproduce the confirmed pattern. Do not invent timestamps.

The confirmed evidence used in this exercise contains two successful logins from `192.168.175.200` on different dates:

```text
2026-09-04 23:48:53 | remoteuser | 192.168.175.200
2026-09-05 20:28:29 | remoteuser | 192.168.175.200
```

These private addresses show a source-baseline deviation in the lab. They do not prove that the source was in another country or geographic region.
