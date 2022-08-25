# helm cheatsheet

Helm helps you manage Kubernetes applications

## Installing Helm

- [Docs](https://helm.sh/docs/intro/install/)

From a script:

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

On Mac:

```bash
brew install helm
```

Manually from their [releases](https://github.com/helm/helm/releases):

```
wget https://get.helm.sh/helm-v3.9.4-darwin-amd64.tar.gz
tar helm-v3.9.4-darwin-amd64.tar.gz
mv darwin-amd64/helm /usr/local/bin
```
