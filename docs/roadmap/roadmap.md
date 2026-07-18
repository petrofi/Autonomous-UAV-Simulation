# Development Roadmap

The roadmap is sequential and evidence-driven. Phase 1 is complete after the
verified headless and WSLg GUI PX4 SITL and Gazebo Harmonic X500 smoke tests.
Phase 2 is in progress after the Phase 2A QGroundControl telemetry validation.

| Phase | Scope | Status |
| --- | --- | --- |
| Phase 0 | Repository and architecture scaffolding | Complete |
| Phase 1 | Environment plus headless and GUI PX4 SITL/Gazebo X500 smoke tests | Complete — runtime verified |
| Phase 2 | Operator telemetry and manual vehicle-control verification in simulation | In progress — Phase 2A telemetry runtime verified; vehicle control unverified |
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
motor outputs remained zero. The exact next checkpoint is Phase 2B: plan and
execute separately reviewed, safety-bounded manual vehicle-control validation
in simulation. No Phase 2B flight-control capability is verified yet.

Advancing a phase requires documented prerequisites, executed verification, known
limitations, and synchronized architecture and safety documentation. Simulation
results alone do not establish real-hardware readiness.
