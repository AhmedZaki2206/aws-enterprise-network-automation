variable "project_name" {
  description = "Name prefix for network resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR assigned to the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR."
  }
}

variable "availability_zones" {
  description = "Optional explicit pair of Availability Zones."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Two public subnet CIDRs."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Two private subnet CIDRs."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
}

