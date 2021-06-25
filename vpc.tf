

# Internet VPC
resource "aws_vpc" "vpc-themusk-flowerapp-dev" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "vpc-themusk-flowerapp-dev"
  }
  
}


# Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-themusk-flowerapp-dev.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc-themusk-flowerapp-dev.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.vpc-themusk-flowerapp-dev.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
  }
}
resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.vpc-themusk-flowerapp-dev.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
  }
}

# Internet GW
resource "aws_internet_gateway" "flowerapp-gw" {
  vpc_id = aws_vpc.vpc-themusk-flowerapp-dev.id

  tags = {
    Name = "flowerapp-gw"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.vpc-themusk-flowerapp-dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flowerapp-gw.id
  }

  tags = {
    Name = "main-public-1"
  }
}

# route tables
# resource "aws_route_table" "main-private" {
#     vpc_id = "${aws_vpc.vpc-themusk-flowerapp-dev.id}"
#     route {
#         cidr_block = "10.0.0.0/16"
#         target = "local"
#     }

#     tags = {
#         Name = "main-public-1"
#     }
# }


# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.main-public.id
}
resource "aws_route_table_association" "public-subnet-2-a" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.main-public.id
}


# Security Group
resource "aws_security_group" "allow-all-traffic" {
  vpc_id      = aws_vpc.vpc-themusk-flowerapp-dev.id
  name        = "allow-ssh"
  description = "security group that allows traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-all-traffic"
  }
}
