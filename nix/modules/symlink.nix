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
    ".claude/skills/functional-programming".source = symlink "${dotfiles}/agents/skills/functional-programming";
    ".claude/skills/fixing-review-findings".source = symlink "${dotfiles}/agents/skills/fixing-review-findings";
    ".claude/skills/dev-workflow".source = symlink "${dotfiles}/agents/skills/dev-workflow";
    # editors
    ".config/nvim".source = symlink "${dotfiles}/nvim";
  };
}
