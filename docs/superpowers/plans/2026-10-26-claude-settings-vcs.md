# Claude settings version control Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Track `~/.claude/settings.json` in the dotfiles repo while letting Claude Code keep writing to it.

**Architecture:** The real file lives in `home-manager/dotfiles/claude/settings.json`. `modules/default.nix` links it to `~/.claude/settings.json` with `config.lib.file.mkOutOfStoreSymlink` (same `home.file` block that already links `CLAUDE.md`), so writes by `/plugin`, `/config`, `/model` land in the repo.

**Tech Stack:** Nix, home-manager (flake), git.

**Spec:** None. Design was agreed in chat on 2026-10-26 (no written spec, by user's choice).

## Global Constraints

- Only `~/.claude/settings.json` is tracked. No credentials, history, sessions, plugin cache, or `settings.local.json`.
- Link target path is built from `config.home.homeDirectory`; the repo is assumed to be at `~/workspace/dotfiles` on every machine.
- The change goes in `home-manager/modules/default.nix` (shared by both profiles), not in `linux.nix` or `mac.nix`.
- Flakes only see git-tracked files: `git add` the new file before `home-manager switch`.
- Do not touch the user's uncommitted work in `home-manager/modules/linux.nix`.
- Out of scope: trimming settings/skills/plugins, agents/commands/hooks/skills tracking, simplifying the `AGENTS.md` double symlink.

## Review Focus

- Claude replaces the file with an atomic rename on write, which would turn the symlink into a regular file and silently detach it from the repo. Expected: still a symlink after a `/config` change.
- A real `~/.claude/settings.json` already exists. Expected: `home-manager switch` fails on the clobber, so it must be removed first (after copying it into the repo).
- Repo is not at `~/workspace/dotfiles` on the Mac. Expected: link dangles; verify on that machine.

---

### Task 1: Link settings.json from the repo

**Files:**
- Create: `home-manager/dotfiles/claude/settings.json` (copy of the current `~/.claude/settings.json`)
- Modify: `home-manager/modules/default.nix` (the `home.file` attrset, next to `".claude/CLAUDE.md"`)

**Interfaces:**
- Consumes: `config.lib.file.mkOutOfStoreSymlink`, `config.home.homeDirectory` (both already used in this file).
- Produces: `~/.claude/settings.json` as a symlink to `<homeDirectory>/workspace/dotfiles/home-manager/dotfiles/claude/settings.json`.

- [ ] **Step 1: Check the tree is safe to work in**

Run: `git -C ~/workspace/dotfiles status --short`
Expected: any entries (e.g. `MM home-manager/modules/linux.nix`) are the user's; do not stage, commit, or modify them. Stage only the files named in this task.

- [ ] **Step 2: Copy the current settings into the repo**

Run: `mkdir -p home-manager/dotfiles/claude && cp ~/.claude/settings.json home-manager/dotfiles/claude/settings.json && git add home-manager/dotfiles/claude/settings.json`
Expected: file exists and `git status --short` shows `A  home-manager/dotfiles/claude/settings.json`.

- [ ] **Step 3: Add the `home.file` entry in `modules/default.nix`**

Add this attribute to the existing `home.file` set, after `".claude/CLAUDE.md"`:

```nix
".claude/settings.json".source =
  config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/workspace/dotfiles/home-manager/dotfiles/claude/settings.json";
```

- [ ] **Step 4: Remove the real file so home-manager can create the link**

Run: `rm ~/.claude/settings.json`
Expected: the copy from Step 2 is the only one left (`diff` is not needed; Step 2 was a plain `cp`).

- [ ] **Step 5: Apply**

Run (from `home-manager/`): `home-manager switch --flake .#gpapadok-linux`
Expected: exits 0, no "would be clobbered" error.

- [ ] **Step 6: Verify the link**

Run: `ls -l ~/.claude/settings.json`
Expected: symlink whose target ends in `/home-manager/dotfiles/claude/settings.json` (via the nix store link or directly).

- [ ] **Step 7: Verify Claude writes through the link**

In Claude Code, change a harmless setting with `/config` (e.g. toggle theme and back), then run `ls -l ~/.claude/settings.json` and `git -C ~/workspace/dotfiles diff --stat home-manager/dotfiles/claude/settings.json`.
Expected: still a symlink, and the diff shows the change. If it became a regular file (atomic-rename write), stop and report; the plan needs a different approach.

- [ ] **Step 8: Commit**

```bash
git add home-manager/dotfiles/claude/settings.json home-manager/modules/default.nix
git commit -m "feat(claude): version control settings.json via home-manager symlink" -- home-manager/dotfiles/claude/settings.json home-manager/modules/default.nix
```
Expected: commit contains only those two files. Path-limited commit keeps the user's staged `linux.nix` changes out.
