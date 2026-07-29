# Phase 2D-A MAVSDK Telemetry Validation

Status: Passed — MAVSDK-Python installed in an isolated external virtual
environment and a bounded telemetry-only PX4 SITL connection verified

## Date and Environment

- Validation date: 2026-07-29
- Environment: Ubuntu 24.04.3 LTS on WSL2
- Platform architecture: x86_64
- Python: 3.12.3
- Development target: simulation only
- Vehicle: PX4 SITL X500, airframe 4001
- World and model: Gazebo default world with `x500_0`
- Project checkpoint:
  `0ca82fc3baa47e732d1269f413f71445722e8899`

## Test Objective

Verify that pinned MAVSDK-Python can be installed without modifying the system
Python environment and can observe one PX4 SITL vehicle through the standard
UDP endpoint. The validation covered discovery, health, GPS, global and local
position, velocity, attitude, battery, flight-mode, armed, and in-air telemetry.

This checkpoint was telemetry-only. It did not test or authorize MAVSDK Action,
Offboard, GoTo, mission, MissionRaw, ManualControl, Calibration, Param, Shell,
actuator, or other state-changing APIs.

## Simulation-Only Safety Scope

No real flight controller or other flight hardware was connected. QGroundControl
was not started. The temporary probe imported `System`, connected through the
Core API, and subscribed only to read-only Core and Telemetry streams.

No arm, takeoff, land, flight-mode, GoTo, Offboard, position, velocity,
attitude, manual-control, actuator, waypoint, mission, calibration, parameter,
or shell command was sent by the probe. No PX4 parameter or source file was
modified.

## Verified Components

| Component | Verified version or revision |
| --- | --- |
| MAVSDK-Python | 3.17.2 |
| Python | 3.12.3 |
| PX4 SITL | v1.17.0 |
| PX4 commit | `d6f12ad1c4f70ad3230afd7d86e971421e02fef4` |
| Gazebo | Harmonic with Gazebo Sim 8.14.0 |

The project repository and external PX4 checkout were clean before the test.
PX4 submodules were initialized. No external source checkout was modified.

## MAVSDK Package Installation

The target release was queried from the official PyPI JSON endpoint before
installation. Version 3.17.2 existed, required Python 3.7 or newer, and none of
its nine release files was yanked.

The selected x86_64 wheel was:

`mavsdk-3.17.2-py3-none-manylinux1_x86_64.manylinux2014_x86_64.manylinux_2_17_x86_64.manylinux_2_5_x86_64.whl`

Its PyPI SHA-256 was:

`78ac2402306022bb6000e1fa02dfe4af7a634c803d4ca90673b1c7918a23c937`

The package was installed from PyPI only into:

`/home/darklove/.venvs/autonomous-uav-mavsdk`

The environment used its own Python and pip paths. System Python remained at
`/usr/bin/python3`, had no importable `mavsdk` package, and was not modified.
The resolved isolated environment contained:

- `mavsdk==3.17.2`
- `grpcio==1.83.0`
- `protobuf==7.35.1`
- `typing_extensions==4.16.0`

## Embedded MAVSDK Server

The wheel supplied the embedded binary at:

`/home/darklove/.venvs/autonomous-uav-mavsdk/lib/python3.12/site-packages/mavsdk/bin/mavsdk_server`

- Binary size: 47,191,344 bytes
- SHA-256:
  `81f3a63f91695b844067b42afa5d994cc6e858b88b35cdfc5e069e9945221d7d`
- Runtime PID: 1320
- MAVSDK server system/component: 245/190
- Local gRPC listener: TCP 50051

The server reported MAVSDK v3.17.2, discovered PX4 system ID 1, started its gRPC
service, and was independently observed as the only `mavsdk_server` process.

## PX4 Pre-Connection State

One PX4 process and one Gazebo server were present. PX4 reported:

- Disarmed
- Hold navigation state
- Landed, ground contact, and at-rest states true
- Failsafe false
- Valid local XY, local Z, and velocity estimates
- GPS 3D fix with 10 satellites
- All 16 applied `actuator_outputs` values zero

The initial no-GCS and early EKF startup messages were expected before the
telemetry observer connected. After discovery, `commander check` returned
`Preflight check: OK`.

## Connection and Discovery

| Item | Result |
| --- | --- |
| Connection URL | `udpin://0.0.0.0:14540` |
| PX4 UDP endpoint | PX4 14580 to MAVSDK 14540 |
| gRPC endpoint | Local TCP 50051 |
| PX4 systems discovered | One intended SITL system, ID 1 |
| Time from probe start to discovery snapshot | 3.138 s |
| Manual MAVLink reconfiguration | None |

While connected, PX4 reported valid GCS heartbeat traffic from 245/190 with
zero received-message loss. The connection used only localhost.

## Initial Telemetry Snapshot

| Telemetry | Observed value |
| --- | --- |
| Health flags | Gyro, accelerometer, magnetometer, local position, global position, home position, and armable all true |
| `health_all_ok` | True |
| Armed | False |
| In air | False |
| Flight mode | Hold |
| GPS fix | 3D |
| Satellites | 10 |
| Latitude | 47.397970800° |
| Longitude | 8.546163900° |
| Absolute altitude | 0.233 m |
| Relative altitude | 0.015 m |
| Local NED position | `(0.0069, 0.0017, 0.0086)` m |
| NED velocity | `(-0.0107, 0.0060, -0.0013)` m/s |
| Roll / pitch / yaw | `0.0075° / 0.0079° / 95.9380°` |
| Battery voltage | 16.200 V |
| Battery remaining | 100.000% |

## Connection Stability and Stationary State

The bounded monitoring interval was 125.000 seconds. Total time from connection
start through the final telemetry summary was 128.139 seconds.

| Measurement | Result |
| --- | ---: |
| Connection interruptions | 0 |
| Reconnects | 0 |
| Collector errors | 0 |
| Safety violations | 0 |
| Maximum horizontal displacement from first local sample | 0.064685 m |
| Maximum horizontal speed | 0.029293 m/s |
| Maximum absolute vertical speed | 0.009900 m/s |
| Relative-altitude range | -0.032000 to 0.041000 m |
| Maximum absolute roll | 0.041633° |
| Maximum absolute pitch | 0.037600° |

The probe received 6,280 global-position samples, 3,767 local position/velocity
samples, 12,559 attitude samples, 3,806 GPS samples, 70 battery samples, 126
armed samples, 628 in-air samples, and 126 flight-mode samples. Connection
remained true, armed and in-air remained false, and flight mode remained Hold.
The small measured variation was stationary estimator and model jitter; no
vehicle movement was commanded or observed.

## Independent Vehicle-Safety Audit

PX4 shell observations were taken before, during, and after the MAVSDK probe.
During the connection, PX4 remained disarmed, landed, at rest, and in Hold.
Failsafe stayed false, Offboard control stayed disabled, and all sampled
applied actuator outputs were zero.

The 233.068-second ULog contained:

- Arming state only disarmed
- Navigation state only Hold
- Failsafe only false
- Landed, ground-contact, and at-rest states true throughout
- Offboard-control-enabled only false
- Armed time and takeoff time both zero
- 2,332 applied actuator-output samples, all zero
- No ULog dropout
- No probe-related state-changing vehicle command or acknowledgement

Two acknowledgements targeted MAVSDK system/component 245/190. Both were
accepted read-only `MAV_CMD_REQUEST_MESSAGE` requests. The independent
`commander check` produced one internal `MAV_CMD_RUN_PREARM_CHECKS`
acknowledgement to PX4 system/component 1/1.

PX4 also recorded one internal, non-external `MAV_CMD_DO_GRIPPER` event during
early simulator startup, about 69 seconds before MAVSDK discovery. The same
startup event was present in the earlier Phase 2C ULog, used a different source
from MAVSDK, and produced no applied actuator output. It was not generated by
the probe, but remains noted for later simulator-startup investigation.

The only changed parameters in the ULog were the three automatic simulator
barometer metadata values `CAL_BARO0_ID`, `CAL_BARO0_OFF`, and
`CAL_BARO0_PRIO` at startup. No parameter-set or parameter-save command was
issued by this test.

## Shutdown

The probe cancelled its read-only telemetry streams and sent SIGINT to its
embedded `mavsdk_server`. The server exited with signal return code -2.
Independent inspection then confirmed:

- No `mavsdk_server` process remained
- UDP 14540 was released
- TCP 50051 was released

PX4 and Gazebo were then stopped with one Ctrl+C/SIGINT. No PX4, Gazebo,
MAVSDK, or QGroundControl process and no relevant MAVLink or gRPC port remained.
SIGKILL was not used.

The temporary `make | tee` launcher returned 141 because the Ctrl+C terminal
shutdown also closed the logging pipeline and produced a SIGPIPE status. The
simulation processes were absent, the ULog was closed and parsed successfully,
and it contained no dropout. The wrapper exit status is a test-tooling issue,
not a vehicle-state, MAVSDK-connection, or cleanup failure.

## Warning Classification

### Expected or Non-Blocking

- Gazebo emitted the known SDF `gz_frame_id` extension warnings.
- PX4 reported the unavailable simulated LED device.
- Early EKF and no-GCS messages cleared after MAVSDK discovery.
- PX4 reported GCS loss after the telemetry observer shut down; the vehicle
  remained disarmed, landed, in Hold, and without a failsafe.
- The PyPI version query emitted pip's experimental-command notice.

### Investigation Recommended

- System pip reported an unrelated pre-existing invalid `pybind11` metadata
  entry while querying package versions. The isolated venv installation was
  unaffected.
- The recurring internal startup `MAV_CMD_DO_GRIPPER` event should be traced to
  its simulator component, although it predated MAVSDK, was not external, and
  produced no applied output.
- The temporary logging launcher should trap SIGINT separately from `tee` so a
  clean simulation shutdown is not represented as pipeline exit 141.

### Blocking

No MAVSDK installation failure, server startup failure, gRPC error, UDP bind
conflict, discovery timeout, reconnect, telemetry timeout, health-data failure,
protocol incompatibility, Python exception, bridge failure, external
state-changing command, arming, in-air transition, flight-mode transition,
Offboard activation, actuator activity, or residual process was found.

## Artifact Boundary

The virtual environment remains outside the repository at
`/home/darklove/.venvs/autonomous-uav-mavsdk`. The temporary probe, launchers,
installation log, telemetry log, PX4 console log, and ULog analysis log remained
under `/tmp` during active validation and were verified there before final
helper shutdown. When the last WSL keepalive helper terminated, WSL stopped and
cleared its volatile `/tmp`; the temporary files were not copied elsewhere.
PX4's generated ULog remained in the external PX4 checkout. No complete log,
telemetry dataset, virtual environment, package, server binary, PX4 build
output, Gazebo output, or generated binary entered the project repository.

## Remaining Unverified MAVSDK Capabilities

The following remain explicitly unverified:

- MAVSDK Action commands
- Offboard mode and setpoints
- GoTo
- Mission and MissionRaw
- ManualControl
- Calibration and parameter APIs
- Shell
- Actuator control
- Intentional horizontal movement
- Waypoint navigation
- Mission execution
- Return-to-Home
- Communication-loss recovery
- ROS 2 integration
- Real hardware

## Exact Next Step

Phase 2 remains in progress. The exact next checkpoint is Phase 2D-B: prepare a
separately reviewed, safety-gated plan for any first MAVSDK control validation
and one small bounded horizontal movement in simulation. The plan must define
the approved command path, safety-supervisor boundary, displacement, speed,
attitude, timeout, abort, return, landing, and watchdog criteria before any
state-changing MAVSDK method is authorized.
