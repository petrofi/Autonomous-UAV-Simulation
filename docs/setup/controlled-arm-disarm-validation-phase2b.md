# Phase 2B Controlled Arm and Disarm Validation

Status: Passed — normal simulation arm and disarm verified without takeoff or
flight

## Date and Environment

- Validation date: 2026-07-18
- Environment: Ubuntu 24.04.3 LTS on WSL2
- Development target: simulation only
- Vehicle: PX4 SITL X500, airframe 4001
- World and model: Gazebo default world with `x500_0`
- QGroundControl rendering: normal WSLg path

## Test Objective

Verify one bounded normal arm and disarm cycle while the simulated X500 remains
landed. Observe the PX4 and QGroundControl arming states, expected multicopter
idle output, ground contact, position, attitude, flight mode, and failsafe state.
Return all applied outputs to zero and shut down every test process cleanly.

This validation did not attempt takeoff or prove any flight capability.

## Simulation-Only Safety Scope

The test used no real flight controller or other flight hardware. It was an
explicitly authorized operator-controlled PX4 SITL test, not an autonomy command
path. Only one normal `commander arm` request and normal `commander disarm`
requests were sent.

No forced arm, disabled check, parameter change, throttle, takeoff, altitude,
movement, mode-change, mission, waypoint, manual-control, raw-actuator, motor
test, or actuator test command was used. No safety check or safety-supervisor
boundary was bypassed.

## Verified Components

| Component | Verified version or revision |
| --- | --- |
| PX4 SITL | v1.17.0 |
| PX4 commit | `d6f12ad1c4f70ad3230afd7d86e971421e02fef4` |
| Gazebo | Harmonic with Gazebo Sim 8.14.0 |
| QGroundControl stable | v5.0.8 |

The project repository was clean at
`ff3df4cd4c8cf8648420ee25c83a64ca8b1a1aef`. The external PX4 checkout was
clean at the exact `v1.17.0` tag, and all required submodules were initialized.
The existing extracted QGroundControl installation was used without download,
reinstallation, or copying a binary into the project.

## Pre-Arm Health

PX4 SITL and the Gazebo server started successfully with:

```bash
HEADLESS=1 make px4_sitl gz_x500
```

The default world and `x500_0` spawned, airframe 4001 was active, simulated
IMU data was live, and GPS reported a 3D fix with 10 satellites and 0.7 HDOP.
QGroundControl connected to the single system/component `1/1`, updated its
parameter cache, and PX4 reported `gcs_connection_lost=False`.

Immediately before arm:

- `pre_flight_checks_pass=True`
- Arming state: disarmed
- Navigation state: Hold
- Failsafe: false
- `actuator_armed=False` and `ready_to_arm=True`
- Local position: `x=-0.04679`, `y=-0.03292`, `z=-0.01811` m
- Ground contact, landed, and at-rest states: true
- Final actuator outputs: all zero
- Gazebo motor-speed commands: four zeros
- Gazebo model pose: approximately `(0, 0, -0.013)` m with zero roll,
  pitch, and yaw

The initial transient `ekf2 missing data` and no-GCS warnings cleared before
arm. No fatal runtime error or active pre-arm rejection remained.

## Safety Timeout

An independent watchdog was confirmed ready before arm. It watched a
simulation-specific trigger under `/tmp` and wrote the normal
`commander disarm` request to the PX4 SITL command FIFO 4.500357 seconds after
the trigger.

The primary control flow requested normal disarm after 2.000555 seconds, so the
watchdog request was a redundant safe-state confirmation. The watchdog then
terminated successfully. No forced disarm was used.

## Arm and Armed-State Result

One normal command was sent:

```text
commander arm
```

PX4 accepted it and reported `Armed by internal command`, arming state 2, and
`actuator_armed=True`. Hold remained the navigation mode and failsafe remained
false.

QGroundControl's received MAVLink HEARTBEAT stream changed from disarmed to
armed at timestamp `1784381747.607`, contained two armed heartbeats, and
returned to disarmed at `1784381749.744`. QGroundControl remained connected
throughout the interval.

The primary arm-request-to-disarm-request interval was 2.000555 seconds. PX4
state timestamps also showed an armed interval of approximately 2.0 seconds,
while the QGroundControl heartbeat window was approximately 2.137 seconds.

## Applied Output and Motor-Speed Result

Both armed PX4 samples showed the first four final `actuator_outputs` values
as:

```text
[151, 151, 151, 151]
```

The other output slots remained zero. This was symmetric simulation-only idle
behavior, not throttle or a takeoff command.

The bounded Gazebo motor window contained 1374 messages and 5496 values:

- 940 messages: `(0, 0, 0, 0)`
- 429 messages: `(151, 151, 151, 151)`
- 5 messages: `(151, 151, 151, 150)`
- Maximum applied value: `151`
- Maximum observed channel difference: `1`

The five one-count differences were within the observed idle tolerance. No
large, saturated, or meaningfully asymmetric command appeared.

## Ground Position, Altitude, and Attitude

Two armed local-position samples were:

- `(-0.04674, -0.02890, -0.00950)` m
- `(-0.03917, -0.02385, -0.00184)` m

The largest sampled horizontal change from the immediate pre-arm value was
approximately 0.012 m. Local NED `z` increased by about 0.016 m rather than
decreasing, so the samples did not indicate an altitude increase. Ground
contact, landed, and at-rest remained true in every armed sample.

Roll and pitch remained approximately zero and yaw remained approximately 96
degrees. After the observation period, the Gazebo model pose was again
approximately `(0, 0, -0.013)` m with zero roll, pitch, and yaw, matching the
pre-arm ground-truth pose.

## Normal Disarm and Post-Disarm Observation

The primary flow sent:

```text
commander disarm
```

PX4 reported `Disarmed by internal command`. QGroundControl received the
disarmed heartbeat transition, `actuator_armed` returned to false, all final
actuator outputs returned to zero, and the next Gazebo motor-speed sample
contained four zeros.

At the immediate post-disarm sample, local position was
`(-0.03021, -0.02652, -0.00917)` m. After at least 20 seconds it was
`(-0.01471, -0.01890, -0.01886)` m. The approximately 0.035 m local-estimator
offset from the immediate pre-arm value was not accompanied by Gazebo
ground-truth movement. The model remained landed and at rest, Hold remained
active, and failsafe remained false.

## State Comparison

| Measurement | Before arm | Armed interval | After disarm |
| --- | --- | --- | --- |
| Arming state | Disarmed | Armed | Disarmed |
| QGroundControl state | Disarmed heartbeat | Two armed heartbeats | Disarmed heartbeat |
| `actuator_armed` | False | True | False |
| Final motor outputs | Four zeros | Four equal values of 151 | Four zeros |
| Gazebo motor commands | Four zeros | 150–151 idle range; maximum channel difference 1 | Four zeros |
| Local position | `(-0.04679, -0.03292, -0.01811)` m | Two samples within about 0.012 m horizontally | `(-0.01471, -0.01890, -0.01886)` m after 20 seconds |
| Altitude change | Baseline | No increase; landed true | No increase; landed true |
| Flight mode | Hold | Hold | Hold |
| Failsafe | False | False | False |

## Graceful Shutdown

QGroundControl received SIGTERM because no window-close helper was installed;
it logged `Exiting main` and terminated. The PX4/Gazebo process group then
received SIGINT and terminated. The PX4, Gazebo, QGroundControl, and test-helper
processes were absent afterward, and the MAVLink UDP ports were closed.

SIGKILL was not used. The temporary runtime files existed only under `/tmp`
and were cleared when WSL stopped; no runtime artifact entered the project
repository. The project and external PX4 working trees remained clean after the
runtime.

## Warning Classification

### Expected or Non-Blocking

- Gazebo reported the known SDF `gz_frame_id` extension warnings.
- PX4 reported the unavailable simulated LED device.
- Initial EKF2 and GCS pre-flight warnings cleared before arm.
- QGroundControl reported EGL/Zink fallback messages and an unavailable
  `speechd` text-to-speech plug-in but opened, connected, and exited normally.
- QGroundControl emitted camera-control null-property warnings while closing
  without an attached camera.

### Investigation Recommended

- Intermittent Gazebo publish interruptions and duplicate PX4 IMU timestamp
  errors occurred during earlier diagnostic activity. They were not present in
  the bounded arm interval and did not activate a failsafe or break the bridge,
  but should be monitored in later runs.
- A malformed read-only process-filter command briefly launched a separate,
  empty `gz sim` GUI process. It was identified and stopped with SIGTERM well
  before arm. The intended headless PX4/Gazebo session remained separate and
  healthy, but future diagnostics should continue using direct process queries.

### Blocking

No blocking warning, pre-arm rejection, forced-arm attempt, unexpected command,
actuator saturation, excessive asymmetry, altitude increase, ground-contact
loss, telemetry loss, bridge failure, or crash occurred.

## Command Boundary Confirmation

No takeoff or throttle command was sent. No safety check was bypassed or
weakened. No parameter was altered. No second arm attempt was made.

## Remaining Unverified Capabilities

The following remain explicitly unverified:

- Takeoff
- Hover
- Landing
- Manual flight
- Mission execution
- Autonomous navigation
- Emergency stop
- Communication-loss recovery
- MAVLink signing
- ROS 2
- MAVSDK
- Real hardware

## Exact Next Step

Phase 2 remains in progress. The exact next checkpoint is Phase 2C: prepare a
separately reviewed, safety-gated controlled takeoff, hover, and landing
validation plan for simulation, including explicit abort criteria and the
mandatory approved command path. No Phase 2C flight capability is verified by
this report.
