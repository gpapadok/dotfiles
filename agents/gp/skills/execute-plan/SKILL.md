---
name: execute-plan
description: Use when executing an approved implementation plan task by task, inline or with a subagent per task.
---

# Execute plan

Execute the plan as written, without checking in between tasks. Stop and ask only for: an
irreversible or destructive operation, a security-sensitive action, a side effect outside the
branch (merge, push to a shared branch, publish), or a plan so broken that every path is a guess.

## Setup

- Read the plan and its spec once; where they conflict, the spec wins. One todo per task.
- Progress lives in the plan file: tick each step's checkbox in the commit that completes it.
  After compaction, trust the ticks and `git log` over your memory; never redo a ticked task.
- Before Task 1, check every task's Consumes against the earlier task's Produces and resolve
  mismatches against the spec.
- Choose the mode and state it in one line:
  - **Inline**: few, sequential or tightly coupled tasks.
  - **Subagent per task**: several independent tasks, or a plan long enough that its last tasks
    would run on a compacted context.

## Per task

1. Re-read the task's text; your memory of it is a summary. Note the SHA from `git rev-parse HEAD`
   as the task's BASE, and write that literal SHA into later commands and prompts: shell variables
   don't survive between Bash calls, and an empty BASE turns the diff into `..HEAD`, which is empty.
2. Implement it under `gp:testing`, comparing every `Expected:` line against real output.
   - Code is wrong → `gp:debugging`.
   - Plan is wrong → make the smallest change that satisfies the spec and append
     `Ruling: <what you decided> — <why> — <cost if wrong>` to a **Rulings** section in the plan.
3. Commit as the plan says.

**Subagent mode,** in addition:
- Dispatch prompt: where the task fits (one line); "read Task N in `<plan path>`, it is your
  requirements"; interfaces and rulings from earlier tasks it touches; the report contract: status
  (DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED), commits, one-line test result, concerns.
  No session history. It must not spawn subagents, and should report BLOCKED rather than guess on
  an architectural choice.
- Set the model explicitly: complete spec in 1-2 files → cheapest; multi-file integration →
  mid-tier; design judgment → most capable. Mid-tier is the floor for reviewers and for tasks
  described only in prose; cheap models take more turns on multi-step work.
- One implementer at a time; they share the working tree.
- On DONE, read `git diff <BASE>..HEAD` yourself; a success report is not evidence. Then a fresh
  mid-tier reviewer with [reviewer-prompt.md](reviewer-prompt.md) on `<BASE>..HEAD` (never
  `HEAD~1`) against the task text. Critical or Important findings go back to the same
  implementer; after 3 rounds, rule on what's left and log it.

## Final review

When every task is ticked, dispatch one fresh reviewer on the most capable model with
[reviewer-prompt.md](reviewer-prompt.md) over `$(git merge-base <base> HEAD)..HEAD`, with the plan,
spec and Rulings. Re-grade each finding by what a user would get if it shipped, not by whether the
spec mentions the case. Fix Critical and Important in one pass, each with a failing test first,
then the full suite green. List Minor findings; don't fix them.

## Report

Rulings you made (with cost if wrong), deferred minor findings, final test results.
