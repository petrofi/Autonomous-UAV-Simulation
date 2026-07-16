# ADR 0001: Monorepo-Style Project Structure

## Status

Accepted

## Context

The planned system spans simulation assets, PX4 integration, ROS 2 modules,
mission clients, configuration, tests, and cross-cutting documentation. These
parts will evolve together and must preserve explicit safety and data-flow
boundaries.

## Decision

Use a monorepo-style structure for project-owned assets. Keep planned modules in
separate top-level or ROS workspace directories, maintain a central version
manifest, and store cross-cutting architectural decisions and policies under
`docs/`.

Upstream PX4, ROS 2, Gazebo, and MAVSDK source trees will not be copied or
vendored into this repository.

## Consequences

- Cross-module changes can be reviewed with their documentation and tests.
- Naming, dependency versions, and safety rules can be governed centrally.
- Module boundaries must remain explicit to prevent tight coupling.
- Repository growth requires disciplined ownership and focused changes.
