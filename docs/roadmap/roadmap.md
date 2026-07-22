# Development Roadmap

The roadmap is sequential and evidence-driven. Phase 1 is complete after the
verified headless and WSLg GUI PX4 SITL and Gazebo Harmonic X500 smoke tests.
Phase 2 is in progress after the Phase 2A QGroundControl telemetry validation
and Phase 2B and Phase 2C controlled-flight checkpoints.

| Phase | Scope | Status |
| --- | --- | --- |
| Phase 0 | Repository and architecture scaffolding | Complete |
| Phase 1 | Environment plus headless and GUI PX4 SITL/Gazebo X500 smoke tests | Complete — runtime verified |
| Phase 2 | Operator telemetry and manual vehicle-control verification in simulation | In progress — telemetry, normal arm/disarm, and one bounded vertical takeoff/hover/landing verified; horizontal flight unverified |
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

Phase 2C verified one normal vertical takeoff to the configured 2.5 m target, a
6.772-second stationary hover, one watchdog-controlled normal landing, and
automatic landed-state disarm. Ground-truth horizontal displacement remained
below 0.059 m. No horizontal navigation or manual-control input was performed.

The exact next checkpoint is Phase 2D: prepare a separately reviewed,
safety-gated plan for a small bounded horizontal movement in simulation. No
Phase 2D or horizontal-flight capability is verified yet.

Advancing a phase requires documented prerequisites, executed verification, known
limitations, and synchronized architecture and safety documentation. Simulation
results alone do not establish real-hardware readiness.
