# Development Environment

Status: Phase 2 in progress — the PX4 SITL and Gazebo Harmonic X500 simulation
foundation has passed headless and WSLg GUI runtime smoke tests, and the
QGroundControl telemetry runtime has been verified without flight.

## Verified Baseline

- Windows host with WSL2
- Ubuntu 24.04.3 LTS in the Linux ext4 filesystem
- Linux kernel 6.6.87.2-microsoft-standard-WSL2
- systemd and WSLg available
- NVIDIA GeForce RTX 4060 visible inside WSL
- PX4 v1.17.0 at commit d6f12ad1c4f70ad3230afd7d86e971421e02fef4
- PX4 source at /home/darklove/src/PX4-Autopilot
- Gazebo Harmonic with Gazebo Sim 8.14.0
- Python 3.12.3 and the PX4-supported build toolchain
- X500 model and PX4 airframe 4001 available
- QGroundControl stable v5.0.8, extracted at
  `/home/darklove/Applications/QGroundControl/5.0.8`
- QGroundControl rendering through the normal WSLg path

The centrally pinned versions are recorded in
[`../../toolchain/versions.yaml`](../../toolchain/versions.yaml). Do not silently
upgrade major dependencies.

## Runtime Verification

Phase 1B ran the following command from the external PX4 checkout:

```bash
HEADLESS=1 make px4_sitl gz_x500
```

The test built PX4 SITL, started the Gazebo server without the GUI, spawned
`x500_0`, established simulator bridge traffic, and confirmed zero motor
velocities while the vehicle remained disarmed and on the ground. The process
group was then stopped with SIGINT, and no PX4 or Gazebo process remained.

Phase 1C then ran the normal GUI target from the same external PX4 checkout:

```bash
make px4_sitl gz_x500
```

Gazebo Sim opened through WSLg without a software-rendering override. The
default world and X500 rendered, camera orbit, dolly, and zoom worked, live IMU
traffic remained available through the PX4-Gazebo bridge, and all four sampled
motor velocities remained zero. Bounded runs rendered stably, and the final run
was stopped with SIGINT without leaving a PX4, Gazebo, Make, or Ninja process.

Detailed records:

- [Phase 1 environment audit](environment-audit-phase1.md)
- [Phase 1A PX4 and Gazebo installation](px4-gazebo-installation-phase1a.md)
- [Phase 1B headless runtime smoke test](px4-gazebo-smoke-test-phase1b.md)
- [Phase 1C Gazebo GUI runtime smoke test](px4-gazebo-gui-smoke-test-phase1c.md)

Phase 2A started the same PX4 SITL v1.17.0 and Gazebo Harmonic X500 runtime,
then opened QGroundControl v5.0.8 through WSLg. QGroundControl automatically
detected one simulated vehicle over UDP, received a MAVLink heartbeat and 1000
parameters, and displayed live position, GPS, IMU, attitude, battery, and link
telemetry. The vehicle remained in Hold, standby, disarmed, and without a
failsafe. All sampled final actuator outputs and applied Gazebo motor-speed
commands remained zero. A 15-minute safety timer ended PX4 and Gazebo with
SIGINT, after which QGroundControl reported the expected communication loss.

Detailed record:

- [Phase 2A QGroundControl telemetry validation](qgroundcontrol-telemetry-validation-phase2a.md)

## Current Boundary

ROS 2, MAVSDK, Docker, and Gazebo Classic are not installed as project
dependencies. QGroundControl is an external operator runtime whose telemetry
connection has been verified; it is not a project-owned telemetry module. No
manual vehicle control, arming, takeoff, autonomous flight, mission logic,
perception, or security feature has been implemented or verified.

The verified baseline establishes only that PX4 SITL, Gazebo Harmonic, the
PX4-Gazebo bridge, and the X500 vehicle model can start, exchange simulation
data, render through WSLg, support GUI camera navigation, and stop cleanly in the
approved WSL2 environment, and that QGroundControl can receive live MAVLink
telemetry while the vehicle remains disarmed. It does not establish controlled
flight, production, or real-flight readiness.
