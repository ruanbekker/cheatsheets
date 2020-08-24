# Samba

## External Resources

- https://confluence.jaytaala.com/display/TKB/Create+samba+share+writeable+by+all%2C+group%2C+or+only+a+user

## Setup Shares

Create user:

```
useradd --system me
chown -R me /disk/share
```

Create a Group:

```
sudo groupadd mygroup
```

Add user to the group:

```
sudo useradd me -G mygroup
```

Set permissions to the directory:

```
chgrp -R mygroup /disk/share
chmod g+s /disk/share
```

Allow all users to read and write to your share:

```
[share]
  path = /disk/share
  writeable = yes
  browseable = yes
  public = yes
  create mask = 0644
  directory mask = 0755
  force user = me
```

Allow all linux users which is part of a group to read and write to your share:

```
[share]
  path = /disk/share
  valid users = @mygroup
  writeable = yes
  browseable = yes
  create mask = 0644
  directory mask = 0755
  force user = me
```

Only allowing one user to access our share, we need to assign a samba password:

```
sudo smbpasswd -a me
```

Then we can specify our config that only our `me` user can access our share with read/write permissions:

```
[share]
  path = /disk/share
  valid users = me
  writeable = yes
  browseable = yes
  create mask = 0644
  directory mask = 0755
  force user = me
```

## Other examples

```
# read to some, write to some
[share]
  comment = Ubuntu Share
  path = /your/samba/share
  browsable = yes
  guest ok = yes
  read only = no
  read list = guest nobody
  write list = user1 user2 user3
  create mask = 0755

# read to all, write to some
[share]
  comment = Ubuntu Share
  path = /your/samba/share
  browsable = yes
  guest ok = yes
  read only = yes
  write list = user1 user2 user3
  create mask = 0755
```
