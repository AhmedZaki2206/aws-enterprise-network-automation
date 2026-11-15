#!/usr/bin/env python3
"""Credential-free structural checks for the Terraform network design."""

from __future__ import annotations

import ipaddress
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODULE = (ROOT / "modules" / "network" / "main.tf").read_text(encoding="utf-8")
TFVARS = (ROOT / "terraform.tfvars.example").read_text(encoding="utf-8")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)
    print(f"PASS: {message}")


def resource_block(kind: str, name: str) -> str:
    marker = f'resource "{kind}" "{name}"'
    start = MODULE.find(marker)
    require(start >= 0, f"resource {kind}.{name} exists")
    brace = MODULE.find("{", start)
    depth = 0
    for index in range(brace, len(MODULE)):
        if MODULE[index] == "{":
            depth += 1
        elif MODULE[index] == "}":
            depth -= 1
            if depth == 0:
                return MODULE[brace + 1 : index]
    raise AssertionError(f"Unterminated resource block: {kind}.{name}")


def main() -> int:
    cidrs = re.findall(r'"(10\.20\.\d+\.\d+/\d+)"', TFVARS)
    networks = [ipaddress.ip_network(cidr) for cidr in cidrs]
    vpc = ipaddress.ip_network("10.20.0.0/16")

    require(len(networks) == 5, "example defines one VPC and four subnet CIDRs")
    subnets = [network for network in networks if network.prefixlen == 24]
    require(len(subnets) == 4, "example defines exactly four /24 subnets")
    require(all(subnet.subnet_of(vpc) for subnet in subnets), "all subnets are inside the VPC CIDR")
    require(
        all(not left.overlaps(right) for i, left in enumerate(subnets) for right in subnets[i + 1 :]),
        "subnet CIDRs do not overlap",
    )

    public_route = resource_block("aws_route", "public_internet")
    require('destination_cidr_block = "0.0.0.0/0"' in public_route, "public default route exists")
    require("gateway_id             = aws_internet_gateway.this.id" in public_route, "public default route targets the IGW")

    private_tables = resource_block("aws_route_table", "private")
    require('0.0.0.0/0' not in private_tables, "private route tables contain no default route")
    require("gateway_id" not in private_tables, "private route tables contain no direct IGW route")

    private_subnet = resource_block("aws_subnet", "private")
    require("map_public_ip_on_launch = false" in private_subnet, "private subnets disable public IPv4 auto-assignment")

    security_group = resource_block("aws_security_group", "application")
    require('from_port   = 22' not in security_group, "example security group exposes no SSH")
    require('from_port   = 3389' not in security_group, "example security group exposes no RDP")
    require('cidr_blocks = ["0.0.0.0/0"]' not in security_group, "example security group has no world-open rule")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)

