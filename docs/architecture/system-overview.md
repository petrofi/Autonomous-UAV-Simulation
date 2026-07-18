# Conceptual System Overview

Status: The headless and GUI simulation foundation and QGroundControl telemetry
runtime are verified without flight; autonomy architecture components remain
conceptual and unimplemented.

## Verified Simulation Foundation

Phase 1B and Phase 1C verified the lowest layer of the planned stack in headless
and WSLg GUI modes:

- PX4 SITL v1.17.0
- Gazebo Harmonic server with Gazebo Sim 8.14.0
- PX4-Gazebo bridge sensor and actuator-topic connectivity
- Gazebo X500 vehicle model using PX4 airframe 4001
- Default-world GUI rendering and X500 visibility through WSLg
- Gazebo camera orbit, dolly, and zoom interaction

Phase 2A additionally verified QGroundControl v5.0.8 as an external operator
telemetry runtime. It automatically detected one PX4 SITL vehicle over UDP,
received a MAVLink heartbeat and 1000 parameters, and displayed live position,
GPS, IMU, attitude, battery, and link data. The vehicle remained in Hold and
standby, with `actuator_armed` and failsafe both zero. Four final actuator-output
channels and the sampled PX4-Gazebo motor-speed commands remained zero.

The observed small non-zero internal `actuator_motors` values were controller
setpoints only; they were not present in final actuator outputs or applied
Gazebo motor-speed commands. The vehicle remained disarmed and on the ground.
These results do not verify manual vehicle control or the planned autonomy,
safety, security, ROS 2, MAVSDK, or project-owned telemetry components.

The planned system is a simulation-first, modular autonomy stack for civil
research, safe navigation, and authorized visual tracking. Its primary control
path is deliberately constrained:

```text
Simulation Sensors
        ↓
Perception
        ↓
Mission Manager / Guidance
        ↓
Safety Supervisor
        ↓
PX4 Flight Control
        ↓
Gazebo Vehicle Model
```

Perception turns simulated sensor data into observations and confidence
estimates; it cannot produce actuator or motor commands. Mission management
selects authorized objectives, while guidance converts approved objectives into
bounded motion requests. The safety supervisor is the mandatory validation
boundary for every critical motion request before PX4 flight control.

Telemetry and the Security Monitor are cross-cutting observers. They are planned
to observe all critical commands, approvals, rejections, state transitions,
failsafe activations, health changes, and security-relevant events without
becoming alternate command paths.

QGroundControl is currently a verified external telemetry observer only. Phase
2A did not use it to arm, change mode, upload a mission, modify a parameter, or
send an actuator or other flight command.

## Planned Operating Boundary

- Gazebo provides the simulated environment and vehicle model.
- PX4 SITL provides the planned flight-control behavior.
- ROS 2 provides planned modular communication and lifecycle integration.
- MAVSDK provides a planned mission-client boundary for authorized high-level interaction.
- Safety policies constrain altitude, speed, operating area, command freshness, and system health.

Concrete interfaces, ROS 2 topic names, quality-of-service profiles, and runtime
deployment choices will be defined only when implementation begins and can be
validated against the chosen dependency versions.
