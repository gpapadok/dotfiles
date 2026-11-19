---
name: dev-workflow
description: Use when the user hands over a work item — a Jira issue key, a bead (`br`) ID, or an implementation plan with no ticket — and wants it implemented end to end.
argument-hint: <jira-key | bead-id | plan-path> [crit | pr | pr:<target-branch>]
---

# Dev workflow

Orchestrates the superpowers skills into one workflow. Invoking this skill authorizes: creating the
worktree, commits on the feature branch and, in a PR mode, pushing that branch and opening the PR.
It never merges and never pushes to `main`. Rules in the user's global CLAUDE.md take precedence
over this skill.

## Arguments

`$ARGUMENTS` is `<work-item> [finish]`. If the work item is missing, ask for it.

- `<work-item>`: bead ID, Jira key, or plan file path (see step 1).
- `[finish]`, optional, how the work is handed over for review:
  - `crit`: local review with `crit:crit`. This argument is the user's explicit request for it.
    Nothing is pushed. Check `command -v crit` first; if it is missing, say so and wait for the
    user.
  - `pr`: PR against `main`.
  - `pr:<target-branch>`: PR against that branch.
  - Omitted: `superpowers:finishing-a-development-branch` asks the user in step 7.
  - Any other value: ask.

## Steps

Create a todo per step and do them in order.

1. **Read the work item.**
   - Run `br show <id>` first. If it resolves, it is a bead. Otherwise, a key like `ABC-123` is a
     Jira issue: read it via the Atlassian MCP (`getJiraIssue`), read-only. Never assign,
     transition or comment on Jira.
   - Plan with no ticket (a file path, or plan text in the chat): the plan is the spec. Plan text
     from the chat is saved to a file in the worktree (step 2) and committed first, so subagents
     can read it and the PR can reference it.
   - For a ticket, find the plan in its body or in the file it points to. No plan is fine when the
     task is small and well scoped: the ticket is the spec. If it is neither, stop and ask.
   - Bead only: after the spec check passes, `br update <id> --claim`.
2. **Isolate.** Invoke `superpowers:using-git-worktrees`. Branch `type/short-description`; put the
   ticket ID in the description, or derive it from the plan title when there is no ticket. If the
   baseline tests fail, stop and ask.
3. **Choose the executor** and state the choice and why in one line.
   - Several independent tasks → `superpowers:subagent-driven-development`.
   - Few, sequential or tightly coupled tasks, or no plan → `superpowers:executing-plans`.
4. **Implement** under `superpowers:test-driven-development` and the `functional-programming`
   skill. If the work item's type is `bug` (Jira issue type or bead type), run
   `superpowers:systematic-debugging` first, then fix test-first. Subagent prompts must say:
   invoke `functional-programming` and `superpowers:test-driven-development` first.
5. **Review in a clean context.** The executor's own review does not replace this one. Run
   `superpowers:requesting-code-review` with a fresh subagent, then act on feedback with
   `superpowers:receiving-code-review`.
6. **Verify.** `superpowers:verification-before-completion`: run the repo's own test/lint/type-check
   wrapper and read the output before claiming anything.
7. **Finish.** Always run `superpowers:finishing-a-development-branch`. The `finish` argument
   answers its options menu, so it does not ask; with no `finish` argument it asks the user. Then
   stop and hand over.
   - `pr` / `pr:<target-branch>`: answers "push and create a PR", with the given target (`main`
     for `pr`) as the base branch. Conventional Commit title; ticket ID in the body, or the plan
     file path when there is no ticket. Hand over the PR link. If the push or PR creation fails,
     report it and wait for the user.
   - `crit`: answers "keep the branch as-is" (nothing pushed or merged). Then invoke `crit:crit`
     on the branch's changes and hand over once the review is open.

## Reporting

End with: PR link (or crit review), which executor ran and why, verification results (paste
failures), anything skipped or unverified.
