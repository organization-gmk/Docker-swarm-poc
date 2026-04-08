module "vpc" {
  source = "./modules/vpc"

  name_prefix            = local.name_prefix
  vpc_cidr               = var.vpc_cidr
  azs                    = local.azs
  project_name           = var.project_name
  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  tags = local.common_tags
}

module "compute-cloud" {
  source = "./modules/elastic-compute"

  name_prefix = local.name_prefix
  mngr_instance_type = var.mngr_instance_type
  worker_instance_type = var.worker_instance_type
  docker-swarm-sg_id = module.vpc.docker-swarm-manager-sg_id
  subnet_ids           = module.vpc.private_subnets
  key_name             = var.key_name 
  tags = local.common_tags
}