variable "cidr_block" {
  type        = string
  default     = null
  description = "VPC cidr block"
}

variable "route_table_cidr_block" {
  type = string
  default = null
  description = "Route table cidr block"
}

variable "dns_hostnames" {
  type        = bool
  default     = false
  description = "DNS Hostnames"
}

variable "availability_zone" {
  type        = map(any)
  default     = {}
  description = "Subnets Availability Zones"
}

variable "name" {
  type        = string
  default     = null
  description = "Security Group Name"
}

variable "sg_description" {
  type = string
  default = null
  description = "Security group description"
}

variable "security_group_rule" {
  type        = map(any)
  default     = {}
  description = "AWS Security Group rule"
}

variable "family" {
  type        = string
  default     = null
  description = "ECS task definition family"
}

variable "network_mode" {
  type        = string
  default     = null
  description = "ECS task definition network mode"
}

variable "requires_compatibilities" {
  type        = string
  default     = null
  description = "ECS task definition compatibilities"
}

variable "operating_system_family" {
  type        = string
  default     = null
  description = "Operating system"
}

variable "cpu_architecture" {
  type        = string
  default     = null
  description = "cpu Architecture"
}

variable "container_definitions_name" {
  type        = string
  default     = null
  description = "Container Image Name"
}

variable "container_definitions_image" {
  type        = string
  default     = null
  description = "Container Image Version"
}

variable "container_definitions_essential" {
  type        = bool
  default     = false
  description = "Container Image Essential"
}

variable "container_definitions_memory" {
  type        = number
  default     = 0
  description = "Container Image memory"
}

variable "container_definitions_cpu" {
  type        = number
  default     = 0
  description = "Container Image cpu"
}

variable "container_definitions_containerPort" {
  type        = number
  default     = 0
  description = "Container Port"
}

variable "container_definitions_hostPort" {
  type        = number
  default     = 0
  description = "Host Port"
}

variable "container_definitions_protocol" {
  type        = string
  default     = null
  description = "Container Protocol"
}

variable "aws_iam_role_name" {
  type        = string
  default     = null
  description = "IAM role name"
}

variable "aws_iam_role_version" {
  type        = string
  default     = null
  description = "IAM role version"
}

variable "aws_iam_role_action" {
  type        = string
  default     = null
  description = "IAM role action"
}

variable "aws_iam_role_effect" {
  type        = string
  default     = null
  description = "IAM role effect"
}

variable "aws_iam_role_service" {
  type        = string
  default     = null
  description = "IAM role Service"
}

variable "policy_arn" {
  type        = string
  default     = null
  description = "Policy ARN"
}

variable "ecs_cluster_name" {
  type        = string
  default     = null
  description = "Cluster Name"
}

variable "ecs_service_name" {
  type        = string
  default     = null
  description = "Service Name"
}

variable "ecs_service_launch_type" {
  type        = string
  default     = null
  description = "Service Launch Type"
}

variable "lb_name" {
  type = string
  default = null
  description = "Load Balancer Name"
}

variable "lb_internal" {
  type = bool
  default = false
  description = "Load Balancer Internal"
}

variable "lb_type" {
  type = string
  default = null
  description = "Load Balancer Type"
}

variable "lb_tg_name" {
  type = string
  default = null
  description = "Target Group Name"
}

variable "lb_tg_port" {
  type = number
  default = 0
  description = "Target Group Port"
}

variable "lb_tg_protocol" {
  type = string
  default = null
  description = "Target Group Protocol"
}

variable "lb_tg_target_type" {
  type = string
  default = null
  description = "Target Group Target Type"
}

variable "lb_tg_path" {
  type = string
  default = null
  description = "HealthCheck path"
}

variable "health_check_enabled" {
  type = bool
  default = false
  description = "Health check enabled"
}

variable "health_check_threshold" {
  type = number
  default = 0
  description = "Health Check Threshold"
}

variable "health_check_timeout" {
  type = number
  default = 0
  description = "Health Check Timeout"
}

variable "lb_listener_port" {
  type = number
  default = 0
  description = "Load Balancer Listener Port"
}

variable "lb_listener_protocol" {
  type = string
  default = null
  description = "Load Balancer Listener Protocol"
}

variable "listener_default_action" {
  type = string
  default = null
  description = "Load Balancer Default Action"
}

variable "cluster_service_version" {
  type = string
  default = null
  description = "Cluster Service Platform Version"
}

variable "cluster_desired_count" {
  type = number
  default = 0
  description = "Cluster Service desired count"
}

variable "cluster_public_ip" {
  type = bool
  default = false
  description = "Cluster Service Public Ip"
}

variable "load_balancer_container_name" {
    type = string
  default = null
  description = "Container Name"
}

variable "load_balancer_container_port" {
    type = number
  default = 0
  description = "Container port"
}

variable "map_public_ip_on_launch" {
  type = bool
  default = false
  description = "Map public Ip"
}

variable "enable_deletion_protection" {
  type = bool
  default = false
  description = "Deletion protection"
}

variable "enable_http2" {
  type = bool
  default = false
  description = "Enable http2"
}

variable "key_pair_name" {
  type = string
  default = null
  description = "Name of the key pair"
}

variable "aws_role_worker"{
  type = string
  default = 0
  description = "Role for kubernetes cluster"
}

variable "aws_eks_cluster"{
  type = string
  default = null
  description = "Name of the K8 Cluster" 
}

variable "cluster_policy"{
  type = string
  default = null
  description = "cluser policy" 
}

variable "resource_controller"{
  type = string
  default = null
  description = "Policy of resource controller" 
}

variable "node_controller"{
  type = string
  default = null
  description = "Node policy" 
}

variable "cni_policy"{
  type = string
  default = null
  description = "cni policy" 
}

variable "registry_read_only" {
    type = string
  default = null
  description = "registry" 
}