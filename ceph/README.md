# ceph cheatsheet

## View Status:

```
$ ceph -s
  cluster:
    id:     uuid-x-x-x-x
    health: HEALTH_OK

  services:
    mon: 1 daemons, quorum ceph:10.20.30.40:16789
    mgr: 1f2c207d5ec9(active)
    osd: 3 osds: 3 up, 3 in

  data:
    pools:   2 pools, 200 pgs
    objects: 16  objects, 21 MiB
    usage:   3.0 GiB used, 27 GiB / 30 GiB avail
    pgs:     200 active+clean
```

## Pools:

List pools:

```
$ ceph osd lspools
1 default
2 volumes
```

List objects in pool:

```
$ rados -p volumes ls
rbd_header.10516b8b4567
journal_data.2.10516b8b4567.1
journal_data.2.10516b8b4567.2
```

View disk space of a pool:

```
$ rados df -p volumes
POOL_NAME   USED OBJECTS CLONES COPIES MISSING_ON_PRIMARY UNFOUND DEGRADED RD_OPS     RD WR_OPS     WR
volumes   21 MiB      16      0     48                  0       0        0    665 11 MiB    794 16 MiB

total_objects    16
total_used       3.0 GiB
total_avail      27 GiB
total_space      30 GiB
```

## Get PGNum:

```
$ ceph osd pool get volumes pg_num
pg_num: 100
```

## Set Dashboard Username/Password:

```
ceph dashboard set-login-credentials
```

## Ceph Docker Volumes

### Dockerized Ceph:
- https://github.com/flaviostutz/ceph-osd

### Docker Volume Plugin:
- https://github.com/flaviostutz/cepher

## Resources:
- http://docs.ceph.com/docs/mimic/mgr/dashboard/
- https://wiki.nix-pro.com/view/Ceph_FAQ/Tweaks/Howtos