# stern

[Stern](https://github.com/stern/stern) is a utility that allows you to specify both pod and container id as regular expressions. 

## Installation

Installation with Mac:

```bash
brew install stern
```

## Examples

Tail pod logs starting with `my-pods-` in the `default` namespace:

```bash
stern -n default my-pods
```

Tail the same, but only for the `web` container:

```bash
stern -n default my-pods --container web
```

Do the same but only from 1 minute ago:

```bash
stern -n default my-pods --container web --since 1m
```

## Documentation

- [github.com/stern/stern](https://github.com/stern/stern)
- [kubernetes.io/blog/2016/10/tail-kubernetes-with-stern/](https://kubernetes.io/blog/2016/10/tail-kubernetes-with-stern/)
