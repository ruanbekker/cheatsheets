## External Sources:

- [Prometheus Relabeling Tricks](https://medium.com/quiq-blog/prometheus-relabeling-tricks-6ae62c56cbda)

## Example Queries

Combining values from 2 different vectors (Hostname with a Metric):

```
node_memory_Active_bytes * on(instance) group_left(nodename) (node_uname_info)
```
