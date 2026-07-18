# Development Roadmap

The roadmap is sequential and evidence-driven. Phase 1 is complete after the
verified headless and WSLg GUI PX4 SITL and Gazebo Harmonic X500 smoke tests.
Phase 2 is in progress after the Phase 2A QGroundControl telemetry validation
and Phase 2B controlled arm/disarm validation.

| Phase | Scope | Status |
| --- | --- | --- |
| Phase 0 | Repository and architecture scaffolding | Complete |
| Phase 1 | Environment plus headless and GUI PX4 SITL/Gazebo X500 smoke tests | Complete — runtime verified |
| Phase 2 | Operator telemetry and manual vehicle-control verification in simulation | In progress — telemetry and normal arm/disarm verified; takeoff and flight unverified |
| Phase 3 | Autonomous takeoff, landing and waypoint mission | Planned — not started |
| Phase 4 | Return-to-home, geofence and failsafe scenarios | Planned — not started |
| Phase 5 | ROS 2 modular autonomy architecture | Planned — not started |
| Phase 6 | Authorized visual marker tracking | Planned — not started |
| Phase 7 | Moving object tracking in controlled simulation | Planned — not started |
| Phase 8 | Security hardening and adversarial simulation tests | Planned — not started |
| Phase 9 | Hardware-in-the-loop research | Planned — not started |
| Phase 10 | Controlled real-hardware evaluation | Planned — not started |

Phase 2A verified QGroundControl auto-connect and live MAVLink telemetry while
the simulated vehicle remained disarmed and all applied actuator and Gazebo
motor outputs remained zero. Phase 2B verified one normal arm/disarm cycle with
expected symmetric simulation-only idle output while the model remained landed.
No takeoff, throttle, movement, mission, or mode-change command was sent.

The exact next checkpoint is Phase 2C: prepare a separately reviewed,
safety-gated controlled takeoff, hover, and landing validation plan for
simulation. No Phase 2C flight capability is verified yet.

Advancing a phase requires documented prerequisites, executed verification, known
limitations, and synchronized architecture and safety documentation. Simulation
results alone do not establish real-hardware readiness.
