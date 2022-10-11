# Kubernetes Cheatsheet - kubectl


- [Components](#components)
- [Kubectl](#kubectl)
  - [Nodes](#nodes)
  - [Pods](#pods)
  - [Deployments](#deployments)
  - [Logs](#logs)
  - [Secrets](#secrets)
  - [Copy](#CP)
- [Troubleshooting](#troubleshooting)
- [Snippets](#snippets)
  - [Pod Snippet](#pods-1)
  - [Deployment Snippet](#deployment)
  - [Secrets Snippet](#secret)
- [Useful Aliases](#useful-aliases)
- [Useful Tools](#useful-tools)
- [Resources](#resources)

## Components

|Name|Description|
|----|-----------|
|kube-apiserver|	validates and configures data for the api objects which include pods, services, replicationcontrollers, and others|
|etcd|	distributed k/v store|
|kube-scheduler|	schedule pods to run on selected nodes|
|kube-controller-manager|	daemon that embeds the core control loops shipped with kubernetes|

Components and Services running on Worker Nodes:

|Name|Description|
|----|-----------|
|kubelet|node-agent that runs on each node|
|kube-proxy	connection| forwarding|
|container runtime|	container runtimes supported by kubernets: (docker, rkt, runc, etc)|

## kubectl 

### Nodes

Show nodes in the cluster:

```
kubectl get nodes
```

Show nodes with extra info:

```
kubectl get nodes -o wide
```

Show nodes in yaml format:

```
kubectl get nodes -o yaml
```

Describe nodes:

```
kubectl describe nodes
```

Describe a specific node:

```
kubectl describe node/node-1
```

Show nodes in yaml format	

```
kubectl get nodes -o yaml
```

Show node labels	

```
kubectl get node --show-labels
```

Show nodes with specific label
	
```
kubectl get node --selector=[label_name]
```

Show value from a key	

```
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="External IP")].address}'
```

Get node resource information	

```
kubectl top node [node_name]
```

### Pods

- The single smallest interactable unit in Kubernetes.
- a Pod can be comprimised of multiple containers that will form a unit deployed on a single node together
- a Pod receives one IP which is shared between containers

Show pods:

```
kubectl get pods
```

Show pods from all namespaces:

```
kubectl get pods --all-namespaces
```

Show pods in yaml format:

```
kubectl get pods --output yaml
```

Show system pods	

```
kubectl get pods --namespace kube-system
```

Show pods in yaml format	

```
kubectl get pods --output yaml
```

Dont truncate output	

```
kubectl get pods -o wide
```

Show pod info	

```
kubectl get pod svclb-traefik --namespace kube-system
```

Show pod info from app selector	

```
kubectl get pods --selector app=svclb-traefik --namespace kube-system
```

To show only the pod name from the previous query:

```
kubectl get pods --selector app=svclb-traefik --namespace kube-system --output name 
# or
kubectl get pods --selector app=svclb-traefik --namespace kube-system -o jsonpath="{.items[0].metadata.name}"
```

Show all pods info from all ns	

```
kubectl describe pods --all-namespaces
```

Show pods with labels	

```
kubectl get pods --show-labels
```

Dump pod info in yaml	

```
kubectl get pod svclb-traefik --namespace kube-system -o yaml --export
```

Export pod info to file	

```
kubectl get pod svclb-traefik --namespace kube-system -o yaml --export > exported.yml
```

Show pods, sort by node	

```
kubectl get pods -o wide --sort-by="{.spec.nodeName}"
```

Show pods, sort by restarts	

```
kubectl get pods --sort-by="{.status.containerStatuses[:1].restartCount}"
```

Show pods on a node	

```
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName="ip-10-10-4-20.eu-west-1.compute.internal"
```

Show pods from a deployment	

```
kubectl get pods --output wide --selector app.kubernetes.io/name=my-app
```

Run a pod without a deployment (Restart policy with Never wont create a deployment)

```
kubectl run pod1 --image=alpine --restart=Never -- ping localhost
```

Run a pod without a deployment (Using generator flag)

```
kubectl run pod2 --generator=run-pod/v1 --image=alpine -- ping localhost
```

Run a debug pod:

```
kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh
```

### Deployments

List deployments	

```
kubectl get deployment
```

List deployments from all namespaces	

```
kubectl get deployments --all-namespaces
```

Show deployment info 

```
kubectl get deployment/myapp -o yaml
```

Run a Nginx Deployment with 2 Replicas	

```
kubectl run nginx01 --image=nginx --replicas=2 --port=80
```

### Logs

Tail logs from a pod:

```
kubectl logs -f drone-agent-557ddc7bb4-crjns
```

Tail logs from a container (when two or more containers runs in a pod):

```
kubectl logs -f drone-agent-557ddc7bb4-crjns -c docker-in-docker
```

Show pods and dont truncate the output:

```
kubectl get pods -o wide
```

Show pods with their labels:

```
kubectl get pods --show-labels
```

Show pods from a specific deployment:

```
kubectl get pods --output wide --selector app.kubernetes.io/name=my-test-app
```

Show pods on specific node:

```
kubectl get pods -o wide --field-selector spec.nodeName="ip-10-0-1-20.eu-west-1.compute.internal"
```

Show pods, sort output by node:

```
kubectl get pods -o wide --sort-by="{.spec.nodeName}"
```

Show pods, sort output by restarts:

```
kubectl get pods --sort-by="{.status.containerStatuses[:1].restartCount}"
```

### Events

View kube-system events:

```bash
kubectl get events -n kube-system
```

View kube-system events, sorted by date:

```bash
kubectl get events -n kube-system --sort-by='.metadata.creationTimestamp'
```

### Secrets

Create two files with the username and password:

```bash
echo -n 'admin' > ./username.txt
echo -n '1f2d1e2e67df' > ./password.txt
```

Create the secret:

```bash
kubectl create secret generic db-user-pass --from-file=admin-user=./username.txt --from-file=password=./password.txt
# or from literals
kubectl create secret generic db-user-pass --from-literal=admin-user=admin --from-literal=password='1f2d1e2e67df'
```

To view secrets:

```bash
kubectl get secrets
```

To view a specific secret:

```bash
kubectl get secret/db-user-pass -o yaml
```

To view them in json format:

```bash
kubectl get secret/db-user-pass -o jsonpath='{.data}'
```

As secrets are encoded with base64, we can decode and copy the value of our secret into our clipboard:

```bash
kubectl get secret/db-user-pass --template='{{index .data "admin-user"}}' | base64 --decode | pbcopy
```

## CP

Copy a remote file from a container in a pod to local filesystem:

```bash
kubectl cp monitoring/prometheus-operator-grafana-x-x:/tmp/dump/grafana-backup.tar.gz ~/backups/grafana-backup.tar.gz -c grafana
```

## Generate Manifests

Deployments:

```bash
kubectl create deployment nginx --namespace default --replicas 2 --image registry.gitlab.com/ruanbekker/containers:nginx --port 80 --dry-run=client -o yaml > deployment.yaml
```

Services:

```bash
kubectl expose deployment nginx --port 80 --target-port 80 --dry-run=client -o yaml > service.yaml
```

## Troubleshooting

Let's look at a pod:

```
$ kubectl get pods -o wide
pistack-blog-7cddc5b979-grbv4              0/1     ContainerCreating   0          4m47s   <none>        rpi-03   <none>           <none>
```

We can see it's been in a `ContainerCreating` state for some time, we can have a look at the logs:

```
$ kubectl logs -f pod/pistack-blog-7cddc5b979-grbv4
Error from server (BadRequest): container "ghost" in pod "pistack-blog-7cddc5b979-grbv4" is waiting to start: ContainerCreating
```

Let's describe the pod to see whats currently happening:

```
$ kubectl describe pod/pistack-blog-7cddc5b979-grbv4
Name:         pistack-blog-7cddc5b979-grbv4
Namespace:    default
...
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  8m21s  default-scheduler  Successfully assigned default/pistack-blog-7cddc5b979-grbv4 to rpi-03
  Normal  Pulling    8m20s  kubelet            Pulling image "alexellis2/ghost-on-docker:armv6"
```

We can see that the it's currently pulling the image from the registry, let's try again after a minute or so:

```
$ kubectl describe pod/pistack-blog-7cddc5b979-grbv4
Name:         pistack-blog-7cddc5b979-grbv4
Namespace:    default
...
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  8m21s  default-scheduler  Successfully assigned default/pistack-blog-7cddc5b979-grbv4 to rpi-03
  Normal  Pulling    8m20s  kubelet            Pulling image "alexellis2/ghost-on-docker:armv6"
  Normal  Pulled     10s    kubelet            Successfully pulled image "alexellis2/ghost-on-docker:armv6"
  Normal  Created    6s     kubelet            Created container ghost
  Normal  Started    4s     kubelet            Started container ghost
```

We can also look at our nodes utilization, should we thought it was resource related:

```
$ kubectl top nodes
NAME     CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
rpi-01   163m         4%     303Mi           32%
rpi-02   229m         5%     318Mi           34%
rpi-03   276m         6%     330Mi           35%
rpi-05   1107m        27%    2222Mi          57%
rpi-06   298m         7%     467Mi           12%
rpi-07   238m         5%     416Mi           10%
```

## Snippets

### Pods

Example pod snippet:

```yaml
# https://kubernetes.io/docs/concepts/workloads/pods/
apiVersion: v1
kind: Pod
metadata:
  name: "myapp"
  namespace: default
  labels:
    app: "myapp"
spec:
  containers:
  - name: myapp
    image: "debian-slim:latest"
    resources:
      limits:
        cpu: 200m
        memory: 500Mi
      requests:
        cpu: 100m
        memory: 200Mi
    env:
    - name: DB_HOST
      valueFrom:
        configMapKeyRef:
          name: myapp
          key: DB_HOST
    ports:
    - containerPort: 80
      name:  http
    volumeMounts:
    - name: localtime
      mountPath: /etc/localtime
  volumes:
    - name: localtime
      hostPath:
        path: /usr/share/zoneinfo/Asia/Tehran
  restartPolicy: Always
```

### Deployment

Example deployment snippet:

```yaml
# https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
apiVersion: apps/v1
kind: Deployment
metadata:
  name:  myjob
  namespace: default
  labels:
    app: myjob
spec:
  selector:
    matchLabels:
      app: myjob
  replicas: 1
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: myjob
    spec:
      # initContainers:
        # Init containers are exactly like regular containers, except:
          # - Init containers always run to completion.
          # - Each init container must complete successfully before the next one starts.
      containers:
      - name:  myjob
        image:  myjob:latest
        imagePullPolicy: IfNotPresent
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits:
            cpu: 100m
            memory: 100Mi
        livenessProbe:
          tcpSocket:
            port: 80
          initialDelaySeconds: 5
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 3
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /_status/healthz
            port: 80
          initialDelaySeconds: 5
          timeoutSeconds: 2
          successThreshold: 1
          failureThreshold: 3
          periodSeconds: 10
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: myjob
              key: DB_HOST
        ports:
        - containerPort:  80
          name:  myjob
        volumeMounts:
        - name: localtime
          mountPath: /etc/localtime
      volumes:
        - name: localtime
          hostPath:
            path: /usr/share/zoneinfo/Asia/Tehran
      restartPolicy: Always
```

### Secret

Example secret snippet:

```yaml
# https://kubernetes.io/docs/concepts/configuration/secret/
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
  namespace: default
type: Opaque
data:
  password: cGFzc3dvcmQ=
  # echo -n 'password' | base64
```

## Useful Aliases

```
alias k=kubectl
alias ktx=kubectx
alias kns=kubens
```

## Useful Tools

- [kubectx](https://github.com/ahmetb/kubectx) : lets you switch between contexts (clusters) on kubectl faster.
- [kubens](https://github.com/ahmetb/kubectx) : lets you switch between Kubernetes namespaces (and configure them for kubectl) easily.
- [stern](https://github.com/wercker/stern) : lets you to tail multiple pods on Kubernetes and multiple containers within the pod.

## Resources:

Kubectl Output Formatting:
- https://gist.github.com/so0k/42313dbb3b547a0f51a547bb968696ba

Kubernetes Cheatsheet:
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/

CI/CD with Kubernets:
- https://platform9.com/blog/kubernetes-for-ci-cd-at-scale/
- https://www.weave.works/technologies/cicd-tools/
