provider "aws" {
    region = var.region
}

# Create a custom VPC
resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        "Name" = "MyProjectVPC"
    }
}

# Create Subnets
resource "aws_subnet" "Mysubnet01" {
    vpc_id                  = aws_vpc.myvpc.id
    cidr_block              = var.subnet01_cidr_block
    availability_zone       = var.availability_zone_a
    map_public_ip_on_launch = true
    tags = {
        "Name" = "MyPublicSubnet01"
    }
}

resource "aws_subnet" "Mysubnet02" {
    vpc_id                  = aws_vpc.myvpc.id
    cidr_block              = var.subnet02_cidr_block
    availability_zone       = var.availability_zone_b
    map_public_ip_on_launch = true
    tags = {
        "Name" = "MyPublicSubnet02"
    }
}

# Creating Internet Gateway IGW
resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        "Name" = "MyIGW"
    }
}

# Creating Route Table
resource "aws_route_table" "myroutetable" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        "Name" = "MyPublicRouteTable"
    }
}

# Create a Route in the Route Table with a route to IGW
resource "aws_route" "myigw_route" {
    route_table_id         = aws_route_table.myroutetable.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.myigw.id
}

# Associate Subnets with the Route Table
resource "aws_route_table_association" "Mysubnet01_association" {
    route_table_id = aws_route_table.myroutetable.id
    subnet_id      = aws_subnet.Mysubnet01.id
}

resource "aws_route_table_association" "Mysubnet02_association" {
    route_table_id = aws_route_table.myroutetable.id
    subnet_id      = aws_subnet.Mysubnet02.id
}

# Adding security group
resource "aws_security_group" "allow_tls" {
    name_prefix   = "allow_tls_"
    description   = "Allow TLS inbound traffic"
    vpc_id        = aws_vpc.myvpc.id

    ingress {
        description = "TLS from VPC"
        from_port   = var.ssh_port
        to_port     = var.ssh_port
        protocol    = "tcp"
        cidr_blocks = var.ssh_cidr_blocks
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = var.ssh_cidr_blocks
    }
}

# Creating IAM role for EKS
resource "aws_iam_role" "master" {
    name = "innoscripta-eks-master"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

# Attach policies to the IAM role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = aws_iam_role.master.name
}
# Creating EKS Node Group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = [aws_subnet.Mysubnet01.id, aws_subnet.Mysubnet02.id]
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t2.micro"]

  scaling_config {
    desired_size = 2
    min_size     = 1   # Specify the minimum number of nodes
    max_size     = 5   # Specify the maximum number of nodes
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
# Create EKS Cluster
resource "aws_eks_cluster" "eks" {
    name     = "innoscripta-eks"
    role_arn = aws_iam_role.master.arn

    vpc_config {
        subnet_ids = [aws_subnet.Mysubnet01.id, aws_subnet.Mysubnet02.id]
    }

    tags = {
        "Name" = "assignment"
    }
}
