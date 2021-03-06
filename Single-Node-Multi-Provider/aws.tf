#########################################################################
### Networking

// Create the cloud network stack
module "aws_vpc" {
  // Module Source
  source      = "./modules/aws/vpc"

  // Networking Settings
  cidr_block  = var.aws.vpc.cidr_block
  subnets     = var.aws.subnets
  tags        = var.aws.tags
}

#########################################################################
### Virtual Machines

// Create the AWS EC2 Instances
module "aws_compute" {
  // Module Source
  source = "./modules/aws/ec2"

  // Compute Settings
  compute_nodes   = var.aws.compute
  public_subnets  = module.aws_vpc.public_subnets
  ssh_auth        = var.ssh_auth
  tags            = var.aws.tags

  // Depends On the AWS VPC being ready
  depends_on      = [
    module.aws_vpc
  ]
}

#########################################################################
### Security Groups

module "aws_k3s_security_groups" {
  // Module Source
  source = "./modules/aws/security_group"

  vpc_id = module.aws_vpc.vpc_id
  security_groups = var.aws.security_groups
  tags = var.aws.tags
}

module "aws_k3s_security_group_association" {
  // Module Source
  source = "./modules/aws/ec2_sg_associate"

  // Load in Security Groups and ENIs
  security_groups = module.aws_k3s_security_groups.security_group_ids
  ec2_enis        = module.aws_compute.primary_net_interface_id

  depends_on = [
    module.aws_compute,
    module.aws_k3s_security_groups
  ]
}