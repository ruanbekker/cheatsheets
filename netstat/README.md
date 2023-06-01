# netstat cheatsheet

## Listening Ports

Command:

```bash
netstat -tulpn
```

<details>
  <summary>Response:</summary>
  
```bash
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      420/sshd
tcp6       0      0 :::9100                 :::*                    LISTEN      402/node_exporter
tcp6       0      0 :::35955                :::*                    LISTEN      405/promtail
tcp6       0      0 :::22                   :::*                    LISTEN      420/sshd
tcp6       0      0 :::9080                 :::*                    LISTEN      405/promtail
udp        0      0 0.0.0.0:36345           0.0.0.0:*                           279/avahi-daemon: r
udp        0      0 0.0.0.0:68              0.0.0.0:*                           401/dhcpcd
udp        0      0 0.0.0.0:5353            0.0.0.0:*                           279/avahi-daemon: r
udp6       0      0 :::59354                :::*                                279/avahi-daemon: r
udp6       0      0 :::5353                 :::*                                279/avahi-daemon: r
```
  
</details>

