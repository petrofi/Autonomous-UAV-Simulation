# UAV Safety Supervisor

## Planned Responsibility

Serve as the mandatory boundary that validates critical motion requests against
state, freshness, bounds, geofence, battery, health, and failsafe policy.

## Current Status

Status: Planned — no implementation yet.

This directory is not a ROS 2 package yet.

## Future Inputs

Guidance requests, vehicle state, operating limits, battery status, geofence
state, component health, command metadata, and security events.

## Future Outputs

Explicit approvals or rejections, bounded requests toward PX4 integration,
failsafe requests, and safety events.

## Dependencies

Accepted safety ADRs, validated policy configuration, explicit interfaces, and comprehensive tests.

## Explicit Non-Responsibilities

No mission selection, perception inference, silent policy changes, unavailable
pass-through mode, or unreviewed direct actuator behavior.
