# Planned Continuous Integration

Status: Planned — no active GitHub Actions workflow exists yet.

Executable application code and verified development dependencies are not yet
present, so Phase 0 intentionally provides no active workflow. Future workflows
are expected to cover:

- Markdown checks
- Python lint and tests
- C++ formatting and tests
- ROS 2 build validation
- Simulation smoke tests
- Secret scanning

Workflow implementation must pin action versions, use least-privilege
permissions, avoid exposing secrets to untrusted code, and be introduced with
the behavior it validates.
