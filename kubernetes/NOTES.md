# Kubernetes Notes

Table of Contents:
- [Pod Anti-Affinity](#pod-anti-affinity)

## Pod Anti-Affinity

### What is it Pod Anti-Affinity

Pod Anti-Affinity ensures that **certain Pods are NOT scheduled on the same node (or other topology domains)** as other Pods. It is used to **spread Pods** across nodes or availability zones to increase application reliability and fault tolerance.

#### 1. **Hard Anti-Affinity**
   - **Rule**: **Pods must not** run together on the same node (or topology domain).
   - **Key Config**: `requiredDuringSchedulingIgnoredDuringExecution`
   - **Behavior**: If the rule cannot be satisfied (e.g., insufficient nodes), the Pod will not be scheduled.
   - **Use Case**: When strict separation is critical (e.g., avoiding colocating replicas of a critical service).

   ```yaml
   affinity:
     podAntiAffinity:
       requiredDuringSchedulingIgnoredDuringExecution:
         - labelSelector:
             matchLabels:
               app: my-app
           topologyKey: "kubernetes.io/hostname"
   ```

#### 2. **Soft Anti-Affinity**
   - **Rule**: **Prefer Pods not** to run together, but allow it if necessary.
   - **Key Config**: `preferredDuringSchedulingIgnoredDuringExecution`
   - **Behavior**: Kubernetes will try to satisfy the rule, but if no alternative nodes are available, it will schedule Pods on the same node.
   - **Use Case**: When separation is desirable but not strictly required (e.g., to improve redundancy without risking unschedulable Pods).

   ```yaml
   affinity:
     podAntiAffinity:
       preferredDuringSchedulingIgnoredDuringExecution:
         - weight: 100
           podAffinityTerm:
             labelSelector:
               matchLabels:
                 app: my-app
             topologyKey: "kubernetes.io/hostname"
   ```

### **Key Configuration Components**

#### 1. **Label Selector**
   - Specifies which Pods to avoid.
   - Types:
     - `matchLabels`: Matches specific key-value pairs.
     - `matchExpressions`: Supports more complex rules (e.g., `In`, `NotIn`, `Exists`).

   Example:
   ```yaml
   labelSelector:
     matchLabels:
       app: my-app
   ```

   OR

   ```yaml
   labelSelector:
     matchExpressions:
       - key: app
         operator: In
         values:
           - my-app
           - my-secondary-app
   ```

#### 2. **Topology Key**
   - Defines the "domain" for anti-affinity.
   - Common keys:
     - `kubernetes.io/hostname`: Node-level anti-affinity.
     - `topology.kubernetes.io/zone`: Zone-level anti-affinity (e.g., across availability zones).
     - `topology.kubernetes.io/region`: Region-level anti-affinity.

   Example:
   ```yaml
   topologyKey: "kubernetes.io/hostname"
   ```

### **Comparison of Hard and Soft Anti-Affinity**

| **Aspect**                  | **Hard Anti-Affinity**                          | **Soft Anti-Affinity**                          |
|-----------------------------|------------------------------------------------|------------------------------------------------|
| **Key Config**              | `requiredDuringSchedulingIgnoredDuringExecution` | `preferredDuringSchedulingIgnoredDuringExecution` |
| **Behavior**                | Pods **must not** colocate (strict).           | Pods **prefer not** to colocate (flexible).    |
| **Impact on Scheduling**    | Pods remain unscheduled if the rule can't be satisfied. | Pods are scheduled even if the rule can't be satisfied. |
| **Use Case**                | Critical separation (e.g., HA replicas).       | Best-effort separation for improved redundancy.|

### **Use Cases**

1. **Critical Services with Replicas**:
   - Ensure replicas of critical services (e.g., databases) do not run on the same node:
     ```yaml
     affinity:
       podAntiAffinity:
         requiredDuringSchedulingIgnoredDuringExecution:
           - labelSelector:
               matchLabels:
                 app: my-db
             topologyKey: "kubernetes.io/hostname"
     ```

2. **Load Balancer Pods**:
   - Spread load balancer Pods across availability zones for fault tolerance:
     ```yaml
     affinity:
       podAntiAffinity:
         preferredDuringSchedulingIgnoredDuringExecution:
           - weight: 50
             podAffinityTerm:
               labelSelector:
                 matchLabels:
                   app: my-lb
               topologyKey: "topology.kubernetes.io/zone"
     ```

3. **Mix of Critical and Non-Critical Pods**:
   - Use **hard** anti-affinity for critical services and **soft** for non-critical ones.
