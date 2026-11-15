mock_provider "aws" {}

variables {
  availability_zones = ["eu-central-1a", "eu-central-1b"]
}

run "network_plan" {
  command = plan

  assert {
    condition     = aws_vpc.this.cidr_block == "10.20.0.0/16"
    error_message = "The VPC must use the expected default CIDR."
  }

  assert {
    condition     = length(aws_subnet.public) == 2 && length(aws_subnet.private) == 2
    error_message = "The design must create two public and two private subnets."
  }

  assert {
    condition = alltrue([
      for subnet in concat(aws_subnet.public, aws_subnet.private) :
      cidrcontains(aws_vpc.this.cidr_block, cidrhost(subnet.cidr_block, 1))
    ])
    error_message = "Every subnet must be contained within the VPC CIDR."
  }

  assert {
    condition = length(distinct(concat(
      [for subnet in aws_subnet.public : subnet.cidr_block],
      [for subnet in aws_subnet.private : subnet.cidr_block]
    ))) == 4
    error_message = "Subnet CIDRs must be unique."
  }

  assert {
    condition = alltrue(flatten([
      for left in concat(aws_subnet.public, aws_subnet.private) : [
        for right in concat(aws_subnet.public, aws_subnet.private) :
        left.cidr_block == right.cidr_block || !cidrcontains(left.cidr_block, cidrhost(right.cidr_block, 1))
      ]
    ]))
    error_message = "Subnet CIDRs must not overlap."
  }

  assert {
    condition     = aws_route.public_internet.destination_cidr_block == "0.0.0.0/0" && aws_route.public_internet.gateway_id == aws_internet_gateway.this.id
    error_message = "The public route table must send the default route to the Internet Gateway."
  }

  assert {
    condition     = length(aws_route_table.private) == 2
    error_message = "A private route table must exist for each Availability Zone."
  }

  assert {
    condition     = alltrue([for subnet in aws_subnet.private : subnet.map_public_ip_on_launch == false])
    error_message = "Private subnets must not auto-assign public IPv4 addresses."
  }
}

