variable "ami" {
  type        = string
  description = "Set the AMI"
}

variable "instance_type" {
  type        = string
  default = "t3.medium"
  description = "Set the instance type"
}

variable "subnet" {
  type = string
}

variable "webservername" {
  type        = string
  description = "Set the name of the webserver"
}
variable "Environment" {
  type        = string
  description = "Set the Environment"
}

variable "vpc_id" {
  type = string
}

variable "backup" {
  type        = string
  description = "Set the Backup Schedule"
}

variable "Patchgroup" {
  type        = string
  description = "Set the Patch Group"
}

variable "eip-id" {
  type        = string
  description = "Set the Elastic IP"
}
variable "key" {
  type        = string
  description = "key pair"
}