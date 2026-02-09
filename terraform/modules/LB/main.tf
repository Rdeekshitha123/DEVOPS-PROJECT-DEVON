resource "aws_lb" "my_alb" {
    name = "my-alb"
    load_balancer_type = "application"
    subnets = var.subnets
    security_groups = [aws_security_group.alb_sg.id]
    tags = {
        Name = "my-alb"
    } 
}

resource "aws_lb_target_group" "my_tg" {
    vpc_id = var.vpc_id
    port = 80
    protocol = "HTTP"
    target_type = "instance"
    health_check {
        interval = 30
        port = 80
        protocol = "HTTP"
        path = "/"
        matcher = "200"
        timeout = 10
        healthy_threshold = 2
        unhealthy_threshold = 2 
    }
tags = {
    Name = "my_tg"
}
}

resource "aws_lb_target_group_attachment" "my_lb_tg" {
    target_group_arn = aws_lb_target_group.my_tg.arn
    target_id = var.instance_id
    
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

resource "aws_security_group" "alb_sg" {
    vpc_id = var.vpc_id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}