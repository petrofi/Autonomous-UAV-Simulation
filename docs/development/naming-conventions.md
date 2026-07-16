# Naming Conventions

- Use English, lowercase `snake_case` for planned ROS 2 package and Python module names.
- Use lowercase `kebab-case` for Markdown document names and branch suffixes.
- Use `PascalCase` for C++ types and `snake_case` for C++ functions and variables unless an adopted upstream convention requires otherwise.
- Name events as completed facts, such as `command_rejected`; name requests as intentions, such as `return_home_request`.
- Include units in ambiguous numeric names, such as `altitude_m` or `timeout_ms`.
- Distinguish observation, request, approval, rejection, state, and event types in names.
- Do not use names that imply certification, complete security, or verified behavior without supporting evidence.

Concrete ROS 2 interface naming will be documented when interfaces are designed
and implemented.
