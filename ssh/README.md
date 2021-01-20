# SSH Cheatsheet

- [Proxy Jump](#proxy-jump)
- [SSH Tunnel](#ssh-tunnel)

## External Resources:
- https://cheatsheet.dennyzhang.com/cheatsheet-ssh-a4

## Proxy Jump

### Method 1

Using your key for SSH to bastion and using your key to SSH to target host:

```
Host *
    Port 22
    User ubuntu
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 60
    ServerAliveCountMax 30

Host jump-host
    HostName bastion.domain.com
    IdentityFile ~/.ssh/bastion.pem

Host target-a
    HostName target-a.pvt.domain.com
    IdentityFile ~/.ssh/target_a.pem
    ProxyJump jump-host
```

### Method 2

Using your key to SSH to bastion and using the remote key on B to SSH to the target host:

```
Host *
    Port 22
    User ubuntu
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ServerAliveInterval 60
    ServerAliveCountMax 30

Host jump-host
    HostName bastion.domain.com
    IdentityFile ~/.ssh/bastion.pem
    
Host target-b
    HostName target-b.pvt.domain.com
    IdentityFile /home/ubuntu/.ssh/id_rsa
    ProxyCommand ssh -o 'ForwardAgent yes' jump-host 'ssh-add && nc %h %p'
```

### Method 3

One liner:

```
ssh -i ~/.ssh/target.pem -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/id_rsa -q ubuntu@bastion.domain" ubuntu@target.domain
```

## SSH Tunnel

Setup a local tunnel accessible on port 8080 which will traverse via the tunnel to access port 9100 on target-a which is only accessible locally on the remote end.

First to setup our SSH Config (optional):

```
$ cat ~/.ssh/config
Host jump-host
    HostName jump-host.mydomain.com
    Port 22
    User ruan
    IdentityFile ~/.ssh/id_rsa
    
Host target-a
    Hostname 172.31.16.3
    User ec2-user
    IdentityFile ~/.ssh/id_rsa
    ProxyCommand ssh -o 'ForwardAgent yes' jump-host 'ssh-add && nc %h %p'
```

### Method 1

This ssh session will log you into the remote server, so the session will remain active as long as you are logged in:

```
$ ssh -L 8080:localhost:9100 target-a
```

### Method 2

Then we can do the same, but fork the ssh session to the background:

```
$ ssh -fN -L 8080:localhost:9100 target-a
```

To kill the session, you can get the `pid` by running: `ps aux | grep '8080:localhost:9100'`, and then kill the pid with: `kill $pid`

### Method 3

Then we can do the same, but run the ssh session in the forground:

```
$ ssh -fN -L 8080:localhost:9100 -CqN target-a
```

Now when you try to access port 8080 locally, you will see that we can reach port 80 on the remote target:

```
$ nc -vz localhost 8080
Connection to localhost port 8080 [tcp/*] succeeded!
```

### Resources

- [Bastion ProxyJump](https://www.redhat.com/sysadmin/ssh-proxy-bastion-proxyjump)
- [Bastion JumpHost](https://www.techrepublic.com/article/how-to-use-ssh-to-proxy-through-a-linux-jump-host/)
- [Proxy Jump to C using Key B](https://serverfault.com/a/701884)
