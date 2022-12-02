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

data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:eu-west-2:695677589526:secret:MSSQL-MnsfER"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

output "sensitive_example_hash" {
  value = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string))
}



# resource "aws_db_instance" "dev" {
#   allocated_storage    = 20
#   db_name              = "${var.db_name}"
#   engine               = "sqlserver-se"
#   engine_version       = "SQL Server 2019 15.00.4198.2.v1"
#   instance_class       = "db.m5.large"
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true
# }