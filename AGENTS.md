# Repository Instructions for Coding Agents

These instructions apply to every automated or agent-assisted change in this
repository, including changes made by Codex.

## Working Practices

- Inspect the repository, relevant documentation, and current Git status before editing.
- Prefer small, reviewable changes with an explicit purpose.
- Preserve existing user work and do not overwrite files without inspection.
- Use English for file names, repository content, comments, and technical documentation.
- Do not install system dependencies without explicit user approval.
- Do not commit or push unless explicitly requested.
- Do not claim a feature works unless it has been executed and verified.
- Keep the root README, architecture documents, and roadmap synchronized.
- Add or update documentation and tests whenever behavior is introduced or changed.
- Record important architectural and all safety-critical decisions in `docs/adr/`.

## Architecture and Safety Rules

1. Use simulation-first development. The initial development target is simulation only; real hardware belongs to a later, separate phase.
2. Never give perception or AI components direct access to motors, actuators, or PX4 actuator commands.
3. Route motion requests through guidance and then through the safety supervisor.
4. Never send a critical motion command to flight control unless the safety supervisor has approved it.
5. Keep mission management, perception, guidance, safety, security monitoring, and telemetry as explicit, separate modules.
6. Treat communication loss, target loss, low battery, geofence violation, and invalid commands as distinct states with explicit handling.
7. Keep secrets, private keys, certificates, tokens, personal configuration, generated flight data, and telemetry logs out of the repository.
8. Do not vendor or copy upstream PX4, ROS 2, Gazebo, or MAVSDK source trees into this repository.
9. Pin PX4, ROS 2, Gazebo, MAVSDK, and relevant toolchain versions centrally in `toolchain/versions.yaml` after compatibility testing.
10. Keep module boundaries explicit and document allowed inputs, outputs, and forbidden responsibilities.
11. Ensure safety-sensitive changes receive focused review and corresponding validation coverage.
12. Apply defence-in-depth, security-oriented design, and resilient communication principles without making unverifiable security claims.

## Scope Guardrails

- Never bypass the safety supervisor, including in examples, tests, or temporary integrations.
- Never connect perception output directly to actuators.
- Do not add real-flight arming logic, weaponization, or uncontrolled hardware interfaces.
- Do not create placeholder application code that appears operational.
- Do not add generated binaries, datasets, model weights, screenshots, or simulation outputs.
- Do not create ROS 2 package metadata until the ROS 2 environment is verified and a package is intentionally implemented.
