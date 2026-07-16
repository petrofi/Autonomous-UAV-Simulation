# Planned Failsafe Scenarios

Status: Planned test scenarios — none are implemented or verified.

| Scenario | Condition to model | Expected safe direction for later specification |
| --- | --- | --- |
| Lost ground-control connection | Command or heartbeat exceeds a validated timeout | Enter an explicit lost-link state and select validated hold, return-to-home, or safe-landing behavior |
| GPS degradation | Navigation quality falls below a defined threshold | Prevent navigation behavior that depends on invalid position and select a validated degraded response |
| Target loss | Tracking observation is missing, stale, or below confidence limits | Stop tracking-dependent motion and transition to a defined safe state |
| Low battery | Battery estimate crosses warning or critical thresholds | Reject mission continuation as appropriate and select return-to-home or safe landing |
| Geofence violation | Vehicle reaches or crosses a configured boundary | Reject outward motion and execute a validated containment response |
| Invalid command | Schema, authorization, state, bounds, or freshness validation fails | Reject the command, log the reason, and preserve the current safe state |
| Stale telemetry | Vehicle state is older than its accepted age | Stop relying on stale state and reject unsafe new requests |
| Perception timeout | Required perception output misses its deadline | Mark perception unavailable and stop perception-dependent motion |
| Safety supervisor unavailable | Supervisor health or communication is lost | Fail closed; do not pass autonomy requests to flight control |
| Mission manager crash | Mission state owner becomes unavailable | Prevent new mission motion and transition through a validated recovery or failsafe path |

Each scenario will later require deterministic setup, observable transitions,
acceptance criteria, safe reset behavior, and negative tests for boundary bypass.
