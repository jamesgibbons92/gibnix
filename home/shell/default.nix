{pkgs, ...}: {
  imports = [
    ./tmux.nix
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
      };
      history = {
        save = 999999;
        size = 999999;
        share = true;
      };
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
