# Parámetro configuración no sensible.
resource "aws_ssm_parameter" "app_env" {
  name        = "/cicd-project/dev/APP_ENV"
  description = "Entorno de ejecución de la aplicación"
  type        = "String"
  value       = "production-low-cost"

  tags = {
    Environment = "Dev"
    Project     = "CI-CD-Pipeline"
  }
}
