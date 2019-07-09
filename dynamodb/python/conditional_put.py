import boto3
from botocore import exceptions
import time

client = boto3.Session(region_name='eu-west-1').client('dynamodb', aws_access_key_id='', aws_secret_access_key='', endpoint_url='http://localhost:4567')

try:
    response = client.put_item(
        TableName='gamescores',
        Item={
            'event': {'S': 'gaming_nationals_zaf'},
            'timestamp': {'S': '2019-02-08T14:53'},
            'score': {'N': '11885'},
            'name': {'S': 'will'},
            'gamerid': {'S': 'wilson9335'},
            'game': {'S': 'counter strike'},
            'age': {'N': '27'},
            'rank': {'S': 'professional'},
            'location': {'S': 'sweden'}
        },
        ConditionExpression='attribute_not_exists(gamerid)'
    )
    print(response)

except exceptions.ClientError as e:
    if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
        print('ConditionalCheckFailedException')
