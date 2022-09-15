# helm cheatsheet

Helm helps you manage Kubernetes applications

## TOC

- [Installing Helm](#installing-helm)
- [Global Flags](#global-flags)
- [Repositories](#repositories)
- [Search](#search)
- [Show](#show)

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

## Global Flags

List of global flags of version `v3.9.3`:

```bash
Global Flags:
      --debug                       enable verbose output
      --kube-apiserver string       the address and the port for the Kubernetes API server
      --kube-as-group stringArray   group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --kube-as-user string         username to impersonate for the operation
      --kube-ca-file string         the certificate authority file for the Kubernetes API server connection
      --kube-context string         name of the kubeconfig context to use
      --kube-token string           bearer token used for authentication
      --kubeconfig string           path to the kubeconfig file
  -n, --namespace string            namespace scope for this request
      --registry-config string      path to the registry config file (default "~/Library/Preferences/helm/registry/config.json")
      --repository-cache string     path to the file containing cached repository indexes (default "~/Library/Caches/helm/repository")
      --repository-config string    path to the file containing repository names and URLs (default "~/Library/Preferences/helm/repositories.yaml")
```

## Repositories

List repositories:

```bash
helm repo list
```

Add a repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

Update repositories:

```bash
helm repo update
```

Remove a repository:

```bash
helm repo remove prometheus-community
```

## Search

Search all release versions of a chart:

```bash
helm search repo prometheus-community/kube-prometheus-stack --versions
```

Search for release versions that starts with a specific number:

```bash
helm search repo prometheus-community/kube-prometheus-stack --versions --version "^31.0"
```

Search for release versions as a minimum and up:

```bash
helm search repo prometheus-community/kube-prometheus-stack --versions --version ">31.0"
```

Search for a repo with regular expressions:

```bash
helm search repo -r "bitnami/(re-).*"
```

## Show

Show the chart's values:

```bash
helm show values prometheus-community/kube-prometheus-stack --version "39.0.0"
```

Dumpe the chart's values to a file:

```bash
helm show values prometheus-community/kube-prometheus-stack --version "39.0.0" > values.yaml
```

## Install

Install a release with a local chart:

```bash
helm install my-hostname . -f values.yaml
```

## Upgrade

Upgrade a release with a local chart and specify a timeout:

```bash
helm upgrade my-hostname . -f values.yaml --timeout 10s
```

## History

View the deployment history:

```bash
helm history chart-name
```

## Rollbacks

Rollback to most recent version:

```bash
helm rollback chart-name
```

Rollback to specific version:

```bash
helm rollback chart-name 2
```

## Chart Museum 

```bash
helm plugin install https://github.com/chartmuseum/helm-push
helm repo add cm --username ${HELM_REPO_USERNAME} --password ${HELM_REPO_PASSWORD} https://chartmuseum.mydomain.com/
helm create mychart
# helm package mychart # or cd mychart; helm package .
# helm dependency build -> if you are in the chart directory with dependency in the Chart.yaml
cd mychart
helm cm-push . -f --username ${HELM_REPO_USERNAME} --password ${HELM_REPO_PASSWORD} https://chartmuseum.mydomain.com/ # chart name will be the directory name
```
