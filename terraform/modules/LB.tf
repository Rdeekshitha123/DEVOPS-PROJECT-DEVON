resource "aws_lb" "my_alb" {
    name = "my-alb"
    load_balancer_type = "application"
    subnets = [aws_subnet.subnet_1.id, aws_subnet.subnet_3.id]
    security_groups = [aws_security_group.alb_sg.id]
    tags = {
        Name = "my-alb"
    } 
}

resource "aws_lb_target_group" "my_tg" {
    vpc_id = aws_vpc.my_vpc.id
    port = 80
    protocol = "HTTP"
    target_type = "instance"
    health_check {
        enabled = true
        interval = 60
        port = "traffic-port"
        protocol = "HTTP"
        path = "/healthcheck.txt"
        matcher = "200"
        timeout = 30
        healthy_threshold = 2
        unhealthy_threshold = 2 
    }
tags = {
    Name = "my_tg"
}
}



resource "aws_lb_listener" "my_alb_listener" {
    load_balancer_arn = aws_lb.my_alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.my_tg.arn
    }
}

