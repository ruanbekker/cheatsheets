# symlinks

## Example

Scenario:

- We have a NFS mounted at `/mnt`
- We want to persist `/data/shares/teams` to `/mnt/teams`
- The directory at the local fs `teams` should not exist
- The directory at the nfs fs `/mnt/teams` should exist

The commands:

```bash
mkdir /mnt/teams
mv /data/shares/teams /data/shares/bak-teams
sudo ln -s /mnt/teams /data/shares/teams
mv /data/shares/bak-teams/* /data/shares/teams/
```
