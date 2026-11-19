resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ec2/cicd-project-app"
  retention_in_days = 7

  tags = {
    Environment = "Dev"
    Project     = "CI-CD-Pipeline"
  }
}