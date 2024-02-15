resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.dns_hostnames
  tags = {
    Name = "practica-final-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "practica-final-ig"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "this" {
  for_each = var.availability_zone
  subnet_id = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this.id
}

resource "aws_subnet" "this" {
  for_each = var.availability_zone

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, each.value.cidr_block)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone
  tags = {
    Name = each.value.name
  }
}

resource "aws_security_group" "this" {
  name        = var.name
  description = var.sg_description
  vpc_id      = aws_vpc.this.id
}

resource "aws_security_group_rule" "this" {
  for_each = var.security_group_rule

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_blocks]
  security_group_id = aws_security_group.this.id
}

resource "aws_iam_role" "this" {
  name = var.aws_iam_role_name
  assume_role_policy = jsonencode({
    Version = var.aws_iam_role_version,
    Statement = [
      {
        Action = var.aws_iam_role_action,
        Effect = var.aws_iam_role_effect,
        Principal = {
          Service = var.aws_iam_role_service
        }
      }
    ]
  })
}

  resource "aws_iam_role" "worker" {
    name = var.aws_role_worker

    assume_role_policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    })
  }

resource "aws_iam_role_policy_attachment" "eks_execution_policy_attachment" {
  policy_arn = var.policy_arn
  role       = aws_iam_role.this.name
}

resource "aws_alb" "this" {
  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.this.id]
  subnets            = [for i in aws_subnet.this : i.id]
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2 = var.enable_http2
}

resource "aws_alb_target_group" "this" {
  name        = var.lb_tg_name
  port        = var.lb_tg_port
  protocol    = var.lb_tg_protocol
  target_type = var.lb_tg_target_type
  vpc_id      = aws_vpc.this.id
  health_check {
    enabled = var.health_check_enabled
    protocol = var.lb_tg_protocol
    path = var.lb_tg_path
    port = var.lb_tg_port
    unhealthy_threshold = var.health_check_threshold
    timeout = var.health_check_timeout
  }
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type = var.listener_default_action
    target_group_arn = aws_alb_target_group.this.arn
  }
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = var.cluster_policy
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = var.resource_controller
  role       = aws_iam_role.this.name
}

resource "aws_eks_cluster" "eks_cluster_practica" {
  name     = var.aws_eks_cluster
  role_arn = aws_iam_role.this.arn

  vpc_config {
    subnet_ids            = [for i in aws_subnet.this : i.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_execution_policy_attachment,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

  resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
    policy_arn = var.node_controller
    role       = aws_iam_role.worker.name
  }

  resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
    policy_arn = var.cni_policy
    role       = aws_iam_role.worker.name
  }

    resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = var.registry_read_only
    role       = aws_iam_role.worker.name
  }

  resource "tls_private_key" "this" {
    algorithm = "RSA"
    rsa_bits  = 4096
  }


  resource "aws_key_pair" "this" {
    key_name = var.key_pair_name
    public_key = tls_private_key.this.public_key_openssh
  }


resource "aws_eks_node_group" "node_group" {
  cluster_name = aws_eks_cluster.eks_cluster_practica.name
  node_group_name = "kc-group-node-practica"
  node_role_arn = aws_iam_role.worker.arn
  subnet_ids = [for i in aws_subnet.this : i.id]
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = ["t2.small"]

  remote_access {
    ec2_ssh_key = aws_key_pair.this.key_name
    source_security_group_ids = [ aws_security_group.this.id ]
  }

  scaling_config {
    desired_size = 2
    max_size = 2
    min_size = 1
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


output "endpoint" {
  value = aws_eks_cluster.eks_cluster_practica.endpoint
}