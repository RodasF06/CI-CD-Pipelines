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

# Parámetro cifrado para credenciales o secretos de API o DB.
resource "aws_ssm_parameter" "app_secret_key" {
  name        = "/cicd-project/dev/APP_SECRET_KEY"
  description = "Clave secreta de la aplicación consumida por el contenedor"
  type        = "SecureString"
  value       = "CAMBIAR_EN_CONSOLA_O_VARIABLE" # Placeholder

  lifecycle {
    ignore_changes = [value]
  }

  tags = {
    Environment = "Dev"
    Project     = "CI-CD-Pipeline"
  }
}