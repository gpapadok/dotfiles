# AGENTS.md

## Repository purpose

Personal dotfiles for user `gpapadok`. Three independent tool configs, plus coding-agent instructions:

- `nix/` — Nix flake: nix-darwin + home-manager (macOS), standalone home-manager (Linux), NixOS host module
- `nvim/` — Neovim config using `lazy.nvim`
- `emacs/` — Emacs config using `straight.el` + `use-package`
- `agents/AGENTS.md` — personal global agent instructions, linked to `~/AGENTS.md` and `~/.claude/CLAUDE.md`.
- `agents/skills/` — agent skills, each linked into `~/.claude/skills/`.

`nix/modules/symlink.nix` creates those links (plus `~/.config/nvim`) as out-of-store symlinks: edits take effect immediately; only adding/removing a link needs a switch.

There is no build/test/lint tooling in this repo — it's declarative config consumed by external tools. "Validating" a change means applying it with the relevant tool (below) and checking it doesn't error.

## Nix (`nix/`)

- Entry point: `nix/flake.nix`. Outputs:
  - `darwinConfigurations."gpapadok"` (`aarch64-darwin`) — `darwin.nix` (system: nix daemon, GC, optimise) + home-manager as a nix-darwin module importing `mac.nix`, `clojure.nix`, `emacs.nix`, `git.nix`, `symlink.nix`, `default.nix`. Apply with the `nds` alias (`sudo darwin-rebuild switch --flake /etc/nix-darwin#gpapadok`).
  - `homeConfigurations."gpapadok-linux"` (`x86_64-linux`) — `linux.nix`, `clean-downloads.nix`, `git.nix`, `symlink.nix`, `default.nix`. Apply with `home-manager switch --flake .#gpapadok-linux` from `nix/` (the `hms` alias is bare `home-manager switch`, no `--flake`).
  - `nixosModules.parnitha` — NixOS host config in `hosts/parnitha/`.
- Modules:
  - `default.nix` — shared by every profile: core CLI packages, TUIs, tmux (inline in `programs.tmux`; no separate tmux.conf), zsh/oh-my-zsh.
  - `mac.nix` — mac-only packages, `clean-downloads` script, launchd agents, brew/OrbStack `.zprofile` lines (`programs.zsh.profileExtra`), `nds` alias.
  - `linux.nix` — Linux profile identity (`home.username`/`home.homeDirectory`).
  - `clean-downloads.nix` — Linux-only systemd user service + timer deleting old `~/Downloads` entries.
  - `git.nix` — all git config (identity, editor, aliases); there is no standalone `.gitconfig`.
- Adding a machine means a new flake output with its own module list, not editing an existing one.
- Flakes only see git-tracked files: a new module must be `git add`ed before a switch can find it, even for an uncommitted local change.

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
