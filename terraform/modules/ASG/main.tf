resource "aws_launch_template" "instance_template" {
  name_prefix   = "instance-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.my_instance_type
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
sleep 30
docker pull deekshithar1307/devops-prg-app
docker container run -d --name devops-prg-app -p 80:80 deekshithar1307/devops-prg-app
EOF
  )
  
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "instance_template"
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name = "my-asg"

  min_size         = 1
  max_size         = 5
  desired_capacity = 2

  vpc_zone_identifier = var.subnet_id

  launch_template {
    id      = aws_launch_template.instance_template.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 900

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_to_alb" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  lb_target_group_arn   = var.my_tg
}

resource "aws_security_group" "asg_sg" {
    name = "asg_instance_sg"
    vpc_id = var.vpc_id
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
     }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "asg_sg"
    }
}