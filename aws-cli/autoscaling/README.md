# AWS CLI Autoscaling Cheatsheet

Userdata:

```
$ cat userdata.txt
#!/bin/bash
CLUSTER_NAME="aws-qa-ecs"
ENVIRONMENT_NAME="qa"
MY_HOSTNAME="$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)"
INSTANCE_ID="$(curl -s http://instance-data/latest/meta-data/instance-id)"
INSTANCE_LIFECYCLE="$(curl -s http://169.254.169.254/latest/meta-data/instance-life-cycle)"
REGION="$(curl -s http://instance-data/latest/meta-data/placement/availability-zone | rev | cut -c 2- | rev)"

echo "ECS_CLUSTER=${CLUSTER_NAME}" >> /etc/ecs/ecs.config
echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"awslogs\"]" >> /etc/ecs/ecs.config
echo "ECS_INSTANCE_ATTRIBUTES={\"environment\":\"${ENVIRONMENT_NAME}\"}" >> /etc/ecs/ecs.config
```

I am multiplying the current spot price with 2 to set my maximum bid price, so alter according to your needs:

```
#!/usr/bin/env bash

launch_config_name="ecs-dev-cap-spot-lc.v1"
instance_type="t2.medium"
ssh_key_name="infra"
userdata="userdata.txt"
security_group="sg-00000000000000000"
instance_profile="ecs-instance-role"

ecs_ami_id="$(aws --profile dev ssm get-parameter --name '/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id' | jq -r '.Parameter.Value')"
spot_price=$(aws --profile dev ec2 describe-spot-price-history --instance-types ${instance_type} --product-descriptions "Linux/UNIX" --max-items 1 | jq -r '.SpotPriceHistory[].SpotPrice')

get_bid_price(){
    spot_price=$(aws --profile dev ec2 describe-spot-price-history --instance-types ${instance_type} --product-descriptions "Linux/UNIX" --max-items 1 | jq -r '.SpotPriceHistory[].SpotPrice')
    echo ${spot_price} 2 | awk '{printf "%4.3f\n",$1*$2}'
}

aws --profile dev autoscaling create-launch-configuration \
  --launch-configuration-name ${launch_config_name} \
  --image-id ${ecs_ami_id} \
  --instance-type ${instance_type} \
  --key-name ${ssh_key_name} \
  --user-data file://${userdata} \
  --security-groups ${security_group} \
  --instance-monitoring Enabled=true \
  --iam-instance-profile ${instance_profile} \
  --spot-price "$(get_bid_price)"
```

Create the Auto Scaling Group:

```
asg_name="ecs-dev-cap-spot"
subnets="subnet-00000000000000000,subnet-11111111111111111,subnet-22222222222222222"

aws --profile dev autoscaling create-auto-scaling-group \
  --auto-scaling-group-name ${asg_name} \
  --launch-configuration-name ${launch_config_name} \
  --min-size 0 \
  --max-size 3 \
  --vpc-zone-identifier "${subnets}"
```


