resource "random_string" "userid" {
  length = 16
  special = false
  upper = false
}

resource "aws_dynamodb_table" "users" {
  name           = "users"
  read_capacity  = "2"
  write_capacity = "1"
  hash_key       = "userid"

  attribute {
    name = "userid"
    type = "S"
  }
}

resource "aws_dynamodb_table" "countries" {
  name           = "countries"
  read_capacity  = "1"
  write_capacity = "1"
  hash_key       = "country"

  attribute {
    name = "country"
    type = "S"
  }
}

resource "aws_kinesis_stream" "registrations" {
  name = "registration-stream"
  shard_count = 1
  retention_period = 30

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}
