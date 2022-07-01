variable "aws_region" {
    description = "aws region"
    default = "us-east-2"
  
}
variable "vpc_cidr" {
    description = "CIDR value of VPC"
    default = "172.31.0.0/16"
}

variable "aws_az" {
    description = "available availability zone"
    type = map
    default = {
        az_one = "us-east-2a"
        az_two = "us-east-2b"
    } 
}

variable "vpc_subnet" {
    description = "CIDR block of VPC subnets"
    type = map
    default = {
        az_one_public = "172.31.0.0/24"
        az_one_private = "172.31.2.0/24"
        az_two_public = "172.31.1.0/24"
        az_two_private = "172.31.3.0/24"
    }
}

variable "resource_name" {
    description = "resource naming convention"
    type = map
    default = {
        vpc = "vpc-us-e2-pictory"
        public_subnet = "vpc-us-e2-pictory_Public"
        private_subnet = "vpc-us-e2-pictory_Private"
        internet_gateway = "vpc-us-e2-pictory"
        public_route_table = "vpc-us-e2-pictory_Public"
        private_route_table = "vpc-us-e2-pictory_Private"
        nat_elastic_ip = "NAT-EIP"        
    }  
}
