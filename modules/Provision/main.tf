# Used to pull data from the region selected
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

##################################
#       Security Group           #
##################################

data "aws_security_group" "zabbix" {
  name = "i-zabbixmgmt-dev-infra-sg"
}

data "aws_security_group" "sgdev" {
  name = "i-mgmt-dev-infra-sg"
}

data "aws_vpc" "dev" {
  filter {
    name = "tag:Name"
    values = ["main-dev-vpc"]
  }
}

resource "aws_security_group" "sgdev" {
  name        = "i-mgmt-dev-infra-sg"
  description = "Management Ports for Zabbix Agent + Powershell Remoting"
  vpc_id      = data.aws_vpc.dev.id
  ingress {
    cidr_blocks      = ["192.168.250.10/32"]
    description      = "MSSQL from VPN Clients"
    from_port        = "1433"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "1433"
  }

  ingress {
    cidr_blocks      = ["192.168.250.10/32"]
    description      = "RDP from VPN Clients"
    from_port        = "3389"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "3389"
  }

  ingress {
    cidr_blocks      = []
    description      = "Powershell Remoting"
    from_port        = "22"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = [data.aws_security_group.zabbix.id]
    self             = "false"
    to_port          = "22"
  }

  ingress {
    cidr_blocks      = []
    description      = "Zabbix Agent"
    from_port        = "10050"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = [data.aws_security_group.zabbix.id]
    self             = "false"
    to_port          = "10050"
  }


  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = "0"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "All"
    security_groups  = []
    self             = "false"
    to_port          = "0"
  }

  tags = {
    "Name" : "i-mgmt-dev-infra-sg"
    "Domain" : "infra"
    "Environment" : "dev"
    "type" = "Terraform-managed"
  }
}

resource "aws_security_group" "sgrdp" {
  name        = "i-rdp-dev-infra-sg"
  description = "Allow RDP access"
  vpc_id      = data.aws_vpc.dev.id

  ingress {
    cidr_blocks      = ["212.36.32.38/32"]
    description      = "Edmund-House-Office-WiFi"
    from_port        = "3389"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "3389"
  }

  ingress {
    cidr_blocks      = ["212.36.34.46/32"]
    description      = "Crossway-Office-Public-WiFi"
    from_port        = "3389"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "3389"
  }

  ingress {
    cidr_blocks      = ["78.86.129.115/32"]
    description      = "CT Phone - 211125"
    from_port        = "3389"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "3389"
  }


  ingress {
    cidr_blocks      = ["80.3.50.173/32"]
    description      = "CT Home"
    from_port        = "3389"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "3389"
  }

  ingress {
    cidr_blocks      = ["82.12.145.67/32"]
    description      = "KT Home"
    from_port        = "3389"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "3389"
  }

  ingress {
    cidr_blocks      = ["82.12.235.130/32"]
    description      = "TH Home"
    from_port        = "3389"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "3389"
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = "0"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "All"
    security_groups  = []
    self             = "false"
    to_port          = "0"
  }
  tags = {
    "Name"        = "i-rdp-dev-infra-sg"
    "Domain"      = "infra"
    "Environment" = "dev"
    "type"        = "Terraform-managed"
  }
}

resource "aws_security_group" "sgweb" {
  name        = "e-web-dev-app-sg"
  description = "Allow HTTP+S to application for customers"
  vpc_id      = data.aws_vpc.dev.id


  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = "0"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = "false"
    to_port          = "0"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = "443"
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "443"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = "80"
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "80"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = "443"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "443"
  }

  ingress {
    cidr_blocks      = []
    description      = ""
    from_port        = "443"
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "443"
  }

  tags = {
    "Name"        = "e-web-dev-app-sg"
    "Domain"      = "app"
    "Environment" = "dev"
    "type"        = "Terraform-managed"
  }

}

resource "aws_security_group" "TerraConnect" {
  name        = "i-Terraform-connect-sg"
  description = "Allow Terraform to provision files"
  vpc_id      = data.aws_vpc.dev.id
  ingress {
    cidr_blocks      = ["212.36.32.38/32"]
    description      = "terraform from the office"
    from_port        = "5985"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "5985"
  }

  ingress {
    cidr_blocks      = ["212.36.32.38/32"]
    description      = "terraform from the office"
    from_port        = "5986"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "5986"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "terraform from github"
    from_port        = "5985"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "5985"
  }

  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "terraform from github"
    from_port        = "5986"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "5986"
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = "0"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "All"
    security_groups  = []
    self             = "false"
    to_port          = "0"
  }

  tags = {
    "Name" = "i-Terraform-connect-sg"
    "type" = "Terraform-managed"
  }

}


resource "aws_security_group" "Zabbix" {
  name        = "i-zabbixmgmt-dev-infra-sg"
  description = "Remote Management Ports for Zabbix"
  vpc_id      = data.aws_vpc.dev.id


  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = "0"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = "false"
    to_port          = "0"
  }

  egress {
    cidr_blocks      = []
    description      = ""
    from_port        = "10050"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = [data.aws_security_group.sgdev.id]
    self             = "false"
    to_port          = "10050"
  }

  ingress {
    cidr_blocks      = ["172.30.0.0/15"]
    description      = "Zabbix Agent from eu-west-1+2"
    from_port        = "10051"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "10051"
  }

  ingress {
    cidr_blocks      = ["192.168.250.0/24"]
    description      = "Zabbix Agent from eu-west-2-ad-subnet"
    from_port        = "10051"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "10051"
  }

  ingress {
    cidr_blocks      = ["192.168.250.10/32"]
    description      = "SSH from VPN Client"
    from_port        = "22"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "22"
  }

  ingress {
    cidr_blocks      = ["212.36.32.38/32"]
    description      = "HTTPS from Edmund-House-Office-WiFi"
    from_port        = "443"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "443"
  }

  ingress {
    cidr_blocks      = ["80.3.50.173/32"]
    description      = "HTTPS from CT Home"
    from_port        = "443"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "443"
  }

  ingress {
    cidr_blocks      = ["82.12.235.130/32"]
    description      = "HTTPS from TH Home"
    from_port        = "443"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "443"
  }

  ingress {
    cidr_blocks      = ["86.165.21.144/32"]
    description      = "HTTPS from TPY Home"
    from_port        = "443"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = "false"
    to_port          = "443"
  }

  tags = {
    "Domain"      = "infra"
    "Environment" = "dev"
    "Name"        = "i-zabbixmgmt-dev-infra-sg"
    "type"        = "Terraform-managed"

  }

}