# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles for user `gpapadok`. Three independent tool configs share nothing but the repo root:

- `home-manager/` — Nix home-manager config (macOS)
- `nvim/` — Neovim config using `lazy.nvim`
- `emacs/` — Emacs config using `straight.el` + `use-package`

There is no build/test/lint tooling in this repo — it's declarative config consumed by external tools. "Validating" a change means applying it with the relevant tool (below) and checking it doesn't error.

The root `.zshrc` is a standalone fallback (a handful of aliases) — it is **not** wired into home-manager, which generates its own `~/.zshrc` via `programs.zsh`. On the Nix machine the generated one wins, so editing the root `.zshrc` has no effect there.

## home-manager (Nix)

- Entry point: `home-manager/flake.nix`. Apply with `home-manager switch --flake .` from `home-manager/` (aliased as `hms` in the configured shell once activated).
- Module split:
  - `modules/default.nix` — base packages/config for the `gpapadok` home-manager profile (always applied).
  - `modules/mac.nix` — macOS-specific additions layered on top (packages, shell aliases), wired into `flake.nix`'s `homeConfigurations`.
- Only one `homeConfigurations` output exists (`"gpapadok"`, `aarch64-darwin`), composed of `default.nix` + `mac.nix`. Adding a new machine profile means adding a new `homeConfigurations.<name>` entry with its own module list, not editing the existing one.
- `dotfiles/tmux.conf` is linked in via `home.file` in `default.nix` — edit it directly, it's not templated.
- Git config (identity, aliases) lives inside the Nix modules (`programs.git.settings`), not in a standalone `.gitconfig`.

## Neovim (lazy.nvim)

- Entry point: `nvim/init.lua` → `require("gpapadok")` → `nvim/lua/gpapadok/init.lua`, which wires up, in order: helpers (`util.lua`, exposed as global `vim.fn.*` functions), keymaps (`keymaps.lua`), diagnostics/LSP/autocommands (`config.lua`), plugin manager (`lazy.lua`), then `options.lua`.
- `lua/gpapadok/config.lua` is the place to change: enabled LSP servers (the `language_servers` list), diagnostic display, and buffer-write autocommands.
- LSP servers are configured individually under `nvim/lsp/<server>.lua` (new-style `vim.lsp.config`/`vim.lsp.enable`, not `lspconfig`-managed setup calls) and enabled via the `language_servers` list in `config.lua`.
- Plugins live under `lua/plugins/*.lua`, one file per plugin, auto-imported by `lazy.lua`.
- Lua formatting: `stylua.toml` — 2-space indent, 100 column width. Run `stylua` over `nvim/` if reformatting.
- `nvim/lazy-lock.json` is a generated lockfile (plugin versions) — don't hand-edit; it updates when lazy.nvim syncs plugins.

## Emacs (straight.el)

- Entry point: `emacs/init.el` — bootstraps `straight.el` (not the built-in `package.el`) and sets `straight-use-package-by-default t`, so every `use-package` form pulls its package from straight unless told otherwise. There is no separate lockfile in the repo.
- Feature modules live in `emacs/modules/*.el` and are loaded by the explicit `init-modules` list in `init.el` — load order is that list, **not** directory order or auto-discovery. Adding a module means: create `emacs/modules/init-<x>.el` ending in `(provide 'init-<x>)`, then add the `init-<x>` symbol to `init-modules`. Modules are grouped by concern (`init-config`, `init-lsp`, `init-python`, `init-clojure`, `init-common-lisp`, `init-theme`, etc.).
- Deployment gotcha: `init.el` adds `gpapadok/modules` (under the Emacs user dir) to `load-path`, while the repo stores modules at `emacs/modules/`. So the runtime layout differs from the repo layout — deployment is not a flat copy of `emacs/`; the modules land at `<emacs-user-dir>/gpapadok/modules/`.
- "Validating" a change means loading it in Emacs (e.g. restart or re-eval the module) and checking it doesn't error — same no-tooling convention as the rest of the repo.
