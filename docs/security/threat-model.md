# Initial Defensive Threat Model

Status: Conceptual — no security controls have been implemented or verified.

## Scope and Assets

This model covers the planned simulation environment, mission requests, ROS 2
communication, configuration, telemetry, and development supply chain. Assets
include command integrity, safety-policy integrity, mission state, simulation
evidence, credentials, configuration, and trustworthy event history.

## Trust Boundaries

- Operator or mission client to mission-management interfaces
- ROS 2 module-to-module communication
- Autonomy and guidance to the mandatory safety supervisor
- Safety-approved requests to PX4 SITL
- Development dependencies and upstream artifacts to the local environment
- Local data and logs to any external storage or reporting path

## Threats and Defensive Direction

| Threat | Potential impact | Initial defensive direction |
| --- | --- | --- |
| Unauthorized command injection | Unsafe or unintended mission changes | Authenticate sources, authorize operations, validate schema/state/bounds, and log rejection |
| Replay attempts | Re-execution of previously valid commands | Use freshness, unique identifiers, monotonic state, and duplicate detection |
| Compromised companion application | Malicious or invalid high-level requests | Apply least privilege and treat all requests as untrusted at safety boundaries |
| Misconfigured ROS 2 permissions | Excessive publish, subscribe, or service access | Define least-privilege policies and verify configuration in controlled tests |
| Exposed secrets | Unauthorized access or impersonation | Keep secrets out of Git, use managed local injection, rotation, and scanning |
| Telemetry spoofing | Incorrect operator decisions or corrupted evidence | Authenticate provenance where feasible, correlate sources, and flag inconsistencies |
| Communication loss | Stale control or loss of supervision | Use explicit timeouts, lost-link states, and validated failsafe behavior |
| Unsafe perception output | Motion based on incorrect or stale observations | Require confidence/freshness checks and route all motion through guidance and safety supervision |
| Dependency and supply-chain risks | Compromised builds or runtime behavior | Pin tested versions, verify sources and hashes where available, minimize dependencies, and review upgrades |
| Physical access risks | Configuration or system tampering | Treat host integrity as a separate boundary and plan controlled access and integrity checks for later hardware phases |

## Assumptions and Limitations

- Phase 0 contains documentation only; controls described here are planned.
- The current target is authorized local simulation, not an exposed production service.
- A compromised host can undermine application-layer controls and requires separate mitigation.
- No claim of complete security, real-flight readiness, or certification is made.

This document intentionally excludes attack code and actionable exploit
instructions. Future security testing must remain authorized, defensive, and
confined to controlled simulation environments.
