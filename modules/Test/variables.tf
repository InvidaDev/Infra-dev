variable "vpc_cidr" {
  type        = string
  default     = "172.31.0.0/16"
  description = "Set cidr Block for VPC"
}

variable "ami" {
  type        = string
  description = "Set the AMI"
}

variable "instance_type" {
  type        = string
  default = "t3.medium"
  description = "Set the instance type"
}

# variable "subnet_id" {
#   type = string
# }

variable "webservername" {
  type        = string
  description = "Set the name of the webserver"
}

variable "password" {
  type    = string
  default = "oAa73.5TEf4&=YxQ;4.Q=sUfgl!cy2xx"
}

variable "ami_name" {
  type        = string
  default = "Invida Instance Template v0.71-2022(WinRM)"
  description = "Set the AMI"
}

variable "override_ami" {
  default = ""
}

variable "Environment" {
  type        = string
  default     = "demo"
  description = "Set the Environment"
}

variable "vpc_id" {
  type = string
  default = "main-prod-vpc"
}

variable "backup" {
  type        = string
  description = "Set the Environment"
}

variable "Patchgroup" {
  type        = string
  description = "Set the Environment"
}

variable "key" {
  type = string
}
