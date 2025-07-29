# Contains aws_instance, data "aws_ami", user_data

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [module.vpc.jenkins_sg_id]
  subnet_id              = module.vpc.private_subnets[0]
  iam_instance_profile   = var.iam_instance_profile

  dynamic "user_data" {
    for_each = var.user_data_path != "" ? [1] : []
    content {
      content = templatefile(var.user_data_path, {})
    }
  }

  tags = {
    Name = var.instance_name
  }
}