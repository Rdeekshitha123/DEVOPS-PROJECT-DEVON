resource "aws_launch_template" "instance_template" {
  name_prefix   = "instance-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.my_instance_type
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  user_data = base64encode(templatefile("${path.module}/userdata.tftpl", {}))
  
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
  wait_for_capacity_timeout = "0"
  min_size         = 1
  max_size         = 5
  desired_capacity = 3
  target_group_arns = [aws_lb_target_group.my_tg.arn]

  vpc_zone_identifier = [aws_subnet.subnet_2.id, aws_subnet.subnet_4.id]

  launch_template {
    id      = aws_launch_template.instance_template.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}



