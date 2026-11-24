---
name: fixing-review-findings
description: Use when the user wants to work through code review findings and fix them one at a time with their approval — findings from a GitHub PR review (a colleague's inline comments or review summary), from a review this agent just produced in the session (e.g. /code-review, ReportFindings), or from another agent's review pasted into the chat or saved to a file. Use it whenever the user says things like "let's fix the review comments", "address the PR feedback", "go through the findings", "fix what the reviewer found", or gives a PR number/URL together with fixing intent, even if they don't mention approving each one.
---

# Fixing review findings

The user stays in control of every change. For each finding you explain the problem, propose a
fix, and wait for their decision. Then you act on it and move on to the next finding, until none
are left. A finding is a claim to check, not an order to follow: reviewers are sometimes wrong, so
read the code before you agree with one.

## 1. Collect the findings

Work out where the findings come from:

- **This session:** the findings are already in the conversation, from a review you ran. Use them
  as they are.
- **Another agent:** the user pastes the text or gives a file path. Read it.
- **A GitHub PR:** the user gives a number or URL. Fetch the unresolved review threads:

  ```bash
  gh repo view --json owner,name -q '.owner.login + " " + .name'   # → OWNER REPO
  gh api graphql -F owner=OWNER -F repo=REPO -F pr=N -f query='
    query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){
      pullRequest(number:$pr){reviewThreads(first:100){nodes{
        isResolved isOutdated path line
        comments(first:30){nodes{databaseId author{login} body}}}}}}}'
  gh pr view N --json reviews,comments   # review summaries and general PR comments
  ```

  Skip resolved threads. Keep outdated threads only if the problem still exists in the current
  code. Read the whole thread, because later replies may narrow or withdraw the original point.
  Keep each thread's first `databaseId`, since you need it to reply.

If any finding is unclear, ask about it before working on any of them: findings are often related,
and fixing the clear ones first can go the wrong way. When a finding asks to build something out
"properly", grep for real usage first; if nothing uses it, suggest removing it instead.

Turn each finding into one entry: where (`file:line`), what the reviewer said, and its source (the
thread id for PR threads). Merge duplicates. Order the list by severity if the review gives one;
otherwise follow the review's own order. Tell the user how many findings there are before you start.

## 2. Check the working tree first

- Run `git status`. If there are uncommitted changes in files the findings touch, tell the user
  and wait. Never commit their work along with your fixes.
- If the current branch is `main`/`master`, stop and ask which branch to use.
- For a PR, check that the checked-out branch is the PR's head branch. If it isn't, ask before
  switching.

## 3. One finding at a time

Read the code around the finding, enough to understand it, including callers if the fix changes
behavior. Then show:

```
### Finding 3/7 — src/billing/invoice.ts:42  (reviewer: @alice)
**Problem:** <one or two sentences, in your own words>
**Proposed fix:** <what you will change and why — a small diff if it helps>
```

If you think the finding is wrong or not worth fixing, say so here with the concrete reason and
suggest Skip. Don't quietly propose a fix you don't believe in.

Ask for the decision with `AskUserQuestion`, using three options: **Approve**, **Modify**,
**Skip**. Put the proposed diff in the Approve option's `preview`.

- **Modify:** the user's notes, or what they type under "Other", say what to change. If they
  picked Modify with no notes, ask in plain text what they want. Revise the proposal and show it
  again. Repeat until they approve or skip.
- **Skip:** note the reason if they gave one, then go to the PR reply step.
- **Approve:**
  1. Make the smallest change that fixes the finding. Don't fix anything else on the side; if you
     notice something, mention it.
  2. Stage only the files you changed (`git add <paths>`, never `-A`) and commit with a
     Conventional Commit message, e.g. `fix(billing): guard against negative quantities`. If the
     branch name contains a ticket ID, reference it. Never make one up. One commit per finding.
  3. Don't run the test suite here. Verification runs once at the end.

**PR reply (PR findings only, after Approve or Skip):** draft a short reply to the thread. For a
fix, say what changed and give the short SHA. For a skip, give the reason. Ask with
`AskUserQuestion`: **Post** / **Edit** / **Don't post**. Post only on Post:

```bash
gh api repos/OWNER/REPO/pulls/N/comments/COMMENT_ID/replies -f body='...'   # inline thread
gh pr comment N --body '...'                                                # review summary / general comment
```

Never resolve threads; the user does that. If the branch hasn't been pushed yet, say so in the
question, because the SHA won't exist on GitHub until it is.

Then go to the next finding.

## 4. Verify once at the end

When every finding has been handled, run the repo's own checks (its `make`/`just`/package
scripts: tests, lint, type-check) for the files you changed. If something fails, show the actual
output. Treat the failure as a new finding and handle it the same way (problem, proposed fix,
Approve/Modify/Skip).

## 5. Wrap up

Give a short summary table: finding → fixed (`sha`) / skipped (reason) / reply posted or not.
Then the verification result. Don't push unless the user explicitly asks.
