# Planned Module Boundaries

Status: Conceptual — the modules below have no implementation yet.

## Mission Manager

- **Responsibility:** Maintain mission state, select authorized objectives, and coordinate explicit mission transitions.
- **Allowed inputs:** Operator mission requests, validated vehicle state, guidance status, and safety events.
- **Allowed outputs:** High-level objectives for guidance, mission-state events, and cancellation requests.
- **Forbidden responsibilities:** Direct actuator control, safety-policy override, raw perception interpretation, or silent failsafe suppression.
- **Safety relevance:** Must stop or transition safely when state is invalid, stale, or rejected.

## Perception

- **Responsibility:** Convert simulated sensor data into observations, classifications, tracks, and confidence estimates for authorized scenarios.
- **Allowed inputs:** Simulated camera or sensor data, calibration, and bounded perception configuration.
- **Allowed outputs:** Timestamped observations, confidence values, health status, and target-loss events.
- **Forbidden responsibilities:** Producing actuator, motor, PX4, or flight-control commands; selecting missions; bypassing guidance or safety supervision.
- **Safety relevance:** Unsafe or low-confidence output must be rejected or treated as unavailable; confidence and freshness must remain explicit.

## Guidance

- **Responsibility:** Convert authorized mission objectives and valid observations into bounded motion requests.
- **Allowed inputs:** Mission objectives, validated vehicle state, perception observations, navigation constraints, and cancellation events.
- **Allowed outputs:** Timestamped, bounded motion requests to the safety supervisor and guidance-health events.
- **Forbidden responsibilities:** Direct PX4 or actuator commands, relaxing safety limits, or authorizing its own requests.
- **Safety relevance:** Requests must be bounded, cancellable, fresh, and safe to reject.

## Safety Supervisor

- **Responsibility:** Validate critical motion requests and system state against safety policies and select defined failsafe responses.
- **Allowed inputs:** Guidance requests, vehicle state, battery status, geofence state, component health, command freshness, and security events.
- **Allowed outputs:** Approved bounded control requests toward the flight-control adapter, explicit rejections, failsafe requests, and safety events.
- **Forbidden responsibilities:** Mission goal selection, perception inference, silent policy bypass, or pass-through behavior while unavailable.
- **Safety relevance:** This is the mandatory safety boundary; no critical autonomy command may reach flight control without approval.

## PX4 Flight-Control Integration

- **Responsibility:** Adapt safety-approved requests to supported PX4 SITL interfaces and report vehicle state.
- **Allowed inputs:** Safety-supervisor-approved requests and explicitly authorized operator control for controlled tests.
- **Allowed outputs:** PX4 SITL commands, acknowledged state, health information, and flight-control events.
- **Forbidden responsibilities:** Accepting direct perception, mission-manager, or guidance commands; embedding hidden mission policy; vendoring PX4 source.
- **Safety relevance:** Must fail closed for invalid or unapproved autonomy requests and preserve PX4-native failsafes.

## Gazebo Simulation

- **Responsibility:** Provide controlled worlds, vehicle models, sensors, and repeatable scenario conditions.
- **Allowed inputs:** Versioned simulation configuration, approved control effects from PX4 SITL, and test scenario controls.
- **Allowed outputs:** Simulated sensor data, vehicle dynamics, environment state, and scenario events.
- **Forbidden responsibilities:** Representing simulation results as real-flight evidence or embedding production secrets and data.
- **Safety relevance:** Scenario fidelity and limitations affect the validity of safety claims.

## MAVSDK Mission Client

- **Responsibility:** Provide a future authorized, high-level client for mission requests and observability.
- **Allowed inputs:** User-authorized mission definitions, vehicle state, telemetry, and command acknowledgements.
- **Allowed outputs:** Validated high-level requests through the defined mission boundary and operator-visible status.
- **Forbidden responsibilities:** Direct actuator commands, safety-supervisor bypass, or storage of embedded credentials.
- **Safety relevance:** Requests require authentication, validation, freshness checks, and explicit rejection handling.

## Security Monitor

- **Responsibility:** Observe command provenance, validation failures, component health, and security-relevant anomalies.
- **Allowed inputs:** Security events, command metadata, configuration integrity status, and component health signals.
- **Allowed outputs:** Alerts, audit events, risk signals, and requests for a safe system response through defined interfaces.
- **Forbidden responsibilities:** Covert command paths, offensive actions, or unilateral unsafe flight behavior.
- **Safety relevance:** Security anomalies can trigger conservative safety handling but cannot bypass the safety supervisor.

## Telemetry

- **Responsibility:** Record and expose time-correlated vehicle, mission, safety, and security events.
- **Allowed inputs:** Read-only state and event streams from all critical modules.
- **Allowed outputs:** Structured logs, metrics, and authorized operator views.
- **Forbidden responsibilities:** Modifying control state, issuing flight commands, storing secrets, or silently dropping critical events.
- **Safety relevance:** Complete and trustworthy event history supports diagnosis, validation, and incident review.
