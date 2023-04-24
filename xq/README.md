# xq

## Download

Get xq:

```bash
wget -q -O - "https://github.com/sibprogrammer/xq/releases/download/v1.1.4/xq_1.1.4_linux_amd64.tar.gz" | tar zxv
install -o root -g root -m 0755 xq /usr/local/bin/xq
```

## Usage

Prepare a xml file names `test.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Name>fullnode-backup-2</Name>
  <Contents>
    <Key>archive-v1.tgz</Key>
    <LastModified>2023-04-20T15:13:12.000Z</LastModified>
    <Size>1493252335919</Size>
    <StorageClass>STANDARD</StorageClass>
  </Contents>
  <Contents>
    <Key>archive-v2.tgz</Key>
    <LastModified>2023-04-21T15:10:56.000Z</LastModified>
    <Size>1495321500561</Size>
    <StorageClass>STANDARD</StorageClass>
  </Contents>
</ListBucketResult>
```

To return the key names:

```bash
cat test.xml | xq -x '/ListBucketResult/Contents/Key'
```

Which will return:

```bash
archive-v1.tgz
archive-v2.tgz
```
