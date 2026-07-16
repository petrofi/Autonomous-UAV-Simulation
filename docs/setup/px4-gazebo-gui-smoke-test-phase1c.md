# Phase 1C PX4 and Gazebo GUI Smoke Test

Date: 2026-07-17

Outcome: PASS

Scope: Gazebo GUI runtime verification only. No manual vehicle control, arming,
takeoff, autonomous behavior, ROS 2, MAVSDK, QGroundControl, perception, or
security feature was exercised.

## Repository Context

Project repository:

```text
/home/darklove/projects/autonomous-uav-simulation
```

Project branch: `main`

Project baseline:

```text
8600419c4394af3efe71f4705a1dd2154538d85f
```

The project worktree was clean before and after the test.

PX4 repository:

```text
/home/darklove/src/PX4-Autopilot
```

PX4 version:

```text
v1.17.0
d6f12ad1c4f70ad3230afd7d86e971421e02fef4
```

The PX4 checkout remained outside the project repository and its tracked
worktree was clean after the test.

## Preflight Verification

- Ubuntu 24.04.3 LTS was running on WSL2.
- WSLg exposed `DISPLAY=:0`, `WAYLAND_DISPLAY=wayland-0`, and its X11 and
  Wayland sockets.
- The NVIDIA GeForce RTX 4060 remained visible inside WSL.
- Gazebo Sim reported version 8.14.0.
- `LIBGL_ALWAYS_SOFTWARE`, `MESA_LOADER_DRIVER_OVERRIDE`, and `GALLIUM_DRIVER`
  were not set.
- No pre-existing PX4, Gazebo, Make, or Ninja process was found.

No package was installed or upgraded during Phase 1C. No PX4 source, shell
configuration, or persistent PX4 parameter was changed.

## Test Launch

The normal GUI target was launched from the external PX4 checkout with bounded
timeouts equivalent to:

```bash
timeout --signal=INT --kill-after=30s 480s make px4_sitl gz_x500
```

A shorter confirmation run used the same target with a 300-second bound. The
successful runs did not set a headless flag or a software-rendering override.
Runtime output from the primary bounded run was directed to
`/tmp/phase1c-runtime.log`, outside the project repository.

### WSLg Recovery Observation

The first GUI attempt encountered a transient WSLg transport failure after the
X11 and Wayland sockets disappeared. Gazebo and Qt dependencies were present,
and no missing library was identified. A full WSL shutdown and restart restored
both sockets. The normal launch then succeeded without installing a package or
using a software-rendering override.

## GUI and Rendering Evidence

- Gazebo Sim opened as a WSLg GUI window and remained responsive.
- The `default` world rendered with `ground_plane` and `sunUTC` present.
- The Entity Tree contained `x500_0`.
- The X500 was visible in the viewport and rendered with model detail and
  ground shadows.
- Mouse-wheel zoom changed the camera distance.
- Right-drag dolly changed the camera distance.
- Left-drag orbit changed the camera from a front view to an oblique view.

The first successful GUI session rendered for approximately eight minutes. A
second confirmation session rendered for almost five minutes while selection,
zoom, dolly, and orbit interactions were exercised. No blank viewport, render
crash, or unresponsive Gazebo window was observed during the successful runs.

Only camera and entity-selection interactions were used. No model transform,
vehicle-control, arming, takeoff, or actuator input was sent.

## PX4 and Bridge Evidence

PX4 reported:

```text
INFO  [init] Gazebo simulator 8.14.0
INFO  [init] Starting gz gui
INFO  [init] Gazebo world is ready
INFO  [gz_bridge] world: default, model: x500_0
INFO  [px4] Startup script returned successfully
```

The X500 pose remained approximately `[0, 0, -0.013]`, consistent with the
vehicle resting on the ground.

The IMU topic had a Gazebo publisher and a PX4 bridge subscriber. A live
`gz.msgs.IMU` sample was observed for
`x500_0::base_link::imu_sensor`.

The motor-speed command topic used `gz.msgs.Actuators`, with a PX4-side
publisher and Gazebo subscribers. Its sampled message contained four zero
velocities:

```text
velocity: 0
velocity: 0
velocity: 0
velocity: 0
```

These observations confirm bridge traffic and the absence of rotor motion in
the sampled state. The vehicle was never armed and did not take off.

## Non-Blocking Warnings

- Gazebo reported `gz_frame_id` SDF extension warnings for sensor elements.
- PX4 initially reported missing EKF2 data and no GCS connection during
  preflight checks.
- PX4 could not open the SITL `/dev/led0` device.
- The non-interactive launcher reported an unusual terminal screen size.

None of these warnings prevented the world, model, bridge traffic, GUI
rendering, or camera interaction. No speculative fix was applied.

## Controlled Shutdown

The primary bounded run ended when its timeout sent SIGINT. For the final run,
SIGINT was sent directly to the bounded process group after evidence
collection. The resulting Make `Interrupt` and nonzero wrapper exit were the
expected effects of deliberate shutdown, not a simulation failure.

Post-shutdown inspection found no PX4, Gazebo, Make, or Ninja process. The
Gazebo GUI window closed, while the WSLg broker remained available without an
application window.

## Artifact and Repository Boundary

- No runtime log, PX4 build output, Gazebo runtime file, screenshot, binary, or
  dataset was added to the project repository.
- Temporary GUI output stayed under `/tmp`.
- PX4 build and flight-log output remained in the external PX4 checkout and was
  not staged or copied into the project repository.
- No commit or push was performed as part of the runtime test.

## Readiness Conclusion

The Phase 1 simulation foundation is complete. PX4 SITL v1.17.0, Gazebo
Harmonic, the PX4-Gazebo bridge, and the X500 model can start in headless or
normal WSLg GUI mode, exchange verified sensor and zero-motor data, render the
default world, support camera navigation, and stop cleanly in the approved
Ubuntu 24.04 WSL2 environment.

This conclusion does not establish manual vehicle control, arming, takeoff,
autonomous navigation, ROS 2, MAVSDK, QGroundControl, perception, safety or
security behavior, production use, or real-flight readiness.
