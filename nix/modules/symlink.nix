{ config, pkgs, dotfiles, symlink, ... }:

{
  _module.args = {
    dotfiles = "${config.home.homeDirectory}/workspace/dotfiles";
    symlink = config.lib.file.mkOutOfStoreSymlink;
  };

  home.file = {
    # claude
    "AGENTS.md".source = symlink "${dotfiles}/agents/AGENTS.md";
    ".claude/CLAUDE.md".source = symlink "${config.home.homeDirectory}/AGENTS.md";
    # plugin dir under ~/.claude/skills: auto-loads as gp@skills-dir, skills namespaced gp:<name>
    ".claude/skills/gp".source = symlink "${dotfiles}/agents/gp";
    # third-party skill, read-only from the store; rev is a security-reviewed commit
    ".claude/skills/archify".source = "${pkgs.fetchFromGitHub {
      owner = "tt-a1i";
      repo = "archify";
      rev = "81c6be8d87090670c45d08a8f97f9d29c5af0bec";
      hash = "sha256-D8szuLyfSbZgKEwS9YDrVEZKJiK1YeLusSot63dP1sU=";
    }}/archify";
    # editors
    ".config/nvim".source = symlink "${dotfiles}/nvim";
  };
}
