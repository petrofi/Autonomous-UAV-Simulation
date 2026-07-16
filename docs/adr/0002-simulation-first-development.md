# ADR 0002: Simulation-First Development

## Status

Accepted

## Context

Autonomous flight behavior, perception, and failsafe logic can produce unsafe
outcomes when introduced directly on physical hardware. The initial toolchain
and all planned behaviors are still unverified.

## Decision

Develop and validate the system in simulation first. Introduce capabilities in
bounded phases, beginning with environment verification and smoke tests, then
progressing through simulated mission and failure scenarios. Hardware-in-the-loop
and real-hardware evaluation remain later, separate phases with additional
approval and safety controls.

## Consequences

- Planned behavior must have simulation evidence before hardware consideration.
- Simulation limitations and assumptions must be documented.
- Real-world performance cannot be inferred from simulation results alone.
- The repository must not imply current real-flight readiness.
