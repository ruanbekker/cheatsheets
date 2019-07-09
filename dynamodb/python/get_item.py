import boto3

client = boto3.Session(region_name='eu-west-1').client('dynamodb', aws_access_key_id='', aws_secret_access_key='', endpoint_url='http://localhost:4567')

response = client.get_item(
    Key={
        'event': {'S': 'gaming_nationals_zaf'},
        'timestamp': {'S': '2019-02-08T14:53'}
    },
    TableName='gamescores'
)

print(response)
