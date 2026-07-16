## Summary

Describe the focused change and why it is needed.

## Scope

- Affected modules or documents:
- Out-of-scope work:

## Safety and Security Impact

Explain changes to trust boundaries, guidance, safety supervision, failsafes,
command validation, telemetry, or sensitive data handling. Write `None` only
when the change has no such impact.

## Verification

List only checks that were actually executed and their results.

## Checklist

- [ ] I inspected existing repository guidance before editing.
- [ ] The change is small and reviewable.
- [ ] Documentation and roadmap references are synchronized where needed.
- [ ] Tests were added or updated if behavior changed.
- [ ] Perception does not issue actuator or motor commands.
- [ ] Critical motion commands cannot bypass the safety supervisor.
- [ ] No secrets, generated flight data, binaries, datasets, or model weights are included.
- [ ] I have not claimed unexecuted behavior works.
