
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "k8s-hybrid-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "public" {
  for_each                = var.worker_nodes
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${10 + index(keys(var.worker_nodes), each.key)}.0/24"
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags                    = { Name = "subnet-${each.key}" }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "wg_sg" {
  name   = "k8s-worker-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "worker_eip" {
  for_each = var.worker_nodes
  instance = aws_instance.worker_node[each.key].id
  domain   = "vpc"
  tags     = { Name = "eip-${each.key}" }
}
