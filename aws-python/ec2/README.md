## List Instances

Get instance details from a filter, [examples/ec2_list_instances.py](examples/ec2_list_instances.py)

```
>>> import boto3
>>> ec2 = boto3.Session(profile_name='prod', region_name='eu-west-1').client('ec2')
>>> instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['running']},{'Name': 'tag:Name', 'Values': ['my-instance-group-name']}])
>>> for instance in instances:
...     print(instance.id, instance.instance_type, instance.private_ip_address)
...
('i-00bceb55c1cec0c00', 'c5.large', '172.30.34.253')
('i-007f2ef27779f3f00', 'c5.large', '172.30.34.245')
('i-00228d357d1ddd200', 'c5.large', '172.30.36.188')
('i-00a0087392f7ebe00', 'c5.large', '172.30.37.192')
('i-008895f213ae84000', 'c5.large', '172.30.38.170')
```
