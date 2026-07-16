# Development Environment

Status: Planned — the environment has not been installed or verified by this repository.

The intended Phase 1 baseline is:

- WSL2
- Ubuntu 24.04
- PX4 SITL
- Gazebo Harmonic
- ROS 2 Jazzy
- MAVSDK
- Python and C++ toolchains selected after environment inspection

Exact compatible versions belong in
[`../../toolchain/versions.yaml`](../../toolchain/versions.yaml) after the first
compatibility smoke test. Do not silently upgrade major dependencies.

No setup commands are provided in Phase 0 because system packages, host
integration, and upstream installation methods must first be verified against
official documentation. Dependency installation requires explicit user approval.

The next environment task should inspect the existing WSL2/Ubuntu state before
making changes, record installed versions, and perform the smallest possible PX4
SITL plus Gazebo smoke test without adding application behavior.
