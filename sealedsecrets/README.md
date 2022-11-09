# sealed secrets

[Bitnami Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) is a Kubernetes controller and tool for one-way encrypted Secrets.

## Pre-Requisites

You will need [kubectl]() and [kubeseal](https://github.com/bitnami-labs/sealed-secrets/releases)

## Installing Kubeseal

Get the latest version from their [releases](https://github.com/bitnami-labs/sealed-secrets/releases) then for linux:

```bash
curl -sSL  https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.1/kubeseal-0.19.1-linux-amd64.tar.gz | tar -xz
sudo install -o root -g root -m 0755 kubeseal /usr/local/bin/kubeseal
```

## Create a Sealed Secret

### From stdin

Create a kubernetes secret:

```bash
echo -n pass123 | kubectl create secret generic app-secret --dry-run=client --from-file=foo=/dev/stdin -o yaml > app-secret.yaml
```

Encrypt the secret:

```bash
kubeseal --controller-name=sealed-secrets --controller-namespace=kube-system --format yaml < app-secret.yaml > app-sealedsecret.yaml
```

Create the sealed secret:

```bash
kubectl create -f app-sealedsecret.yaml
```

## Master Key

To backup the master key:

```bash
kubectl get secret -n kube-system -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml > sealedsecret-master.key
```

To restore the master key:

```bash
kubectl apply -f sealedsecret-master.key
kubectl delete pod -n kube-system -l name=sealed-secrets-controller
```
