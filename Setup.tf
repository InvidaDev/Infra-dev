#############################
#       Providers           #
#############################

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "west-1"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "west-2"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "central-1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "west-3"
  region = "eu-west-3"
}