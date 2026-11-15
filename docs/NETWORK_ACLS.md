# Network ACL Strategy

Version 1 intentionally keeps the VPC's default Network ACL behavior. Security groups provide the primary stateful workload boundary, while route tables provide subnet-level reachability control.

Network ACLs are stateless: return traffic must be permitted explicitly, rule order matters, and ephemeral port ranges must be considered. An aggressively restricted NACL can create difficult-to-diagnose asymmetric failures without adding useful protection to this small demonstration. A production design should introduce custom NACLs only after documenting traffic flows, ephemeral port requirements, operational ownership, and logging/alerting procedures.

The default NACL allows inbound and outbound traffic. This does **not** make private subnets Internet-accessible: they have no default route to an Internet Gateway or NAT device, no public IPv4 auto-assignment, and the example security group has no public ingress.

Future hardening could add tier-specific NACLs as defense in depth, accompanied by automated reachability tests and VPC Flow Logs. That capability is planned, not implemented.

