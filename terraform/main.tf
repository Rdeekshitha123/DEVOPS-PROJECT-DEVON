module "vpc" {
    source = "./modules/VPC"
}



module "ec2" {
    source = "./modules/EC2"
    vpc_id = module.vpc.my_vpc_id
    subnet_id = module.vpc.public_subnets[0]
    
}

module "lb" {
    source = "./modules/LB"
    vpc_id      = module.vpc.my_vpc_id
    subnets  = module.vpc.public_subnets
    
}
module "asg" {
  source = "./modules/ASG"
  subnet_id = module.vpc.private_subnets
  vpc_id      = module.vpc.my_vpc_id
  my_tg = module.lb.my_tg
  alb_sg_id = module.lb.alb_sg
  nat_gateway_id = module.vpc.nat_gateway_id
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

