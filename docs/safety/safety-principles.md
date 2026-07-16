# Safety Principles

Status: Planned principles — no safety behavior has been implemented or verified.

1. **Fail-safe over mission completion.** Preserve a safe state even when that means abandoning the mission.
2. **Explicit state transitions.** Represent normal, degraded, lost-link, target-loss, low-battery, geofence, invalid-command, and failsafe states explicitly.
3. **Bounded altitude, speed, and operating area.** Reject requests outside configured and validated limits.
4. **Geofence enforcement.** Treat boundary approach and violation as explicit safety conditions.
5. **Return-to-home or safe landing on critical failure.** Select a validated response based on available navigation, vehicle, and environment state.
6. **Perception confidence thresholds.** Use confidence, freshness, and health thresholds before observations may influence guidance.
7. **Target-loss behaviour.** Stop tracking-dependent motion and transition to a defined safe behavior when an authorized target is lost.
8. **Human override in controlled testing.** Provide a clear, authorized override and abort path without creating an unvalidated bypass.
9. **Complete event logging.** Record commands, approvals, rejections, transitions, faults, and operator actions with consistent time context.
10. **Simulation verification before hardware use.** Validate nominal and failure scenarios in simulation before any later hardware phase.

The safety supervisor remains mandatory between autonomy and flight control. Its
absence, failure, or uncertainty must never produce pass-through behavior.
