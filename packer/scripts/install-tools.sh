
#!/bin/bash
set -euxo pipefail

# Actualizar el sistema operativo
sudo dnf update -y

# Instalar Docker y dependencias
sudo dnf install -y docker unzip curl

# Habilitar Docker para futuros arranques
sudo systemctl enable docker

# Descargar AWS CLI v2 oficial
cd /tmp

curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o "awscliv2.zip"

unzip -q awscliv2.zip

# Instalar AWS CLI
sudo ./aws/install --update

# Limpiar archivos temporales
rm -rf /tmp/aws /tmp/awscliv2.zip

# Verificar instalaciones
docker --version
aws --version

# Verificar que Docker quedó habilitado
systemctl is-enabled docker
