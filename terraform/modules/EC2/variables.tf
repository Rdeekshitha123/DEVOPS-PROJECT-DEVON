variable "my_instance_type" {
    default = "t3.micro"
}
variable "vpc_id" {}

variable "subnet_id" {}
variable "docker_username" {
    type = string
}