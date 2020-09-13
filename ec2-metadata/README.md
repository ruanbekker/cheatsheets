# EC2 Metadata

## Examples

Get the hostname:

```
$ curl http://instance-data/latest/meta-data/instance-id
i-xxxxxxxxxxx
```

Get the private ipv4 address:

```
$ curl -s http://169.254.169.254/latest/meta-data/local-ipv4
172.31.50.37
```

Get the region:

```
$ curl -s http://instance-data/latest/meta-data/placement/availability-zone | rev | cut -c 2- | rev
eu-west-1
```

Get the EC2 Tag Name Value:

```
TAG_NAME="Name"
INSTANCE_ID="$(curl -s http://instance-data/latest/meta-data/instance-id)"
REGION="$(curl -s http://instance-data/latest/meta-data/placement/availability-zone | rev | cut -c 2- | rev)"
TAG_VALUE="$(aws ec2 describe-tags --filters "Name=resource-id,Values=${INSTANCE_ID}" "Name=key,Values=${TAG_NAME}" --region ${REGION} --output=text | cut -f5)"

$ echo ${TAG_VALUE}
my-instance
```
