# Security Scan Exceptions

Checkov remains blocking in CI. Version 1 contains three resource-scoped suppressions with documented rationale; it does not use a global soft-fail setting.

| Check | Resource | Rationale | Production recommendation |
|---|---|---|---|
| `CKV_AWS_394` | Availability Zones data source | The portfolio requirement selects two available AZs dynamically and supports configurable regions. A zone-name or zone-ID allowlist would make the reusable module region-specific. | Pin stable AZ IDs per account/region through environment configuration and review changes to the mapping. |
| `CKV2_AWS_11` | VPC | Flow Logs require a billable destination and are explicitly planned rather than deployed in the no-cost v1 baseline. | Enable organization-standard Flow Logs with encrypted storage, retention, least-privilege delivery, monitoring, and cost controls. |
| `CKV2_AWS_5` | Example application security group | Version 1 intentionally creates no paid compute or endpoint resource to attach to the reusable example group. | Attach the group to an approved workload or remove it when integrating the module into a real architecture. |

The VPC default security group is not suppressed: Terraform manages it explicitly with no ingress or egress rules. Exceptions should be re-evaluated whenever scope, cost constraints, or deployment status changes.

