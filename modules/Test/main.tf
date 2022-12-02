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
    values = ["main-dev-vpc"]
  }
}
data "aws_security_group" "sgdev" {
  name = "i-mgmt-dev-infra-sg"
}

# data "aws_security_group" "Zabbix" {
#   name = "i-zabbixmgmt-dev-infra-sg"
# }

# data "aws_security_group" "TerraConnect" {
#   name = "i-Terraform-connect-sg"
# }

data "aws_security_group" "sgweb" {
  name = "e-web-dev-app-sg"
}

data "aws_security_group" "sgrdp" {
  name = "i-rdp-dev-infra-sg"
}

data "aws_security_group" "Ansible" {
  name = "ansible-sg"
}

data "aws_key_pair" "key" {
key_name = "${var.key}"
}

data "aws_ami" "Win2022" {
  most_recent = true
  owners      = ["self","952195334851","amazon", "aws-marketplace", "microsoft"]
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
  filter {
    name = "tag:Name"
    values = ["main1-dev-sn"]
  }
}

output "subnet" {
  value = data.aws_subnet.main
}

resource "aws_instance" "Customer" {
  ami                    = data.aws_ami.Win2022.id
  instance_type          = var.instance_type
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  subnet_id              = data.aws_subnet.main.id
  vpc_security_group_ids = [data.aws_security_group.sgdev.id, data.aws_security_group.sgrdp.id, data.aws_security_group.sgweb.id, data.aws_security_group.Ansible.id]
  key_name               = data.aws_key_pair.key.key_name


  tags = {
    "Name"          = "${var.webservername}"
    "Environment"   = "${var.Environment}"
    "Patch Group"   = "${var.Patchgroup}"
    "backup-config" = "${var.backup}"
    "Schedule"      = "Dev"
    "type"          = "Terraform-Managed"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.Customer.id
  allocation_id = aws_eip.assign.id

}

resource "aws_eip" "assign" {
  vpc = true
}