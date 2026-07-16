# PX4 Integration

## Planned Responsibility

Contain project-owned adapters, configuration guidance, and reviewed PX4 SITL
integration assets without copying the upstream PX4 source tree.

## Current Status

Status: Planned — no implementation yet.

## Future Inputs

Safety-approved motion requests, PX4-compatible configuration, and simulated
vehicle state requirements.

## Future Outputs

PX4 SITL integration configuration, acknowledged state, and flight-control events.

## Dependencies

PX4 SITL at the compatibility-tested ref recorded in `toolchain/versions.yaml`.

## Explicit Non-Responsibilities

No direct perception or guidance commands, upstream source vendoring, real-flight
arming, or safety-supervisor bypass.
