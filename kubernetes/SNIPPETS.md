## Pod Anti-Affinity

Ensures pods dont run on the same node.

```
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - bitcoin
        topologyKey: "kubernetes.io/hostname"
```

```
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchLabels:
            app: bitcoind
        topologyKey: "kubernetes.io/hostname"

```

Soft Anti-Affinity

```
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app: bitcoind
          topologyKey: "kubernetes.io/hostname"

```

## Mounting a Docker Socket:

```
      - image: docker:stable-dind
        name: docker-in-docker
        volumeMounts:
          - name: dockersock
            mountPath: "/var/run"
            #mountPath: "/var/run/docker.sock"
        securityContext:
          privileged: true
          allowPrivilegeEscalation: true
      volumes:
      - name: dockersock
        hostPath:
          path: /var/run/docker.sock
          #type: File
```
