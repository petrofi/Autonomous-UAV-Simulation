# UAV Perception

## Planned Responsibility

Convert authorized simulated sensor data into timestamped observations,
confidence estimates, tracks, and component-health status.

## Current Status

Status: Planned — no implementation yet.

This directory is not a ROS 2 package yet.

## Future Inputs

Simulated sensor data, calibration, bounded configuration, and authorized tracking objectives.

## Future Outputs

Observations, classifications, confidence values, track state, target-loss events,
and perception-health events.

## Dependencies

Verified ROS 2 and Gazebo sensor interfaces; later OpenCV and perception dependencies
selected through compatibility testing.

## Explicit Non-Responsibilities

Perception is forbidden from producing actuator, motor, PX4, or flight-control
commands. It cannot select missions, authorize motion, or bypass guidance and the
safety supervisor.
