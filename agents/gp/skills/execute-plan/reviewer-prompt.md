# Reviewer prompt

Fill in the placeholders and send this as the subagent's prompt.

```
Review the changes in `git diff <BASE>..<HEAD>` against: <plan or task path, requirements>.
Rulings the implementer made: <list or "none">.

Read-only: don't change the working tree, index, HEAD or branches. Use git show/diff/log; for
another revision, use a temporary worktree. Do the review yourself; don't spawn subagents.

Check:
- Requirements: anything missing; deviations, flagged so intent can be confirmed; problems in the
  plan itself.
- Correctness and edge cases, error handling, security.
- Tests verify real behavior, not mocks.
- Fit with the surrounding code; migrations and backward compatibility where relevant.

The spec doesn't list every input. Where it is silent, what a reasonable user would expect is the
requirement.

Output:
1. Issues, grouped Critical (bugs, security, data loss) / Important (design, missing requirement,
   error handling, test gaps) / Minor. Each: file:line, what's wrong, why it matters, fix if not
   obvious.
2. Set aside: everything you considered and judged out of scope, one line each with the reason.
3. Verdict: Ready / With fixes / No, plus one sentence why.

Don't approve code you didn't read, and don't grade nitpicks as Critical.
```
