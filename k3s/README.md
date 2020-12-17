# k3s

Install a Cluster:

```
curl https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 0644 --tls-san foo.bar" sh -s -
```
