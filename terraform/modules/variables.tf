variable "my_instance_type" {
    default = "t3.micro"
}

variable "subnet_id" {
    type = list(string)
}
variable "my_tg" {}
variable "vpc_id" {
    type = string
}
variable "alb_sg_id" {
    type = string
}

variable "subnets" {}
variable "alb_sg" {}
variable "lb_sg" {}