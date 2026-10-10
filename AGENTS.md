# AGENTS.md

This file provides guidance to coding agents when working with code in this repository.

## Repository purpose

Personal dotfiles for user `gpapadok`. Three independent tool configs, plus coding-agent instructions:

- `home-manager/` — Nix home-manager config (one macOS profile, one Linux profile)
- `nvim/` — Neovim config using `lazy.nvim`
- `emacs/` — Emacs config using `straight.el` + `use-package`
- `home-manager/dotfiles/agents/AGENTS.md` — personal global agent instructions. `modules/default.nix` deploys it as `~/AGENTS.md` and points `~/.claude/CLAUDE.md` at that, so an edit takes effect only after `home-manager switch`.
- `agents/skills/` — agent skills (`functional-programming`), symlinked into `~/.claude/skills/` by hand; no Nix module manages that link.

There is no build/test/lint tooling in this repo — it's declarative config consumed by external tools. "Validating" a change means applying it with the relevant tool (below) and checking it doesn't error.

## home-manager (Nix)

- Entry point: `home-manager/flake.nix`. Apply with `home-manager switch --flake .#<profile>` from `home-manager/`. (The configured shell has an `hms` alias, but it's bare `home-manager switch` — no `--flake`.)
- Module split:
  - `modules/default.nix` — base packages/config shared by every profile (always applied): core CLI packages, TUIs, tmux, zsh/oh-my-zsh.
  - `modules/linux.nix` — Linux profile: sets `home.username`/`home.homeDirectory` for `gpapadok-linux` and personal git identity.
  - `modules/mac.nix` — personal macOS profile: sets `home.username`/`home.homeDirectory` for `gpapadok`, personal git identity, mac-only packages (clojure, leiningen, beads), launchd agents, and the brew/OrbStack `.zprofile` lines (`programs.zsh.profileExtra`).
  - `modules/clean-downloads.nix` — systemd user service + timer that deletes `~/Downloads` entries older than 30 days, weekly. Linux-only (systemd), applied alongside `linux.nix`, not `mac.nix`.
- Two `homeConfigurations` outputs exist in `flake.nix`:
  - `"gpapadok"` (`aarch64-darwin`) — `mac.nix` + `default.nix`.
  - `"gpapadok-linux"` (`x86_64-linux`) — `linux.nix` + `clean-downloads.nix` + `default.nix`.
  Adding a new machine profile means adding a new `homeConfigurations.<name>` entry with its own module list, not editing an existing one.
- Flakes only see git-tracked files: a new module must be `git add`ed before `home-manager switch` can find it, even for an uncommitted local change.
- `linux.nix` and `mac.nix` both carry a near-identical personal `programs.git.settings` block (same email/username, `core.editor = "nvim"`) — when changing personal git config, update both.
- tmux config lives inline in `programs.tmux` in `default.nix` (`terminal`, `keyMode`, `shortcut`, `extraConfig`) — edit it there; there is no separate tmux.conf.
- Git config (identity, aliases) lives inside the Nix modules (`programs.git.settings`), not in a standalone `.gitconfig`.

## Neovim (lazy.nvim)

- Entry point: `nvim/init.lua` → `require("gpapadok")` → `nvim/lua/gpapadok/init.lua`, which wires up, in order: helpers (`util.lua`, a module table that `init.lua` requires as `helpers`), keymaps (`keymaps.lua`), diagnostics/LSP/autocommands (`config.lua`), plugin manager (`lazy.lua`), then `options.lua`.
- `lua/gpapadok/config.lua` is the place to change: enabled LSP servers, diagnostic display, and buffer-write autocommands. The LSP server list is unconditional — every server listed in `language_servers` is enabled on all machines.
- LSP servers are configured individually under `nvim/lsp/<server>.lua` (new-style `vim.lsp.config`/`vim.lsp.enable`, not `lspconfig`-managed setup calls) and enabled via the `language_servers` list in `config.lua`. A server in the list with no file under `nvim/lsp/` falls back to the config `nvim-lspconfig` ships (that's how `pyright`, `intelephense`, `gopls`, and `vue_ls` work). Cross-server overrides go in `lsp_overrides` in `config.lua`.
- Plugins live under `lua/plugins/*.lua`, one file per plugin, auto-imported by `lazy.lua`.
- Lua formatting: `stylua.toml` — 2-space indent, 100 column width. Run `stylua` over `nvim/` if reformatting.
- `nvim/lazy-lock.json` is a generated lockfile (plugin versions) — don't hand-edit; it updates when lazy.nvim syncs plugins.

## Emacs (straight.el)

- Entry point: `emacs/init.el` — bootstraps `straight.el` (not the built-in `package.el`) and sets `straight-use-package-by-default t`, so every `use-package` form pulls its package from straight unless told otherwise. There is no separate lockfile in the repo.
- Feature modules live in `emacs/modules/*.el` and are loaded by the explicit `init-modules` list in `init.el` — load order is that list, **not** directory order or auto-discovery. Adding a module means: create `emacs/modules/init-<x>.el` ending in `(provide 'init-<x>)`, then add the `init-<x>` symbol to `init-modules`. Modules are grouped by concern (`init-config`, `init-lsp`, `init-python`, `init-clojure`, `init-common-lisp`, `init-theme`, etc.).
- Deployment gotcha: `init.el` adds `gpapadok/modules` (under the Emacs user dir) to `load-path`, while the repo stores modules at `emacs/modules/`. So the runtime layout differs from the repo layout — deployment is not a flat copy of `emacs/`; the modules land at `<emacs-user-dir>/gpapadok/modules/`.
- "Validating" a change means loading it in Emacs (e.g. restart or re-eval the module) and checking it doesn't error — same no-tooling convention as the rest of the repo.
