# Development Environment

Status: Phase 1 verified — the minimum PX4 SITL and Gazebo Harmonic X500
simulation foundation is installed and has passed a headless runtime smoke test.

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

Detailed records:

- [Phase 1 environment audit](environment-audit-phase1.md)
- [Phase 1A PX4 and Gazebo installation](px4-gazebo-installation-phase1a.md)
- [Phase 1B headless runtime smoke test](px4-gazebo-smoke-test-phase1b.md)

## Current Boundary

ROS 2, MAVSDK, QGroundControl, Docker, and Gazebo Classic are not installed as
project dependencies. No GUI simulation, manual control, arming, takeoff,
autonomous flight, mission logic, perception, or security feature has been
implemented or verified.

The verified baseline establishes only that PX4 SITL, Gazebo Harmonic, the
PX4-Gazebo bridge, and the X500 vehicle model can start and exchange simulation
data in the approved WSL2 environment. It does not establish production or
real-flight readiness.
