from diagrams import Diagram, Cluster
from diagrams.aws.compute import ECS, ElasticContainerServiceContainer
from diagrams.aws.network import VPC, PrivateSubnet, PublicSubnet, InternetGateway, NATGateway, ALB
from diagrams.aws.general import GenericDatabase
from diagrams.aws.network import Route53


with Diagram("Fargate Cluster", show=False):
    dns = Route53("dns")
    with Cluster("VPC"):
        igw = InternetGateway("Internet Gateway")
        

        with Cluster("Public Subnets"):
            public_subnets = [PublicSubnet("Public Subnet AZ1"),
                              PublicSubnet("Public Subnet AZ2"),
                              PublicSubnet("Public Subnet AZ3")]

        with Cluster("Private Subnets"):
            private_subnets = [PrivateSubnet("Private Subnet AZ1"),
                               PrivateSubnet("Private Subnet AZ2"),
                               PrivateSubnet("Private Subnet AZ3")]

        nat_gateways = [NATGateway("NAT Gateway AZ1"),
                        NATGateway("NAT Gateway AZ2"),
                        NATGateway("NAT Gateway AZ3")]

        for i in range(3):
            igw >> public_subnets[i] >> nat_gateways[i] >> private_subnets[i]

        alb = ALB("Application Load Balancer")
        igw >> alb

        with Cluster("Fargate Cluster in Private Subnets"):
            fargate = ECS("ECS Fargate")
            containers = [ElasticContainerServiceContainer("Task 1"),
                          ElasticContainerServiceContainer("Task 2")]

            dns >> alb >> fargate >> containers



    