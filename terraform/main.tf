module "vpc" {
    source = "./modules/VPC"
}



module "ec2" {
    source = "./modules/EC2"
    vpc_id = module.vpc.my_vpc_id
    subnet_id = module.vpc.subnets[0]
    
}

module "lb" {
    source = "./modules/LB"
    vpc_id      = module.vpc.my_vpc_id
    subnets  = module.vpc.subnets
    instance_id = module.ec2.instance_id
}
module "asg" {
  source = "./modules/ASG"
  asg_instance_sg = module.ec2.asg_instance_sg
  subnet_id = module.vpc.subnets[0]
  my_tg = module.lb.my_tg
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

