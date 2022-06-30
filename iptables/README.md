# iptables cheatsheet

A couple of iptables examples

## Prerouting

client -> host (10.20.1.1:2098) -> forward connection to a destination ip and port -> (10.22.23.4:22) 

```
# create and insert at the top of the chain
iptables -t nat -I PREROUTING -p tcp --dport 2098 -j DNAT --to-destination 10.22.23.4:22

# create and append 
iptables -t nat -I PREROUTING -p tcp --dport 2098 -j DNAT --to-destination 10.22.23.4:22

# deletes rule
iptables -t nat -D PREROUTING -p tcp --dport 2098 -j DNAT --to-destination 10.22.23.4:22
```

Resources:
- [difference-beetween-dnat-and-redirect-in-iptables](https://serverfault.com/questions/179200/difference-beetween-dnat-and-redirect-in-iptables)
