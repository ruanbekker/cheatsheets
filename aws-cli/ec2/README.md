## EC2 AWS CLI Cheatsheet

### EC2

#### Run Instances

Create the EBS Mapping:

```
[
    {
        "DeviceName": "/dev/sda1",
        "Ebs": {
            "DeleteOnTermination": true,
            "VolumeSize": 50,
            "VolumeType": "standard"
        }
    }
]
```

Get the latest AMI (ecs optimized in this case):

```
AWS_AMI_ID="$(aws --profile prod ssm get-parameter --name '/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id' | jq -r '.Parameter.Value')"
```

Create a EC2 instance:

```
aws --profile default ec2 run-instances --image-id ${AWS_AMI_ID} --count 1 \
     --instance-type t2.micro --key-name mykey \
     --subnet-id subnet-123456789 --security-group-ids ${AWS_SG_ID} \
     --block-device-mappings file://ebs_mapping.json \
     --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyEC2}]' 'ResourceType=volume,Tags=[{Key=Name,Value=MyEC2}]' \
     --iam-instance-profile '{"Name":"my-instance-role"}' \
     --user-data file://userdata.txt
```

#### Query

Show InstanceId, State, PrivateDnsName of a given PrivateDnsName:

```
$ aws --profile dev ec2 describe-instances --query 'Reservations[*].Instances[?PrivateDnsName==`ip-192-168-42-186.eu-west-1.compute.internal`].[InstanceId,PrivateDnsName,State.Name][][]'
[
    "i-0d016de17a46d5178",
    "ip-192-168-42-186.eu-west-1.compute.internal",
    "running"
]
```

### Security Groups

Describe Security Group:

```
$ aws --profile dev ec2 describe-security-groups --group-ids "sg-00000000000000000"
{
    "SecurityGroups": [
        {
            "IpPermissionsEgress": [],
            "Description": "",
             "Tags": [],
             "IpPermissions": [],
             "GroupName": "",
             "VpcId": "",
             "OwnerId": "",
             "GroupId": ""
        }
    ]
}
```

View Ingress Rules:

```
$ aws --profile dev ec2 describe-security-groups --group-ids "sg-00000000000000000" | jq -r .SecurityGroups[].IpPermissions
[
  {
    "PrefixListIds": [],
    "FromPort": 22,
    "IpRanges": [
      {
        "CidrIp": "10.1.10.0/24"
      }
    ],
    "ToPort": 22,
    "IpProtocol": "tcp",
    "UserIdGroupPairs": [],
    "Ipv6Ranges": []
  }
]
```

Allow Ingress Rule:

```
$ aws --profile dev ec2 authorize-security-group-ingress --group-id sg-00000000000000000 --protocol tcp --port 3306 --cidr 10.1.10.0/16
```

### Subnets

List the subnets containing "private" in tags:

```
$ aws --profile prod ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxxxxx" | jq -r '.Subnets[] | select(.Tags[].Value | contains("private"))'
{
  "AvailabilityZone": "eu-west-1c",
  "AvailabilityZoneId": "euw1-az3",
  "AvailableIpAddressCount": 4089,
  "CidrBlock": "172.31.80.0/20",
  "DefaultForAz": false,
  "MapPublicIpOnLaunch": false,
  "State": "available",
  "SubnetId": "subnet-xxxxxxxx",
  "VpcId": "vpc-xxxxxxx",
  "OwnerId": "xxxxxxxxxxx",
  "AssignIpv6AddressOnCreation": false,
  "Ipv6CidrBlockAssociationSet": [],
  "Tags": [
    {
      "Key": "Name",
      "Value": "prod-private-subnet-1c"
    }
  ],
  "SubnetArn": "arn:aws:ec2:eu-west-1:xxxxxxxxx:subnet/subnet-xxxxxxxx"
}
{
...
```

Get only the subnetids:

```
$ aws --profile prod ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxxxxxxx" | jq -r '.Subnets[] | select(.Tags[].Value | contains("private")) .SubnetId'
subnet-xxxxxx
subnet-xxxxxx
subnet-xxxxxx
```
