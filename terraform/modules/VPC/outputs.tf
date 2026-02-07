output "my_vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "subnets" {
    value = [ aws_subnet.subnet_1.id, aws_subnet.subnet_2.id ]
}
