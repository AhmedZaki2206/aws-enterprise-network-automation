variable "aws_region" {
  description = "AWS Region in which to build the network."
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name prefix used for resources and tags."
  type        = string
  default     = "aws-enterprise-network-automation"
}

variable "environment" {
  description = "Environment tag for the portfolio deployment."
  type        = string
  default     = "demo"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR assigned to the VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Optional two-AZ override. Leave empty to select the first two available AZs dynamically."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.availability_zones) == 0 || length(var.availability_zones) == 2
    error_message = "availability_zones must be empty or contain exactly two AZ names."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets, one per Availability Zone."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs are required."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDRs for isolated private subnets, one per Availability Zone."
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Exactly two private subnet CIDRs are required."
  }
}

variable "additional_tags" {
  description = "Additional tags merged with the required project tags."
  type        = map(string)
  default     = {}
}

