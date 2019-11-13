## Elasticache AWS CLI Cheatsheet

List Clusters:

```
$ aws --profile dev elasticache describe-cache-clusters --max-items 5
{
    "CacheClusters": [
        {
            "CacheClusterId": "test-cluster-dev-0001-001", 
            ...
        }
    ]
}
```

Describe Cluster:

```
$ aws --profile eu-dev elasticache describe-cache-clusters --cache-cluster-id "test-cluster-dev-0001-001"
{
    "CacheClusters": [
        {
            "CacheClusterId": "test-cluster-dev-0001-001", 
            ...
        }
    ]
}
```
