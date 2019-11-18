## EC2 AWS CLI Cheatsheet

### EC2

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
