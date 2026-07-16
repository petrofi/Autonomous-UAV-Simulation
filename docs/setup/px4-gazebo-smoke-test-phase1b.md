# Phase 1B PX4 and Gazebo Headless Smoke Test

Date: 2026-07-16

Outcome: PASS

Scope: Runtime verification only. No GUI, arming, takeoff, autonomous behavior,
ROS 2, MAVSDK, perception, or security feature was exercised.

## Repository Context

Project repository:

```text
/home/darklove/projects/autonomous-uav-simulation
```

Project branch: `main`

Pre-test project status:

```text
?? docs/setup/environment-audit-phase1.md
?? docs/setup/px4-gazebo-installation-phase1a.md
```

These two untracked documentation files were pre-existing Phase 1 work and were
preserved.

PX4 repository:

```text
/home/darklove/src/PX4-Autopilot
```

PX4 version:

```text
v1.17.0
d6f12ad1c4f70ad3230afd7d86e971421e02fef4
```

The PX4 source worktree was clean before and after the test.

## Preflight Verification

- Ubuntu distribution restart was confirmed by the new WSL uptime.
- Kernel: `6.6.87.2-microsoft-standard-WSL2`
- Gazebo Sim: `8.14.0`
- CMake: `3.28.3`
- Ninja: `1.11.1`
- No existing PX4, Gazebo, Make, or Ninja process was detected.

No package was installed or upgraded during Phase 1B.

## Test Command

The test was started from the PX4 repository with a bounded timeout:

```bash
timeout --signal=INT --kill-after=30s 420s \
  env HEADLESS=1 make px4_sitl gz_x500
```

The first configure and build completed successfully. Ninja built 1,098 targets
and produced:

```text
build/px4_sitl_default/bin/px4
```

The generated build output is ignored by the PX4 repository and did not modify
tracked PX4 source files.

## Runtime Evidence

### PX4 SITL

The running PX4 process used:

```text
PX4_SIM_MODEL=gz_x500
GZ_IP=127.0.0.1
```

### Gazebo Server and Headless Mode

Gazebo ran with the server-only option:

```text
gz sim --verbose=1 -r -s \
  /home/darklove/src/PX4-Autopilot/Tools/simulation/gz/worlds/default.sdf
```

No `gz-gui` process was present.

### X500 Model

`gz model --list` reported:

```text
ground_plane
x500_0
```

The sampled `x500_0` pose remained approximately at
`[0, 0, -0.013]`, consistent with the vehicle resting on the ground.

### PX4-Gazebo Bridge

Gazebo topics were present for the simulation clock, IMU, magnetometer,
barometer, NavSat, airspeed, optical flow, lidar, pose/state, servo commands, and
motor commands.

The IMU topic had a Gazebo publisher and a PX4 bridge subscriber, and a live IMU
message was sampled. The motor-speed command topic used
`gz.msgs.Actuators`, with one publisher and multiple subscribers.

The sampled motor command contained four zero velocities:

```text
velocity: 0
velocity: 0
velocity: 0
velocity: 0
```

This confirms that the smoke test did not arm the vehicle or command rotor
motion.

The `/model/x500_0/odometry_with_covariance` topic had a subscriber but no
publisher during the sample. This is recorded as a non-blocking observation; no
odometry-topic coverage is claimed by this test.

## Non-Blocking Warnings

- CMake emitted a developer warning about policy CMP0148.
- Java was unavailable, but it was not required for the selected SITL target.
- Gazebo reported `gz_frame_id` SDF extension warnings for sensor elements.
- PX4 reported a non-interactive screen-size warning.

None of these warnings prevented the build, model spawn, bridge traffic, or
headless runtime verification. No speculative fix was applied.

## Controlled Shutdown

After evidence collection, SIGINT was sent to the bounded test process group.
The resulting Make `Interrupt` and nonzero wrapper exit were the expected
consequence of this deliberate shutdown, not a runtime failure.

Post-shutdown checks found no PX4, Gazebo, Make, or Ninja process. The PX4
worktree remained clean.

## Readiness Conclusion

The Phase 1 simulation foundation is ready: PX4 SITL v1.17.0, Gazebo Harmonic,
the PX4-Gazebo bridge, and the X500 vehicle model can build, start, exchange
runtime data, and stop cleanly in headless mode on the verified Ubuntu 24.04
WSL2 environment.

This conclusion is limited to the Phase 1 runtime foundation. GUI operation,
manual control, arming, takeoff, autonomous flight, mission logic, ROS 2,
MAVSDK, perception, safety behavior, security behavior, production use, and
real-flight readiness remain unverified and out of scope.
