# UAV Guidance

## Planned Responsibility

Convert authorized mission objectives and valid observations into bounded,
timestamped motion requests for safety-supervisor evaluation.

## Current Status

Status: Planned — no implementation yet.

This directory is not a ROS 2 package yet.

## Future Inputs

Mission objectives, validated vehicle state, navigation constraints, perception
observations, and cancellation or target-loss events.

## Future Outputs

Bounded motion requests to the safety supervisor and explicit guidance-health events.

## Dependencies

Future interfaces, mission management, vehicle state, and safety-policy contracts.

## Explicit Non-Responsibilities

No PX4, motor, or actuator commands; no self-approval; no geofence or safety-limit override.
