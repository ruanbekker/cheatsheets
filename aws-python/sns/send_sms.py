import boto3

SMS_NUMBER='+27000000000'

sns = boto3.Session(profile_name='prod', region_name='eu-west-1').client('sns')

response = sns.publish(
    PhoneNumber=SMS_NUMBER, 
    Message='testing', 
    MessageAttributes={
        'AWS.SNS.SMS.SenderID': {
            'DataType': 'String',
            'StringValue': '123'
        },
        'AWS.SNS.SMS.SMSType': {
            'DataType': 'String',
            'StringValue': 'Transactional'
        }
    }
)
