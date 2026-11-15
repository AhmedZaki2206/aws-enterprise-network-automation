# Test Results

Execution date: 2026-11-16

Environment: local Windows workspace, Python 3.13.9

## Executed

`python scripts/static_network_tests.py`

- Result: **PASS**
- Assertions passed: **18**
- Coverage: expected CIDR count, four `/24` subnets, VPC containment, subnet non-overlap, public default route, Internet Gateway target, absence of private default/IGW routes, disabled public IPv4 auto-assignment, and absence of world-open SSH/RDP rules in the example security group.

## Not executed locally

The following tools were not installed in the local environment, so no local pass result is claimed:

- Terraform format, initialization, validation, and native tests
- TFLint
- Checkov

These checks are configured in `.github/workflows/terraform-ci.yml`. Their status remains pending until the repository is published and the workflow runs. Provider download and GitHub-hosted execution require network access.

No AWS credentials were used, no plan was applied, and no AWS resources were created.

