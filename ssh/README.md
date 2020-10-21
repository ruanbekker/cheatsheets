## SSH Cheatsheet

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

### Resources

- [Bastion ProxyJump](https://www.redhat.com/sysadmin/ssh-proxy-bastion-proxyjump)
- [Bastion JumpHost](https://www.techrepublic.com/article/how-to-use-ssh-to-proxy-through-a-linux-jump-host/)
- [Proxy Jump to C using Key B](https://serverfault.com/a/701884)
