{ config, dotfiles, symlink, ... }:

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
    # editors
    ".config/nvim".source = symlink "${dotfiles}/nvim";
  };
}
