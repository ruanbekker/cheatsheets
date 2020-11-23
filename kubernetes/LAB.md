# Kubernetes Lab

## Create a Cluster

Create a cluster with k3s:

```
$ curl https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s -
```

View the nodes:

```
$ kubectl get nodes --output wide
NAME      STATUS   ROLES    AGE     VERSION        INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
primary   Ready    master   4m43s   v1.19.3+k3s3   192.168.64.10   <none>        Ubuntu 20.04.1 LTS   5.4.0-54-generic   containerd://1.4.1-k3s1
```

## Create a Basic Deployment

Run a basic deployment for a web service that returns the hostname:

```
$ kubectl create deployment hostname --image ruanbekker/hostname
deployment.apps/hostname created
```

View the deployment status:

```
$ kubectl get deployment/hostname --output wide
NAME       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                SELECTOR
hostname   1/1     1            1           71s   hostname     ruanbekker/hostname   app=hostname
```

View the pods using the `app=hostname` selector:

```
$ kubectl get pods --selector app=hostname --output wide
NAME                        READY   STATUS    RESTARTS   AGE    IP          NODE      NOMINATED NODE   READINESS GATES
hostname-6cc46b9766-bvrcs   1/1     Running   0          101s   10.42.0.8   primary   <none>           <none>
```

Create a service and expose port 80 to the container:

```
$ kubectl expose deployment/hostname --type NodePort --port 8000
service/hostname exposed
```

View the service details:

```
$ kubectl get service/hostname --output wide
NAME       TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE   SELECTOR
hostname   NodePort   10.43.155.228   <none>        8000:30033/TCP   8s    app=hostname
```

From outside your cluster, view the application:

```
$ curl http://192.168.64.10:30033
Hostname: hostname-6cc46b9766-bvrcs
```
