output "private_ip" {
  value       = aws_instance.web_app.private_ip
  description = "IP privada de la instancia dentro de la subred aislada"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}