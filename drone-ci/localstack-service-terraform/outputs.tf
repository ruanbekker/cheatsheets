output "userid" {
  value = random_string.userid.result
}

output "users_dynamodb_table_arn" {
  value = aws_dynamodb_table.users.arn
}

output "countries_dynamodb_table_arn" {
  value = aws_dynamodb_table.countries.arn
}

output "registrations_kinesis_stream_arn" {
  value = aws_kinesis_stream.registrations.arn
}
