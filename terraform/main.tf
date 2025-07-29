module "vpc" {
  source         = "./modules/vpc"
  vpc_name       = var.vpc_name
  subnet_name    = var.subnet_name
  ...
}

module "iam" {
  source    = "./modules/iam"
  iam_role  = var.iam_role
}

module "ec2" {
  source                = "./modules/ec2"
  instance_type         = var.instance_type
  key_name              = var.key_name
  instance_name         = var.instance_name
  subnet_id             = module.vpc.public_subnet_id
  iam_instance_profile  = module.iam.instance_profile_name
  security_group_ids    = [module.vpc.security_group_id]
  user_data_path        = "${path.module}/scripts/tools-install.sh"
  ami_id                = data.aws_ami.ubuntu.id
}

module "bastion" {
  source               = "./modules/bastion"
  bastion_instance_type = "t2.micro"
  key_name              = var.key_name
  public_subnet_id      = module.vpc.public_subnets[0]
  vpc_id                = module.vpc.vpc_id
  allowed_ssh_cidr      = "YOUR_PUBLIC_IP/32"
}
