
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "amazon_linux" {
  region        = "us-east-1"
  instance_type = "t2.micro"

  ami_name        = "cicd-project-golden-ami"
  ami_description = "Golden AMI con Docker y AWS CLI para CI/CD"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    owners      = ["137112412989"]
    most_recent = true
  }

  ssh_username = "ec2-user"

  tags = {
    Name        = "cicd-project-golden-ami"
    Project     = "CI-CD-Pipeline"
    Environment = "Dev"
    ManagedBy   = "Packer"
  }

  snapshot_tags = {
    Project   = "CI-CD-Pipeline"
    ManagedBy = "Packer"
  }
}

build {
  name = "cicd-golden-ami"

  sources = [
    "source.amazon-ebs.amazon_linux"
  ]

  provisioner "shell" {
    script = "packer/scripts/install-tools.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo dnf clean all",
      "sudo rm -rf /var/cache/dnf",
      "sudo cloud-init clean --logs"
    ]
  }

  post-processor "manifest" {
    output     = "packer-manifest.json"
    strip_path = true
  }
}
