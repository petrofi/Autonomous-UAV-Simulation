# Test Strategy

Status: Planned — no executable tests or application behavior exist yet.

## Test Layers

- **Unit:** Validate pure policy, state-transition, bounds, freshness, and parsing behavior.
- **Integration:** Validate module contracts, rejection paths, lifecycle behavior, and timeouts.
- **Simulation:** Exercise nominal missions and deterministic failure scenarios in Gazebo with PX4 SITL.
- **Security:** Validate authorization, replay resistance, input rejection, configuration boundaries, and safe behavior under anomalies.

## Safety-Critical Expectations

- Every behavior change requires corresponding tests.
- Negative tests must prove perception, guidance, mission management, and security monitoring cannot bypass the safety supervisor.
- Communication loss, target loss, low battery, geofence violation, invalid commands, stale data, and component failures require distinct coverage.
- Tests must assert observable events and explicit state transitions, not only final position.
- Results must record toolchain versions, scenario configuration, and known simulation limitations.
- Generated logs, reports, datasets, screenshots, and binaries must not be committed.

## Evidence

Only executed checks may be reported as passing. Future CI will complement, not
replace, local simulation evidence and focused review of safety-sensitive changes.
