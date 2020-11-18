# Sudo Cheatsheet

## Usage

User to sudo without a password:

```
$ echo "${USER} ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/no-sudo-password-for-${USER}
```
