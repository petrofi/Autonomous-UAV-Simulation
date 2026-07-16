# Conceptual System Overview

Status: The headless and GUI simulation foundation is verified; autonomy
architecture components remain conceptual and unimplemented.

## Verified Simulation Foundation

Phase 1B and Phase 1C verified the lowest layer of the planned stack in headless
and WSLg GUI modes:

- PX4 SITL v1.17.0
- Gazebo Harmonic server with Gazebo Sim 8.14.0
- PX4-Gazebo bridge sensor and actuator-topic connectivity
- Gazebo X500 vehicle model using PX4 airframe 4001
- Default-world GUI rendering and X500 visibility through WSLg
- Gazebo camera orbit, dolly, and zoom interaction

The vehicle remained disarmed and on the ground, with four sampled motor
channels at zero. This result does not verify manual vehicle control or the
planned autonomy, safety, security, telemetry, ROS 2, or MAVSDK components.

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

## Planned Operating Boundary

- Gazebo provides the simulated environment and vehicle model.
- PX4 SITL provides the planned flight-control behavior.
- ROS 2 provides planned modular communication and lifecycle integration.
- MAVSDK provides a planned mission-client boundary for authorized high-level interaction.
- Safety policies constrain altitude, speed, operating area, command freshness, and system health.

Concrete interfaces, ROS 2 topic names, quality-of-service profiles, and runtime
deployment choices will be defined only when implementation begins and can be
validated against the chosen dependency versions.
