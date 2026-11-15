# Test Results

Execution date: 2026-11-16

Environment: local Windows workspace, Python 3.13.9

## Executed

`python scripts/static_network_tests.py`

- Result: **PASS**
- Assertions passed: **18**
- Coverage: expected CIDR count, four `/24` subnets, VPC containment, subnet non-overlap, public default route, Internet Gateway target, absence of private default/IGW routes, disabled public IPv4 auto-assignment, and absence of world-open SSH/RDP rules in the example security group.

`terraform -chdir=modules/network test -no-color` using the official HashiCorp Terraform 1.9.8 container image

- Result: **PASS**
- Native test runs passed: **1**
- Native test runs failed: **0**
- AWS provider behavior was mocked; no credentials or deployed resources were required.

`checkov -d . --framework terraform --compact` using Checkov 3.4.5

- Result: **PASS**
- Passed checks: **20**
- Failed checks: **0**
- Skipped checks: **3**, each resource-scoped and documented in `docs/SECURITY_EXCEPTIONS.md`

## Not executed locally

The following tool was not installed in the local environment, so no local pass result is claimed:

- TFLint

TFLint is configured in `.github/workflows/terraform-ci.yml` and has completed successfully for the pull request. The updated full GitHub Actions result remains pending.

No AWS credentials were used, no plan was applied, and no AWS resources were created.

