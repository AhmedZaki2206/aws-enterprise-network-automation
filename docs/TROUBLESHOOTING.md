# Validation and Troubleshooting Runbook

## Static validation

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
(cd modules/network && terraform test)
tflint --recursive
checkov -d . --framework terraform
```

None of these commands should create AWS resources. Provider installation requires Internet access.

## After an approved real deployment

1. Confirm all four subnet CIDRs and Availability Zones in the VPC console or with `aws ec2 describe-subnets`.
2. Inspect route-table associations. Public subnets must use the table containing `0.0.0.0/0 -> igw-*`; private subnets must use their per-AZ tables with only the local VPC route.
3. Confirm `MapPublicIpOnLaunch` is false for every subnet.
4. Use VPC Reachability Analyzer for intended paths; it is billable, so review current pricing first.
5. Test from temporary, explicitly approved workloads. Do not add `0.0.0.0/0` SSH/RDP rules for convenience.

## Common failures

- **No credentials during `plan`:** validation and native tests are credential-free, but a real plan uses the AWS Availability Zones data source. Authenticate with an approved short-lived identity.
- **CIDR overlap:** select non-overlapping CIDRs contained in the VPC and re-run native tests.
- **Private host cannot reach the Internet:** expected in v1. There is no NAT Gateway and no private default route.
- **Public host has no Internet connectivity:** a public route alone is insufficient. The workload also needs an explicitly assigned public address, suitable security-group/NACL rules, and host firewall configuration.
- **Provider download fails:** verify proxy/DNS access and retry `terraform init`; do not commit the `.terraform` directory.

