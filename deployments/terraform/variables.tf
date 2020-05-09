variable "count_instances" {
    default = 2 
    description = "Please provide list of instances to create"
}

variable "instance_ami" {
    default         = "ami-00129b193dc81bc31"
    description     = "Please provide AMI ID for servers"
}

variable "instance_type" {
  default           = "t2.micro"
  description       = ""
}


variable "vpc_id" {
  default           = "vpc-3b472741"
  description       = "Please provide VPC ID for instances"
}

variable "key_name" {
  default = "example"
  description = "Please provide key name"
}


variable "ssh_key_location" {
    default = "~/.ssh/id_rsa"
}

variable "user" {
  default = "ec2-user"
  description = "Username for servers"
  
}

variable "region" {
  default = "us-east-1"
  description = "Please provide region name"
  
}

