terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}




# module "template" {
#   source = "./modules/Test"
#   providers = {
#     aws = aws.west-2
#    }  
#   webservername = "i-dev-template"
#   Environment   = "dev"
#   Patchgroup    = "No patch"
#   backup        = "No backups"
#   ami           = "Windows_Server-2022-English-Full-Base-*"
#   key           = "main-dev-keypair-eu-west-2"

# }


module "Invida" {
  source = "./modules/Test"
  providers = {
    aws = aws.west-2
   }  
  webservername = "i-dev-winrm-template"
  Environment   = "dev"
  Patchgroup    = "No patch"
  backup        = "No backups"
  ami           = "Invida Instance Template v0.75"
  key           = "main-dev-keypair-eu-west-2"

}

module "INVAMI" {
  source = "./modules/Test"
  providers = {
    aws = aws.west-2
   }  
  webservername = "i-winrm-template"
  Environment   = "dev"
  Patchgroup    = "No patch"
  backup        = "No backups"
  ami           = "Invida Instance Template v0.76-2022"
  key           = "main-dev-keypair-eu-west-2"

}

module "Ansible" {
  source = "./modules/Test"
  providers = {
    aws = aws.west-2
   }  
  webservername = "i-ansible-template"
  Environment   = "dev"
  Patchgroup    = "No patch"
  backup        = "No backups"
  ami           = "Ubuntu Desktop Server v0.1"
  key           = "main-dev-keypair-eu-west-2"

}
# data "aws_secretsmanager_secret" "secrets" {
#   provider = aws.west-2
#   name = "MSSQL"
#   # arn = "arn:aws:secretsmanager:eu-west-2:695677589526:secret:MSSQL-MnsfER"
# }

# data "aws_secretsmanager_secret_version" "current" {
#   secret_id = data.aws_secretsmanager_secret.secrets.id
# }

# output "sensitive_example_hash" {
#   value = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string))
# }
