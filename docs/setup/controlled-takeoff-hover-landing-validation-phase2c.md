# Phase 2C Controlled Takeoff, Hover, and Landing Validation

Status: Passed — one bounded simulation-only vertical takeoff, short stationary
hover, normal landing, and landed-state disarm verified

## Date and Environment

- Validation date: 2026-07-19
- Evidence review and documentation date: 2026-07-22
- Environment: Ubuntu 24.04.3 LTS on WSL2 with normal WSLg rendering
- Development target: simulation only
- Vehicle: PX4 SITL X500, airframe 4001
- World and model: Gazebo default world with `x500_0`
- PX4 checkout: `/home/darklove/src/PX4-Autopilot`
- QGroundControl installation:
  `/home/darklove/Applications/QGroundControl/5.0.8`

## Test Objective

Verify the first safety-gated simulation-only controlled flight: one normal arm,
one normal vertical takeoff to the existing PX4 target, a short stationary hover,
one normal landing, automatic landed-state disarm, zero final outputs, and clean
process shutdown.

This test did not attempt horizontal flight, manual-control input, waypoint
navigation, a mission, Return-to-Home, communication-loss recovery, or autonomy.

## Simulation-Only Safety Scope

No real flight controller or other flight hardware was connected. QGroundControl
was a read-only visual and telemetry observer. The operator-side control path
sent exactly one normal `commander arm` request and one normal
`commander takeoff` request. The independent flight watchdog sent the only
normal `commander land` request.

No forced arm or disarm, safety-check bypass, parameter-set command, throttle,
manual-control, joystick, Guided GoTo, horizontal movement, yaw, waypoint,
mission, Return-to-Home, raw-actuator, motor-test, actuator-test, or emergency
termination command was sent.

## Verified Components

| Component | Verified version or revision |
| --- | --- |
| PX4 SITL | v1.17.0 |
| PX4 commit | `d6f12ad1c4f70ad3230afd7d86e971421e02fef4` |
| Gazebo | Harmonic with Gazebo Sim 8.14.0 |
| QGroundControl stable | v5.0.8 |

The project repository was clean at
`68536e5daf4147a2e50223a3da0a86a15e8d381b`. The PX4 checkout was clean at
the exact tag and commit above, and its submodules were initialized. The
QGroundControl AppImage SHA-256 remained
`06969c67ef58ea063def0a8271447a1cc385438c4a7df36813315b4475146737`.
No external component was reinstalled, and no external source or binary artifact
was modified.

## Existing Flight Configuration

The following values were read before flight and confirmed again from the ULog
initial-parameter record:

| Parameter | Existing value | Meaning in this test |
| --- | ---: | --- |
| `MIS_TAKEOFF_ALT` | 2.5 m | Existing takeoff target |
| `MPC_TKO_SPEED` | 1.5 m/s | Existing maximum takeoff speed |
| `MPC_LAND_SPEED` | 0.7 m/s | Existing landing speed setting |
| `COM_DISARM_LAND` | 2.0 s | Existing landed auto-disarm delay |

No test-initiated parameter modification occurred. The ULog recorded three
automatic simulator-startup barometer calibration metadata updates at 4.272 s
(`CAL_BARO0_ID`, `CAL_BARO0_OFF`, and `CAL_BARO0_PRIO`), long before arm. No
takeoff, landing, safety, or flight-control parameter changed.

## Preflight Health

The graphical Gazebo client, PX4 SITL, bridge, default world, and `x500_0`
started successfully. QGroundControl connected automatically to one PX4 vehicle
at system/component `1/1`; the separate read-only telemetry monitor used
system/component `255/190` and was not another vehicle.

Immediately before arm:

- `commander check` returned `Preflight check: OK`.
- `pre_flight_checks_pass=True`.
- The vehicle was disarmed, landed, at rest, and in Hold (`AUTO_LOITER`).
- Failsafe and GCS-link-loss states were false.
- GPS reported a 3D fix with 10 satellites.
- Local XY, local Z, horizontal velocity, and vertical velocity were valid.
- Final actuator outputs were four zeros.
- Roll and pitch were approximately zero; yaw was approximately 95.9 degrees.
- The preflight local sample was approximately
  `(-0.0113, -0.0006, 0.0514)` m in local NED coordinates.

The initial no-GCS and EKF startup warnings cleared before arm. No active
preflight rejection, estimator fault, bridge loss, or fatal runtime error
remained.

## Acceptance Results

| Project criterion | Measured result | Outcome |
| --- | ---: | --- |
| Maximum total armed time: 30 s | 24.176 s | Passed |
| Intended stable hover: 6–10 s | 6.772 s | Passed |
| Hover altitude within 0.5 m of 2.5 m | Mean 2.359 m; range 2.001–2.493 m | Passed |
| Horizontal displacement no more than 0.75 m | Hover 0.037 m estimated; 0.046 m ground truth | Passed |
| Steady absolute vertical velocity no more than 0.30 m/s | Mean 0.071 m/s; maximum 0.239 m/s | Passed |
| Failsafe remains inactive | False throughout armed interval | Passed |
| Expected flight modes only | Hold → Takeoff → Hold → Land → Hold | Passed |
| Position estimate remains valid | XY, Z, and velocity valid throughout flight | Passed |
| Telemetry and bridge remain connected | No GCS loss, ULog dropout, or bridge failure | Passed |
| No collision, inversion, or unstable attitude | Maximum flight roll 0.693°, pitch 0.308° | Passed |
| Land close to takeoff point | Ground-truth final distance 0.027 m | Passed |

## Safety Watchdogs

Both independent safety mechanisms were ready before arm.

The flight watchdog was triggered by takeoff initiation and owned a 14-second
normal-land deadline, within the required 15-second maximum. The primary flow
targeted an eight-second hover, but the stable-hover condition began late enough
that the watchdog reached its deadline first. At 14.064 seconds after the
takeoff command, it acquired the single-land lock and sent one normal
`commander land` request. It did not send forced disarm.

The primary orchestration consequently returned
`safety path initiated landing during hover`. Offline ULog analysis established
that 6.772 seconds of stable hover had already completed, which is inside the
project's 6–10 second acceptance range, and that every other acceptance guardrail
passed. The run is therefore accepted as a watchdog-controlled success. Future
test orchestration should align the primary hover deadline with the independent
watchdog margin so the primary path can land first without weakening the
watchdog.

The total-runtime watchdog activated at 600 seconds, after automatic disarm and
25.30 seconds of post-disarm observation. It sent SIGINT to the PX4/Gazebo group
and SIGTERM to QGroundControl. It sent no flight or disarm command.

## Commands and Acknowledgements

The PX4 ULog recorded the following operator-requested control sequence:

| ULog time | Request | Acknowledgement |
| ---: | --- | --- |
| 351.932 s | Normal arm (`MAV_CMD_COMPONENT_ARM_DISARM`) | Accepted at 351.936 s |
| 354.752 s | Normal takeoff (`MAV_CMD_NAV_TAKEOFF`) | Accepted at 354.760 s |
| 368.816 s | Normal land (`MAV_CMD_NAV_LAND`) from watchdog | Accepted at 368.828 s |

PX4 generated an additional internal arm-state command and acceptance at
354.764–354.772 s as part of the accepted takeoff sequence. This was not a
second operator arm request or retry.

QGroundControl's received heartbeat stream confirmed the state sequence for the
single PX4 vehicle: disarmed Hold, armed Hold, armed Takeoff, armed Hold, armed
Land, and disarmed Hold. QGroundControl did not issue the arm, takeoff, land, or
mode commands.

## Takeoff and Ascent

PX4 reported `Using default takeoff altitude: 2.5 m` and `Takeoff detected`.
The landing detector changed `landed` to false 0.764 seconds after the takeoff
request and `ground_contact` to false after 0.948 seconds.

The takeoff state machine progressed from Disarmed through Spoolup,
Ready-for-takeoff, Rampup, and Flight. Navigation changed from Hold to
`AUTO_TAKEOFF`, then returned to Hold at the target. Peak estimated upward
velocity was 0.804 m/s, below the configured 1.5 m/s takeoff-speed limit. No
horizontal or yaw command was sent.

Maximum measured altitude above the takeoff baseline was 2.497 m; maximum
Gazebo/PX4 ground-truth altitude was 2.512 m. The 0.012 m ground-truth overshoot
was far below the 0.75 m abort threshold.

## Stable Hover

The stable interval began when estimated altitude was within 0.5 m of the
configured target and absolute vertical velocity remained at or below 0.30 m/s
for at least 0.8 seconds. It ended when the watchdog issued normal land.

- Duration: 6.772 s
- Mean estimated altitude: 2.359 m
- Estimated altitude range: 2.001–2.493 m
- Mean altitude error from the 2.5 m target: -0.141 m
- Mean absolute vertical velocity: 0.071 m/s
- Maximum absolute vertical velocity: 0.239 m/s
- Maximum horizontal speed: 0.037 m/s
- Maximum estimated horizontal displacement: 0.037 m
- Maximum ground-truth horizontal displacement: 0.046 m
- Maximum estimated roll magnitude: 0.370 degrees
- Maximum estimated pitch magnitude: 0.225 degrees
- Maximum ground-truth roll/pitch: 0.410/0.212 degrees
- Heading change: -0.097 degrees
- Navigation state: Hold (`AUTO_LOITER`)
- Failsafe: false

The four hover actuator-output means were 767.618, 767.691, 767.574, and
767.632. Maximum instantaneous channel spread was 3 counts. This was symmetric
closed-loop hover behavior without saturation or unexplained asymmetry.

## Landing and Disarm

PX4 accepted the normal land request and changed navigation to `AUTO_LAND`. Peak
estimated downward velocity before ground contact was 0.750 m/s. Ground contact
became true 4.592 seconds after the request, `maybe_landed` became true after
4.948 seconds, `landed` after 5.284 seconds, and `at_rest` after 5.420 seconds.
PX4 reported `Landing detected` and then `Disarmed by landing` 7.296 seconds
after the land request. No manual or forced disarm was needed.

Total airborne time from the first `landed=False` sample to `landed=True` was
18.584 seconds. Maximum horizontal displacement during the complete flight was
0.045 m estimated and 0.058 m ground truth. Final ground-truth distance from the
takeoff point was 0.027 m.

After automatic disarm, all four final `actuator_outputs` values were zero in
every retained ULog sample, and the live MAVLink observation also showed four
zero servo outputs. The disarmed state was observed for 25.30 seconds before the
runtime watchdog shut the simulation down. Ground truth showed the model landed
and stationary.

The temporary direct Gazebo motor-topic capture was cleared with `/tmp` when WSL
stopped during the interrupted evidence-review session, so its individual
post-disarm messages are not retained. The audited zero-output conclusion is
based on final PX4 actuator outputs, the live MAVLink zero-output sample, and the
landed stationary ground-truth state; no direct Gazebo motor-topic dataset is
claimed in this checkpoint.

## Measured State Comparison

Local Z and vertical velocity use the PX4 NED convention: more-negative Z is
higher, and positive vertical velocity is downward.

| Measurement | Preflight | Armed on ground | Ascent | Hover | Landed |
| --- | --- | --- | --- | --- | --- |
| Arming state | Disarmed | Armed | Armed | Armed | Disarmed |
| Navigation state | Hold | Hold | Takeoff | Hold | Hold |
| Relative altitude | 0.014 m | 0.004 m | 0.305 m | 2.406 m | -0.010 m |
| Local position | `(-0.011, -0.001, 0.051)` m | `(-0.021, 0.008, 0.062)` m | `(-0.036, 0.004, -0.239)` m | `(-0.012, 0.026, -2.340)` m | `(-0.045, 0.027, 0.076)` m |
| Horizontal speed | 0.011 m/s | 0.002 m/s | 0.060 m/s | 0.032 m/s | 0.009 m/s |
| Vertical speed | 0.003 m/s down | 0.001 m/s down | 0.679 m/s up | 0.048 m/s up | 0.002 m/s up |
| Roll/pitch | 0.018° / 0.003° | 0.031° / -0.015° | -0.101° / -0.099° | 0.022° / 0.087° | 0.028° / 0.003° |
| Landed state | True | True | False | False | True |
| Ground contact | True | True | False | False | True |
| Failsafe | False | False | False | False | False |
| Applied motor output | `0, 0, 0, 0` | `151, 151, 151, 151` | `797, 797, 798, 797` | `769, 769, 768, 768` | `0, 0, 0, 0` |

## Health and Safety Results

Throughout the armed interval:

- `vehicle_status.failsafe` remained false.
- GCS connection loss remained false.
- Local XY, local Z, horizontal velocity, and vertical velocity remained valid.
- Preflight checks remained passed.
- The failure detector remained clear.
- The ULog contained no dropout.
- No valid manual-control setpoint was present.
- No collision, inversion, estimator reset affecting validity, actuator
  saturation, or unexpected navigation transition occurred.

## Graceful Shutdown

The total-runtime watchdog acted only after the vehicle was landed, disarmed,
at rest, and observed for more than 20 seconds. PX4 and Gazebo received SIGINT;
PX4 closed the ULog, printed `PX4 Exiting`, and the build stopped as interrupted.
QGroundControl received SIGTERM. Its separate `Exiting main` line was not
captured before the controlling tool session ended, but the tlog closed and a
later process/port audit confirmed that QGroundControl, PX4, Gazebo, and MAVLink
ports were absent.

Because the primary orchestration returned at the watchdog landing event, it did
not write its later landed/shutdown marker. The already-activated land-watchdog
shell therefore remained waiting after the first shutdown audit; it sent no
further command and was removed when WSL stopped. The resumed audit confirmed
that no watchdog or other test process remained. This is a test-tooling cleanup
issue, not a vehicle-state or flight-safety failure.

SIGKILL was not used. No runtime log, ULog, tlog, CSV, screenshot, cache, binary,
or helper script entered the project repository.

## Warning Classification

### Expected or Non-Blocking

- Gazebo emitted the known SDF `gz_frame_id` extension warnings.
- PX4 reported the unavailable simulated LED device.
- Initial EKF and no-GCS warnings cleared before preflight approval.
- QGroundControl emitted EGL/Zink fallback and unavailable `speechd` warnings
  while continuing to render, connect, and record telemetry.
- The independent flight watchdog, rather than the primary flow, issued normal
  land at its conservative deadline; all flight acceptance criteria passed.

### Investigation Recommended

- PX4 logged `vehicle_command_ack lost` messages during initial QGroundControl
  message-interval negotiation, about 298 seconds before arm. Command ACKs for
  arm, takeoff, internal takeoff arming, and land were subsequently recorded as
  accepted.
- Duplicate IMU timestamp warnings appeared twice before arm, with the final
  occurrence approximately 5.9 seconds before the arm request. No duplicate
  warning, estimator invalidity, failsafe, or ULog dropout occurred in flight.
- Two unsupported `echo` commands used only as preflight log labels were rejected
  by the PX4 shell before arm and then removed from the flight helper. They made
  no state change and were not control requests.
- The primary hover target and independent watchdog deadline should be aligned
  in future test tooling so successful watchdog intervention is not reported as
  an orchestration error.
- The land-watchdog should also observe PX4's landed/disarmed state directly or
  receive its shutdown marker from a `finally` path so an orchestration exception
  cannot leave it waiting until the WSL session closes.
- QGroundControl's explicit application-level exit line and the temporary direct
  Gazebo motor-topic capture were not retained after the interrupted analysis;
  final process cleanup and the remaining independent evidence were verified.

### Blocking

No blocking preflight rejection, takeoff rejection, land rejection, safety
threshold violation, failsafe, estimator loss, bridge loss, collision, unstable
attitude, excessive drift, excessive altitude, incomplete landing, failure to
disarm, or final process residue occurred.

## Command and Change Boundary

Exactly one operator normal arm request and one operator normal takeoff request
were sent. Exactly one normal land request was sent by the independent watchdog.
No retry, forced command, horizontal command, manual-control input, joystick,
Guided action, waypoint, mission, Return-to-Home, raw-actuator command, motor
test, actuator test, or safety-check bypass was used.

No parameter-set or parameter-save command was sent. PX4 source, QGroundControl,
and the project dependency set were not modified.

## Remaining Unverified Capabilities

The following remain explicitly unverified:

- General manual flight
- Horizontal position control or translation
- Waypoint navigation
- Mission execution
- Autonomous navigation
- Return-to-Home
- Communication-loss recovery
- Emergency termination
- Geofence enforcement
- MAVLink signing
- ROS 2
- MAVSDK
- Real hardware

## Exact Next Step

Phase 2 remains in progress. The exact next checkpoint is Phase 2D: prepare a
separately reviewed, safety-gated validation plan for one small bounded
horizontal movement in simulation, with explicit position, speed, attitude,
abort, return, landing, and watchdog criteria. No horizontal-flight or Phase 2D
capability is verified by this report.
