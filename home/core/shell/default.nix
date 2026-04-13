{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./tmux.nix
    ./starship.nix
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      autosuggestion = {
        enable = true;
      };
      history = {
        save = 999999;
        size = 999999;
        share = true;
      };
      historySubstringSearch = {
        enable = true;
        searchDownKey = "$terminfo[kcud1]";
        searchUpKey = "$terminfo[kcuu1]";
      };
      initContent = lib.mkOrder 1600 ''
        # if [ -z "$TMUX" ]; then
        #   tmux a
        # fi
      '';
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
