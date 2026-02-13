resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "my-vpc"
    }
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "my-igw"
    }
}

resource "aws_subnet" "subnet_1" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.my_vpc.id
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "subnet-1"
    }
}


resource "aws_subnet" "subnet_3" {
    cidr_block = "10.0.3.0/24"
    vpc_id = aws_vpc.my_vpc.id
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
    tags = {
        Name = "subnet-3"
    }
}
resource "aws_route_table" "my_rt_1" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "my-rt-1"
    }
}

resource "aws_route_table_association" "rt_asso_1" {
    subnet_id = aws_subnet.subnet_1.id
    route_table_id = aws_route_table.my_rt_1.id
   
}
resource "aws_route_table_association" "rt_asso_3" {
    subnet_id = aws_subnet.subnet_3.id
    route_table_id = aws_route_table.my_rt_1.id
   
}
resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags = {
        Name = "nat_eip"
    }
}

resource "aws_nat_gateway" "my_nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.subnet_1.id
    depends_on = [aws_internet_gateway.my_igw]
    tags = {
        Name = "my-nat"
    }
}

resource "aws_subnet" "subnet_2" {
      cidr_block = "10.0.5.0/24"
    vpc_id = aws_vpc.my_vpc.id
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
    tags = {
        Name = "subnet-2"
    }
}

resource "aws_route_table" "my_rt_2" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.my_nat.id
    }
    tags = {
        Name = "my-rt-2"
    }
}

resource "aws_route_table_association" "rt_asso_2" {
    subnet_id = aws_subnet.subnet_2.id
    route_table_id = aws_route_table.my_rt_1.id
    
}

resource "aws_subnet" "subnet_4" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1d"          
  map_public_ip_on_launch = false
  tags = { Name = "private-subnet-4" }
}

resource "aws_route_table_association" "rt_asso_4" {
  subnet_id      = aws_subnet.subnet_4.id
  route_table_id = aws_route_table.my_rt_2.id
}