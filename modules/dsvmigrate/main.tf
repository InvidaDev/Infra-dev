terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_vpc" "main" {
  filter {
    name = "tag:Name"
    values = ["main-prod-vpc"]
  }
}
data "aws_security_group" "sgprod" {
  name = "i-mgmt-prod-infra-sg"
}
data "aws_security_group" "sgweb" {
  name = "e-web-prod-app-sg"
}

data "aws_security_group" "sgrdp" {
  name = "i-emergency-rdp-access-prod-infra-sg"
}

data "aws_instance" "old" {
  instance_tags = {
    "Name" = "${var.webservername}"
  }
  
}

data "aws_eip" "by_filter" {
id = "${var.eip-id}"
}
data "aws_ami" "Win2022" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["${var.ami}"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_subnet" "main" {
  id =  var.subnet
}
locals {
  timestamp = "${timestamp()}"
}

data "aws_key_pair" "key" {
key_name = "${var.key}"
}

output "data1" {
  value = var.ami
}
resource "aws_instance" "Customer" {
  ami                    = data.aws_ami.Win2022.id
  instance_type          = var.instance_type
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  subnet_id              = data.aws_subnet.main.id
  vpc_security_group_ids = [data.aws_security_group.sgprod.id, data.aws_security_group.sgrdp.id, data.aws_security_group.sgweb.id]
  key_name               = data.aws_key_pair.key.key_name
  root_block_device {
    encrypted = true
  }



  tags = {
    "Name"          = "${var.webservername}"
    "Environment"   = "${var.Environment}"
    "Patch Group"   = "${var.Patchgroup}"
    "backup-config" = "${var.backup}"
    "Migrated-Date" = formatdate("YYYYMMDD", timestamp())  
    "type"          = "Terraform-Managed"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.Customer.id
  allocation_id = data.aws_eip.by_filter.id
}