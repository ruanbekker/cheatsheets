# helm-2

Legacy Helm v2 Cheatsheet

## List Releases

```bash
helm2 --tiller-namespace kube-system list
```

## History

```bash
helm2 --tiller-namespace kube-system history my-app
```

## Get Values

```bash
helm2 --tiller-namespace kube-system get values my-app --output yaml
```

## Get Manifest

```bash
helm2 --tiller-namespace kube-system get manifest my-app --revision 188
```

## Rollback

```bash
helm2 --tiller-namespace kube-system rollback my-app 5
```

