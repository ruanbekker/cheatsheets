#!/usr/bin/env python3

import boto3
import time 

aws_profile = 'default'
aws_region = 'eu-west-1'
retention_in_days_number = 5

cwlogs = boto3.Session(profile_name=aws_profile, region_name=aws_region).client('logs')

def list_log_groups(limit_number):
    response = cwlogs.describe_log_groups(limit=limit_number)
    return response['logGroups']

def update_retention(log_group_name, retention_in_days):
    response = cwlogs.put_retention_policy(
        logGroupName=log_group_name, 
        retentionInDays=retention_in_days
    )
    return response

paginator = cwlogs.get_paginator('describe_log_groups')

updated_log_groups = 0

for response in paginator.paginate():
    for log_group in response['logGroups']:
        if 'retentionInDays' not in log_group.keys():
            print("X {loggroup} has no retention policy set, and setting to 5 days".format(loggroup=log_group['logGroupName']))
            update_response = update_retention(log_group['logGroupName'], retention_in_days_number)
            print("RequestID: {rid}, StatusCode: {sc}".format(rid=update_response['ResponseMetadata']['RequestId'], sc=update_response['ResponseMetadata']['HTTPStatusCode']))
            updated_log_groups += 1
            time.sleep(1)
    
print("Updated {count} log groups to the retention on {num} days".format(count=updated_log_groups, num=retention_in_days_number))
            
