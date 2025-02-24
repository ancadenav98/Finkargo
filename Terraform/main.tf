#Configuración del provider, por simplicidad lo dejo en el main, sin embargo es mejor práctica aislar la configuracion del provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Se llaman los modulos definidos para el proyecto donde se crearon pensado en una estructura de proyecto mas granular y cada modulo por tipo de recurso

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr 
  private_subnets_cidr = var.private_subnets_cidr 
}


module "nat_instance" {
  source = "./modules/nat_instance"

  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnets_cidr = module.vpc.private_subnets_cidr

}

#Se definen internet gateway y route table para las subnets publicas
module "internet_gateway" {
  source = "./modules/internet_gateway"

  vpc_id = module.vpc.vpc_id
}

module "public_route_table" {
  source = "./modules/route_table"

  vpc_id = module.vpc.vpc_id
  name   = "public-route-table"
  routes = {
    default = {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.internet_gateway.igw_id
    }
  }
}
#Se definen internet gateway y route table para las subnets privadas
module "private_route_table" {
  source = "./modules/route_table"

  vpc_id = module.vpc.vpc_id
  name   = "private-route-table"
  routes = {
    default = {
      cidr_block = "0.0.0.0/0"
      instance_id = module.nat_instance.nat_public_ip
    }
  }
}

#Se crean desde el main las asociaciones por simplicidad del proyecto, sin embargo podrían crearse desde un modulo donde se centralize la creacion de la VPC y los recursos involucrados en la misma
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(module.vpc.public_subnet_ids)
  subnet_id      = module.vpc.public_subnet_ids[count.index]
  route_table_id = module.public_route_table.route_table_id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(module.vpc.private_subnet_ids)
  subnet_id      = module.vpc.private_subnet_ids[count.index]
  route_table_id = module.private_route_table.route_table_id
}

