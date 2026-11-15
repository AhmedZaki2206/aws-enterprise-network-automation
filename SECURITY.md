# Security Policy

## Reporting

Please report suspected credential exposure or security defects privately to the repository owner. Do not open a public issue containing secrets, account identifiers, exploit details, or sensitive logs.

## Repository rules

- Never commit AWS access keys, session tokens, private keys, `.tfvars`, plans, or state.
- Use short-lived federated identities for any approved AWS operation.
- Review Terraform plans before deployment; CI is validation-only.
- Keep action and provider versions reviewed and current.
- Treat changes to routes, security groups, NACLs, IAM, and state backends as security-sensitive.

This portfolio repository is not a production system and provides no operational SLA.

