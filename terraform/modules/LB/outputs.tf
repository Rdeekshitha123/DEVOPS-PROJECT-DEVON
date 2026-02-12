output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

output "my_tg" {
  value = aws_lb_target_group.my_tg.arn
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}