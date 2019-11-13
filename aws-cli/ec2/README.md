## EC2 AWS CLI Cheatsheet

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
