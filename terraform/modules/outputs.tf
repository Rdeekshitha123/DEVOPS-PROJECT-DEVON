output "instance_id" {
  value = aws_instance.my_ec2.id
}
output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "instance_private_ip" {
  value = aws_instance.my_ec2.private_ip
}

output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

output "my_tg" {
  value = aws_lb_target_group.my_tg.arn
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}
output "my_vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "public_subnets" {
  value = [aws_subnet.subnet_1.id, aws_subnet.subnet_3.id]
}
output "private_subnets" {
  value = [aws_subnet.subnet_2.id, aws_subnet.subnet_4.id]
}
output "nat_gateway_id" {
    value = aws_nat_gateway.my_nat.id
}
