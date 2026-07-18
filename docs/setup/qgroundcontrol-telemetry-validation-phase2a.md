# Phase 2A QGroundControl Telemetry Validation

Status: Passed — QGroundControl telemetry runtime verified without flight

## Date and Environment

- Validation date: 2026-07-18
- Environment: Ubuntu 24.04.3 LTS on WSL2 with normal WSLg rendering
- Development target: simulation only
- PX4 checkout: `/home/darklove/src/PX4-Autopilot`
- QGroundControl installation:
  `/home/darklove/Applications/QGroundControl/5.0.8`

## Test Objective

Verify that QGroundControl can start through WSLg, automatically discover the
PX4 SITL vehicle, and display live MAVLink telemetry without sending a flight,
mission, parameter, or actuator command. Also verify that final actuator outputs
and Gazebo motor-speed commands remain zero while the vehicle is disarmed.

This report records the already verified results. The simulation and
QGroundControl test were not repeated while creating this checkpoint.

## Component Versions and Installation

| Component | Verified version or revision |
| --- | --- |
| QGroundControl stable | v5.0.8 |
| PX4 SITL | v1.17.0 |
| PX4 commit | `d6f12ad1c4f70ad3230afd7d86e971421e02fef4` |
| Gazebo | Harmonic with Gazebo Sim 8.14.0 |
| Gazebo world and model | Default world with `x500_0` |

QGroundControl used the extracted AppImage installation at the location above.
The AppImage SHA-256 was
`06969c67ef58ea063def0a8271447a1cc385438c4a7df36813315b4475146737`.
Extraction was used because `libfuse.so.2` was unavailable. No additional
system package was installed.

## Standalone GUI Result

QGroundControl opened successfully through the normal WSLg rendering path. No
software-rendering override was used.

PX4 SITL v1.17.0 and Gazebo Harmonic also started successfully. The default
Gazebo world and `x500_0` model were available.

## MAVLink Auto-Connect Result

QGroundControl automatically detected one simulated PX4 vehicle. The automatic
UDP telemetry path used:

- QGroundControl UDP port: `14550`
- PX4 UDP port: `18570`

The MAVLink heartbeat succeeded, and 1000 PX4 parameters were transferred into
the QGroundControl cache.

## Vehicle State and Live Telemetry

The observed simulated map position was approximately `47.397971, 8.546164`.
QGroundControl displayed:

- GPS data with 10 satellites and approximately 0.7 HDOP
- Live IMU and attitude data
- Battery data at approximately 16.2 V and 100 percent
- Live link telemetry

The flight mode remained Hold. The vehicle remained in standby and disarmed,
`actuator_armed` remained `0`, and failsafe remained `0` throughout the test.

## Applied Actuator-Output Verification

Four final `actuator_outputs` channels contained 5830 samples each. Every
applied output value in those channels was `0.0`.

Small non-zero values were present in internal `actuator_motors` control
setpoints. These were not propagated to final actuator outputs or applied
Gazebo motor commands.

The internal actuator_motors values were controller setpoints only. Final
actuator outputs and Gazebo motor-speed commands remained zero, and the
vehicle remained disarmed.

## Gazebo Motor-Command Verification

Twenty-five Gazebo bridge messages contained 100 motor-speed values. Every
applied Gazebo motor-speed command was zero.

Together, the final actuator-output and Gazebo bridge observations establish
that the internal controller setpoints were not applied to the simulated
motors. They do not establish any armed or flight capability.

## Stability and Controlled Shutdown

The telemetry connection remained stable until the controlled shutdown. A
15-minute safety timer stopped PX4 and Gazebo using SIGINT. SIGKILL was not
used.

After PX4 stopped, QGroundControl correctly displayed `Comms Lost`.
QGroundControl, PX4, Gazebo, and the MAVLink ports were clean after shutdown.

## Non-Blocking Warnings and Observations

- `libfuse.so.2` was unavailable, so the AppImage extraction method was used.
  This did not block QGroundControl startup, and no system package was added.
- The small non-zero internal `actuator_motors` setpoints did not reach final
  actuator outputs or Gazebo motor-speed commands.
- The `Comms Lost` indication occurred after the intentional PX4 shutdown and
  was the expected operator-visible result.

## Command and Change Boundary

No arming, takeoff, mode change, mission, waypoint, parameter modification, or
actuator command was sent.

ROS 2, MAVSDK, Docker, serial, USB, ModemManager, `dialout`, and real-hardware
configuration were not changed. Temporary screenshots and large ULog copies
were removed; none are part of this documentation checkpoint.

## Remaining Unverified Capabilities

The following remain explicitly unverified:

- Controlled arming
- Takeoff
- Landing
- Manual flight
- Autonomous navigation
- Mission upload
- MAVLink signing
- ROS 2
- MAVSDK
- Real hardware

This result also does not verify a project-owned telemetry module, production
readiness, or real-flight readiness.

## Exact Next Phase

Phase 2 remains in progress. The exact next checkpoint is Phase 2B: plan and
execute separately reviewed, safety-bounded manual vehicle-control validation
in simulation. Any critical motion request must follow the documented guidance
and mandatory safety-supervisor path. No Phase 2B capability is verified by
this report.
