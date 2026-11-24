---
name: write-plan
description: Use when there is an agreed spec or set of requirements for a multi-step change and it needs an implementation plan before code is written.
---

# Write plan

Write for an engineer who knows the language but not this codebase or spec. The plan holds the
decisions they can't make alone: which files, names and signatures, the spec's exact values, and
which tests prove each task. Nothing else.

Save it where the repo or user says; otherwise `docs/plans/YYYY-MM-DD-<feature>.md`.

**Header:** goal (one sentence), approach (2-3 sentences), spec path, and **Global constraints**:
version floors, naming, platform requirements, one line each, values copied verbatim from the
spec.

**Files:** list the files to create or modify and each one's responsibility, following the repo's
existing patterns.

**Tasks:** each is the smallest unit with its own test cycle that a reviewer could accept or reject
on its own. Fold setup, config and docs into the task that needs them.

````markdown
### Task N: <name>

Files: Create `path` · Modify `path:12-40` · Test `path`
Interfaces: Consumes <exact signatures from earlier tasks> · Produces <exact signatures later tasks use>

- [ ] Write failing test `test_name` (assertions as code, with the spec's values)
- [ ] Run `<cmd>`. Expected: FAIL with <message>
- [ ] Implement `name(params) -> Return` in `path`
- [ ] Run `<cmd>`. Expected: PASS
- [ ] Commit `type(scope): description`
````

A step is done when the implementer can write exactly one reasonable thing from it. Add a line on
approach only when the signature and test leave a choice, and a function body only when they don't
determine it. A plan longer than the code it describes is a transcript; "TBD", "handle edge cases"
or "add validation" are gaps.

**Self-review before handing over:**
1. Every spec requirement maps to a task.
2. Names, types and signatures match across tasks.
3. Inputs the spec implies but no test exercises (empty, malformed, concurrent, …) get a test in
   the task that owns the code.
4. Mostly code blocks → replace bodies with signatures and assertions.

Ask the user to review the plan. Don't implement before they approve it.
