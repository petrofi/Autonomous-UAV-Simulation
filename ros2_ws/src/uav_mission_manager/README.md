# UAV Mission Manager

## Planned Responsibility

Maintain explicit mission state and coordinate authorized high-level objectives
without becoming a low-level control path.

## Current Status

Status: Planned — no implementation yet.

This directory is not a ROS 2 package yet.

## Future Inputs

Authorized mission requests, vehicle and guidance status, safety events, and operator cancellation.

## Future Outputs

High-level objectives for guidance, mission-state transitions, cancellations, and mission events.

## Dependencies

Future interfaces, command validation, guidance contracts, telemetry, and safety-event semantics.

## Explicit Non-Responsibilities

No actuator or PX4 commands, raw perception interpretation, safety approval, or silent failsafe suppression.
