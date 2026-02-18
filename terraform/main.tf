module "my_prg_resources" {
    source = "./modules/*"
}

terraform {
  backend "s3" {
    bucket         = "mystate002"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mytable"
    encrypt        = true
  }
}

