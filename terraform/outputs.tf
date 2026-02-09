output "alb_dns_name" {
  value = module.lb.alb_dns_name
}
output "ec2_instance_ip" {
  value = module.ec2.instance_public_ip
}

