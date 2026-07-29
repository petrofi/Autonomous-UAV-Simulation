# Autonomous UAV Simulation

**Current status:** Phase 2 in progress — bounded vertical flight and external MAVSDK telemetry integration verified; MAVSDK control and horizontal flight remain unverified

## Project Overview

Autonomous UAV Simulation is a long-term, simulation-first research project for
safe autonomous navigation, civil simulation research, and authorized visual
marker and object tracking. The repository is designed around modular autonomy,
explicit safety supervision, observable system behavior, and security-oriented
command handling.

> The simulation, operator telemetry, and bounded vertical takeoff/hover/landing foundations are verified, but horizontal navigation, autonomous flight, perception, safety, and security features have not been implemented yet.

## Initial Objectives

- Autonomous takeoff and landing in simulation
- Waypoint navigation
- Return-to-home behaviour
- Telemetry and event logging
- Geofence and communication-loss failsafes
- Authorized visual marker and object tracking
- Security-oriented command validation

## Technology Stack

- Ubuntu 24.04 on WSL2
- PX4 SITL
- Gazebo Harmonic
- QGroundControl
- ROS 2 Jazzy
- MAVSDK
- Python, C++, and OpenCV

The tested PX4, Gazebo, QGroundControl, MAVSDK-Python, and Python versions are
pinned in [`toolchain/versions.yaml`](toolchain/versions.yaml). ROS 2 remains
uninstalled. MAVSDK-Python is installed only in an external virtual environment;
its read-only telemetry compatibility is verified, but its vehicle-control
capabilities are not.

## Architecture Principles

- Develop and verify in simulation before considering hardware.
- Separate mission management, perception, guidance, safety supervision,
  security monitoring, and telemetry.
- Prevent perception and AI components from issuing actuator commands.
- Route motion requests through guidance and a mandatory safety supervisor
  before flight control.
- Prefer fail-safe behavior, bounded operation, explicit state transitions,
  defence-in-depth, and resilient communication.
- Document safety-critical architectural decisions as ADRs.

## Repository Structure

| Path | Purpose |
| --- | --- |
| `autopilot/` | Planned PX4 integration assets maintained by this project |
| `config/` | Planned mission, safety, security, and simulation configuration |
| `docs/` | Architecture, ADRs, setup, safety, security, testing, and roadmap |
| `mission_client/` | Planned external mission client integration |
| `ros2_ws/src/` | Planned ROS 2 module boundaries; no packages yet |
| `simulation/` | Planned Gazebo worlds, models, scenarios, and launch assets |
| `tests/` | Planned unit, integration, simulation, and security validation |
| `toolchain/` | Central compatibility and version manifest |
| `tools/` | Planned offline analysis and dataset-support utilities |

## Development Phases

Phase 0 established repository and architecture scaffolding. Phase 1 verified the
Ubuntu 24.04 WSL2 environment and the headless and WSLg GUI PX4 SITL/Gazebo
Harmonic X500 runtime foundation. Phase 2A verified QGroundControl startup,
automatic MAVLink telemetry, live vehicle data, and zero applied actuator and
motor outputs while disarmed. Phase 2B then verified one normal simulation arm
and disarm cycle, expected symmetric idle motor output, and continued ground
contact without sending throttle, takeoff, movement, mission, or mode-change
commands. Phase 2C verified one normal simulation takeoff, a short stationary
hover at the configured target, normal landing, and automatic landed-state
disarm without horizontal navigation or QGroundControl control input. Phase 2
2D-A then verified an external MAVSDK-Python 3.17.2 telemetry-only connection
through the standard PX4 SITL UDP endpoint while the vehicle remained disarmed,
landed, and stationary. Phase 2 remains in progress, and MAVSDK control,
horizontal flight, autonomous mission behavior, and later capabilities remain
planned; see the [roadmap](docs/roadmap/roadmap.md).

## Safety and Security Position

This project prioritizes fail-safe behavior over mission completion. The planned
safety supervisor is a mandatory boundary between autonomy and flight control.
Security work is defensive and uses defence-in-depth and resilient communication
principles. The project makes no production or real-flight security guarantee.

## Current Limitations

- No horizontal-flight, mission, perception, tracking, or security-monitoring
  project code exists.
- PX4 SITL and Gazebo Harmonic are installed outside this repository; headless
  and WSLg GUI X500 runtime foundations and one bounded vertical flight have
  been verified in simulation.
- QGroundControl is installed outside this repository; automatic telemetry has
  been verified, including arm and flight-mode observation, but it sent no arm,
  takeoff, land, movement, mission, mode-change, or parameter command.
- No ROS 2 packages, MAVSDK vehicle-control integration, active CI workflows,
  or project-owned simulation launch assets are configured.
- MAVSDK-Python telemetry was verified from an isolated external virtual
  environment; Action, Offboard, GoTo, mission, and parameter APIs remain
  unverified and outside the current command path.
- Autonomous behavior has not been executed or verified.
- The repository is not ready for production or real-flight use.

## Documentation

- [System overview](docs/architecture/system-overview.md)
- [Module boundaries](docs/architecture/module-boundaries.md)
- [Data flow](docs/architecture/data-flow.md)
- [Safety principles](docs/safety/safety-principles.md)
- [Threat model](docs/security/threat-model.md)
- [Development environment](docs/setup/development-environment.md)
- [Phase 1B headless smoke test](docs/setup/px4-gazebo-smoke-test-phase1b.md)
- [Phase 1C Gazebo GUI smoke test](docs/setup/px4-gazebo-gui-smoke-test-phase1c.md)
- [Phase 2A QGroundControl telemetry validation](docs/setup/qgroundcontrol-telemetry-validation-phase2a.md)
- [Phase 2B controlled arm/disarm validation](docs/setup/controlled-arm-disarm-validation-phase2b.md)
- [Phase 2C controlled takeoff, hover, and landing validation](docs/setup/controlled-takeoff-hover-landing-validation-phase2c.md)
- [Phase 2D-A MAVSDK telemetry validation](docs/setup/mavsdk-telemetry-validation-phase2da.md)
- [Test strategy](docs/testing/test-strategy.md)
- [Contributing](CONTRIBUTING.md)
- [Security reporting](SECURITY.md)

## License Status

No license has been selected yet. No `LICENSE` file is included, and no rights
should be assumed beyond those provided by applicable law.
