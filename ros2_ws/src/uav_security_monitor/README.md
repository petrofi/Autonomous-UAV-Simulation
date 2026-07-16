# UAV Security Monitor

## Planned Responsibility

Observe command provenance, validation failures, component health, configuration
integrity, and other security-relevant anomalies in controlled simulation.

## Current Status

Status: Planned — no implementation yet.

This directory is not a ROS 2 package yet.

## Future Inputs

Command metadata, rejection events, component health, configuration state, and authentication signals.

## Future Outputs

Alerts, audit events, risk signals, and safe-response requests through defined safety interfaces.

## Dependencies

Threat model, event interfaces, identity design, telemetry, and verified ROS 2 security configuration.

## Explicit Non-Responsibilities

No offensive actions, exploit execution, covert flight commands, secret storage,
or bypass of the safety supervisor.
