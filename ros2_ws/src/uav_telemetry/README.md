# UAV Telemetry

## Planned Responsibility

Provide time-correlated, read-only observability for mission, vehicle, guidance,
safety, security, and simulation events.

## Current Status

Status: Planned — no implementation yet.

This directory is not a ROS 2 package yet.

## Future Inputs

Structured state and event streams from all critical modules.

## Future Outputs

Authorized operator views, metrics, and local structured logs for validation and diagnosis.

## Dependencies

Future event schemas, time-source decisions, retention policy, and secure transport design.

## Explicit Non-Responsibilities

No command or control path, flight-state modification, secret collection, silent
critical-event dropping, or committed generated telemetry.
