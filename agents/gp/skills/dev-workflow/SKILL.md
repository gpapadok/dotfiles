---
name: dev-workflow
description: Use when the user hands over a work item — a Jira issue key, a bead (`br`) ID, or an implementation plan with no ticket — and wants it implemented end to end.
argument-hint: <jira-key | bead-id | plan-path> [merge | merge:<target-branch> | crit | pr | pr:<target-branch>]
---

# Dev workflow

Orchestrates the `gp` skills into one workflow. Invoking this skill authorizes: creating the
worktree, commits on the feature branch and, in a PR mode, pushing that branch and opening the PR.
It merges only locally, through `gp:close-branch`, when the `finish` argument or the user's answer
in step 6 asks for it. It never pushes to `main`. Rules in the user's global CLAUDE.md take precedence
over this skill.

## Arguments

`$ARGUMENTS` is `<work-item> [finish]`. If the work item is missing, ask for it.

- `<work-item>`: bead ID, Jira key, or plan file path (see step 1).
- `[finish]`, optional, how the work is handed over for review:
  - `merge` / `merge:<target-branch>`: local merge with `gp:close-branch`, into the given target
    or the branch the work forked from. Nothing is pushed.
  - `crit`: local review with `crit:crit`. This argument is the user's explicit request for it.
    Nothing is pushed. Check `command -v crit` first; if it is missing, say so and wait for the
    user.
  - `pr`: PR against `main`.
  - `pr:<target-branch>`: PR against that branch.
  - Omitted: step 6 asks the user.
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
2. **Isolate.** Already in a linked worktree (`git rev-parse --path-format=absolute --git-dir`
   differs from `git rev-parse --path-format=absolute --git-common-dir`) → use it. Otherwise create one with `git worktree add .claude/worktrees/<name> -b <branch> HEAD`,
   after `git check-ignore -q .claude/worktrees` confirms it is ignored, and enter it with
   `EnterWorktree` (`path`). Branch `type/short-description`; put the ticket ID in the description,
   or derive it from the plan title when there is no ticket. Run the baseline tests; if they fail,
   stop and ask.
3. **Implement.** With a plan, run `gp:execute-plan`; it chooses inline or subagent-per-task
   execution and says why. A small ticket with no plan is implemented inline. Either way, work
   under `gp:testing` and `gp:functional-programming`. If the work item's type is `bug` (Jira issue
   type or bead type), run `gp:debugging` first, then fix test-first. Subagent prompts must say:
   invoke `gp:functional-programming` and `gp:testing` first.
4. **Review in a clean context.** `gp:execute-plan`'s final review is this review. Without it, dispatch
   a fresh reviewer on the most capable model with `gp:execute-plan`'s `reviewer-prompt.md` over the
   branch. Check every finding against the code before acting on it; push back on wrong ones with
   evidence.
5. **Verify.** Run the repo's own test/lint/type-check wrapper and read the output before claiming
   anything.
6. **Finish.** The `finish` argument decides; with none, ask: merge locally, PR, or keep the branch.
   Then stop and hand over.
   - `merge` / `merge:<target-branch>`: `gp:close-branch`, with the target as its argument.
   - `pr` / `pr:<target-branch>`: push the branch and open a PR against the target (`main` for
     `pr`). Conventional Commit title; ticket ID in the body, or the plan file path when there is no
     ticket. Hand over the PR link. If the push or PR creation fails, report it and wait for the
     user.
   - `crit`: nothing pushed or merged. Invoke `crit:crit` on the branch's changes and hand over once
     the review is open.

## Reporting

End with: PR link (or crit review), which executor ran and why, verification results (paste
failures), anything skipped or unverified.
