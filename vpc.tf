terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "EC2VPC" {
    cidr_block = "172.31.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    tags = {
        Name = "vpc-us-e2-pictory"
    }
}

resource "aws_subnet" "EC2Subnet1" {
    availability_zone = "ap-south-1a"
    cidr_block = "172.31.0.0/24"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = true
    tags = {
        Name = "vpc-us-e2-pictory_Public"
    }
}

resource "aws_subnet" "EC2Subnet2" {
    availability_zone = "ap-south-1b"
    cidr_block = "172.31.1.0/24"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = true
    tags = {
        Name = "vpc-us-e2-pictory_Public"
    }
}

resource "aws_subnet" "EC2Subnet4" {
    availability_zone = "ap-south-1a"
    cidr_block = "172.31.3.0/24"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
    tags = {
        Name = "vpc-us-e2-pictory_Private"
    }
}

resource "aws_subnet" "EC2Subnet3" {
    availability_zone = "ap-south-1b"
    cidr_block = "172.31.2.0/24"
    vpc_id = "${aws_vpc.EC2VPC.id}"
    map_public_ip_on_launch = false
    tags = {
        Name = "vpc-us-e2-pictory_Private"
    }
}

resource "aws_internet_gateway" "EC2InternetGateway" {
    tags = {
        Name = "vpc-us-e2-pictory"
    }
    vpc_id = "${aws_vpc.EC2VPC.id}"
}

# resource "aws_vpc_dhcp_options" "EC2DHCPOptions" {
#     domain_name = "us-east-2.compute.internal"
#     tags = ""
# }

resource "aws_vpc_dhcp_options" "EC2DHCPOptions" {
    domain_name = "ap-south-1.compute.internal"
}
resource "aws_vpc_dhcp_options_association" "EC2VPCDHCPOptionsAssociation" {
    dhcp_options_id = aws_vpc_dhcp_options.EC2DHCPOptions.id
    vpc_id = "${aws_vpc.EC2VPC.id}"
}

#public_route_table
resource "aws_route_table" "EC2RouteTable1" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "vpc-us-e2-pictory_Public"
    }
}

#private_route_table
resource "aws_route_table" "EC2RouteTable2" {
    vpc_id = aws_vpc.EC2VPC.id
    tags = {
        Name = "vpc-us-e2-pictory_Private"
    }
}

#main_route_table
resource "aws_route_table" "EC2RouteTable3" {
    vpc_id = "${aws_vpc.EC2VPC.id}"
    tags = {
        Name = "vpc-us-e2-pictory_sub"
    }
}

resource "aws_route" "EC2Route1" {
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.EC2NatGateway.id
    route_table_id = aws_route_table.EC2RouteTable2.id
}

# resource "aws_route" "EC2Route2" {
#     destination_cidr_block = "0.0.0.0/0"
#     gateway_id = aws_vpc_endpoint.EC2VPCEndpoint.id
#     route_table_id = aws_route_table.EC2RouteTable2.id
# }

resource "aws_route" "EC2Route3" {
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.EC2InternetGateway.id
    route_table_id = aws_route_table.EC2RouteTable1.id
}

#Public_RT_association
resource "aws_route_table_association" "EC2SubnetRouteTableAssociation" {
    route_table_id = aws_route_table.EC2RouteTable1.id
    subnet_id = aws_subnet.EC2Subnet1.id
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation2" {
    route_table_id = aws_route_table.EC2RouteTable1.id
    subnet_id = aws_subnet.EC2Subnet2.id
}

#Private_RT_association
resource "aws_route_table_association" "EC2SubnetRouteTableAssociation3" {
    route_table_id = aws_route_table.EC2RouteTable2.id
    subnet_id = aws_subnet.EC2Subnet3.id
}

resource "aws_route_table_association" "EC2SubnetRouteTableAssociation4" {
    route_table_id = aws_route_table.EC2RouteTable2.id
    subnet_id = aws_subnet.EC2Subnet4.id
}

#Elastic_IP
resource "aws_eip" "elasticIP1" {
  vpc      = true
  tags = {
    Name = "NAT-EIP"
  }
}
#NAT_gateway
resource "aws_nat_gateway" "EC2NatGateway" {
    subnet_id = aws_subnet.EC2Subnet4.id
     
    allocation_id = aws_eip.elasticIP1.id
}

#VPC_endpoint

resource "aws_vpc_endpoint" "EC2VPCEndpoint" {
    vpc_endpoint_type = "Gateway"
    vpc_id = aws_vpc.EC2VPC.id
    service_name = "com.amazonaws.ap-south-1.s3"
    policy = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"*\",\"Resource\":\"*\"}]}"
    route_table_ids = [
        aws_route_table.EC2RouteTable3.id,
        aws_route_table.EC2RouteTable2.id
    ]
    private_dns_enabled = false
}

