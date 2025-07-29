variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH"
  type        = string
}

variable "instance_name" {
  description = "Tag name for the instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where instance will be deployed"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
}

variable "user_data_path" {
  description = "Path to tools-install.sh script"
  type        = string
  default     = ""
}
