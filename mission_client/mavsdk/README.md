# MAVSDK Mission Client

## Planned Responsibility

Provide an authorized high-level client for simulated mission requests, status,
and operator-visible events.

## Current Status

Status: External telemetry runtime verified — no project-owned command
implementation yet.

MAVSDK-Python 3.17.2 is installed only in the isolated external virtual
environment `/home/darklove/.venvs/autonomous-uav-mavsdk`. Phase 2D-A verified
its embedded `mavsdk_server`, the standard PX4 SITL
`udpin://0.0.0.0:14540` endpoint, and read-only health, GPS, position, velocity,
attitude, battery, flight-mode, armed, and in-air telemetry.

The 125.000-second observation had no connection interruption or reconnect. PX4
remained disarmed, landed, at rest, and in Hold with zero applied actuator
output. The temporary probe did not access MAVSDK Action, Offboard, Mission,
MissionRaw, ManualControl, Calibration, Param, or Shell control APIs.

Detailed record:

- [Phase 2D-A MAVSDK telemetry validation](../../docs/setup/mavsdk-telemetry-validation-phase2da.md)

## Future Inputs

Validated mission definitions, authorized operator actions, telemetry, and acknowledgements.

## Future Outputs

High-level requests through the mission-management boundary and clear operator feedback.

## Dependencies

Compatibility-tested MAVSDK-Python 3.17.2 and PX4 SITL telemetry are available
externally. Command-validation interfaces remain undefined and unimplemented.

## Explicit Non-Responsibilities

No actuator commands, direct Offboard or Action control, autonomous safety
approval, embedded credentials, or real-flight control. Telemetry compatibility
does not authorize this planned client to bypass mission management, guidance,
or the safety supervisor.
