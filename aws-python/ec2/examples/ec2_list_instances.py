import boto3

profile_name = ''
region_name = ''

ec2 = boto3.Session(profile_name=profile_name, region_name=region_name).client('ec2')
instances = ec2.instances.filter(
    Filters=[
        {'Name': 'instance-state-name', 'Values': ['running']},
        {'Name': 'tag-key', 'Values': ['my-instance-group-name']}
    ]
)

for instance in instances:
    print(instance.id, instance.instance_type, instance.private_ip_address)
