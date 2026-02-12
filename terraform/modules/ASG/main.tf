resource "aws_launch_template" "instance_template" {
  name_prefix   = "instance-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.my_instance_type
  vpc_security_group_ids = [var.asg_instance_sg]
  user_data = base64encode(<<-EOF
#!/bin/bash

yum update -y
yum install -y docker
echo "Docker installed"
systemctl start docker
echo "Docker daemon started"
systemctl enable docker
sleep 60
echo "Sleep completed, pulling image..."
usermod -aG docker ec2-user
docker pull deekshitha/devops-prg-app:latest
echo "Image pulled successfully"
docker container run -d --name devops-prg-app -p 80:80 deekshitha/devops-prg-app:latest
echo "Container started successfully"
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
  max_size         = 3
  desired_capacity = 2

  vpc_zone_identifier = [var.subnet_id]

  launch_template {
    id      = aws_launch_template.instance_template.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 1200

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
  