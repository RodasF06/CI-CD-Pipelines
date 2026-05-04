variable "region" {
  description = "Region en donde se realizara el despliegue"
  default = "us-east-1"
  type = string
}

variable "cidr_block" {
  description = "Cidr para la vpc"
  default = "10.0.0.0/16"
  type = string
}

variable "public_cidr_block" {
  description = "Cidr para la subnet publica"
  default = "10.0.1.0/24"
  type = string
}