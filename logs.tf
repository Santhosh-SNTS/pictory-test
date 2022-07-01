# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "pictory_log_group" {
  name              = "/ecs/pictory-app"
  retention_in_days = 30

  tags = {
    Name = "pictory-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "pictory_log_stream" {
  name           = "pictory-log-stream"
  log_group_name = aws_cloudwatch_log_group.pictory_log_group.name
}

