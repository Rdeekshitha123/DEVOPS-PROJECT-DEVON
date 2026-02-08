module "vpc" {
    source = "./modules/VPC"
}



module "ec2" {
    source = "./modules/EC2"
    vpc_id = module.vpc.my_vpc_id
    subnet_id = module.vpc.subnets[0]
    docker_username = var.docker_username
}

module "lb" {
    source = "./modules/LB"
    vpc_id      = module.vpc.my_vpc_id
    subnet_ids  = module.vpc.subnets
    instance_id = module.ec2.instance_id
}

terraform {
  backend "s3" {
    bucket         = "mystate001"
    region         = "us-east-1"
    key            = "statefile/terraform.tfstate"
    dynamodb_table = "mytable"
    encrypt        = true
  }
}