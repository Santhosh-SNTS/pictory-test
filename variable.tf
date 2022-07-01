variable "aws_region" {
  description = "aws region"
  default     = "us-east-2"
}

variable "resource_name" {
  description = "resource naming convention"
  type        = map(any)
  default = {
    vpc                 = "vpc-us-e2-pictory"
    public_subnet       = "vpc-us-e2-pictory_Public"
    private_subnet      = "vpc-us-e2-pictory_Private"
    internet_gateway    = "vpc-us-e2-pictory"
    public_route_table  = "vpc-us-e2-pictory_Public"
    private_route_table = "vpc-us-e2-pictory_Private"
    nat_elastic_ip      = "NAT-EIP"
    ecs_cluster         = "cluster-us-e2-dev-pictory-api"
  }
}
#=============================================
###################VPC########################
#=============================================
variable "vpc_cidr" {
  description = "CIDR value of VPC"
  default     = "172.31.0.0/16"
}

variable "aws_az" {
  description = "available availability zone"
  type        = map(any)
  default = {
    az_one = "us-east-2a"
    az_two = "us-east-2b"
  }
}

variable "vpc_subnet" {
  description = "CIDR block of VPC subnets"
  type        = map(any)
  default = {
    az_one_public  = "172.31.0.0/24"
    az_one_private = "172.31.2.0/24"
    az_two_public  = "172.31.1.0/24"
    az_two_private = "172.31.3.0/24"
  }
}


#=============================================
####################ECS#######################
#=============================================
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "nginx:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}


