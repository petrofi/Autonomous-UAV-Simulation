# ADR 0003: Mandatory Safety Supervisor Boundary

## Status

Accepted

## Context

Mission logic, guidance, and perception can be incomplete, stale, compromised,
or incorrect. Allowing those components to command flight control directly would
create an unacceptable single-component path to unsafe motion.

## Decision

Place a mandatory safety supervisor between autonomy-generated motion requests
and PX4 flight control. Perception may produce observations only. Guidance may
produce bounded motion requests only. The safety supervisor validates state,
freshness, limits, geofence constraints, and applicable failsafe conditions
before any critical request can proceed toward flight control.

No example, test path, fallback, or degraded mode may bypass this boundary.

## Consequences

- The safety supervisor is a safety-critical component requiring focused review and tests.
- Interfaces must distinguish observations, requests, approvals, rejections, and safety events.
- Supervisor unavailability must cause a safe response rather than pass-through behavior.
- Added latency and integration complexity are accepted in exchange for a clear safety boundary.
