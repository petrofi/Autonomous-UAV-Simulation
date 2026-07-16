# Contributing

This project is in its architecture-scaffolding phase. Keep contributions small,
reviewable, simulation-first, and consistent with the documented safety boundary.

## Branches and Commits

Use descriptive branch names such as `docs/refine-threat-model`,
`feat/simulation-launch`, or `fix/telemetry-timeout`. Prefer small commits that
each represent one coherent change.

Conventional-style commit examples:

```text
docs: clarify safety supervisor boundary
feat: add simulated telemetry event model
test: cover invalid guidance request rejection
fix: reject stale mission commands
```

## Change Requirements

- Update relevant documentation whenever architecture, behavior, or scope changes.
- Add or update tests whenever behavior is introduced or modified.
- Never commit secrets, credentials, private keys, certificates, generated flight data, ROS bags, telemetry logs, datasets, model weights, or build outputs.
- Do not vendor upstream dependency source trees.
- Request focused review for safety-sensitive changes, including guidance, failsafe, geofence, command-validation, and safety-supervisor changes.
- State what was actually executed and verified; do not imply untested behavior works.
- Follow the rules in `AGENTS.md` and record significant decisions in `docs/adr/`.

Do not commit directly to `main`. Open a focused pull request with a clear
description, verification notes, and any known limitations.
