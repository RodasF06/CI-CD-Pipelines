output "public_ip" {
  value = aws_instance.web_app.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}