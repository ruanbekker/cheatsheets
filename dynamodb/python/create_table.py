import boto3
import time

client = boto3.Session(region_name='eu-west-1').resource('dynamodb', aws_access_key_id='', aws_secret_access_key='', endpoint_url='http://localhost:4567')

response = client.create_table(
    AttributeDefinitions=[{
        'AttributeName': 'event',
        'AttributeType': 'S'
    },
    {
        'AttributeName': 'timestamp',
        'AttributeType': 'S'
    }],
    TableName='gamescores',
    KeySchema=[{
        'AttributeName': 'event',
        'KeyType': 'HASH'
    },
    {
        'AttributeName': 'timestamp',
        'KeyType': 'RANGE'
    }],
    ProvisionedThroughput={
        'ReadCapacityUnits': 1,
        'WriteCapacityUnits': 10
    }
)

time.sleep(2)
print(response)
