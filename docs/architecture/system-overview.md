# Conceptual System Overview

Status: The headless and GUI simulation foundation and QGroundControl telemetry
runtime, controlled arm/disarm, and one bounded vertical takeoff/hover/landing
cycle are verified; horizontal flight and autonomy architecture components
remain
unimplemented.

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

Phase 2B verified one explicitly authorized operator-controlled test through the
PX4 SITL shell. A normal arm request was accepted, PX4 and QGroundControl
reported the armed state, and the four applied motor outputs showed symmetric
idle behavior. A normal disarm request followed after approximately two seconds,
and all applied outputs returned to zero. The vehicle remained landed, in Hold,
and without a failsafe. No autonomy path, takeoff, throttle, movement, mission,
mode-change, raw-actuator, or forced-arm command was used.

Phase 2C verified a separate explicitly authorized operator-controlled PX4 SITL
test. One normal arm request and one normal takeoff request were accepted. The
X500 ascended vertically to the existing 2.5 m target, held position for a
6.772-second stable interval, and then received one normal land request from the
independent flight watchdog. PX4 detected touchdown and disarmed automatically.
Failsafe remained inactive, local position and velocity remained valid, and
post-disarm final actuator outputs returned to zero. QGroundControl observed the
armed, Takeoff, Hold, Land, and disarmed transitions without becoming a command
path. No horizontal, manual-control, waypoint, mission, Return-to-Home,
raw-actuator, forced, or autonomy command was used.

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
2A, Phase 2B, and Phase 2C did not use it to arm, take off, land, change mode,
upload a mission, modify a parameter, or send an actuator or other flight
command. Phase 2C verified that it received the armed, Takeoff, Hold, Land, and
disarmed state transitions for exactly one PX4 vehicle.

## Planned Operating Boundary

- Gazebo provides the simulated environment and vehicle model.
- PX4 SITL provides the planned flight-control behavior.
- ROS 2 provides planned modular communication and lifecycle integration.
- MAVSDK provides a planned mission-client boundary for authorized high-level interaction.
- Safety policies constrain altitude, speed, operating area, command freshness, and system health.

Concrete interfaces, ROS 2 topic names, quality-of-service profiles, and runtime
deployment choices will be defined only when implementation begins and can be
validated against the chosen dependency versions.
