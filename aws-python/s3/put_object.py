import boto3
s3 = boto3.client('s3')

with open('file.txt', 'r') as file_content:
    s3.put_object(Bucket='my-bucket-name', Key=testfolder/file.txt, Body=file_content.read())
