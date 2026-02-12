output "my_vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "public_subnets" {
    value = [ aws_subnet.subnet_1.id, aws_subnet.subnet_3.id ]
}
output "private_subnets" {
    value = [ aws_subnet.subnet_2.id ]
}