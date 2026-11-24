---
name: close-branch
description: Use when a feature branch's work is done and the user wants it wrapped up — consolidated, merged into the integration branch, beads closed, branch and worktree removed.
argument-hint: [target-branch]
---

# Close branch

Invoking this skill authorizes a local merge and deleting the merged branch and its worktree.
Pushing and deleting remote branches need the user's explicit request.

Shell variables don't survive between Bash calls: note each value below and write it literally
into later commands.

1. **Check state.** In the branch's checkout, note the branch name, its path
   (`git rev-parse --show-toplevel`), and the main checkout's path (the parent of
   `git rev-parse --path-format=absolute --git-common-dir`). It is a linked worktree when
   `git rev-parse --path-format=absolute --git-dir` differs from
   `git rev-parse --path-format=absolute --git-common-dir`. Uncommitted changes → stop and ask.
2. **Target branch.** `$ARGUMENTS` if given; otherwise the integration branch the work forked from
   (`dev`, `devel`, `master`, …). Not obvious → ask; a merge into the wrong base is expensive to
   undo. Then check the main checkout: `git -C <main> status --porcelain --untracked-files=no` and
   `git -C <main> branch --show-current`. Modified or staged files there, or a branch other than
   the target checked out → stop and ask; never move the user's checkout or carry their changes.
3. **Consolidate** (unpushed branches only). Note `git rev-parse HEAD` as OLD_HEAD and
   `git merge-base <target> HEAD` as BASE. Fold a small commit that only fixes the commit right
   before it into that commit; leave commits that touch several earlier ones alone. No large
   rewrites. Without `rebase -i`: `git reset --hard <BASE>`, then per group
   `git cherry-pick -n <feat> <fix>… && git commit -C <feat>`, plain `cherry-pick` for the rest.
   `git diff <OLD_HEAD> HEAD` must be empty; if it isn't, or a cherry-pick conflicts,
   `git reset --hard <OLD_HEAD>` and report.
4. **Beads** (repo has `.beads/`): for each bead the branch implemented,
   `br close <id> -r "<what was done, commit>"`, then `br sync --flush-only` and commit `.beads/` on
   the branch.
5. **Bring the target in and verify on the branch.** Unpushed branch: `git rebase <target>`;
   pushed: `git merge <target>`. Conflicts → stop and ask. Run the full suite on the branch;
   failures → stop and show them. The target only ever receives a tested result.
6. **Merge.** `git -C <main> merge --ff-only <branch>`. Not fast-forward because the target moved →
   repeat step 5.
7. **Clean up.** Remove the worktree only if it was created by `gp:dev-workflow` or by hand for
   this work (under `.claude/worktrees/`, `.worktrees/` or `worktrees/`). If this session is
   inside it, call `ExitWorktree` with `action: "keep"` first. Then
   `git -C <main> worktree remove <path>`; if git refuses because of uncommitted or untracked
   files, show them and ask — never `--force`. Then `git -C <main> branch -d <branch>`.
8. **Push** only on explicit request: `git push origin <target>`, and
   `git push origin --delete <branch>` if it exists on the remote. Rejected → report it; never
   force-push.

Report: merge commit, beads closed, what was deleted, what is left to push.

**Housekeeping on request:** `git branch --no-merged <target>` lists unmerged work;
`git worktree list` plus `git branch --merged <target>` shows worktrees that are safe to remove.
