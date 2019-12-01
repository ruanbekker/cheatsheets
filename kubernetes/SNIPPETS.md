Mounting a Docker Socket:

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
