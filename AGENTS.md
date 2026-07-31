# AGENTS.md

This file provides guidance to coding agents when working with code in this repository.

## Repository purpose

Personal dotfiles for user `gpapadok`. Three independent tool configs share nothing but the repo root:

- `home-manager/` — Nix home-manager config (one macOS profile, one Linux profile)
- `nvim/` — Neovim config using `lazy.nvim`
- `emacs/` — Emacs config using `straight.el` + `use-package`

There is no build/test/lint tooling in this repo — it's declarative config consumed by external tools. "Validating" a change means applying it with the relevant tool (below) and checking it doesn't error.

The root `.zshrc` is a standalone fallback (a handful of aliases) — it is **not** wired into home-manager, which generates its own `~/.zshrc` via `programs.zsh`. On the Nix machine the generated one wins, so editing the root `.zshrc` has no effect there.

## home-manager (Nix)

- Entry point: `home-manager/flake.nix`. Apply with `home-manager switch --flake .#<profile>` from `home-manager/`. (The configured shell has an `hms` alias, but it's bare `home-manager switch` — no `--flake`.)
- Module split:
  - `modules/default.nix` — base packages/config shared by every profile (always applied): packages, tmux, zsh/oh-my-zsh, shell aliases.
  - `modules/mac.nix` — macOS profile: username/home dir under `/Users`, git identity, mac-only packages and aliases.
  - `modules/linux.nix` — Linux profile: username/home dir under `/home`, git identity.
- Two `homeConfigurations` outputs exist, each `<machine-module> + default.nix`:
  - `"gpapadok"` — `aarch64-darwin`, `mac.nix`
  - `"gpapadok-linux"` — `x86_64-linux`, `linux.nix`
- Adding a new machine profile means adding a new `homeConfigurations.<name>` entry with its own module list, not editing an existing one.
- Flakes only see git-tracked files: a new module must be `git add`ed before `home-manager switch` can find it, even for an uncommitted local change.
- tmux config lives inline in `programs.tmux` in `default.nix` (`terminal`, `keyMode`, `shortcut`, `extraConfig`) — edit it there, not as a separate file. `dotfiles/tmux.conf` is kept only as an unused fallback reference and is not linked into the home-manager build.
- Git identity lives inside the per-machine Nix modules (`programs.git.settings`), not in a standalone `.gitconfig` and not in `default.nix`.

## Neovim (lazy.nvim)

- Entry point: `nvim/init.lua` → `require("gpapadok")` → `nvim/lua/gpapadok/init.lua`, which wires up, in order: helpers (`util.lua`, exposed as global `vim.fn.*` functions), keymaps (`keymaps.lua`), diagnostics/LSP/autocommands (`config.lua`), plugin manager (`lazy.lua`), then `options.lua`.
- `lua/gpapadok/config.lua` is a plain data table — enabled LSP servers (`language_servers`), diagnostic display (`diagnostic_config`), and buffer-write autocommands (`commands`). It has no logic; `init.lua` consumes it.
- LSP servers are configured individually under `nvim/lsp/<server>.lua` (new-style `vim.lsp.config`/`vim.lsp.enable`, not `lspconfig`-managed setup calls) and enabled by listing them in `language_servers`. The two are independent: a server in the list with no file under `nvim/lsp/` falls back to the config `nvim-lspconfig` ships (that's how `pyright` works), and a file under `nvim/lsp/` that isn't in the list is inert (currently `intelephense`).
- Plugins live under `lua/plugins/*.lua`, one file per plugin, auto-imported by `lazy.lua`.
- Lua formatting: `stylua.toml` — 2-space indent, 100 column width. Run `stylua` over `nvim/` if reformatting.
- `nvim/lazy-lock.json` is a generated lockfile (plugin versions) — don't hand-edit; it updates when lazy.nvim syncs plugins.

## Emacs (straight.el)

- Entry point: `emacs/init.el` — bootstraps `straight.el` (not the built-in `package.el`) and sets `straight-use-package-by-default t`, so every `use-package` form pulls its package from straight unless told otherwise. There is no separate lockfile in the repo.
- Feature modules live in `emacs/modules/*.el` and are loaded by the explicit `init-modules` list in `init.el` — load order is that list, **not** directory order or auto-discovery. Adding a module means: create `emacs/modules/init-<x>.el` ending in `(provide 'init-<x>)`, then add the `init-<x>` symbol to `init-modules`. Modules are grouped by concern (`init-config`, `init-lsp`, `init-python`, `init-clojure`, `init-common-lisp`, `init-theme`, etc.).
- Deployment gotcha: `init.el` adds `gpapadok/modules` (under the Emacs user dir) to `load-path`, while the repo stores modules at `emacs/modules/`. So the runtime layout differs from the repo layout — deployment is not a flat copy of `emacs/`; the modules land at `<emacs-user-dir>/gpapadok/modules/`.
- "Validating" a change means loading it in Emacs (e.g. restart or re-eval the module) and checking it doesn't error — same no-tooling convention as the rest of the repo.
