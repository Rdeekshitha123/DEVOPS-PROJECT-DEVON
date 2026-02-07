resource "aws_instance" "my_ec2" {
    instance_type = var.my_instance_type
    ami = data.aws_ami.amazon_linux.id
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
    tags = {
        name = "my_ec2"
    }

}
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners =["679593333241"]
    filter {
        name = "name"
        values = [ "UVDesk Alma Linux 251027.1-167efb65-9bdb-4575-9be2-2a9e0b3e3e78" ] 
    }
    filter {
        name = "Architecture"
        values = [ "x86_64" ]
    }
}
resource "aws_security_group" "allow_ssh_http" {
    name = "allow-ssh"
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
    cidr_blocks = "0.0.0.0/0"
     }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "allow_ssh_http"
    }
}