# Development Workflow

## Before Editing

1. Inspect `AGENTS.md`, relevant architecture documents, and ADRs.
2. Run `git status` and review existing changes without overwriting them.
3. Confirm the requested phase and module boundary.
4. Identify documentation, tests, safety, and security impact.

## During a Change

- Work on one focused concern and keep the diff reviewable.
- Preserve the mandatory safety-supervisor boundary.
- Add behavior and its tests together.
- Update architecture, roadmap, configuration guidance, and version manifest when affected.
- Do not add secrets, generated flight data, dependency source trees, or unverified claims.
- Use simulation evidence before proposing hardware use.

## Before Review

1. Run only relevant, documented checks in the verified environment.
2. Run `git diff --check`.
3. Review documentation links and generated-file status.
4. Report commands and results accurately, including limitations and skipped checks.
5. Obtain focused review for safety-sensitive or trust-boundary changes.
