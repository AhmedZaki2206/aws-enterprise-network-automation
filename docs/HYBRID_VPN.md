# Future Hybrid VPN Architecture

This document describes a future extension and is not deployed by version 1.

```mermaid
flowchart LR
  onprem[Enterprise campus / data center] --> cpe[Redundant customer edge routers]
  cpe -->|Two IPsec tunnels per connection| vgw[AWS Virtual Private Gateway]
  vgw --> vpc[VPC 10.20.0.0/16]
  vpc --> private[Private application subnets]
  logs[VPC Flow Logs and CloudWatch] -. visibility .-> vpc
```

A portfolio extension could model redundant AWS Site-to-Site VPN connections, BGP routing, route propagation, on-premises prefix allowlists, tunnel monitoring, and failover validation. Larger multi-VPC estates should evaluate Transit Gateway. Direct Connect may be appropriate for predictable bandwidth and latency, with VPN as backup.

Before implementation, validate CIDR uniqueness across every site, BGP ASN ownership, encryption domains, MTU/MSS, DNS forwarding, asymmetric-routing risks, and responsibility for incident response. Site-to-Site VPN, Transit Gateway, Direct Connect, logging, and data transfer are billable services.

