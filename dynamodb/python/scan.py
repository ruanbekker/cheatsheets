import boto3

client = boto3.Session(region_name='eu-west-1').client('dynamodb', aws_access_key_id='', aws_secret_access_key='', endpoint_url='http://localhost:4567')

response = client.scan(TableName='gamescores')

print(response)
