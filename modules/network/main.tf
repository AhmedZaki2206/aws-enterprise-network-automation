data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  selected_azs = length(var.availability_zones) == 2 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 2)
  name_prefix  = "${var.project_name}-${var.environment}"
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "${local.name_prefix}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${local.name_prefix}-igw" })
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-public-${count.index + 1}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  count = 2

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-private-${count.index + 1}"
    Tier = "private"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${local.name_prefix}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = 2

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-private-${count.index + 1}-rt"
    Tier = "private"
  })
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Example application-tier SG. It allows HTTPS only from inside the VPC and
# intentionally contains no SSH, RDP, or Internet-sourced ingress rule.
resource "aws_security_group" "application" {
  name        = "${local.name_prefix}-application-sg"
  description = "Private application tier: HTTPS from within the VPC only"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTPS from the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "HTTPS to VPC endpoints or internal services"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(var.tags, { Name = "${local.name_prefix}-application-sg" })
}

