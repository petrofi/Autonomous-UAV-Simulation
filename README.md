# Autonomous UAV Simulation

**Current status:** Phase 0 — Initial Scaffolding

## Project Overview

Autonomous UAV Simulation is a long-term, simulation-first research project for
safe autonomous navigation, civil simulation research, and authorized visual
marker and object tracking. The repository is designed around modular autonomy,
explicit safety supervision, observable system behavior, and security-oriented
command handling.

> The project currently contains architecture and repository scaffolding only. Autonomous flight, perception and security features have not been implemented yet.

## Initial Objectives

- Autonomous takeoff and landing in simulation
- Waypoint navigation
- Return-to-home behaviour
- Telemetry and event logging
- Geofence and communication-loss failsafes
- Authorized visual marker and object tracking
- Security-oriented command validation

## Planned Technology Stack

- Ubuntu 24.04 on WSL2
- PX4 SITL
- Gazebo Harmonic
- ROS 2 Jazzy
- MAVSDK
- Python, C++, and OpenCV

Exact compatible versions will be pinned in
[`toolchain/versions.yaml`](toolchain/versions.yaml) after an environment and
compatibility smoke test.

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

## Planned Development Phases

Phase 0 establishes repository and architecture scaffolding. Later phases plan
environment verification, PX4 SITL and Gazebo smoke tests, autonomous mission
behaviors, failsafe scenarios, ROS 2 modular autonomy, controlled visual
tracking, security hardening, hardware-in-the-loop research, and finally a
separate controlled real-hardware evaluation. Only Phase 0 is currently in
progress; see the [roadmap](docs/roadmap/roadmap.md) for the full sequence.

## Safety and Security Position

This project prioritizes fail-safe behavior over mission completion. The planned
safety supervisor is a mandatory boundary between autonomy and flight control.
Security work is defensive and uses defence-in-depth and resilient communication
principles. The project makes no production or real-flight security guarantee.

## Current Limitations

- No flight, mission, perception, tracking, security-monitoring, or PX4 connection code exists.
- No ROS 2 packages, active CI workflows, simulators, or system dependencies are configured.
- Planned behavior has not yet been executed or verified.
- The repository is not ready for production or real-flight use.

## Documentation

- [System overview](docs/architecture/system-overview.md)
- [Module boundaries](docs/architecture/module-boundaries.md)
- [Data flow](docs/architecture/data-flow.md)
- [Safety principles](docs/safety/safety-principles.md)
- [Threat model](docs/security/threat-model.md)
- [Development environment](docs/setup/development-environment.md)
- [Test strategy](docs/testing/test-strategy.md)
- [Contributing](CONTRIBUTING.md)
- [Security reporting](SECURITY.md)

## License Status

No license has been selected yet. No `LICENSE` file is included, and no rights
should be assumed beyond those provided by applicable law.
