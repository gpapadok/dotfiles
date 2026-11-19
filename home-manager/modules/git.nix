{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "giorgos.papadokostakis@proton.me";
        name = "gpapadok";
      };

      core.editor = "nvim";
    };
  };
}
