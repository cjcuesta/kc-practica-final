module "kc-ecs-final" {

  source = "../modules/ecs"

  cidr_block    = "10.0.0.0/16"
  route_table_cidr_block = "0.0.0.0/0"
  dns_hostnames = true

  availability_zone = {
    subnet1 = {
      "cidr_block" : 1
      "availability_zone" : "eu-west-3a"
      "name" : "subnet1"
    },
    subnet2 = {
      "cidr_block" : 2
      "availability_zone" : "eu-west-3b"
      "name" : "subnet2"
    }
  }

  name = "practica-final-sg"
  sg_description = "ecs-security-group-final"

  security_group_rule = {
    ingress = {
      "type" : "ingress"
      "from_port" : 80
      "to_port" : 80
      "protocol" : "tcp"
      "cidr_blocks" : "0.0.0.0/0"
    },
    egress = {
      "type" : "egress"
      "from_port" : 0
      "to_port" : 0
      "protocol" : "-1"
      "cidr_blocks" : "0.0.0.0/0"
    }
  }

  family                              = "kc-task-definition-final-nicolas"
  network_mode                        = "awsvpc"
  requires_compatibilities            = "FARGATE"
  container_definitions_name          = "nginx"
  container_definitions_image         = "nginx:latest"
  operating_system_family             = "LINUX"
  cpu_architecture                    = "X86_64"
  container_definitions_essential     = true
  container_definitions_memory        = 3072
  container_definitions_cpu           = 1024
  container_definitions_containerPort = 80
  container_definitions_hostPort      = 80
  container_definitions_protocol      = "tcp"
  aws_iam_role_name                   = "final-role-kc"
  aws_iam_role_version                = "2012-10-17"
  aws_iam_role_action                 = "sts:AssumeRole"
  aws_iam_role_effect                 = "Allow"
  aws_iam_role_service                = "eks.amazonaws.com"
  policy_arn                          = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ecs_cluster_name                    = "nginx-cluster-final-nicolas"
  ecs_service_name                    = "nginx-service-final-nicolas"
  ecs_service_launch_type             = "FARGATE"
  lb_name = "LBalancer-practica-final-kc"
  lb_internal = false
  lb_type = "application"
  lb_tg_name = "tgroup-practica-final-kc"
  lb_tg_port = 80
  lb_tg_protocol = "HTTP"
  lb_tg_target_type = "ip"
  lb_tg_path = "/"
  health_check_enabled = true
  health_check_threshold = 2
  health_check_timeout = 3
  lb_listener_port = 80
  lb_listener_protocol = "HTTP"
  listener_default_action ="forward"
  cluster_service_version ="LATEST"
  cluster_desired_count = 2
  cluster_public_ip = true
  load_balancer_container_name = "nginx"
  load_balancer_container_port = 80
  map_public_ip_on_launch = true
  enable_deletion_protection = false
  enable_http2 = true
  aws_role_worker = "ed-eks-worker"
  aws_eks_cluster = "eks_cluster_kc"
  cluster_policy = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  resource_controller = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  node_controller = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  cni_policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  registry_read_only = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
