output "vpc_id" {
  description = "ID of the VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the isolated private subnets."
  value       = module.network.private_subnet_ids
}

output "public_route_table_id" {
  description = "ID of the shared public route table."
  value       = module.network.public_route_table_id
}

output "private_route_table_ids" {
  description = "IDs of the per-AZ private route tables."
  value       = module.network.private_route_table_ids
}

output "availability_zones" {
  description = "Availability Zones selected by the module."
  value       = module.network.availability_zones
}

